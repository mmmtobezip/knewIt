import logging

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import ORJSONResponse
from starlette.exceptions import HTTPException as StarletteHTTPException

from app.core.errors import ApiException, ErrorCode
from app.core.response import fail

logger = logging.getLogger(__name__)


def register_exception_handlers(app: FastAPI) -> None:
    @app.exception_handler(ApiException)
    async def api_exception_handler(_request: Request, exc: ApiException) -> ORJSONResponse:
        return ORJSONResponse(
            status_code=exc.http_status,
            content=fail(exc.code.value, exc.message, exc.detail).model_dump(),
        )

    @app.exception_handler(RequestValidationError)
    async def validation_exception_handler(
        _request: Request, exc: RequestValidationError
    ) -> ORJSONResponse:
        return ORJSONResponse(
            status_code=400,
            content=fail(
                ErrorCode.VALD_001.value,
                "요청 형식이 올바르지 않습니다.",
                detail=str(exc.errors()[:3]),
            ).model_dump(),
        )

    @app.exception_handler(StarletteHTTPException)
    async def http_exception_handler(
        _request: Request, exc: StarletteHTTPException
    ) -> ORJSONResponse:
        code = ErrorCode.SYS_001 if exc.status_code >= 500 else ErrorCode.DATA_001
        return ORJSONResponse(
            status_code=exc.status_code,
            content=fail(code.value, str(exc.detail)).model_dump(),
        )

    @app.exception_handler(Exception)
    async def unhandled_exception_handler(_request: Request, exc: Exception) -> ORJSONResponse:
        logger.exception("unhandled exception: %s", exc)
        return ORJSONResponse(
            status_code=500,
            content=fail(ErrorCode.SYS_001.value, "요청 처리 중 오류가 발생했습니다.").model_dump(),
        )
