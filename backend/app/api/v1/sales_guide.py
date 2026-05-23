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
    summary="PRD 4.2.7 — 고객사별 제안 시작 (3~4줄 행동지침)",
)
async def post_proposal(
    body: ProposalRequest,
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[ProposalData]:
    """기존 strategy LLM (generate_strategy) 을 재사용해 3~4줄 행동지침 생성.

    재사용 전략 (사용자 결정):
      - generate_strategy 의 strategy_summary + recommended_actions[0:2]
        를 결합해 단일 텍스트로 반환.
      - 변동지표(indicator) = 시황영향이 가장 큰 key_feature 1개로 자동 선택.
      - impact = customer.risk_factors → [{risk_factor, direction, priority, reason}].
    """
    user_row = await db.get(User, user.user_id)
    if user_row is None or not user_row.primary_product_code:
        raise ApiException(ErrorCode.AUTH_001, detail="user.primary_product_code 미설정")
    product = user_row.primary_product_code

    allowed_ids = set(await get_assigned_customer_ids(db, user.user_id, user.user_role))
    if body.customer not in allowed_ids:
        raise ApiException(ErrorCode.AUTH_001, detail=f"customer={body.customer} 접근 권한 없음")
    customer = await db.get(CustomerProfile, body.customer)
    if customer is None:
        raise ApiException(ErrorCode.DATA_001, detail=f"customer_profile={body.customer} 미정의")

    # ── 컨텍스트 수집 — 시황 + 가장 큰 변동 지표 1개 ──
    snapshots, _ = await collect_features(db, product)
    if not snapshots:
        raise ApiException(ErrorCode.DATA_001, detail="제안 컨텍스트용 지표 데이터 없음")
    top = max(snapshots, key=lambda s: abs(s.change_pct))

    # 기존 strategy 가 기대하는 impact 구조로 변환 (risk_factors 기반)
    impact = [
        {
            "risk_factor": rf,
            "direction": "증폭" if top.change_pct >= 0 else "완화",
            "priority": "HIGH",
            "reason": f"시황 변동 ({top.change_pct:+.2f}%) 가 {rf} 에 직접 영향",
        }
        for rf in (customer.risk_factors or [])[:2]
    ] or [
        {
            "risk_factor": "—",
            "direction": "중립",
            "priority": "LOW",
            "reason": "risk_factors 미등록",
        }
    ]

    llm = get_llm_service()
    strategy = await llm.generate_strategy(
        customer=customer.customer_id,
        industry=customer.industry or "—",
        market_region=customer.market_region or "—",
        sensitive_topics=list(customer.sensitive_topics or []),
        risk_factors=list(customer.risk_factors or []),
        indicator=top.name,
        change_rate=round(top.change_pct, 2),
        impact=impact,
    )

    # 3~4줄 행동지침으로 결합 (PRD 4.2.7 출력 형태: 인사말 없이 바로 지침)
    actions = list(strategy.recommended_actions or [])[:3]
    pieces = [strategy.strategy_summary.strip()] + actions
    script = " ".join(p.strip().rstrip(".") + "." for p in pieces if p)

    return ok(ProposalData(
        customer=body.customer,
        script=script,
        generated_at=datetime.now(KST).isoformat(),
    ))


__all__ = ["router"]
