from sqlalchemy import Float, String
from sqlalchemy.dialects.postgresql import ARRAY, JSONB
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base, TimestampMixin


class CustomerProfile(Base, TimestampMixin):
    """노션 PRD(0514) CUSTOMER_PROFILE.

    필드 매핑:
    - product_group: 거래처가 다루는 제품군 (배열, 단일 element 가능)
    - sensitive_topics: 거래처가 민감하게 반응하는 주제 (추천 행동/협상 포인트 기반)
    - risk_factors: 거래처 리스크 (Impact 분석 기반)
    """
    __tablename__ = "customer_profiles"

    customer_id: Mapped[str] = mapped_column(String(128), primary_key=True)
    industry: Mapped[str] = mapped_column(String(128), nullable=False)
    market_region: Mapped[str] = mapped_column(String(64), nullable=False)
    product_group: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)
    sensitive_topics: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)
    risk_factors: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)


class Product(Base, TimestampMixin):
    """노션 PRD(0514) PRODUCT_CONFIG.

    - key_features / key_feature_importance: 핵심 지표명 + 가중치 (배열 인덱스 일치)
    - axis: 5개 관점(원료 역동성/시장가격/수급현황/거시경제/전방산업) 매핑
      각 관점은 {indicators: [...], weights: [...]}
    """
    __tablename__ = "products"

    code: Mapped[str] = mapped_column(String(64), primary_key=True)
    key_features: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)
    key_feature_importance: Mapped[list[float]] = mapped_column(
        ARRAY(Float), nullable=False, default=list
    )
    axis: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
