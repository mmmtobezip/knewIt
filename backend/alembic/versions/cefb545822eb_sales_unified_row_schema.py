"""sales_unified_row_schema

설계자 피드백 반영. sales_guides / sales_actuals 를 단일 행 단위로 재편:
  기존: category_big (그룹별/제품별/고객사별) + category_mid + product
  새:   sales_group (후판판매그룹 등) + product + customer_name

한 행 = "이 판매그룹의 이 제품을 이 고객사에 얼마(천톤)" — 상위 집계는
SUM() 으로 BE 가 자동 계산. 결함 4 (제품 가이드 vs 고객사 합 불일치)가
구조적으로 해소.

마이그레이션 정책 (POC):
  - 기존 데이터 truncate (새 csv 재시드 필수)
  - 컬럼 폐기 + 추가 + UNIQUE 재구성

Revision ID: cefb545822eb
Revises: bf4a3ad5f8bc
Create Date: 2026-05-24 09:30:00.000000
"""
from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "cefb545822eb"
down_revision: str | None = "bf4a3ad5f8bc"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    # 기존 데이터 truncate — 새 csv 재시드로 채워짐
    op.execute("DELETE FROM sales_guides")
    op.execute("DELETE FROM sales_actuals")

    # ── sales_guides ──
    op.drop_constraint("uq_sales_guide_cat_prod_ym", "sales_guides", type_="unique")
    op.drop_index("ix_sales_guides_category_big", table_name="sales_guides")
    op.drop_index("ix_sales_guides_category_mid", table_name="sales_guides")
    op.drop_column("sales_guides", "category_big")
    op.drop_column("sales_guides", "category_mid")
    op.add_column(
        "sales_guides",
        sa.Column("sales_group", sa.String(length=32), nullable=False, server_default=""),
    )
    op.add_column(
        "sales_guides",
        sa.Column("customer_name", sa.String(length=128), nullable=False, server_default=""),
    )
    op.alter_column("sales_guides", "product", nullable=False, existing_type=sa.String(length=32))
    op.create_index("ix_sales_guides_sales_group", "sales_guides", ["sales_group"])
    op.create_index("ix_sales_guides_customer_name", "sales_guides", ["customer_name"])
    op.create_unique_constraint(
        "uq_sales_guide_group_prod_cust_ym",
        "sales_guides",
        ["sales_group", "product", "customer_name", "ym_str"],
    )

    # ── sales_actuals ──
    op.drop_constraint("uq_sales_actual_cat_prod_ym", "sales_actuals", type_="unique")
    op.drop_index("ix_sales_actuals_category_big", table_name="sales_actuals")
    op.drop_index("ix_sales_actuals_category_mid", table_name="sales_actuals")
    op.drop_column("sales_actuals", "category_big")
    op.drop_column("sales_actuals", "category_mid")
    op.add_column(
        "sales_actuals",
        sa.Column("sales_group", sa.String(length=32), nullable=False, server_default=""),
    )
    op.add_column(
        "sales_actuals",
        sa.Column("customer_name", sa.String(length=128), nullable=False, server_default=""),
    )
    op.alter_column("sales_actuals", "product", nullable=False, existing_type=sa.String(length=32))
    op.create_index("ix_sales_actuals_sales_group", "sales_actuals", ["sales_group"])
    op.create_index("ix_sales_actuals_customer_name", "sales_actuals", ["customer_name"])
    op.create_unique_constraint(
        "uq_sales_actual_group_prod_cust_ym",
        "sales_actuals",
        ["sales_group", "product", "customer_name", "ym_str"],
    )


def downgrade() -> None:
    # ── sales_actuals 역방향 ──
    op.drop_constraint("uq_sales_actual_group_prod_cust_ym", "sales_actuals", type_="unique")
    op.drop_index("ix_sales_actuals_customer_name", table_name="sales_actuals")
    op.drop_index("ix_sales_actuals_sales_group", table_name="sales_actuals")
    op.alter_column("sales_actuals", "product", nullable=True, existing_type=sa.String(length=32))
    op.drop_column("sales_actuals", "customer_name")
    op.drop_column("sales_actuals", "sales_group")
    op.add_column("sales_actuals", sa.Column("category_big", sa.String(length=16), nullable=False, server_default=""))
    op.add_column("sales_actuals", sa.Column("category_mid", sa.String(length=128), nullable=False, server_default=""))
    op.create_index("ix_sales_actuals_category_big", "sales_actuals", ["category_big"])
    op.create_index("ix_sales_actuals_category_mid", "sales_actuals", ["category_mid"])
    op.create_unique_constraint(
        "uq_sales_actual_cat_prod_ym", "sales_actuals",
        ["category_big", "category_mid", "product", "ym_str"],
    )

    # ── sales_guides 역방향 ──
    op.drop_constraint("uq_sales_guide_group_prod_cust_ym", "sales_guides", type_="unique")
    op.drop_index("ix_sales_guides_customer_name", table_name="sales_guides")
    op.drop_index("ix_sales_guides_sales_group", table_name="sales_guides")
    op.alter_column("sales_guides", "product", nullable=True, existing_type=sa.String(length=32))
    op.drop_column("sales_guides", "customer_name")
    op.drop_column("sales_guides", "sales_group")
    op.add_column("sales_guides", sa.Column("category_big", sa.String(length=16), nullable=False, server_default=""))
    op.add_column("sales_guides", sa.Column("category_mid", sa.String(length=128), nullable=False, server_default=""))
    op.create_index("ix_sales_guides_category_big", "sales_guides", ["category_big"])
    op.create_index("ix_sales_guides_category_mid", "sales_guides", ["category_mid"])
    op.create_unique_constraint(
        "uq_sales_guide_cat_prod_ym", "sales_guides",
        ["category_big", "category_mid", "product", "ym_str"],
    )
