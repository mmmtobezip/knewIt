"""PRD 0516 — 카탈로그 (lv1 제품 / lv2 제품별 거래처).

- `GET /api/catalog/products`: 모든 제품 코드 (lv1)
- `GET /api/catalog/customers?product=<code>`: 해당 제품 다루는 거래처
  (사용자 권한 내 — sales 는 본인 매핑만, admin 은 전체).
  product 미지정 시 사용자 전체 매핑 거래처 반환.
"""
from __future__ import annotations

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.auth import get_current_user
from app.core.response import ApiSuccess, ok
from app.db import get_db
from app.models import CustomerProfile, Product
from app.schemas.api import CustomersCatalogData, ProductsCatalogData
from app.schemas.domain import CustomerCatalogItem, SessionUser
from app.services.authorization import get_assigned_customer_ids

router = APIRouter(prefix="/api/catalog", tags=["catalog"])


@router.get(
    "/products",
    response_model=ApiSuccess[ProductsCatalogData],
    summary="lv1 — 전체 제품 코드 목록",
)
async def list_products(db: AsyncSession = Depends(get_db)) -> ApiSuccess[ProductsCatalogData]:
    codes = (await db.execute(select(Product.code).order_by(Product.code))).scalars().all()
    return ok(ProductsCatalogData(products=list(codes)))


@router.get(
    "/customers",
    response_model=ApiSuccess[CustomersCatalogData],
    summary="lv2 — 제품별 거래처 (사용자 권한 내)",
)
async def list_customers(
    product: str | None = Query(default=None, description="제품 코드 (없으면 전체 매핑 거래처)"),
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[CustomersCatalogData]:
    allowed = await get_assigned_customer_ids(db, user.user_id, user.user_role)

    stmt = select(CustomerProfile).where(CustomerProfile.customer_id.in_(allowed))
    if product:
        # ARRAY 컬럼에 product 가 포함되는 행만 — PostgreSQL `@>` 연산자
        stmt = stmt.where(CustomerProfile.product_group.contains([product]))

    rows = (await db.execute(stmt.order_by(CustomerProfile.customer_id))).scalars().all()
    items = [CustomerCatalogItem.model_validate(r) for r in rows]
    return ok(CustomersCatalogData(product=product, customers=items))
