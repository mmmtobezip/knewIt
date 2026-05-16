"""PRD 0514 캐시 무효화 (새로고침).

scope: top_movers / cause_flow / interpretation / strategy / news / questions
- customer_id / product_code 둘 다 옵셔널 (없으면 전체 패턴 매칭)
- debounce 5초 (동일 사용자 + 동일 customer 키)
"""
from __future__ import annotations

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.cache import redis_client
from app.config import get_settings
from app.core.auth import get_current_user
from app.core.errors import ApiException, ErrorCode
from app.core.response import ApiSuccess, ok
from app.db import get_db
from app.schemas.api import CacheInvalidateData, CacheInvalidateRequest, CacheScope
from app.schemas.domain import SessionUser
from app.services.authorization import assert_customer_access

router = APIRouter(prefix="/api/cache", tags=["cache"])
SETTINGS = get_settings()


def _pattern(scope: CacheScope, customer_id: str | None, product_code: str | None) -> str:
    c = customer_id or "*"
    p = product_code or "*"
    return f"{scope.value}:{c}:{p}:*"


@router.post(
    "/invalidate",
    response_model=ApiSuccess[CacheInvalidateData],
    summary="PRD 0514 캐시 무효화 (debounce 5s)",
)
async def invalidate_cache(
    body: CacheInvalidateRequest,
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[CacheInvalidateData]:
    if body.customer_id:
        await assert_customer_access(db, user, body.customer_id)

    lock_key = f"cache_lock:{user.user_id}:{body.customer_id or '_'}"
    acquired = await redis_client.set(
        lock_key, "1", nx=True, ex=SETTINGS.refresh_debounce_sec
    )
    if not acquired:
        raise ApiException(ErrorCode.CACH_001)

    invalidated: list[str] = []
    for scope in body.scope:
        pattern = _pattern(scope, body.customer_id, body.product_code)
        keys = [k async for k in redis_client.scan_iter(match=pattern)]
        if keys:
            await redis_client.delete(*keys)
            invalidated.extend(keys)

    return ok(CacheInvalidateData(invalidated_keys=invalidated))
