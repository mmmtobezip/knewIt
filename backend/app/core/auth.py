"""인증 의존성 (Phase 2 MVP).

정책:
    - Authorization: Bearer mock-token-{user_id}  → user_id 추출
    - 또는 X-User-Id: {user_id}                     → 개발 편의용 직읽기
    - 둘 다 없으면 E_AUTH_002
    - user_id 가 DB users 에 없으면 E_AUTH_001

FE 가 이미 `mock-token-emp_2026001` 형태로 호출 중이므로 그대로 호환.
실제 SSO/JWT 발급은 추후 Phase 에서 교체.
"""
from __future__ import annotations

from fastapi import Depends, Header
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.errors import ApiException, ErrorCode
from app.db import get_db
from app.models import User
from app.schemas.domain import SessionUser, UserRole

_MOCK_TOKEN_PREFIX = "mock-token-"


def _extract_user_id(authorization: str | None, x_user_id: str | None) -> str | None:
    if x_user_id:
        return x_user_id.strip()
    if not authorization:
        return None
    if not authorization.lower().startswith("bearer "):
        return None
    token = authorization[7:].strip()
    if token.startswith(_MOCK_TOKEN_PREFIX):
        return token[len(_MOCK_TOKEN_PREFIX):]
    return None


async def get_current_user(
    authorization: str | None = Header(default=None),
    x_user_id: str | None = Header(default=None, alias="X-User-Id"),
    db: AsyncSession = Depends(get_db),
) -> SessionUser:
    user_id = _extract_user_id(authorization, x_user_id)
    if not user_id:
        raise ApiException(ErrorCode.AUTH_002)
    row = await db.get(User, user_id)
    if row is None:
        raise ApiException(ErrorCode.AUTH_001)
    return SessionUser(
        user_id=row.user_id,
        user_role=UserRole(row.role.value),
        name=row.name,
    )
