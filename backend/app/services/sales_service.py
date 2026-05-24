"""판매량 가이드 서비스 — PRD SCR-GUIDE-001.

3개 모듈 계산:
    Module 1 (Achievement) — 가이드값 달성률 + 전년 동월 대비
    Module 2 (Opportunity) — 고객사 종합 스코어 + 시황 신호 + key_features
    Module 3 (History)     — 코사인 유사도 기반 과거 유사 시황 Top 3

핵심 수식 (노션 "스코어링 추가 정보(최종)" 우선):
    종합 스코어 = 달성속도 × 0.4 + 전년대비 × 0.4 + 시황영향 × 0.2  (0~100)
    시황영향 점수 = >+1% 기회=70 / -1~+1% 중립=50 / <-1% 주의=30
    전년대비 정규화 = Linear Clip ±20% (JFE/SK텔레콤 베스트프랙티스)
    영업일 = 평일만 (POC 단순)
"""
from __future__ import annotations

import calendar
from dataclasses import dataclass
from datetime import date as DateT
from datetime import timedelta
from statistics import mean

import numpy as np
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models import (
    CustomerProfile,
    Indicator,
    OrderLine,
    Product,
    ProductVariant,
    SalesActual,
    SalesGuide,
    Shipment,
)
from app.schemas.sales_guide import (
    AchievementKpi,
    AchievementStatus,
    CustomerAchievement,
    CustomerGrade,
    CustomerMetric,
    CustomerOpportunity,
    FeatureCycle,
    FeatureDirection,
    GradeSummary,
    IndicatorPoint,
    KeyFeature,
    MarketDriver,
    MarketFeature,
    MarketSignal,
    MarketSignalStatus,
    MarketSummaryItem,
    RuleTagType,
    SimilarityPoint,
    SimilarPeriod,
)

# 데이터가 정적(xlsx)이므로 "오늘" = indicator max_date 로 간주 (#12 결정)
DEMO_TODAY = DateT(2026, 5, 15)

# 판매그룹 전체 가이드 (시연 가상값) — 내 책임 거래처 가이드가 그룹의 일부임을
# KPI info tooltip 에 표시하기 위한 참고값. 실 운영 시 sales_groups 테이블로 이관.
GROUP_TOTAL_GUIDE: dict[str, float] = {
    "후판": 1500.0,
    "선재": 1200.0,
    "HR(고로밀)": 2000.0,
}


# ─────────────────── Utility ───────────────────


def business_days_in_month(year: int, month: int) -> int:
    """해당 월의 평일(월~금) 총 개수."""
    _, ndays = calendar.monthrange(year, month)
    return sum(1 for d in range(1, ndays + 1) if DateT(year, month, d).weekday() < 5)


def elapsed_business_days(today: DateT) -> int:
    """이번 달 1일부터 today 까지 평일 개수 (today 포함)."""
    return sum(1 for d in range(1, today.day + 1) if DateT(today.year, today.month, d).weekday() < 5)


def normalize_yoy(rate: float) -> float:
    """전년 대비 증감률(소수, ex: 0.18) → 0~100점.

    Linear Clip ±20% (JFE Sales Achievement Index 패턴).
      -20% 이하 → 0점 (역성장 한계)
      0%       → 50점 (전년 동수준)
      +20% 이상 → 100점 (성장 한계)
    """
    return max(0.0, min(100.0, (rate + 0.20) / 0.40 * 100))


def normalize_pace(achievement_rate: float, elapsed_bd: int, total_bd: int) -> float:
    """달성 속도 정규화 (0~100, 100 cap).

    수식: 달성률 ÷ (경과 영업일 / 전체 영업일). 1.0 이상이면 페이스 적정 → 100점.
    """
    if total_bd <= 0 or elapsed_bd <= 0:
        return 0.0
    time_factor = elapsed_bd / total_bd
    pace = achievement_rate / time_factor if time_factor else 0
    return max(0.0, min(100.0, pace * 100))


def market_impact_score(market_pct: float) -> float:
    """시황영향 % → 점수 (노션 최종: >+1% 70 / -1~+1% 50 / <-1% 30)."""
    if market_pct > 1.0:
        return 70.0
    if market_pct < -1.0:
        return 30.0
    return 50.0


def grade_of(score: float) -> CustomerGrade:
    """종합 스코어 → 등급. A(80~100) / B(50~79) / C(0~49). (FE 표시: A-/B+ 등은 UX 위임)"""
    if score >= 80:
        return "A"
    if score >= 50:
        return "B"
    return "C"


def market_signal_status(score_pct: float) -> MarketSignalStatus:
    """시황 스코어 → 신호. 노션: > +5% 기회 / -5~+5% 중립 / < -5% 주의."""
    if score_pct > 5:
        return "강세"
    if score_pct < -5:
        return "약세"
    return "중립"


def direction_of(rate: float) -> FeatureDirection:
    if rate > 0.5:
        return "UP"
    if rate < -0.5:
        return "DOWN"
    return "FLAT"


def cycle_label(cycle_char: str) -> FeatureCycle:
    return {"D": "DAILY", "W": "WEEKLY", "M": "MONTHLY"}.get(cycle_char, "MONTHLY")  # type: ignore[return-value]


def rag_status(rate: float) -> AchievementStatus:
    """달성률 → 신호등. ≥80% 정상 / 50~79% 주의 / <50% 위험."""
    if rate >= 0.80:
        return "normal"
    if rate >= 0.50:
        return "warning"
    return "danger"


# ─────────────────── 변화율 ───────────────────


def compute_change_rate_pct(values: list[tuple[DateT, float]], cycle_char: str) -> float:
    """cycle 별 변화율 % (PRD 4.2.3 단계 2, 옵션 A POC).

    D: 최근 5거래일 MA vs 직전 5거래일 MA
    W: 최근 1주값 vs 직전 1주값
    M: 최근값 vs 직전값 (전월 대비)
    Y: 최근값 vs 전년 동월값
    """
    if not values:
        return 0.0
    rows = sorted(values, key=lambda x: x[0])

    if cycle_char == "D":
        if len(rows) < 10:
            return 0.0
        recent = mean(v for _, v in rows[-5:])
        prior = mean(v for _, v in rows[-10:-5])
        return (recent - prior) / prior * 100 if prior else 0.0

    if cycle_char in {"W", "M"}:
        if len(rows) < 2:
            return 0.0
        a = rows[-1][1]
        b = rows[-2][1]
        return (a - b) / b * 100 if b else 0.0

    if cycle_char == "Y":
        latest_date, latest_val = rows[-1]
        target = DateT(latest_date.year - 1, latest_date.month, 1)
        for d, v in reversed(rows):
            if d <= target and v:
                return (latest_val - v) / v * 100
    return 0.0


def format_change(rate_pct: float, cycle: str) -> str:
    """FE 표시용 — '%' 또는 '%p' 접미사. 노션 PRD 의 표시 규약."""
    suffix = "%p" if cycle in {"기준금리", "수익률"} else "%"
    sign = "+" if rate_pct >= 0 else ""
    return f"{sign}{rate_pct:.1f}{suffix}"


# ─────────────────── 데이터 페치 ───────────────────


@dataclass(slots=True)
class FeatureSnapshot:
    name: str
    weight: float
    cycle_char: str
    change_pct: float


async def fetch_indicator_history(
    db: AsyncSession, feature_name: str, *, period_days: int = 400
) -> list[tuple[DateT, float]]:
    cutoff = DEMO_TODAY - timedelta(days=period_days)
    rows = (
        await db.execute(
            select(Indicator.date, Indicator.value)
            .where(Indicator.feature_name == feature_name)
            .where(Indicator.date >= cutoff)
            .order_by(Indicator.date.asc())
        )
    ).all()
    return [(r.date, float(r.value)) for r in rows]


async def collect_features(
    db: AsyncSession, product_code: str
) -> tuple[list[FeatureSnapshot], list[KeyFeature]]:
    """제품 key_features → (FeatureSnapshot list, FE KeyFeature list)."""
    product = await db.get(Product, product_code)
    if product is None:
        return [], []
    snaps: list[FeatureSnapshot] = []
    items: list[KeyFeature] = []
    features = product.key_features or []
    importance = product.key_feature_importance or []
    cycles = product.key_feature_cycle or []

    for idx, name in enumerate(features):
        weight = importance[idx] if idx < len(importance) else 0.0
        cycle_char = cycles[idx] if idx < len(cycles) else "M"
        history = await fetch_indicator_history(db, name)
        change_pct = compute_change_rate_pct(history, cycle_char)
        latest_val = history[-1][1] if history else None
        latest_date = history[-1][0] if history else None
        current_value = f"{latest_val:,.1f}" if latest_val is not None else None
        current_date = latest_date.isoformat() if latest_date is not None else None
        unit = (await db.execute(
            select(Indicator.unit).where(Indicator.feature_name == name).limit(1)
        )).scalar_one_or_none() or ""
        cutoff_90 = DEMO_TODAY - timedelta(days=90)
        sparkline = [
            IndicatorPoint(date=d.isoformat(), value=v)
            for d, v in history
            if d >= cutoff_90
        ]
        snaps.append(FeatureSnapshot(name=name, weight=weight, cycle_char=cycle_char,
                                     change_pct=change_pct))
        items.append(
            KeyFeature(
                rank=idx + 1,
                name=name,
                weight=round(weight * 100),  # 0.20 → 20 (FE 표시)
                direction=direction_of(change_pct),
                change=format_change(change_pct, name),
                cycle=cycle_label(cycle_char),
                current_value=current_value,
                current_date=current_date,
                unit=unit,
                history=sparkline,
            )
        )

    return snaps, items


# ─────────────────── Module 1 — 달성률 ───────────────────


def _variant_codes_for_product(product: str):
    """제품(예: 선재/후판)에 해당하는 variant_code 의 distinct 서브쿼리.

    PRD 결함 3 해결의 핵심:
      product_variants 의 (variant_code, variant_name) composite PK 로 인해
      동일 variant_code(예: WR)에 여러 variant_name(WA, WB)이 존재 → DISTINCT 필수.
      이 서브쿼리로 출하실적/주문을 본인 제품 라인만 자동 분기.
    """
    return (
        select(ProductVariant.variant_code)
        .where(ProductVariant.product == product)
        .distinct()
    )


async def _shipments_kt_by_customer(
    db: AsyncSession, salesperson: str, product: str,
    month_start: DateT, month_end: DateT,
) -> dict[str, float]:
    """지정 기간 출하실적을 *본인 제품* 한정으로 고객사별 천톤 합계 반환.

    PRD 결함 3: 포스코인터내셔널 같은 다제품 고객사는 customer_profiles 가
    단일 키로 통합되어 있고, variant_code 로 제품 분기 (HE/PJ→후판, WR→선재).
    당월: month_start=오늘 1일, month_end=today (부분월)
    전년: month_start=작년 1일, month_end=작년 말일 (전체월)
    """
    rows = (
        await db.execute(
            select(Shipment.customer_name, func.sum(Shipment.weight_kg))
            .join(OrderLine, OrderLine.order_line_no == Shipment.order_line_no)
            .where(OrderLine.salesperson == salesperson)
            .where(Shipment.shipped_at.between(month_start, month_end))
            .where(Shipment.variant_code.in_(_variant_codes_for_product(product)))
            .group_by(Shipment.customer_name)
        )
    ).all()
    return {name: float(kg or 0) / 1_000_000 for name, kg in rows}


async def _guide_lookup(
    db: AsyncSession, ym_str: str, product: str
) -> dict[str, float]:
    """본인 제품의 해당 월 가이드값을 고객사별 dict 로 반환.

    단일 행 단위 (판매그룹/제품/고객사) 스키마. 제품 전체 가이드는
    호출자가 sum(values()) 로 계산.
    """
    rows = (
        await db.execute(
            select(SalesGuide.customer_name, SalesGuide.guide_value)
            .where(SalesGuide.product == product)
            .where(SalesGuide.ym_str == ym_str)
        )
    ).all()
    return {c: float(v) for c, v in rows}


async def _actual_lookup(
    db: AsyncSession, ym_str: str, product: str
) -> dict[str, float]:
    """본인 제품의 해당 월 실적값을 고객사별 dict 로 반환."""
    rows = (
        await db.execute(
            select(SalesActual.customer_name, SalesActual.actual_value)
            .where(SalesActual.product == product)
            .where(SalesActual.ym_str == ym_str)
        )
    ).all()
    return {c: float(v) for c, v in rows}


async def compute_module1(
    db: AsyncSession,
    *,
    salesperson: str,
    product: str,
    customers: list[CustomerProfile],
    today: DateT = DEMO_TODAY,
) -> tuple[AchievementKpi, list[CustomerAchievement]]:
    """Module 1 — 제품 KPI + 고객사 5개 달성률 테이블."""
    ym_now = f"{today.year}{today.month:02d}"
    last_year = DateT(today.year - 1, today.month, 1)
    ym_last_yr = f"{last_year.year}{last_year.month:02d}"
    last_year_end = DateT(today.year - 1, today.month,
                          calendar.monthrange(today.year - 1, today.month)[1])

    # 당월 출하 (천톤) — 본인 제품 한정 (variant_code → product 자동 분기)
    cust_actuals = await _shipments_kt_by_customer(
        db, salesperson, product, today.replace(day=1), today
    )
    # 전년 동월 출하 (전체월) — 출하실적 기반 YoY (salesperson 필터 동일 적용)
    cust_actuals_ly = await _shipments_kt_by_customer(
        db, salesperson, product, last_year, last_year_end
    )
    # 단일 행 단위 lookup — 본인 제품의 모든 고객사 가이드를 dict 로
    guide_by_customer = await _guide_lookup(db, ym_now, product)
    # actual_by_customer_ly = await _actual_lookup(db, ym_last_yr, product)  # 그룹 실적 → shipments 로 대체
    guide_by_customer_ly = await _guide_lookup(db, ym_last_yr, product)
    yoy_label = f"{last_year.year}년 {last_year.month}월"

    # ── 제품 KPI ── (결함 4 정합: 분모 = 고객사 행 합산, 메타 행 제거)
    product_guide = sum(guide_by_customer.values())
    product_actual = sum(cust_actuals.values())
    achievement_rate = (product_actual / product_guide) if product_guide else 0.0
    ly_product = sum(cust_actuals_ly.values())  # 전년 동월 출하실적 (shipments 기반)
    yoy = ((product_actual - ly_product) / ly_product) if ly_product else 0.0

    kpi = AchievementKpi(
        achievement_rate=achievement_rate,
        yoy_change=yoy,
        actual_volume=round(product_actual, 3),
        guide_volume=product_guide,
        volume_unit="천톤",
        group_total_guide=GROUP_TOTAL_GUIDE.get(product, 0.0),
    )

    # ── 고객사 5개 ──
    result: list[CustomerAchievement] = []
    for c in customers:
        actual = cust_actuals.get(c.customer_id, 0.0)
        guide = guide_by_customer.get(c.customer_id, 0.0)
        rate = (actual / guide) if guide else 0.0
        ly_actual = cust_actuals_ly.get(c.customer_id, 0.0)  # shipments 기반 전년 실적
        ly_guide = guide_by_customer_ly.get(c.customer_id, 0.0)
        yoy_c = ((actual - ly_actual) / ly_actual) if ly_actual else 0.0
        ly_rate = (ly_actual / ly_guide) if ly_guide else 0.0
        result.append(
            CustomerAchievement(
                customer_id=c.customer_id,
                customer_name=c.customer_id,
                industry=c.industry or "—",
                achievement_rate=rate,
                actual_volume=round(actual, 3),
                guide_volume=guide,
                volume_unit="천톤",
                yoy_change=yoy_c,
                status=rag_status(rate),
                prev_achievement_rate=round(ly_rate, 4),
                yoy_label=yoy_label,
            )
        )
    # 달성률 내림차순
    result.sort(key=lambda x: x.achievement_rate, reverse=True)
    return kpi, result


# ─────────────────── Module 2 — 기회탐지 (시황영향 제외) ───────────────────


def build_grade_summary(opportunities: list[CustomerOpportunity]) -> GradeSummary:
    a = sum(1 for o in opportunities if o.grade in {"A", "A-"})
    b = sum(1 for o in opportunities if o.grade in {"B", "B+"})
    c = sum(1 for o in opportunities if o.grade in {"C", "D"})
    return GradeSummary(grade_a=a, grade_b=b, grade_c=c)


def build_market_signal(
    snapshots: list[FeatureSnapshot], responsible: str
) -> tuple[MarketSignal, float]:
    """전체 가중 평균 변화율을 시황 스코어로."""
    score = sum(s.change_pct * s.weight for s in snapshots)
    status = market_signal_status(score)
    desc = {
        "강세": "주요 지표 상승 우세, 시황 호재",
        "중립": "일부 지표 상승, 전반적 보합세",
        "약세": "주요 지표 하락 우세, 시황 주의",
    }[status]
    return MarketSignal(status=status, score=round(score, 2),
                        description=desc, responsible=responsible), score


def rule_tag_for(achievement: CustomerAchievement, market_score: float) -> tuple[str, RuleTagType]:
    """노션 4.2.5 규칙 조합."""
    if achievement.achievement_rate >= 0.95 and market_score > 0:
        return "초과 달성 임박 — 추가 물량 제안 검토", "info"
    if achievement.achievement_rate < 0.50 and achievement.yoy_change < 0:
        return "방문 빈도 점검 필요", "danger"
    if market_score > 5 and achievement.achievement_rate < 0.70:
        return "시황 호재 — 제안 타이밍", "warning"
    return "시황 변동성 모니터링 권장", "info"


def metric_pace_sub(score: float) -> str:
    """달성 속도 부가 설명 (노션 4.2.5)."""
    if score >= 90:
        return "달성 가속 중"
    if score >= 70:
        return "달성 속도 정상"
    if score >= 50:
        return "달성 속도 둔화"
    return "달성 속도 저조"


def metric_yoy_sub(yoy: float) -> str:
    if yoy >= 0.15:
        return "전년 대비 큰 폭 성장"
    if yoy >= 0.01:
        return "전년 대비 성장"
    if yoy >= -0.01:
        return "전년 동수준"
    return "전년 대비 역성장"


def metric_impact_sub(market_pct: float) -> str:
    if market_pct > 1:
        return "기회"
    if market_pct < -1:
        return "주의"
    return "중립"


def build_opportunity(
    customer: CustomerProfile,
    achievement: CustomerAchievement,
    market_pct: float,
    market_signal_score: float,
    today: DateT,
    market_directions: dict[str, int] | None = None,
    top_market_drivers: list[MarketDriver] | None = None,
) -> CustomerOpportunity:
    """노션 4.2.4 — 종합 스코어 + i 아이콘 라벨."""
    # 점수 산출
    total_bd = business_days_in_month(today.year, today.month)
    elapsed_bd = elapsed_business_days(today)
    pace_score = normalize_pace(achievement.achievement_rate, elapsed_bd, total_bd)
    yoy_score = normalize_yoy(achievement.yoy_change)
    impact_score = market_impact_score(market_pct)
    total = round(pace_score * 0.4 + yoy_score * 0.4 + impact_score * 0.2)

    # 태그 (sensitive_topics 그대로 — 5.1.2 Step 5 다양성은 dashboard 쪽 별도 처리)
    sensitivity_tags = list(customer.sensitive_topics or [])
    opp_tags: list[str] = []
    risk_tags: list[str] = []
    if achievement.achievement_rate >= 0.85:
        opp_tags.append("추가 발주 가능")
    if pace_score >= 90:
        opp_tags.append("페이스 가속")
    if achievement.yoy_change >= 0.10:
        opp_tags.append(f"전년 대비 +{round(achievement.yoy_change * 100)}%")
    if achievement.achievement_rate < 0.50:
        risk_tags.append(f"기여도 {round(achievement.achievement_rate * 100)}% 위험")
    rate_diff = achievement.achievement_rate - (achievement.prev_achievement_rate or 0)
    if rate_diff <= -0.05:
        risk_tags.append(f"전년 대비 기여율 {rate_diff * 100:+.0f}%p")
    if market_pct < -1:
        risk_tags.append("시황 약세 지속")
    if total < 50:
        risk_tags.extend(customer.risk_factors[:2] if customer.risk_factors else [])

    rule_tag, rule_tag_type = rule_tag_for(achievement, market_signal_score)

    return CustomerOpportunity(
        customer_id=customer.customer_id,
        customer_name=customer.customer_id,
        grade=grade_of(total),
        score=int(total),
        industry=customer.industry or "—",
        achievement_rate=achievement.achievement_rate,
        opportunity_tags=opp_tags,
        risk_tags=risk_tags,
        rule_tag=rule_tag,
        rule_tag_type=rule_tag_type,
        sensitivity_tags=sensitivity_tags,
        metrics=[
            CustomerMetric(label="달성 속도", value=f"{int(pace_score)}점", sub=metric_pace_sub(pace_score)),
            CustomerMetric(label="전년 대비", value=f"{achievement.yoy_change:+.0%}", sub=metric_yoy_sub(achievement.yoy_change)),
            CustomerMetric(label="시황 영향", value=f"{market_pct:+.2f}%", sub=metric_impact_sub(market_pct)),
        ],
        market_directions=market_directions or {},
        top_market_drivers=top_market_drivers or [],
    )


# ─────────────────── Module 3 — 과거 시황 학습 ───────────────────


async def _monthly_avg(
    db: AsyncSession, feature_name: str
) -> dict[str, float]:
    """지표의 월평균 시계열. {ym_str: avg_value}."""
    rows = (
        await db.execute(
            select(Indicator.date, Indicator.value)
            .where(Indicator.feature_name == feature_name)
            .order_by(Indicator.date.asc())
        )
    ).all()
    bucket: dict[str, list[float]] = {}
    for d, v in rows:
        key = f"{d.year}{d.month:02d}"
        bucket.setdefault(key, []).append(float(v))
    return {k: mean(vs) for k, vs in bucket.items()}


def _build_period_insight(rate: float, focus: list[str]) -> str:
    """유사 시점 카드 하단 한 줄 인사이트 (POSCO 정중 톤, 룰 기반).

    영업담당자 다음 액션을 명시 — 당시 달성률 + 집중 고객사 1~2위로 결정.
    """
    top = focus[:2]
    top_str = " · ".join(top) if top else "—"
    if rate >= 1.0:
        return f"당시 달성률 {rate * 100:.0f}% — 목표 초과 달성. {top_str} 우선 접근을 권장드립니다."
    if rate >= 0.7:
        return f"당시 달성률 {rate * 100:.0f}% — 목표 근접. {top_str} 우선 검토를 권장드립니다."
    return f"당시 달성률 {rate * 100:.0f}% — 시그널 차이 분석이 필요해 보입니다. {top_str} 참고."


def cosine_similarity(a: np.ndarray, b: np.ndarray) -> float:
    na = np.linalg.norm(a)
    nb = np.linalg.norm(b)
    if na == 0 or nb == 0:
        return 0.0
    return float(np.dot(a, b) / (na * nb))


async def compute_module3(
    db: AsyncSession,
    *,
    product: str,
    today: DateT = DEMO_TODAY,
) -> tuple[list[MarketSummaryItem], list[SimilarityPoint], list[SimilarPeriod]]:
    """Module 3 — Z-score 정규화 + Cosine Similarity Top 3."""
    snapshots, _ = await collect_features(db, product)
    if not snapshots:
        return [], [], []

    # 1) feature 별 월평균 시계열 수집 — 데이터 없는 피처는 제외
    monthly_per_feature: dict[str, dict[str, float]] = {}
    for s in snapshots:
        avg = await _monthly_avg(db, s.name)
        if avg:
            monthly_per_feature[s.name] = avg
    snapshots = [s for s in snapshots if s.name in monthly_per_feature]

    if not monthly_per_feature:
        return [], [], []

    # 2) 공통 ym 집합 (데이터 있는 지표만)
    common_ym = set.intersection(*(set(d.keys()) for d in monthly_per_feature.values()))
    if not common_ym:
        return [], [], []
    ym_sorted = sorted(common_ym)
    if len(ym_sorted) < 6:
        return [], [], []

    # 3) 행렬 구성 (rows = ym, cols = feature)
    feature_names = [s.name for s in snapshots]
    matrix = np.array(
        [[monthly_per_feature[f][y] for f in feature_names] for y in ym_sorted],
        dtype=float,
    )
    # Z-score per column
    mu = matrix.mean(axis=0)
    sigma = matrix.std(axis=0)
    sigma[sigma == 0] = 1.0
    zmat = (matrix - mu) / sigma

    # 4) 당월 벡터 = today_ym 위치, 없으면 ym_sorted 의 가장 최근 월을 현재로 간주
    today_ym = f"{today.year}{today.month:02d}"
    current_ym = today_ym if today_ym in ym_sorted else ym_sorted[-1]
    cur_idx = ym_sorted.index(current_ym)
    cur_vec = zmat[cur_idx]

    # 5) 과거 벡터들 (cur_idx 제외) 와 코사인 유사도
    sims: list[tuple[str, float]] = []
    for i, y in enumerate(ym_sorted):
        if i == cur_idx:
            continue
        sims.append((y, cosine_similarity(cur_vec, zmat[i])))

    # 6) timeline — score = 코사인 유사도 % (0~100). label 은 yy.mm 통일.
    #    PRD 4.3.4 "월 단위 코사인 유사도 명시" 정합. 이전엔 Top 3 가
    #    max_score 를 차지해 일반 구간 막대가 보이지 않던 문제 해소.
    #    현재 시점은 score=100 (자기 자신과의 유사도 1.0 의미) + 별도 마커.
    timeline: list[SimilarityPoint] = []
    top_yms = {y for y, _ in sorted(sims, key=lambda x: x[1], reverse=True)[:3]}
    for y in ym_sorted:
        label = f"{y[2:4]}.{y[4:6]}"            # yy.mm 통일
        if y == current_ym:
            timeline.append(SimilarityPoint(
                label=label, score=100.0,
                highlighted=False, is_current=True,
            ))
        else:
            cos_val = next((v for k, v in sims if k == y), 0.0)
            timeline.append(SimilarityPoint(
                label=label,
                score=round(max(0.0, cos_val) * 100, 1),
                highlighted=(y in top_yms),
                is_current=False,
            ))

    # 6-2) 현재 시점의 시황 절대값 (당월 평균) — 카드의 delta chip 비교용
    current_values: dict[str, float] = {
        f: monthly_per_feature[f][current_ym] for f in feature_names
    }

    # 7) Top 3 SimilarPeriod 카드
    top3 = sorted(sims, key=lambda x: x[1], reverse=True)[:3]
    similar_periods: list[SimilarPeriod] = []
    for rank, (ym, cos_v) in enumerate(top3, start=1):
        year, month = int(ym[:4]), int(ym[4:6])
        # 단일 행 단위 — 고객사별 dict 로 받고 SUM 으로 제품 전체 산출.
        guide_by_cust = await _guide_lookup(db, ym, product)
        actual_by_cust = await _actual_lookup(db, ym, product)
        gv = sum(guide_by_cust.values())
        av = sum(actual_by_cust.values())
        rate = (av / gv) if gv else 0.0
        # 집중 고객사 — 본인 제품 actual 내림차순 (sales_actuals 직접).
        focus = [name for name, _ in sorted(actual_by_cust.items(), key=lambda x: x[1], reverse=True)]
        # 당시 시황 features — 현재 대비 delta chip 비교용 current_value + delta_pct
        market_features: list[MarketFeature] = []
        for f in feature_names:
            past = monthly_per_feature[f][ym]
            cur = current_values.get(f)
            delta = ((cur - past) / past * 100) if (cur is not None and past) else None
            market_features.append(MarketFeature(
                name=f,
                value=f"{past:.1f}",
                current_value=f"{cur:.1f}" if cur is not None else None,
                delta_pct=round(delta, 1) if delta is not None else None,
            ))

        # 한 줄 인사이트 (룰 기반, POSCO 정중 톤) — 영업담당자 다음 액션 명시
        insight = _build_period_insight(rate, focus)

        similar_periods.append(SimilarPeriod(
            rank=rank,
            period=f"{year}년 {month}월",
            cosine_similarity=round(cos_v, 2),
            description="—",
            tags=[],
            actual_volume=round(av, 1),
            guide_volume=round(gv, 1),
            achievement_rate=round(rate, 2),
            focus_customers=focus,
            market_features=market_features,
            insight=insight,
        ))

    # 8) 현재 시황 요약 (FE Module 3 상단)
    market_summary = [
        MarketSummaryItem(name=s.name, value=format_change(s.change_pct, s.name),
                          direction=direction_of(s.change_pct))
        for s in snapshots
    ]

    return market_summary, timeline, similar_periods


__all__ = [
    "DEMO_TODAY",
    "FeatureSnapshot",
    "build_grade_summary",
    "build_market_signal",
    "build_opportunity",
    "business_days_in_month",
    "collect_features",
    "compute_module1",
    "compute_module3",
    "elapsed_business_days",
    "grade_of",
    "market_impact_score",
    "normalize_pace",
    "normalize_yoy",
]
