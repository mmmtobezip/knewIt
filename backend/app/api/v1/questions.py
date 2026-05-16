"""PRD 0514 추천 질문 Agent (SMI-Bot v1.1).

GET /api/today-questions?product=...  → 3개 질문 생성
POST /api/today-questions/answer       → 클릭된 질문의 1분 브리핑 + 응대 스크립트 JSON
"""
from __future__ import annotations

from datetime import datetime
from zoneinfo import ZoneInfo

from fastapi import APIRouter, Depends, Query
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession

from app.config import get_settings
from app.core.auth import get_current_user
from app.core.errors import ApiException, ErrorCode
from app.core.response import ApiSuccess, ok
from app.db import get_db
from app.models import Product
from app.schemas.api import (
    CacheScope,
    QuestionAnswerData,
    TodayQuestionsData,
)
from app.schemas.domain import (
    SessionUser,
    TodayQuestion,
)
from app.services.cache_service import get_or_compute, make_key
from app.services.indicator_service import fetch_indicator, top_movers_for_product
from app.services.llm_service import get_llm_service

router = APIRouter(prefix="/api", tags=["questions"])
SETTINGS = get_settings()
KST = ZoneInfo(SETTINGS.app_timezone)


class _QuestionsWrap(BaseModel):
    product: str
    generated_at: str
    questions: list[TodayQuestion]


@router.get(
    "/today-questions",
    response_model=ApiSuccess[TodayQuestionsData],
    summary="PRD 0514 추천 질문 3개 생성 (제품 단위)",
)
async def get_today_questions(
    product: str = Query(..., description="product_code (예: HR(고로밀))"),
    user: SessionUser = Depends(get_current_user),  # noqa: ARG001
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[TodayQuestionsData]:
    if (await db.get(Product, product)) is None:
        raise ApiException(ErrorCode.DATA_001, detail=f"product={product} 미정의")

    key = make_key(CacheScope.QUESTIONS, "_", product, "_")

    async def compute() -> _QuestionsWrap:
        movers, _ = await top_movers_for_product(db, product, top_n=5)
        if not movers:
            raise ApiException(ErrorCode.DATA_001, detail="질문 생성용 지표 데이터 없음")
        llm = get_llm_service()
        questions = await llm.generate_questions(
            product=product,
            top_indicators=[
                {
                    "indicator": m.indicator,
                    "change_w1": m.change_w1,
                    "score": m.score,
                }
                for m in movers
            ],
        )
        return _QuestionsWrap(
            product=product,
            generated_at=datetime.now(KST).isoformat(),
            questions=questions,
        )

    result, _ = await get_or_compute(key, _QuestionsWrap, compute)
    return ok(
        TodayQuestionsData(
            product=result.product,
            generated_at=result.generated_at,
            questions=result.questions,
        )
    )


class AnswerRequest(BaseModel):
    product: str
    qid: str
    text: str
    trigger_indicators: list[str]
    related_groups_internal: list[str] = []


@router.post(
    "/today-questions/answer",
    response_model=ApiSuccess[QuestionAnswerData],
    summary="PRD 0514 추천 질문 답변 (1분 브리핑 + 응대 스크립트)",
)
async def post_answer(
    body: AnswerRequest,
    user: SessionUser = Depends(get_current_user),  # noqa: ARG001
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[QuestionAnswerData]:
    product = await db.get(Product, body.product)
    if product is None:
        raise ApiException(ErrorCode.DATA_001, detail=f"product={body.product} 미정의")

    async def _snapshot(feature: str) -> dict | None:
        snap = await fetch_indicator(db, feature)
        if snap is None:
            return None
        return {
            "indicator": feature,
            "value": snap.latest_value,
            "unit": snap.unit,
            "change_w1": snap.change_w1,
        }

    trigger_data: list[dict] = []
    for f in body.trigger_indicators:
        info = await _snapshot(f)
        if info:
            trigger_data.append(info)

    # 같은 axis 그룹 내 지표 (연관)
    axis_def = product.axis or {}
    related_features: set[str] = set()
    for group_name in body.related_groups_internal:
        for ind in axis_def.get(group_name, {}).get("indicators", []):
            if ind not in body.trigger_indicators:
                related_features.add(ind)
    related_data: list[dict] = []
    for f in related_features:
        info = await _snapshot(f)
        if info:
            related_data.append(info)

    # 인접 axis 그룹 (보조)
    adjacent_features: set[str] = set()
    for group_name, grp in axis_def.items():
        if group_name in body.related_groups_internal:
            continue
        for ind in grp.get("indicators", [])[:1]:
            adjacent_features.add(ind)
    adjacent_data: list[dict] = []
    for f in adjacent_features:
        info = await _snapshot(f)
        if info:
            adjacent_data.append(info)

    llm = get_llm_service()
    answer = await llm.generate_answer(
        qid=body.qid,
        question_text=body.text,
        trigger_indicators=trigger_data,
        related_indicators=related_data,
        adjacent_indicators=adjacent_data,
    )
    return ok(QuestionAnswerData(answer=answer))


__all__ = ["router"]
