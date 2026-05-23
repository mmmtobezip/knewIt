"""PRD 판매량 가이드 — 5개 신규 테이블.

CSV 매핑 (docs/resource/*.csv):
    제품_품종.csv       → product_variants
    판매량_가이드.csv   → sales_guides
    판매량_실적.csv     → sales_actuals
    주문.csv            → order_lines
    출하실적.csv        → shipments

PRD 2.10 데이터 조인:
    order_lines.salesperson = 로그인 사용자 → order_lines.order_line_no
    → shipments.order_line_no → 당월 누적 실적 (천톤)
    shipments.variant_code → product_variants.variant_code → product
    sales_guides/sales_actuals: (category_big, category_mid, ym_str) 키로 조회
"""
from __future__ import annotations

from datetime import date as DateT

from sqlalchemy import BigInteger, Float, String, UniqueConstraint
from sqlalchemy import Date as SQLDate
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base, TimestampMixin

# ────────────────── 제품_품종 ──────────────────


class ProductVariant(Base, TimestampMixin):
    """제품 ↔ 품종 ↔ 품명 매핑.

    동일 품종(예: WR)이 여러 품명(WA, WB)을 가질 수 있어 (품종, 품명) composite PK.
    같은 품종은 항상 같은 product (PRD 보장) — variant_code 만으로도 product 식별 가능.
    """

    __tablename__ = "product_variants"

    variant_code: Mapped[str] = mapped_column(String(16), primary_key=True)   # 품종 (예: HE, PJ, WR)
    variant_name: Mapped[str] = mapped_column(String(16), primary_key=True)   # 품명 (예: HE, WA, WB)
    product: Mapped[str] = mapped_column(String(32), nullable=False, index=True)  # 제품 (후판/선재/HR(고로밀))
    detail: Mapped[str | None] = mapped_column(String(128))                   # 상세내용 (HR PLATE 등)


# ────────────────── 판매량_가이드 / 판매량_실적 ──────────────────


class SalesGuide(Base, TimestampMixin):
    """월별 판매량 가이드값 — 단일 행 단위 (판매그룹/제품/고객사).

    설계자 피드백 반영. 기존 "그룹별/제품별/고객사별" 분류 컬럼 폐기.
    한 행 = "이 판매그룹의 이 제품을 이 고객사에 얼마 팔 목표(천톤)".

    상위 집계는 BE 가 SUM() 으로 자동 계산:
      - 제품 전체 = SUM(WHERE product=후판, ym=now)
      - 판매그룹 전체 = SUM(WHERE sales_group=후판판매그룹, ym=now)
      - 고객사별 = 단일 행

    이로써 결함 4 (제품 가이드 vs 고객사 합 불일치) 가 구조적으로 해소.
    """

    __tablename__ = "sales_guides"
    __table_args__ = (
        UniqueConstraint(
            "sales_group", "product", "customer_name", "ym_str",
            name="uq_sales_guide_group_prod_cust_ym",
        ),
    )

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    sales_group: Mapped[str] = mapped_column(String(32), nullable=False, index=True)    # 후판판매그룹/선재판매그룹
    product: Mapped[str] = mapped_column(String(32), nullable=False, index=True)        # 후판/선재/HR(고로밀)
    customer_name: Mapped[str] = mapped_column(String(128), nullable=False, index=True)
    guide_value: Mapped[float] = mapped_column(Float, nullable=False)
    unit: Mapped[str] = mapped_column(String(8), nullable=False, default="천톤")
    ym_str: Mapped[str] = mapped_column(String(6), nullable=False, index=True)


class SalesActual(Base, TimestampMixin):
    """월별 판매량 실적 — SalesGuide 와 동일 구조 (단일 행 단위).

    당월은 shipments raw 에서 집계, 과거 월은 이 테이블에서 조회.
    """

    __tablename__ = "sales_actuals"
    __table_args__ = (
        UniqueConstraint(
            "sales_group", "product", "customer_name", "ym_str",
            name="uq_sales_actual_group_prod_cust_ym",
        ),
    )

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    sales_group: Mapped[str] = mapped_column(String(32), nullable=False, index=True)
    product: Mapped[str] = mapped_column(String(32), nullable=False, index=True)
    customer_name: Mapped[str] = mapped_column(String(128), nullable=False, index=True)
    actual_value: Mapped[float] = mapped_column(Float, nullable=False)
    unit: Mapped[str] = mapped_column(String(8), nullable=False, default="천톤")
    ym_str: Mapped[str] = mapped_column(String(6), nullable=False, index=True)


# ────────────────── 주문 / 출하실적 ──────────────────


class OrderLine(Base, TimestampMixin):
    """주문번호_라인 단위 (판매사원 → 내 실적 필터링 키)."""

    __tablename__ = "order_lines"

    order_line_no: Mapped[str] = mapped_column(String(32), primary_key=True)
    customer_name: Mapped[str] = mapped_column(String(128), nullable=False, index=True)
    variant_code: Mapped[str] = mapped_column(String(16), nullable=False, index=True)   # 품종
    salesperson: Mapped[str] = mapped_column(String(64), nullable=False, index=True)    # 박지은/박현웅


class Shipment(Base, TimestampMixin):
    """출하실적 (매출계상일 기준)."""

    __tablename__ = "shipments"
    __table_args__ = (
        UniqueConstraint(
            "order_line_no", "shipped_at",
            name="uq_shipment_order_date",
        ),
    )

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    shipped_at: Mapped[DateT] = mapped_column(SQLDate, nullable=False, index=True)      # 매출계상일
    customer_name: Mapped[str] = mapped_column(String(128), nullable=False, index=True)
    weight_kg: Mapped[float] = mapped_column(Float, nullable=False)                     # 중량 (Kg)
    weight_unit: Mapped[str] = mapped_column(String(8), nullable=False, default="Kg")
    order_line_no: Mapped[str] = mapped_column(String(32), nullable=False, index=True)  # FK → order_lines
    variant_code: Mapped[str] = mapped_column(String(16), nullable=False, index=True)
