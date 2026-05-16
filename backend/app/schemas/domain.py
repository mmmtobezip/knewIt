"""PRD 0514 Pydantic 도메인 타입.

shared/types/*.ts 일부는 더 이상 사용하지 않음 (negotiation_style 제거).
새 PRD 출력 스키마(MCS-Advisor + SMI-Bot v1.1) 기준.
"""
from __future__ import annotations

from datetime import date as DateT
from datetime import datetime
from enum import StrEnum
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field


class Direction(StrEnum):
    UP = "UP"
    DOWN = "DOWN"


class UserRole(StrEnum):
    SALES = "sales"
    MANAGER = "manager"
    ADMIN = "admin"


class AssignmentRole(StrEnum):
    PRIMARY = "primary"
    SUPPORT = "support"


class _ORMModel(BaseModel):
    model_config = ConfigDict(from_attributes=True)


class CustomerProfile(_ORMModel):
    customer_id: str
    industry: str
    market_region: str
    product_group: list[str]
    sensitive_topics: list[str]
    risk_factors: list[str]


class AxisGroup(BaseModel):
    indicators: list[str]
    weights: list[float]


class Product(_ORMModel):
    code: str
    key_features: list[str]
    key_feature_importance: list[float]
    axis: dict[str, AxisGroup]


# ── Top Mover (메인 대시보드 차트1) ────────────────────────
class TopMover(BaseModel):
    indicator: str
    value: float
    unit: str
    change_d1: float | None = None
    change_w1: float
    change_m1: float | None = None
    score: float
    series: list[IndicatorPointOut] = Field(default_factory=list)


# ── Cause Flow (메인 대시보드 차트2) ───────────────────────
class FlowEvidence(BaseModel):
    news_id: str
    title: str
    date: str
    url: str


class CauseFlowStep(BaseModel):
    step: int
    node: str
    evidence: list[FlowEvidence] = Field(default_factory=list)


# ── LLM 해석 (메인 대시보드 What/Why/Impact) ────────────────
class ImpactItem(BaseModel):
    risk_factor: str
    direction: Literal["증폭", "완화", "중립"]
    reason: str


class Interpretation(BaseModel):
    what: str
    why: str
    impact: list[ImpactItem]


# ── 전략 (메인 대시보드 전략/추천행동/협상포인트) ────────────
class Strategy(BaseModel):
    strategy_summary: str
    recommended_actions: list[str] = Field(min_length=1, max_length=5)
    negotiation_points: list[str] = Field(min_length=1, max_length=5)


# ── 추천 질문 (SMI-Bot v1.1) ────────────────────────────────
class TodayQuestion(BaseModel):
    qid: str
    text: str
    trigger_indicators: list[str]
    related_groups_internal: list[str]
    score: float


# ── 답변 (SMI-Bot v1.1) ─────────────────────────────────────
class AnswerSources(BaseModel):
    indicators: list[str]


class QuestionAnswer(BaseModel):
    qid: str
    briefing: str
    sales_rep_script: str
    sources: AnswerSources
    confidence: float


# ── 뉴스 (인과 흐름도 evidence) ──────────────────────────────
class NewsDoc(BaseModel):
    source: str
    title: str
    summary: str
    url: str
    published_at: datetime


# ── 지표 시계열 ──────────────────────────────────────────────
class IndicatorPointOut(BaseModel):
    date: DateT
    value: float


class IndicatorSeries(BaseModel):
    feature_name: str
    unit: str
    points: list[IndicatorPointOut]


# ── 세션 ────────────────────────────────────────────────────
class SessionUser(BaseModel):
    user_id: str
    user_role: UserRole
    name: str | None = None
