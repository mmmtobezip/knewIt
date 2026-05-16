"""고객사 접근 권한 (IPO Q15).

- sales: 본인 매핑 고객사만
- manager: 본인 + org_hierarchy.subordinate 의 매핑 UNION
- admin: 전체 고객사
"""
from __future__ import annotations

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.errors import ApiException, ErrorCode
from app.models import AssignedCustomer, CustomerProfile, OrgHierarchy
from app.schemas.domain import SessionUser, UserRole


async def get_assigned_customer_ids(
    db: AsyncSession, user_id: str, role: UserRole
) -> set[str]:
    if role == UserRole.ADMIN:
        rows = (await db.execute(select(CustomerProfile.customer_id))).scalars().all()
        return set(rows)

    own_stmt = select(AssignedCustomer.customer_id).where(
        AssignedCustomer.user_id == user_id
    )
    if role == UserRole.SALES:
        rows = (await db.execute(own_stmt)).scalars().all()
        return set(rows)

    if role == UserRole.MANAGER:
        team_stmt = (
            select(AssignedCustomer.customer_id)
            .join(OrgHierarchy, OrgHierarchy.subordinate_id == AssignedCustomer.user_id)
            .where(OrgHierarchy.manager_id == user_id)
        )
        rows = (await db.execute(own_stmt.union(team_stmt))).scalars().all()
        return set(rows)

    return set()


async def assert_customer_access(
    db: AsyncSession, user: SessionUser, customer_id: str
) -> None:
    allowed = await get_assigned_customer_ids(db, user.user_id, user.user_role)
    if customer_id not in allowed:
        raise ApiException(ErrorCode.PERM_001)
