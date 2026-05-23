"""PRD 0516 — 사용자 프로필 (로그인 화면 부재).

- `GET /api/users`: 인증 면제. 프로필 picker 용 사용자 목록.
- `GET /api/users/me`: 인증 필요. 현재 X-User-Id 헤더 사용자 + 담당 거래처 수.
"""
from __future__ import annotations

from fastapi import APIRouter, Depends
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.auth import get_current_user
from app.core.response import ApiSuccess, ok
from app.db import get_db
from app.models import AssignedCustomer, User
from app.schemas.api import UserMeData, UsersListData
from app.schemas.domain import SessionUser, UserMe, UserOut

router = APIRouter(prefix="/api/users", tags=["users"])


@router.get(
    "",
    response_model=ApiSuccess[UsersListData],
    summary="사용자 목록 (프로필 picker — 인증 면제)",
)
async def list_users(db: AsyncSession = Depends(get_db)) -> ApiSuccess[UsersListData]:
    rows = (await db.execute(select(User).order_by(User.user_id))).scalars().all()
    users = [UserOut.model_validate(r) for r in rows]
    return ok(UsersListData(users=users))


@router.get(
    "/me",
    response_model=ApiSuccess[UserMeData],
    summary="현재 사용자 (X-User-Id 헤더 기반) + 담당 거래처 수",
)
async def get_me(
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[UserMeData]:
    count = (
        await db.execute(
            select(func.count(AssignedCustomer.customer_id)).where(
                AssignedCustomer.user_id == user.user_id
            )
        )
    ).scalar_one()
    me = UserMe(
        user_id=user.user_id,
        name=user.name,
        role=user.user_role,
        primary_product_code=user.primary_product_code,
        assigned_customers_count=int(count),
    )
    return ok(UserMeData(user=me))
