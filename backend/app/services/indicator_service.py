"""PRD 0514 — 지표 변동률 + Top Mover + axis 다양성 보장.

핵심:
- D-1/W-1/M-1 변동률 계산
- Score = |변동률| × key_feature_importance
- Top-N 추출 (관점 다양성: 서로 다른 axis 최소 2개 커버)
- 외부 데이터가 static (xlsx 기준) 이므로 max_date 를 "오늘"로 간주 (#12 결정)
"""
from __future__ import annotations

from dataclasses import dataclass, field
from datetime import date as DateT
from datetime import timedelta

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models import Indicator, Product
from app.schemas.domain import IndicatorPointOut, IndicatorSeries, TopMover


@dataclass(slots=True)
class IndicatorSnapshot:
    feature_name: str
    unit: str
    latest_date: DateT
    latest_value: float
    change_d1: float | None
    change_w1: float
    change_m1: float | None
    points: list[IndicatorPointOut] = field(default_factory=list)


def _pct(current: float, baseline: float | None) -> float | None:
    if baseline is None or baseline == 0:
        return None
    return round((current - baseline) / baseline * 100, 2)


def _nearest_value(rows: list[Indicator], target: DateT) -> float | None:
    """target 이하 가장 가까운 일자의 값."""
    candidates = [r for r in rows if r.date <= target]
    if not candidates:
        return None
    return float(max(candidates, key=lambda r: r.date).value)


async def fetch_indicator(
    db: AsyncSession, feature_name: str, *, period_days: int = 90
) -> IndicatorSnapshot | None:
    stmt = (
        select(Indicator)
        .where(Indicator.feature_name == feature_name)
        .order_by(Indicator.date.asc())
    )
    rows = (await db.execute(stmt)).scalars().all()
    if not rows:
        return None
    latest = rows[-1]
    cutoff = latest.date - timedelta(days=period_days)
    in_window = [r for r in rows if r.date >= cutoff]
    points = [IndicatorPointOut(date=r.date, value=float(r.value)) for r in in_window]

    d1 = _pct(float(latest.value), _nearest_value(rows, latest.date - timedelta(days=1)))
    w1 = _pct(float(latest.value), _nearest_value(rows, latest.date - timedelta(days=7)))
    m1 = _pct(float(latest.value), _nearest_value(rows, latest.date - timedelta(days=30)))

    return IndicatorSnapshot(
        feature_name=feature_name,
        unit=latest.unit,
        latest_date=latest.date,
        latest_value=float(latest.value),
        change_d1=d1,
        change_w1=w1 if w1 is not None else 0.0,
        change_m1=m1,
        points=points,
    )


async def fetch_series(
    db: AsyncSession, feature_name: str, *, period_days: int = 90
) -> IndicatorSeries | None:
    snap = await fetch_indicator(db, feature_name, period_days=period_days)
    if snap is None:
        return None
    return IndicatorSeries(feature_name=snap.feature_name, unit=snap.unit, points=snap.points)


async def top_movers_for_product(
    db: AsyncSession, product_code: str, *, top_n: int = 3
) -> tuple[list[TopMover], str]:
    """PRD 0516 차트1.

    Score = |W-1 변동률| × key_feature_importance, score 내림차순 Top-N.
    PRD 0516에서 axis 제거됨 → 단순 영향도 정렬.
    반환: (top_movers, feature_name_of_max_score)
    """
    product = await db.get(Product, product_code)
    if product is None:
        return [], ""
    importance = product.key_feature_importance or []
    cycles = product.key_feature_cycle or []

    candidates: list[TopMover] = []
    for idx, feature in enumerate(product.key_features or []):
        weight = importance[idx] if idx < len(importance) else 0.0
        cycle = cycles[idx] if idx < len(cycles) else None
        snap = await fetch_indicator(db, feature, period_days=90)
        if snap is None:
            continue
        score = round(abs(snap.change_w1) * weight, 4)
        mover = TopMover(
            indicator=feature,
            value=snap.latest_value,
            unit=snap.unit,
            change_d1=snap.change_d1,
            change_w1=snap.change_w1,
            change_m1=snap.change_m1,
            score=score,
            series=snap.points,
            cycle=cycle,
        )
        candidates.append(mover)

    candidates.sort(key=lambda m: m.score, reverse=True)
    top = candidates[:top_n]
    top_feature = top[0].indicator if top else ""
    return top, top_feature


__all__ = [
    "IndicatorSnapshot",
    "fetch_indicator",
    "fetch_series",
    "top_movers_for_product",
]
