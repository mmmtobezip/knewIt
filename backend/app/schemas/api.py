"""PRD 0514 API 응답 데이터 래퍼."""
from __future__ import annotations

from enum import StrEnum

from pydantic import BaseModel, Field

from app.schemas.domain import (
    CauseFlowStep,
    CustomerCatalogItem,
    CustomerProfile,
    IndicatorSeries,
    Interpretation,
    Product,
    QuestionAnswer,
    Strategy,
    TodayQuestion,
    TopMover,
    UserMe,
    UserOut,
)


class CustomerProfileData(BaseModel):
    customer_profile: CustomerProfile


class UsersListData(BaseModel):
    users: list[UserOut]


class UserMeData(BaseModel):
    user: UserMe


class ProductsCatalogData(BaseModel):
    products: list[str]


class CustomersCatalogData(BaseModel):
    product: str | None = None
    customers: list[CustomerCatalogItem]


class ProductData(BaseModel):
    product: Product


class TopMoversData(BaseModel):
    product: str
    top_movers: list[TopMover]


class CauseFlowData(BaseModel):
    flow: list[CauseFlowStep]


class InterpretationData(BaseModel):
    interpretation: Interpretation


class StrategyData(BaseModel):
    strategy: Strategy


class TodayQuestionsData(BaseModel):
    product: str
    generated_at: str
    questions: list[TodayQuestion]


class QuestionAnswerData(BaseModel):
    answer: QuestionAnswer


class IndicatorsData(BaseModel):
    indicators: IndicatorSeries


# ── 통합 대시보드 응답 (PRD 6장 통합 Output 스키마) ─────────
class DashboardData(BaseModel):
    customer: str
    product: str
    generated_at: str
    chart1_top_movers: list[TopMover]
    chart2_cause_flow: list[CauseFlowStep]
    interpretation: Interpretation
    strategy: Strategy


# ── 캐시 무효화 ─────────────────────────────────────────────
class CacheScope(StrEnum):
    TOP_MOVERS = "top_movers"
    CAUSE_FLOW = "cause_flow"
    INTERPRETATION = "interpretation"
    STRATEGY = "strategy"
    NEWS = "news"
    QUESTIONS = "questions"


class CacheInvalidateRequest(BaseModel):
    customer_id: str | None = None
    product_code: str | None = None
    scope: list[CacheScope] = Field(min_length=1)


class CacheInvalidateData(BaseModel):
    invalidated_keys: list[str]
