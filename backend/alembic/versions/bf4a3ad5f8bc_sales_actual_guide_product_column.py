"""sales_actual_guide_product_column

PRD 결함 정합 — sales_guides / sales_actuals 에 product 컬럼 추가.

설계자 피드백 반영:
  - "고객사별" 행을 product 별로 분리 → BE 가 user.primary_product_code
    로 직접 필터 가능. customer_profile.product_group 우회 join 폐기.
  - 다제품 고객사(포스코인터내셔널) 가 단일 customer_id 를 유지하면서
    실적/가이드는 제품별로 split (선재 10 + 후판 8 천톤 같은 형태).

기존 unique (cat, mid, ym) → 새 unique (cat, mid, product, ym).
"그룹별" 행은 product=NULL (PG 의 NULL distinct 동작으로 중복 입력 가능하지만
시드 시 자연 1행/월).

Revision ID: bf4a3ad5f8bc
Revises: 5a3f687a6608
Create Date: 2026-05-23 21:45:00.000000
"""
from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "bf4a3ad5f8bc"
down_revision: str | None = "5a3f687a6608"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    # ── sales_guides ──
    op.add_column("sales_guides", sa.Column("product", sa.String(length=32), nullable=True))
    op.create_index("ix_sales_guides_product", "sales_guides", ["product"])
    op.drop_constraint("uq_sales_guide_cat_ym", "sales_guides", type_="unique")
    op.create_unique_constraint(
        "uq_sales_guide_cat_prod_ym",
        "sales_guides",
        ["category_big", "category_mid", "product", "ym_str"],
    )

    # ── sales_actuals ──
    op.add_column("sales_actuals", sa.Column("product", sa.String(length=32), nullable=True))
    op.create_index("ix_sales_actuals_product", "sales_actuals", ["product"])
    op.drop_constraint("uq_sales_actual_cat_ym", "sales_actuals", type_="unique")
    op.create_unique_constraint(
        "uq_sales_actual_cat_prod_ym",
        "sales_actuals",
        ["category_big", "category_mid", "product", "ym_str"],
    )


def downgrade() -> None:
    op.drop_constraint("uq_sales_actual_cat_prod_ym", "sales_actuals", type_="unique")
    op.create_unique_constraint(
        "uq_sales_actual_cat_ym",
        "sales_actuals",
        ["category_big", "category_mid", "ym_str"],
    )
    op.drop_index("ix_sales_actuals_product", table_name="sales_actuals")
    op.drop_column("sales_actuals", "product")

    op.drop_constraint("uq_sales_guide_cat_prod_ym", "sales_guides", type_="unique")
    op.create_unique_constraint(
        "uq_sales_guide_cat_ym",
        "sales_guides",
        ["category_big", "category_mid", "ym_str"],
    )
    op.drop_index("ix_sales_guides_product", table_name="sales_guides")
    op.drop_column("sales_guides", "product")
