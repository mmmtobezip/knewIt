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


# ─────────────────── Module 2 — 기회탐지 ───────────────────


class MarketSignal(BaseModel):
    status: MarketSignalStatus       # 강세/중립/약세 (시황 스코어 임계값 기반)
    score: float                     # %
    description: str
    responsible: str                 # 담당자 표시명


class KeyFeature(BaseModel):
    rank: int
    name: str                        # 지표명
    weight: float                    # importance × 100 (0~20 등 정수형 표시)
    direction: FeatureDirection
    change: str                      # "+3.8%" 형식 (FE 그대로 표시)
    cycle: FeatureCycle


class GradeSummary(BaseModel):
    grade_a: int
    grade_b: int
    grade_c: int


class CustomerMetric(BaseModel):
    label: str
    value: str
    sub: str | None = None


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
    value: str                       # 표시 문자열


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
    "KeyFeature",
    "MarketFeature",
    "MarketSignal",
    "MarketSignalStatus",
    "MarketSummaryItem",
    "RuleTagType",
    "SalesGuidePayload",
    "SimilarPeriod",
    "SimilarityPoint",
]
