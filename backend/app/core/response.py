from datetime import datetime
from typing import Generic, Literal, TypeVar
from uuid import uuid4
from zoneinfo import ZoneInfo

from pydantic import BaseModel, Field

from app.config import get_settings

T = TypeVar("T")

KST = ZoneInfo(get_settings().app_timezone)


class ApiMeta(BaseModel):
    request_id: str = Field(default_factory=lambda: f"req_{uuid4().hex}")
    timestamp: str = Field(default_factory=lambda: datetime.now(KST).isoformat())
    cache_hit: bool | None = None


class ApiError(BaseModel):
    code: str
    message: str
    detail: str | None = None


class ApiSuccess(BaseModel, Generic[T]):
    success: Literal[True] = True
    data: T
    error: None = None
    meta: ApiMeta = Field(default_factory=ApiMeta)


class ApiFailure(BaseModel):
    success: Literal[False] = False
    data: None = None
    error: ApiError
    meta: ApiMeta = Field(default_factory=ApiMeta)


def ok(data: T, cache_hit: bool | None = None) -> ApiSuccess[T]:
    return ApiSuccess[T](data=data, meta=ApiMeta(cache_hit=cache_hit))


def fail(code: str, message: str, detail: str | None = None) -> ApiFailure:
    return ApiFailure(error=ApiError(code=code, message=message, detail=detail))
