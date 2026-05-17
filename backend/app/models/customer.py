from sqlalchemy import Float, String
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base, TimestampMixin


class CustomerProfile(Base, TimestampMixin):
    """노션 PRD(0516) CUSTOMER_PROFILE.

    - product_group: 거래처가 다루는 제품군 (다중 가능, 예: 포스코인터내셔널=[선재,후판])
    - sensitive_topics: 추천 행동/협상 포인트 LLM 입력
    - risk_factors: Impact 분석 LLM 입력
    """
    __tablename__ = "customer_profiles"

    customer_id: Mapped[str] = mapped_column(String(128), primary_key=True)
    industry: Mapped[str] = mapped_column(String(128), nullable=False)
    market_region: Mapped[str] = mapped_column(String(64), nullable=False)
    product_group: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)
    sensitive_topics: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)
    risk_factors: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)


class Product(Base, TimestampMixin):
    """노션 PRD(0516) PRODUCT_CONFIG.

    - key_features: 핵심 지표명 10개 (배열 인덱스 = importance/cycle 인덱스)
    - key_feature_importance: 가중치 (합 ~= 1.0)
    - key_feature_cycle: 각 지표의 수집 주기 ("D" / "W" / "M") — FE 차트 기간 탭과 매칭
    """
    __tablename__ = "products"

    code: Mapped[str] = mapped_column(String(64), primary_key=True)
    key_features: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)
    key_feature_importance: Mapped[list[float]] = mapped_column(
        ARRAY(Float), nullable=False, default=list
    )
    key_feature_cycle: Mapped[list[str]] = mapped_column(
        ARRAY(String), nullable=False, default=list
    )
