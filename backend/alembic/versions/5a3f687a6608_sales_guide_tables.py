"""sales_guide_tables

PRD 판매량 가이드 (SCR-GUIDE-001) — 5개 신규 테이블:
    - product_variants  (제품_품종.csv)
    - sales_guides      (판매량_가이드.csv)
    - sales_actuals     (판매량_실적.csv)
    - order_lines       (주문.csv)
    - shipments         (출하실적.csv)

Revision ID: 5a3f687a6608
Revises: b618be188309
Create Date: 2026-05-23 19:30:00.000000
"""
from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "5a3f687a6608"
down_revision: str | None = "b618be188309"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _timestamps() -> list[sa.Column]:
    return [
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
    ]


def upgrade() -> None:
    # ── product_variants ──
    op.create_table(
        "product_variants",
        sa.Column("variant_code", sa.String(length=16), primary_key=True),
        sa.Column("variant_name", sa.String(length=16), primary_key=True),
        sa.Column("product", sa.String(length=32), nullable=False),
        sa.Column("detail", sa.String(length=128), nullable=True),
        *_timestamps(),
    )
    op.create_index("ix_product_variants_product", "product_variants", ["product"])

    # ── sales_guides ──
    op.create_table(
        "sales_guides",
        sa.Column("id", sa.BigInteger(), primary_key=True, autoincrement=True),
        sa.Column("category_big", sa.String(length=16), nullable=False),
        sa.Column("category_mid", sa.String(length=128), nullable=False),
        sa.Column("guide_value", sa.Float(), nullable=False),
        sa.Column("unit", sa.String(length=8), nullable=False, server_default="천톤"),
        sa.Column("ym_str", sa.String(length=6), nullable=False),
        *_timestamps(),
        sa.UniqueConstraint(
            "category_big", "category_mid", "ym_str", name="uq_sales_guide_cat_ym"
        ),
    )
    op.create_index("ix_sales_guides_category_big", "sales_guides", ["category_big"])
    op.create_index("ix_sales_guides_category_mid", "sales_guides", ["category_mid"])
    op.create_index("ix_sales_guides_ym_str", "sales_guides", ["ym_str"])

    # ── sales_actuals ──
    op.create_table(
        "sales_actuals",
        sa.Column("id", sa.BigInteger(), primary_key=True, autoincrement=True),
        sa.Column("category_big", sa.String(length=16), nullable=False),
        sa.Column("category_mid", sa.String(length=128), nullable=False),
        sa.Column("actual_value", sa.Float(), nullable=False),
        sa.Column("unit", sa.String(length=8), nullable=False, server_default="천톤"),
        sa.Column("ym_str", sa.String(length=6), nullable=False),
        *_timestamps(),
        sa.UniqueConstraint(
            "category_big", "category_mid", "ym_str", name="uq_sales_actual_cat_ym"
        ),
    )
    op.create_index("ix_sales_actuals_category_big", "sales_actuals", ["category_big"])
    op.create_index("ix_sales_actuals_category_mid", "sales_actuals", ["category_mid"])
    op.create_index("ix_sales_actuals_ym_str", "sales_actuals", ["ym_str"])

    # ── order_lines ──
    op.create_table(
        "order_lines",
        sa.Column("order_line_no", sa.String(length=32), primary_key=True),
        sa.Column("customer_name", sa.String(length=128), nullable=False),
        sa.Column("variant_code", sa.String(length=16), nullable=False),
        sa.Column("salesperson", sa.String(length=64), nullable=False),
        *_timestamps(),
    )
    op.create_index("ix_order_lines_customer_name", "order_lines", ["customer_name"])
    op.create_index("ix_order_lines_variant_code", "order_lines", ["variant_code"])
    op.create_index("ix_order_lines_salesperson", "order_lines", ["salesperson"])

    # ── shipments ──
    op.create_table(
        "shipments",
        sa.Column("id", sa.BigInteger(), primary_key=True, autoincrement=True),
        sa.Column("shipped_at", sa.Date(), nullable=False),
        sa.Column("customer_name", sa.String(length=128), nullable=False),
        sa.Column("weight_kg", sa.Float(), nullable=False),
        sa.Column("weight_unit", sa.String(length=8), nullable=False, server_default="Kg"),
        sa.Column("order_line_no", sa.String(length=32), nullable=False),
        sa.Column("variant_code", sa.String(length=16), nullable=False),
        *_timestamps(),
        sa.UniqueConstraint("order_line_no", "shipped_at", name="uq_shipment_order_date"),
    )
    op.create_index("ix_shipments_shipped_at", "shipments", ["shipped_at"])
    op.create_index("ix_shipments_customer_name", "shipments", ["customer_name"])
    op.create_index("ix_shipments_order_line_no", "shipments", ["order_line_no"])
    op.create_index("ix_shipments_variant_code", "shipments", ["variant_code"])


def downgrade() -> None:
    op.drop_table("shipments")
    op.drop_table("order_lines")
    op.drop_table("sales_actuals")
    op.drop_table("sales_guides")
    op.drop_table("product_variants")
