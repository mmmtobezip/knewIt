"""판매량 가이드 (SCR-GUIDE-001) — 통합 엔드포인트.

GET /api/sales-guide?customer={customer_id}
    → SalesGuidePayload (3개 모듈 한 번에 반환)

캐시:
    key = ("sales_guide", today_kst, user_id, customer)
    ttl = 24h (FE staleTime 과 일치)

권한:
    - user.primary_product_code 가 결정한 제품의 customer_profiles 5개 + user 의
      assigned_customer_ids 교집합 — 본인 담당 거래처 한정.

병렬화:
    - Module 2 의 고객사별 LLM 호출(N=5)은 asyncio.gather 로 fan-out.
"""
from __future__ import annotations

import asyncio
from datetime import datetime
from zoneinfo import ZoneInfo

from fastapi import APIRouter, Depends, Query
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.config import get_settings
from app.core.auth import get_current_user
from app.core.errors import ApiException, ErrorCode
from app.core.response import ApiSuccess, ok
from app.db import get_db
from app.models import CustomerProfile, User
from app.schemas.api import CacheScope
from app.schemas.domain import SessionUser
from app.schemas.sales_guide import SalesGuidePayload
from app.services.authorization import get_assigned_customer_ids
from app.services.cache_service import get_or_compute, make_key
from app.services.llm_service import get_llm_service
from app.services.sales_service import (
    DEMO_TODAY,
    _actual_lookup,
    build_grade_summary,
    build_market_signal,
    build_opportunity,
    collect_features,
    compute_module1,
    compute_module3,
)

SETTINGS = get_settings()
KST = ZoneInfo(SETTINGS.app_timezone)
SALES_GUIDE_TTL_SEC = 24 * 60 * 60  # 24h (FE staleTime 과 일치)

router = APIRouter(prefix="/api", tags=["sales-guide"])


@router.get(
    "/sales-guide",
    response_model=ApiSuccess[SalesGuidePayload],
    summary="PRD SCR-GUIDE-001 — 판매량 가이드 3개 모듈 통합",
)
async def get_sales_guide(
    customer: str = Query(..., description="기준 거래처 (URL 파라미터)"),
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[SalesGuidePayload]:
    # ── 권한 + 컨텍스트 ──
    user_row = await db.get(User, user.user_id)
    if user_row is None:
        raise ApiException(ErrorCode.AUTH_001, detail="user 미확인")
    product = user_row.primary_product_code
    if not product:
        raise ApiException(ErrorCode.DATA_001, detail="user.primary_product_code 미설정")
    salesperson = user_row.name or user.user_id

    allowed_ids = set(await get_assigned_customer_ids(db, user.user_id, user.user_role))
    if customer not in allowed_ids:
        raise ApiException(ErrorCode.AUTH_001, detail=f"customer={customer} 접근 권한 없음")

    today_kst = datetime.now(KST).date().isoformat()
    key = make_key(CacheScope.SALES_GUIDE, customer, product, today_kst)

    async def compute() -> SalesGuidePayload:
        # 사용자가 접근 가능한 customer_profiles (product_group 매칭)
        rows = (
            await db.execute(
                select(CustomerProfile)
                .where(CustomerProfile.customer_id.in_(allowed_ids))
                .where(CustomerProfile.product_group.contains([product]))
                .order_by(CustomerProfile.customer_id)
            )
        ).scalars().all()
        customers: list[CustomerProfile] = list(rows)
        if not customers:
            raise ApiException(ErrorCode.DATA_001, detail="고객사 매칭 없음")

        # ── Module 1 ──
        kpi, achievements = await compute_module1(
            db, salesperson=salesperson, product=product, customers=customers, today=DEMO_TODAY
        )

        # ── Module 2 — 시황 ──
        snapshots, key_features_out = await collect_features(db, product)
        signal, market_signal_score = build_market_signal(snapshots, responsible=salesperson)

        # 고객사별 LLM 시황영향 병렬 호출
        llm = get_llm_service()
        features_payload = [
            {"name": s.name, "change_pct": round(s.change_pct, 2),
             "cycle": s.cycle_char, "weight": s.weight}
            for s in snapshots
        ]

        async def _impact_for(c: CustomerProfile) -> tuple[str, float]:
            try:
                res = await llm.compute_market_impact(
                    product=product,
                    customer_industry=c.industry or "—",
                    market_region=c.market_region or "—",
                    sensitive_topics=list(c.sensitive_topics or []),
                    features=features_payload,
                )
                return c.customer_id, float(res.get("market_score") or 0.0)
            except Exception:  # LLM 실패 시 중립 (50 점 부여) — 화면 진행 보장
                return c.customer_id, 0.0

        impact_pairs = await asyncio.gather(*(_impact_for(c) for c in customers))
        impact_by_customer = dict(impact_pairs)

        # 고객사별 opportunity 카드 빌드
        achievement_by_id = {a.customer_id: a for a in achievements}
        opportunities = []
        for c in customers:
            ach = achievement_by_id.get(c.customer_id)
            if ach is None:
                continue
            opp = build_opportunity(
                customer=c,
                achievement=ach,
                market_pct=impact_by_customer.get(c.customer_id, 0.0),
                market_signal_score=market_signal_score,
                today=DEMO_TODAY,
            )
            opportunities.append(opp)
        opportunities.sort(key=lambda o: o.score, reverse=True)

        # ── Module 3 ──
        market_summary, timeline, similar_periods = await compute_module3(
            db, product=product, today=DEMO_TODAY
        )

        return SalesGuidePayload(
            customer=customer,
            product=product,
            generated_at=datetime.now(KST).isoformat(),
            achievement_kpi=kpi,
            customer_achievements=achievements,
            market_signal=signal,
            key_features=key_features_out,
            grade_summary=build_grade_summary(opportunities),
            customer_opportunities=opportunities,
            market_summary=market_summary,
            similarity_timeline=timeline,
            similar_periods=similar_periods,
        )

    payload, _ = await get_or_compute(
        key, SalesGuidePayload, compute, ttl_sec=SALES_GUIDE_TTL_SEC
    )
    return ok(payload)


# ─────────────────── 제안 시작 (PRD 4.2.7) ───────────────────


class ProposalRequest(BaseModel):
    customer: str


class ProposalData(BaseModel):
    customer: str
    script: str
    generated_at: str


@router.post(
    "/sales-guide/proposal",
    response_model=ApiSuccess[ProposalData],
    summary="PRD 4.2.7 — 고객사별 제안 시작 (4종 컨텍스트 → 3~4줄 행동지침)",
)
async def post_proposal(
    body: ProposalRequest,
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[ProposalData]:
    """PRD 4.2.7 — 4종 컨텍스트(고객사 프로필 + 실적 현황 + 시황 컨텍스트 + 과거 패턴)
    를 모두 LLM 에 전달해 3~4줄 자연어 행동 지침 생성.

    전용 prompt(prompts/proposal.md) + temperature=0 + max_tokens=1000.
    """
    user_row = await db.get(User, user.user_id)
    if user_row is None or not user_row.primary_product_code:
        raise ApiException(ErrorCode.AUTH_001, detail="user.primary_product_code 미설정")
    product = user_row.primary_product_code
    salesperson = user_row.name or user.user_id

    allowed_ids = set(await get_assigned_customer_ids(db, user.user_id, user.user_role))
    if body.customer not in allowed_ids:
        raise ApiException(ErrorCode.AUTH_001, detail=f"customer={body.customer} 접근 권한 없음")
    customer = await db.get(CustomerProfile, body.customer)
    if customer is None:
        raise ApiException(ErrorCode.DATA_001, detail=f"customer_profile={body.customer} 미정의")

    # ── ② 실적 현황 (Module 1) ──
    kpi, achievements = await compute_module1(
        db, salesperson=salesperson, product=product, customers=[customer], today=DEMO_TODAY
    )
    ach = achievements[0] if achievements else None
    achievement_rate_pct = (ach.achievement_rate * 100) if ach else 0.0
    yoy_change_pct = (ach.yoy_change * 100) if ach else 0.0
    actual_volume_kt = ach.actual_volume if ach else 0.0
    guide_volume_kt = ach.guide_volume if ach else 0.0

    # ── ③ 시황 컨텍스트 (Module 2) ──
    snapshots, key_features_out = await collect_features(db, product)
    if not snapshots:
        raise ApiException(ErrorCode.DATA_001, detail="제안 컨텍스트용 지표 데이터 없음")
    signal, market_signal_score = build_market_signal(snapshots, responsible=salesperson)

    llm = get_llm_service()
    features_payload = [
        {"name": s.name, "change_pct": round(s.change_pct, 2),
         "cycle": s.cycle_char, "weight": s.weight}
        for s in snapshots
    ]
    try:
        impact_res = await llm.compute_market_impact(
            product=product,
            customer_industry=customer.industry or "—",
            market_region=customer.market_region or "—",
            sensitive_topics=list(customer.sensitive_topics or []),
            features=features_payload,
        )
        customer_market_impact_pct = float(impact_res.get("market_score") or 0.0)
    except Exception:
        customer_market_impact_pct = 0.0

    # ── ④ 과거 패턴 (Module 3) — 유사 Top 3 월 중 이 거래처가 등장한 곳 추출 ──
    _, _, similar_periods = await compute_module3(db, product=product, today=DEMO_TODAY)
    past_pattern: list[dict] = []
    for sp in similar_periods:
        if body.customer not in sp.focus_customers:
            continue
        # 해당 월 본인 제품 actual lookup 에서 이 고객사 값 추출
        ym_str = sp.period.replace("년 ", "-").replace("월", "").strip()
        # "2026-3" → "202603"
        try:
            year_part, month_part = ym_str.split("-")
            ym_key = f"{int(year_part):04d}{int(month_part):02d}"
        except ValueError:
            continue
        actuals_at_ym = await _actual_lookup(db, ym_key, product)
        cust_actual = actuals_at_ym.get(body.customer)
        if cust_actual is not None:
            past_pattern.append({
                "period": sp.period,
                "cosine_similarity": sp.cosine_similarity,
                "rank_in_focus": sp.focus_customers.index(body.customer) + 1,
                "actual_volume_kt": round(cust_actual, 1),
            })

    # ── LLM 호출 ──
    script = await llm.generate_proposal(
        customer_name=customer.customer_id,
        industry=customer.industry or "—",
        market_region=customer.market_region or "—",
        sensitive_topics=list(customer.sensitive_topics or []),
        risk_factors=list(customer.risk_factors or []),
        user_name=salesperson,
        product=product,
        achievement_rate_pct=achievement_rate_pct,
        yoy_change_pct=yoy_change_pct,
        actual_volume_kt=actual_volume_kt,
        guide_volume_kt=guide_volume_kt,
        market_signal_status=signal.status,
        market_signal_score_pct=market_signal_score,
        customer_market_impact_pct=customer_market_impact_pct,
        key_features=[
            {"name": k.name, "weight": k.weight,
             "direction": k.direction, "change": k.change, "cycle": k.cycle}
            for k in key_features_out
        ],
        past_pattern=past_pattern,
    )

    return ok(ProposalData(
        customer=body.customer,
        script=script,
        generated_at=datetime.now(KST).isoformat(),
    ))


__all__ = ["router"]
