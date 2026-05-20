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
    summary="PRD 0516 추천 질문 3개 생성 (제품 단위, 자정 KST 까지 고정)",
)
async def get_today_questions(
    product: str = Query(..., description="product_code (예: HR(고로밀))"),
    user: SessionUser = Depends(get_current_user),  # noqa: ARG001
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[TodayQuestionsData]:
    if (await db.get(Product, product)) is None:
        raise ApiException(ErrorCode.DATA_001, detail=f"product={product} 미정의")

    # PRD 0516 — 자정 KST boundary 로 고정. 같은 날(YYYY-MM-DD)이면 같은 질문.
    today_kst = datetime.now(KST).date().isoformat()
    key = make_key(CacheScope.QUESTIONS, today_kst, product, "_")

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
    summary="PRD 0516 추천 질문 답변 (Few-Shot + Structured Output, 동적 호칭)",
)
async def post_answer(
    body: AnswerRequest,
    user: SessionUser = Depends(get_current_user),
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

    # PRD 0516 — axis 폐기. 같은 product 의 importance Top-3 (trigger 제외) 사용.
    triggers_set = set(body.trigger_indicators)
    pairs = sorted(
        zip(
            product.key_features or [],
            product.key_feature_importance or [],
            strict=False,
        ),
        key=lambda x: x[1],
        reverse=True,
    )
    related_data: list[dict] = []
    for feat, _imp in pairs:
        if feat in triggers_set:
            continue
        info = await _snapshot(feat)
        if info:
            related_data.append(info)
        if len(related_data) >= 3:
            break

    user_display = user.name or user.user_id
    llm = get_llm_service()
    answer = await llm.generate_answer(
        qid=body.qid,
        question_text=body.text,
        user_name=user_display,
        trigger_indicators=trigger_data,
        related_indicators=related_data,
        adjacent_indicators=[],
    )
    # 방어 후처리 — Structured Output 으로 형식은 거의 보장되지만
    # 라벨 prefix / 호칭 오류 시 마지막 fallback.
    answer.sales_rep_script = _sanitize_script(answer.sales_rep_script, user_display)
    return ok(QuestionAnswerData(answer=answer))


_LABEL_PATTERN = "\n\n"
_LABEL_PREFIXES = (
    "[추천 대응 방안]",
    "[추천대응방안]",
    "추천 대응 방안:",
    "추천 대응:",
    "1)",
    "①",
)
_BAD_HONORIFICS = ("고객님,", "선생님,", "사장님,", "판매담당자님,")


def _sanitize_script(text: str, user_name: str) -> str:
    """LLM 응답의 sales_rep_script 정제 (Phase A 방어 후처리).

    - 다중 단락 → 첫 단락만 / 줄바꿈 → 공백
    - 자체 라벨 prefix 제거
    - 호칭이 "{user_name} 담당자님, " 가 아니면 강제 prepend
    """
    if not text:
        return text
    cleaned = text.split(_LABEL_PATTERN, 1)[0].replace("\n", " ").strip()
    for prefix in _LABEL_PREFIXES:
        if cleaned.startswith(prefix):
            cleaned = cleaned[len(prefix):].strip()

    expected = f"{user_name} 담당자님, "
    if cleaned.startswith(expected):
        return cleaned
    # 잘못된 호칭 prefix 가 붙어있으면 제거 후 올바른 호칭 prepend
    for bad in _BAD_HONORIFICS:
        if cleaned.startswith(bad):
            cleaned = cleaned[len(bad):].strip()
            break
    return f"{expected}{cleaned}"


__all__ = ["router"]
