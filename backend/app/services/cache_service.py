"""LLM/News 응답을 위한 Redis 캐시 헬퍼.

키 컨벤션 (Phase 2 cache.py 의 invalidate 패턴과 일관):
    {scope}:{customer_id}:{product_code}:{event_id}

scope 는 IPO § 2-11 캐시 정책 4종: analysis / causal_chain / news / strategy
"""
from __future__ import annotations

from collections.abc import Awaitable, Callable
from typing import TypeVar

from pydantic import BaseModel

from app.cache import redis_client
from app.config import get_settings
from app.schemas.api import CacheScope

SETTINGS = get_settings()
T = TypeVar("T", bound=BaseModel)


def make_key(
    scope: CacheScope, customer_id: str, product_code: str, event_id: str
) -> str:
    return f"{scope.value}:{customer_id}:{product_code}:{event_id}"


async def get_or_compute(
    key: str,
    model_cls: type[T],
    compute: Callable[[], Awaitable[T]],
    *,
    ttl_sec: int | None = None,
) -> tuple[T, bool]:
    """캐시 hit → (value, True), miss → 계산 후 SETEX → (value, False)."""
    raw = await redis_client.get(key)
    if raw is not None:
        return model_cls.model_validate_json(raw), True
    value = await compute()
    await redis_client.setex(
        key, ttl_sec or SETTINGS.cache_ttl_analysis_sec, value.model_dump_json()
    )
    return value, False


__all__ = ["get_or_compute", "make_key"]
