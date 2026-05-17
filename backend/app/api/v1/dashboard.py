"""PRD 0516 — 통합 메인 대시보드 endpoint.

GET /api/dashboard?customer={id}&product={code?}
  → chart1_top_movers (Top 10) + chart2_cause_flow + interpretation + strategy 일괄 반환

product 결정 우선순위:
  1. query.product (지정 시, 단 customer.product_group 에 포함되어야 함)
  2. user.primary_product_code (있고 customer 도 다루면)
  3. customer.product_group[0] (fallback)

5개 캐시 scope(top_movers / cause_flow / interpretation / strategy / news) 각각 24h.
"""
from __future__ import annotations

from datetime import datetime
from zoneinfo import ZoneInfo

from fastapi import APIRouter, Depends, Query
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession

from app.config import get_settings
from app.core.auth import get_current_user
from app.core.errors import ApiException, ErrorCode
from app.core.response import ApiSuccess, ok
from app.db import get_db
from app.models import CustomerProfile as CustomerProfileORM
from app.models import Product as ProductORM
from app.schemas.api import (
    CacheScope,
    DashboardData,
    TopMoversData,
)
from app.schemas.domain import (
    CauseFlowStep,
    CustomerProfile,
    Interpretation,
    SessionUser,
    Strategy,
    TopMover,
)
from app.services.authorization import assert_customer_access
from app.services.cache_service import get_or_compute, make_key
from app.services.indicator_service import fetch_indicator, top_movers_for_product
from app.services.llm_service import get_llm_service
from app.services.news_service import get_news_service, query_for_indicator

router = APIRouter(prefix="/api", tags=["dashboard"])
SETTINGS = get_settings()
KST = ZoneInfo(SETTINGS.app_timezone)


class _NewsListWrap(BaseModel):
    items: list[dict]


class _TopMoversWrap(BaseModel):
    product: str
    top_movers: list[TopMover]
    top_feature: str


def _select_product(
    profile: CustomerProfile, user: SessionUser, query_product: str | None
) -> str:
    """PRD 0516 — product 결정 (query > user.primary > customer.product_group[0])."""
    groups = profile.product_group or []
    if query_product:
        if query_product not in groups:
            raise ApiException(
                ErrorCode.PERM_001,
                detail=f"customer={profile.customer_id} 가 product={query_product} 미취급",
            )
        return query_product
    primary = user.primary_product_code
    if primary and primary in groups:
        return primary
    if not groups:
        raise ApiException(ErrorCode.DATA_001, detail="customer 의 product_group 비어있음")
    return groups[0]


async def _load_dashboard_context(
    db: AsyncSession,
    user: SessionUser,
    customer_id: str,
    query_product: str | None = None,
) -> tuple[CustomerProfile, str]:
    await assert_customer_access(db, user, customer_id)
    row = await db.get(CustomerProfileORM, customer_id)
    if row is None:
        raise ApiException(ErrorCode.DATA_001, detail=f"customer={customer_id} 없음")
    profile = CustomerProfile.model_validate(row)
    product = _select_product(profile, user, query_product)
    return profile, product


async def _resolve_top_movers(
    db: AsyncSession, customer_id: str, product: str, *, top_n: int = 10
) -> _TopMoversWrap:
    """PRD 0516 — 차트1 Top-N (기본 10개, 회의록 "keyfeature 모두 표시")."""

    async def compute() -> _TopMoversWrap:
        movers, top_feature = await top_movers_for_product(db, product, top_n=top_n)
        return _TopMoversWrap(product=product, top_movers=movers, top_feature=top_feature)

    key = make_key(CacheScope.TOP_MOVERS, customer_id, product, f"n{top_n}")
    result, _ = await get_or_compute(key, _TopMoversWrap, compute)
    return result


async def _resolve_news(
    customer_id: str, product: str, top_feature: str
) -> _NewsListWrap:
    key = make_key(CacheScope.NEWS, customer_id, product, top_feature)

    async def compute() -> _NewsListWrap:
        ko_q, en_q = query_for_indicator(top_feature, product)
        docs = await get_news_service().search(ko_q, en_q)
        return _NewsListWrap(items=[d.model_dump() for d in docs])

    result, _ = await get_or_compute(key, _NewsListWrap, compute)
    return result


@router.get(
    "/dashboard",
    response_model=ApiSuccess[DashboardData],
    summary="PRD 0514 메인 대시보드 통합 응답 (차트1+차트2+해석+전략)",
)
async def get_dashboard(
    customer: str = Query(..., description="customer_id"),
    product: str | None = Query(
        default=None,
        description="customer.product_group 내 제품 코드 (옵셔널, 미지정 시 user.primary 또는 group[0])",
    ),
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[DashboardData]:
    profile, product = await _load_dashboard_context(db, user, customer, product)
    movers_wrap = await _resolve_top_movers(db, customer, product)
    if not movers_wrap.top_movers:
        raise ApiException(ErrorCode.DATA_001, detail=f"product={product} 지표 없음")

    top = movers_wrap.top_movers[0]
    news_wrap = await _resolve_news(customer, product, top.indicator)

    # PRD 0516 — axis 폐기. 동일 product 의 key_feature_importance Top-3 (top.indicator 제외)
    # 를 LLM cause_flow 컨텍스트로 전달.
    product_orm = await db.get(ProductORM, product)
    adjacent: list[dict] = []
    if product_orm:
        pairs = sorted(
            zip(
                product_orm.key_features or [],
                product_orm.key_feature_importance or [],
                strict=False,
            ),
            key=lambda x: x[1],
            reverse=True,
        )
        for feat, _imp in pairs:
            if feat == top.indicator:
                continue
            snap = await fetch_indicator(db, feat, period_days=30)
            if snap is None:
                continue
            adjacent.append(
                {
                    "indicator": feat,
                    "value": snap.latest_value,
                    "unit": snap.unit,
                    "change_w1": snap.change_w1,
                }
            )
            if len(adjacent) >= 3:
                break

    llm = get_llm_service()
    flow_key = make_key(CacheScope.CAUSE_FLOW, customer, product, top.indicator)

    async def _compute_flow() -> _FlowWrap:
        steps = await llm.generate_cause_flow(
            indicator_name=top.indicator,
            change_rate=top.change_w1,
            period="W-1",
            news=news_wrap.items,
            adjacent_indicators=adjacent,
            axis_name=None,
        )
        return _FlowWrap(steps=steps)

    flow_wrap, _ = await get_or_compute(flow_key, _FlowWrap, _compute_flow)

    interp_key = make_key(CacheScope.INTERPRETATION, customer, product, top.indicator)
    flow_text = " → ".join(s.node for s in flow_wrap.steps)

    async def _compute_interp() -> Interpretation:
        return await llm.generate_interpretation(
            customer=customer,
            industry=profile.industry,
            market_region=profile.market_region,
            risk_factors=profile.risk_factors,
            indicator=top.indicator,
            change_rate=top.change_w1,
            period="W-1",
            flow_text=flow_text,
        )

    interp, _ = await get_or_compute(interp_key, Interpretation, _compute_interp)

    strat_key = make_key(CacheScope.STRATEGY, customer, product, top.indicator)

    async def _compute_strat() -> Strategy:
        return await llm.generate_strategy(
            customer=customer,
            industry=profile.industry,
            market_region=profile.market_region,
            sensitive_topics=profile.sensitive_topics,
            risk_factors=profile.risk_factors,
            indicator=top.indicator,
            change_rate=top.change_w1,
            impact=[item.model_dump() for item in interp.impact],
        )

    strat, _ = await get_or_compute(strat_key, Strategy, _compute_strat)

    return ok(
        DashboardData(
            customer=customer,
            product=product,
            generated_at=datetime.now(KST).isoformat(),
            chart1_top_movers=movers_wrap.top_movers,
            chart2_cause_flow=flow_wrap.steps,
            interpretation=interp,
            strategy=strat,
        )
    )


@router.get(
    "/top-movers",
    response_model=ApiSuccess[TopMoversData],
    summary="차트1 Top Mover 단독 조회 (디버그/캐시 검증용)",
)
async def get_top_movers(
    customer: str = Query(...),
    product: str | None = Query(default=None),
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[TopMoversData]:
    _, product_resolved = await _load_dashboard_context(db, user, customer, product)
    wrap = await _resolve_top_movers(db, customer, product_resolved)
    return ok(TopMoversData(product=product_resolved, top_movers=wrap.top_movers))


class _FlowWrap(BaseModel):
    steps: list[CauseFlowStep]
