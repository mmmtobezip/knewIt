"""판매량 가이드 (SCR-GUIDE-001) — Pydantic schemas.

FE frontend/src/types/sales-guide.ts 와 1:1 매핑.
- Module 1: AchievementKpi + CustomerAchievement[]
- Module 2: MarketSignal + KeyFeature[] + GradeSummary + CustomerOpportunity[]
- Module 3: MarketSummaryItem[] + SimilarityPoint[] + SimilarPeriod[]
"""
from __future__ import annotations

from typing import Literal

from pydantic import BaseModel, Field

# ─────────────────── Literals (FE enum 매핑) ───────────────────

AchievementStatus = Literal["normal", "warning", "danger"]
MarketSignalStatus = Literal["강세", "중립", "약세"]
FeatureCycle = Literal["DAILY", "WEEKLY", "MONTHLY"]
FeatureDirection = Literal["UP", "DOWN", "FLAT"]
CustomerGrade = Literal["A", "A-", "B+", "B", "C", "D"]
RuleTagType = Literal["info", "warning", "danger"]


# ─────────────────── Module 1 — 가이드값 달성률 ───────────────────


class AchievementKpi(BaseModel):
    achievement_rate: float          # 0~1.x (당월 / 가이드)
    yoy_change: float                # -1~+1.x (전년 동월 대비)
    actual_volume: float             # 천톤
    guide_volume: float              # 천톤
    volume_unit: str = "천톤"
    # 참고용 — 판매그룹 전체 가이드 (시연 가상값). 내 책임 거래처 가이드가
    # 전체의 일부임을 info tooltip 에 표시. 실 운영 시 sales_groups 테이블로 이관.
    group_total_guide: float = 0.0


class CustomerAchievement(BaseModel):
    customer_id: str
    customer_name: str
    industry: str
    achievement_rate: float
    actual_volume: float
    guide_volume: float
    volume_unit: str = "천톤"
    yoy_change: float
    status: AchievementStatus
    prev_achievement_rate: float = 0.0   # 전년 동월 달성률 (0~1.x)
    yoy_label: str = ""                  # 예: "2025년 5월"


# ─────────────────── Module 2 — 기회탐지 ───────────────────


class MarketSignal(BaseModel):
    status: MarketSignalStatus       # 강세/중립/약세 (시황 스코어 임계값 기반)
    score: float                     # %
    description: str
    responsible: str                 # 담당자 표시명


class IndicatorPoint(BaseModel):
    date: str    # YYYY-MM-DD
    value: float


class KeyFeature(BaseModel):
    rank: int
    name: str                        # 지표명
    weight: float                    # importance × 100 (0~20 등 정수형 표시)
    direction: FeatureDirection
    change: str                      # "+3.8%" 형식 (FE 그대로 표시)
    cycle: FeatureCycle
    current_value: str | None = None  # 최신 실측값 표시 문자열
    current_date: str | None = None   # 최신 실측값 날짜 (YYYY-MM-DD)
    unit: str = ""                    # 단위 (예: USD/MT, %, 원/톤)
    history: list[IndicatorPoint] = Field(default_factory=list)  # 90일 스파크라인용


class GradeSummary(BaseModel):
    grade_a: int
    grade_b: int
    grade_c: int


class CustomerMetric(BaseModel):
    label: str
    value: str
    sub: str | None = None


class MarketDriver(BaseModel):
    name: str          # 지표명
    direction: int     # +1 or -1 (구조적 관계: 지표 상승 → 구매 증가/감소)
    contribution: float  # abs(change_pct × weight × direction)
    impact_sign: int = 0  # sign(change_pct × direction): +1=현재 긍정 작용, -1=현재 부정 작용


class CustomerOpportunity(BaseModel):
    customer_id: str
    customer_name: str
    grade: CustomerGrade
    score: int                       # 0~100 종합 스코어
    industry: str
    achievement_rate: float
    opportunity_tags: list[str] = Field(default_factory=list)
    risk_tags: list[str] = Field(default_factory=list)
    rule_tag: str                    # 한 줄 규칙 코멘트
    rule_tag_type: RuleTagType
    sensitivity_tags: list[str] = Field(default_factory=list)  # customer.sensitive_topics
    metrics: list[CustomerMetric] = Field(default_factory=list)  # 달성속도/전년대비/시황영향
    market_directions: dict[str, int] = Field(default_factory=dict)   # 지표명 → +1/-1/0
    top_market_drivers: list[MarketDriver] = Field(default_factory=list)  # 기여 상위 3개


# ─────────────────── Module 3 — 과거 시황 학습 리포트 ───────────────────


class MarketSummaryItem(BaseModel):
    name: str
    value: str                       # "104 USD" 등 표시 문자열
    direction: FeatureDirection


class SimilarityPoint(BaseModel):
    label: str                       # "25.03" / "05▸" (현재)
    score: float                     # 0~100 표시 점수
    highlighted: bool                # Top 3 표시
    is_current: bool                 # 현재 시점


class MarketFeature(BaseModel):
    name: str
    value: str                       # 당시 시점 값 (표시 문자열)
    current_value: str | None = None # 현재 시점 값 — delta chip 비교용
    delta_pct: float | None = None   # 현재 대비 과거 변화율 (%); past→current


class SimilarPeriod(BaseModel):
    rank: int
    period: str                      # "2025년 9월"
    cosine_similarity: float
    description: str
    tags: list[str] = Field(default_factory=list)
    actual_volume: float
    guide_volume: float
    achievement_rate: float
    focus_customers: list[str] = Field(default_factory=list)
    market_features: list[MarketFeature] = Field(default_factory=list)
    insight: str | None = None       # 카드 하단 한 줄 액션 인사이트 (룰 기반)


# ─────────────────── Unified Payload ───────────────────


class SalesGuidePayload(BaseModel):
    customer: str
    product: str
    generated_at: str
    # Module 1
    achievement_kpi: AchievementKpi
    customer_achievements: list[CustomerAchievement]
    # Module 2
    market_signal: MarketSignal
    key_features: list[KeyFeature]
    grade_summary: GradeSummary
    customer_opportunities: list[CustomerOpportunity]
    # Module 3
    market_summary: list[MarketSummaryItem]
    similarity_timeline: list[SimilarityPoint]
    similar_periods: list[SimilarPeriod]


__all__ = [
    "AchievementKpi",
    "AchievementStatus",
    "CustomerAchievement",
    "CustomerGrade",
    "CustomerMetric",
    "CustomerOpportunity",
    "FeatureCycle",
    "FeatureDirection",
    "GradeSummary",
    "IndicatorPoint",
    "KeyFeature",
    "MarketDriver",
    "MarketFeature",
    "MarketSignal",
    "MarketSignalStatus",
    "MarketSummaryItem",
    "RuleTagType",
    "SalesGuidePayload",
    "SimilarPeriod",
    "SimilarityPoint",
]
