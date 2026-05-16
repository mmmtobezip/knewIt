"""고객사 프로필 조회 (PRD 0514)."""
from __future__ import annotations

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.auth import get_current_user
from app.core.errors import ApiException, ErrorCode
from app.core.response import ApiSuccess, ok
from app.db import get_db
from app.models import CustomerProfile as CustomerProfileORM
from app.schemas.api import CustomerProfileData
from app.schemas.domain import CustomerProfile, SessionUser
from app.services.authorization import assert_customer_access

router = APIRouter(prefix="/api/customers", tags=["customers"])


@router.get(
    "/{customer_id}/profile",
    response_model=ApiSuccess[CustomerProfileData],
    summary="고객사 프로필 (PRD 0514 스키마)",
)
async def get_customer_profile(
    customer_id: str,
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[CustomerProfileData]:
    await assert_customer_access(db, user, customer_id)
    row = await db.get(CustomerProfileORM, customer_id)
    if row is None:
        raise ApiException(ErrorCode.DATA_001)
    return ok(
        CustomerProfileData(customer_profile=CustomerProfile.model_validate(row))
    )
