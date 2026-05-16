import logging
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import ORJSONResponse
from sqlalchemy import text

from app.api.v1 import api_v1_router
from app.cache import ping as redis_ping
from app.config import get_settings
from app.core.exception_handlers import register_exception_handlers
from app.core.response import ok
from app.db import SessionLocal

settings = get_settings()
logging.basicConfig(level=settings.app_log_level)


@asynccontextmanager
async def lifespan(_app: FastAPI) -> AsyncIterator[None]:
    settings.indicators_csv_dir.mkdir(parents=True, exist_ok=True)
    yield


app = FastAPI(
    title="POS-Pricing Navigator API",
    version="0.1.0",
    default_response_class=ORJSONResponse,
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

register_exception_handlers(app)
app.include_router(api_v1_router)


async def _db_ping() -> bool:
    try:
        async with SessionLocal() as s:
            await s.execute(text("SELECT 1"))
        return True
    except Exception:
        return False


@app.get("/health")
async def health() -> dict:
    db_ok = await _db_ping()
    redis_ok = await redis_ping()
    return ok(
        {
            "status": "ok" if db_ok and redis_ok else "degraded",
            "env": settings.app_env,
            "db": db_ok,
            "redis": redis_ok,
        }
    ).model_dump()
