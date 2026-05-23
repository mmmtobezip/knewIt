"""PRD 0523 — 로그인 (해커톤 시연용 mock 인증).

- POST /api/auth/login
  · login_id: 사번(`301096`) 또는 user_id(`emp_2026003`) 모두 허용
  · password: mock — 일괄 `"1234"`
  · 성공: `mock-token-{user_id}` + UserOut 반환
"""
from __future__ import annotations

from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy import or_, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.errors import ApiException, ErrorCode
from app.core.response import ApiSuccess, ok
from app.db import get_db
from app.models import User
from app.schemas.domain import UserOut

router = APIRouter(prefix="/api/auth", tags=["auth"])


class LoginRequest(BaseModel):
    login_id: str  # 사번 또는 user_id
    password: str


class LoginResponseData(BaseModel):
    token: str
    user: UserOut


_MOCK_PASSWORD = "1234"


@router.post(
    "/login",
    response_model=ApiSuccess[LoginResponseData],
    summary="로그인 (mock — 일괄 비밀번호 1234)",
)
async def login(
    body: LoginRequest, db: AsyncSession = Depends(get_db)
) -> ApiSuccess[LoginResponseData]:
    if body.password != _MOCK_PASSWORD:
        raise ApiException(ErrorCode.AUTH_002, detail="비밀번호가 올바르지 않습니다")

    stmt = select(User).where(
        or_(User.user_id == body.login_id, User.employee_no == body.login_id)
    )
    row = (await db.execute(stmt)).scalar_one_or_none()
    if row is None:
        raise ApiException(ErrorCode.AUTH_001, detail="존재하지 않는 사용자입니다")

    return ok(
        LoginResponseData(
            token=f"mock-token-{row.user_id}",
            user=UserOut.model_validate(row),
        )
    )
