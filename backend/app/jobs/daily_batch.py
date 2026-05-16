"""P-09 일일 배치 (시나리오 A: 정적 데이터 + 매일 LLM 갱신).

[docs/main-ipo.md § 2-10] 6단계 처리 흐름을 그대로 따르되,
사내 MIH 플랫폼 접근 불가 환경을 고려해 1단계는 § 2-12 폴백
("CSV 미수신 → 직전일 데이터 유지 + 알림") 으로 동작.

처리 흐름:
    1. 오늘자 MIH CSV 적재 (없으면 skip — 정적 indicators 그대로 사용)
    2. 활성 고객사 순회
    3. 각 고객사 → 담당 제품의 trigger_event 탐지 (|change_rate| >= 3%)
    4. 신규 trigger_event 발생 시 LLM 사전생성 (analysis/causal_chain/strategy)
    5. today_questions 3개 LLM 재생성 → Redis SETEX 24h

결과 요약은 BatchReport 로 반환 (admin endpoint 응답 / 로그 기록용).
"""
from __future__ import annotations

import logging
from dataclasses import dataclass, field
from datetime import date as DateT
from datetime import timedelta

import orjson
from sqlalchemy import select
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.ext.asyncio import AsyncSession

from app.cache import redis_client
from app.config import get_settings
from app.db import SessionLocal
from app.models import (
    AssignedCustomer,
    CustomerProfile,
    Direction,
    Product,
    TriggerEvent,
)
from app.schemas.api import CacheScope
from app.schemas.domain import CustomerProfile as CustomerProfileDTO
from app.schemas.domain import TriggerEvent as TriggerEventDTO
from app.services.cache_service import make_key
from app.services.indicator_service import detect_trigger_events
from app.services.llm_service import get_llm_service
from app.services.news_service import get_news_service, query_for_product

logger = logging.getLogger(__name__)
SETTINGS = get_settings()


@dataclass(slots=True)
class BatchReport:
    started_at: str
    finished_at: str | None = None
    csv_loaded: bool = False
    csv_path: str | None = None
    new_trigger_events: int = 0
    llm_precomputed: int = 0
    today_questions_generated: int = 0
    skipped_customers: list[str] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)


async def _maybe_load_today_csv(today: DateT, report: BatchReport) -> None:
    """오늘자 CSV 존재 시 적재 (IPO § 2-10 1단계).

    없으면 IPO § 2-12 폴백: skip + 알림 (직전일 indicators 유지).
    """
    csv_path = SETTINGS.indicators_csv_dir / f"{today.isoformat()}.csv"
    if not csv_path.exists():
        logger.info("MIH CSV 미수신 (%s) — 직전일 데이터 유지", csv_path.name)
        report.csv_path = str(csv_path)
        return
    # 적재 로직은 scripts/seed_from_xlsx.py 와 동일한 패턴.
    # MIH 자동 수집이 부재한 시나리오 A 에서는 사용자가 수동 드롭한 경우에만 호출됨.
    import csv

    from scripts.seed_from_xlsx import _dedupe, _upsert_indicators

    rows: list[dict] = []
    with csv_path.open(encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        for r in reader:
            try:
                rows.append(
                    {
                        "source": r["source"],
                        "country": r.get("country") or None,
                        "category_big": r.get("category_big") or None,
                        "category_mid": r.get("category_mid") or None,
                        "category_small": r.get("category_small") or None,
                        "feature_name": r["feature_name"],
                        "date": DateT.fromisoformat(r["date"]),
                        "value": float(r["value"]),
                        "unit": r["unit"],
                        "cycle": r["cycle"],
                    }
                )
            except (KeyError, ValueError) as e:
                report.errors.append(f"csv row parse: {e}")
    if rows:
        inserted = await _upsert_indicators(_dedupe(rows))
        report.csv_loaded = True
        report.csv_path = str(csv_path)
        logger.info("CSV 적재 완료: %s 행 (%s)", inserted, csv_path.name)


async def _detect_and_persist_triggers(
    db: AsyncSession, today: DateT, report: BatchReport
) -> list[TriggerEvent]:
    """모든 제품에 대해 trigger_event 탐지 + DB INSERT.

    event_id 컨벤션: EVT-{YYYYMMDD}-{product_code} (FE Mock 형식과 동일)
    이미 존재하는 event_id 는 on_conflict_do_nothing.
    """
    candidates = await detect_trigger_events(db, threshold_pct=3.0, mode="WoW")
    if not candidates:
        return []

    customers_for_product = await _load_assignments_by_product(db)
    yyyymmdd = today.strftime("%Y%m%d")
    inserts: list[dict] = []
    for c in candidates:
        for customer_id in customers_for_product.get(c["product_code"], [None]):
            event_id = f"EVT-{yyyymmdd}-{c['product_code']}"
            if customer_id:
                event_id = f"EVT-{yyyymmdd}-{c['product_code']}-{customer_id}"
            inserts.append(
                {
                    "event_id": event_id,
                    "product_code": c["product_code"],
                    "customer_id": customer_id,
                    "feature": c["feature"],
                    "change_rate": c["change_rate"],
                    "direction": Direction(c["direction"]),
                    "date": today,
                }
            )

    if not inserts:
        return []

    stmt = pg_insert(TriggerEvent).values(inserts).on_conflict_do_nothing(
        index_elements=["event_id"]
    ).returning(TriggerEvent)
    rows = (await db.execute(stmt)).scalars().all()
    await db.commit()
    report.new_trigger_events = len(rows)
    return list(rows)


async def _load_assignments_by_product(db: AsyncSession) -> dict[str, list[str]]:
    """제품 → 그 제품을 사용하는 고객사 리스트 매핑.

    현 시드에서는 모든 고객사가 모든 제품을 다루지 않음. 단순화를 위해
    customer_profile.product 와 product.code 매칭은 약식이므로,
    assigned_customers 의 모든 고객사를 모든 제품에 매핑.
    """
    rows = (await db.execute(select(AssignedCustomer.customer_id))).scalars().all()
    customers = sorted(set(rows))
    products = (await db.execute(select(Product.code))).scalars().all()
    return {code: customers for code in products}


async def _precompute_llm_for_event(
    event: TriggerEvent, db: AsyncSession, report: BatchReport
) -> None:
    """trigger_event 1건에 대해 analysis/causal_chain/strategy 사전 생성.

    캐시 TTL 24h. 이미 캐시가 있으면 덮어쓰기.
    """
    customer_id = event.customer_id
    if customer_id is None:
        return
    profile_row = await db.get(CustomerProfile, customer_id)
    if profile_row is None:
        report.skipped_customers.append(customer_id)
        return
    event_dto = TriggerEventDTO.model_validate(event)
    profile_dto = CustomerProfileDTO.model_validate(profile_row)

    llm = get_llm_service()
    ko_q, en_q = query_for_product(event.product_code)
    try:
        news_docs = await get_news_service().search(ko_q, en_q)
    except Exception as e:  # noqa: BLE001
        logger.warning("뉴스 수집 실패 (%s): %s", event.event_id, e)
        news_docs = []

    news_payload = [n.model_dump() for n in news_docs]
    base = dict(
        customer_id=customer_id,
        product_code=event.product_code,
        event_id=event.event_id,
    )

    async def store(scope: CacheScope, model) -> None:
        key = make_key(scope, **base)
        await redis_client.setex(
            key, SETTINGS.cache_ttl_analysis_sec, model.model_dump_json()
        )

    # 부분 실패 후 재실행 시 이미 캐시된 trigger 는 건너뜀 (네트워크 장애 회복력).
    existing = await redis_client.get(make_key(CacheScope.ANALYSIS, **base))
    if existing is not None:
        logger.info("skip precompute (cache hit): %s", event.event_id)
        return

    try:
        analysis = await llm.generate_analysis(
            event=event_dto.model_dump(), customer_profile=profile_dto.model_dump()
        )
        await store(CacheScope.ANALYSIS, analysis)

        causal = await llm.generate_causal_chain(
            event=event_dto.model_dump(), news=news_payload
        )
        await store(CacheScope.CAUSAL_CHAIN, causal)

        strategy = await llm.generate_strategy(
            event=event_dto.model_dump(),
            customer_profile=profile_dto.model_dump(),
            news=news_payload,
        )
        await store(CacheScope.STRATEGY, strategy)

        await redis_client.setex(
            make_key(CacheScope.NEWS, **base),
            SETTINGS.cache_ttl_analysis_sec,
            orjson.dumps({"items": news_payload}),
        )
        report.llm_precomputed += 1
    except Exception as e:  # noqa: BLE001
        logger.exception("LLM 사전생성 실패 %s", event.event_id)
        report.errors.append(f"precompute {event.event_id}: {e}")


async def _generate_today_questions(
    db: AsyncSession, today: DateT, report: BatchReport
) -> None:
    """고객사별 today_questions 3개를 LLM 생성 → Redis SETEX 24h."""
    customers = (await db.execute(select(CustomerProfile))).scalars().all()
    llm = get_llm_service()
    yyyymmdd = today.strftime("%Y%m%d")

    for profile in customers:
        recent_events_q = (
            select(TriggerEvent)
            .where(TriggerEvent.customer_id == profile.customer_id)
            .where(TriggerEvent.date >= today - timedelta(days=7))
            .order_by(TriggerEvent.date.desc())
            .limit(5)
        )
        events = (await db.execute(recent_events_q)).scalars().all()
        events_payload = [TriggerEventDTO.model_validate(e).model_dump() for e in events]
        try:
            questions = await llm.generate_questions(
                customer_profile=CustomerProfileDTO.model_validate(profile).model_dump(),
                events=events_payload,
            )
        except Exception as e:  # noqa: BLE001
            logger.exception("questions 생성 실패 %s", profile.customer_id)
            report.errors.append(f"questions {profile.customer_id}: {e}")
            continue

        # question_id 를 일자별로 안정화 (FE Mock 패턴 참고)
        payload = [
            {
                "question_id": f"Q-{yyyymmdd}-{profile.customer_id}-{i + 1}",
                "question": q.question,
                "priority": q.priority,
            }
            for i, q in enumerate(questions)
        ]
        await redis_client.setex(
            f"today_questions:{profile.customer_id}",
            SETTINGS.cache_ttl_analysis_sec,
            orjson.dumps(payload),
        )
        report.today_questions_generated += 1


async def run_daily_batch(target_date: DateT | None = None) -> BatchReport:
    """P-09 엔트리 포인트. cron 트리거 / admin 수동 트리거 양쪽에서 사용."""
    from datetime import datetime
    from zoneinfo import ZoneInfo

    kst = ZoneInfo(SETTINGS.app_timezone)
    today = target_date or datetime.now(kst).date()
    report = BatchReport(started_at=datetime.now(kst).isoformat())
    logger.info("daily_batch start: %s", today)

    async with SessionLocal() as db:
        await _maybe_load_today_csv(today, report)
        await _detect_and_persist_triggers(db, today, report)
        # IPO § 2-10 P-09 4단계: 활성 trigger_event 의 LLM 캐시(TTL 24h)를 매일 갱신.
        # 신규 trigger 뿐 아니라 최근 N일 유효 이벤트도 함께 재생성 — 캐시 만료 직후 SLA 보장.
        active_events = (
            await db.execute(
                select(TriggerEvent).where(TriggerEvent.date >= today - timedelta(days=7))
            )
        ).scalars().all()
        for event in active_events:
            await _precompute_llm_for_event(event, db, report)
        await _generate_today_questions(db, today, report)

    report.finished_at = datetime.now(kst).isoformat()
    logger.info(
        "daily_batch done: trigger=%s precompute=%s questions=%s errors=%s",
        report.new_trigger_events,
        report.llm_precomputed,
        report.today_questions_generated,
        len(report.errors),
    )
    return report


__all__ = ["BatchReport", "run_daily_batch"]
