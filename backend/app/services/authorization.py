"""고객사 접근 권한 (IPO Q15 + 해커톤 시연용 조정).

PRD 원안:
- sales: 본인 매핑 고객사만
- manager: 본인 + org_hierarchy.subordinate 의 매핑 UNION
- admin: 전체 고객사

해커톤 시연 조정 (이 commit 범위):
- `get_assigned_customer_ids`: PRD 원안 그대로 (catalog/customers 등이 본인 담당만 반환)
- `assert_customer_access`: 시연용 통과 — dashboard 호출이 본인 매핑이 아닌 거래처여도 OK
  (박지은이 박현웅 담당 고객사를 잘못 클릭해도 403 안 띄움)
  정식 권한 검사 복원은 별도 commit 으로.
"""
from __future__ import annotations

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

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
    db: AsyncSession,  # noqa: ARG001
    user: SessionUser,  # noqa: ARG001
    customer_id: str,  # noqa: ARG001
) -> None:
    """해커톤 시연용 통과. PRD 권한 검사는 별도 commit 에서 복원."""
    return
