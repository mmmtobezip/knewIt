from fastapi import APIRouter

from app.api.v1.cache import router as cache_router
from app.api.v1.catalog import router as catalog_router
from app.api.v1.customers import router as customers_router
from app.api.v1.dashboard import router as dashboard_router
from app.api.v1.questions import router as questions_router
from app.api.v1.users import router as users_router

api_v1_router = APIRouter()
api_v1_router.include_router(users_router)
api_v1_router.include_router(catalog_router)
api_v1_router.include_router(customers_router)
api_v1_router.include_router(dashboard_router)
api_v1_router.include_router(questions_router)
api_v1_router.include_router(cache_router)
