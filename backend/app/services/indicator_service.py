"""PRD 0523 — 지표 변동률 + Top Mover + 카테고리 다양성 보장.

핵심:
- D-1/W-1/M-1 변동률 계산
- Score = |변동률| × key_feature_importance
- Top-N 추출 (PRD 0514 5.1.2 Step 5 "관점 다양성") — indicators.category_big 으로
  axis 대체. 서로 다른 카테고리 최소 2개 커버.
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
    # PRD 0523 — 시트 카테고리 (axis 대체 — questions/answer 다양성 보장용)
    category_big: str | None = None
    category_mid: str | None = None
    category_small: str | None = None


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
        category_big=latest.category_big,
        category_mid=latest.category_mid,
        category_small=latest.category_small,
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
    """PRD 0523 차트1 + 추천 질문 (SMI-Bot v1.1 5.1.2 Step 5).

    Score = |W-1 변동률| × key_feature_importance.
    Top-N 추출 — indicators.category_big 다양성 보장:
      먼저 서로 다른 category_big 으로 1개씩 채우고, 그 후 score 높은 backup 으로 보충.
    이는 PRD 의 "5 관점 (원료/시장가격/수급/거시/전방) 중 최소 2 커버" 요건 충족.
    """
    product = await db.get(Product, product_code)
    if product is None:
        return [], ""
    importance = product.key_feature_importance or []
    cycles = product.key_feature_cycle or []

    # (mover, category_big) 쌍으로 수집 — 다양성 정렬용
    candidates: list[tuple[TopMover, str | None]] = []
    for idx, feature in enumerate(product.key_features or []):
        weight = importance[idx] if idx < len(importance) else 0.0
        cycle = cycles[idx] if idx < len(cycles) else None
        snap = await fetch_indicator(db, feature, period_days=365)
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
        candidates.append((mover, snap.category_big))

    # score 내림차순 정렬 → 가장 강한 변동부터 검토
    candidates.sort(key=lambda x: x[0].score, reverse=True)

    # 카테고리 다양성: top_n 중 가능하면 서로 다른 category_big 우선
    seen: set[str] = set()
    primary: list[TopMover] = []
    backup: list[TopMover] = []
    for mover, cat in candidates:
        if len(primary) >= top_n:
            break
        if cat and cat not in seen:
            primary.append(mover)
            seen.add(cat)
        else:
            backup.append(mover)
    while len(primary) < top_n and backup:
        primary.append(backup.pop(0))

    top_feature = primary[0].indicator if primary else ""
    return primary, top_feature


__all__ = [
    "IndicatorSnapshot",
    "fetch_indicator",
    "fetch_series",
    "top_movers_for_product",
]
