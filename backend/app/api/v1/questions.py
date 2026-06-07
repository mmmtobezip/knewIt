"""추천 질문 Agent (SMI-Bot v2 — LangGraph + tool_use).

GET  /api/today-questions              → 담당자별 개인화 질문 3개 (고객사 프로필 반영)
POST /api/today-questions/answer       → 기존 단발 답변 (하위 호환)
POST /api/today-questions/answer/stream → LangGraph 4단계 체인 SSE 스트리밍
"""
from __future__ import annotations

from datetime import datetime
from zoneinfo import ZoneInfo

from fastapi import APIRouter, Depends, Query
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.config import get_settings
from app.core.auth import get_current_user
from app.core.errors import ApiException, ErrorCode
from app.core.response import ApiSuccess, ok
from app.db import get_db
from app.models import CustomerProfile as CustomerProfileORM
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
from app.services.authorization import get_assigned_customer_ids
from app.services.cache_service import get_or_compute, make_key
from app.services.indicator_service import fetch_indicator, top_movers_for_product
from app.services.llm_service import get_llm_service
from app.services.news_service import get_news_service
from app.services.qa_agent import QAAgent, QAState

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
    summary="SMI-Bot v2 — 담당자별 개인화 질문 3개 (고객사 프로필 반영)",
)
async def get_today_questions(
    product: str = Query(..., description="product_code"),
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[TodayQuestionsData]:
    if (await db.get(Product, product)) is None:
        raise ApiException(ErrorCode.DATA_001, detail=f"product={product} 미정의")

    today_kst = datetime.now(KST).date().isoformat()
    # 담당자별 개인화 캐시 (user_id 포함)
    key = make_key(CacheScope.QUESTIONS, today_kst, product, user.user_id)

    async def compute() -> _QuestionsWrap:
        movers, _ = await top_movers_for_product(db, product, top_n=5)
        if not movers:
            raise ApiException(ErrorCode.DATA_001, detail="질문 생성용 지표 데이터 없음")

        # 담당 고객사 프로필 조회 (최대 3개 — 개인화 컨텍스트)
        assigned_ids = await get_assigned_customer_ids(db, user.user_id, user.user_role)
        profiles: list[dict] = []
        if assigned_ids:
            rows = (
                await db.execute(
                    select(CustomerProfileORM)
                    .where(CustomerProfileORM.customer_id.in_(assigned_ids))
                    .where(CustomerProfileORM.product_group.contains([product]))
                    .limit(3)
                )
            ).scalars().all()
            profiles = [
                {
                    "customer_id": r.customer_id,
                    "industry": r.industry,
                    "market_region": r.market_region,
                    "sensitive_topics": list(r.sensitive_topics or []),
                }
                for r in rows
            ]

        llm = get_llm_service()
        questions = await llm.generate_questions(
            product=product,
            top_indicators=[
                {"indicator": m.indicator, "change_w1": m.change_w1, "score": m.score}
                for m in movers
            ],
            customer_profiles=profiles,
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
    customer_id: str | None = None  # SSE 엔드포인트에서 고객사 프로필 조회용


@router.post(
    "/today-questions/answer",
    response_model=ApiSuccess[QuestionAnswerData],
    summary="추천 질문 답변 — 기존 단발 방식 (하위 호환)",
)
async def post_answer(
    body: AnswerRequest,
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> ApiSuccess[QuestionAnswerData]:
    product = await db.get(Product, body.product)
    if product is None:
        raise ApiException(ErrorCode.DATA_001, detail=f"product={body.product} 미정의")

    async def _snapshot(feature: str) -> tuple[dict, str | None] | None:
        snap = await fetch_indicator(db, feature)
        if snap is None:
            return None
        return (
            {
                "indicator": feature,
                "value": snap.latest_value,
                "unit": snap.unit,
                "change_w1": snap.change_w1,
            },
            snap.category_big,
        )

    trigger_data: list[dict] = []
    trigger_cats: set[str] = set()
    for f in body.trigger_indicators:
        pair = await _snapshot(f)
        if pair is None:
            continue
        info, cat = pair
        trigger_data.append(info)
        if cat:
            trigger_cats.add(cat)

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
    primary: list[dict] = []
    backup: list[dict] = []
    seen_cats: set[str] = set(trigger_cats)
    for feat, _imp in pairs:
        if feat in triggers_set:
            continue
        pair = await _snapshot(feat)
        if pair is None:
            continue
        info, cat = pair
        if cat and cat not in seen_cats:
            primary.append(info)
            seen_cats.add(cat)
        else:
            backup.append(info)
        if len(primary) >= 3:
            break
    related_data: list[dict] = primary[:3]
    while len(related_data) < 3 and backup:
        related_data.append(backup.pop(0))

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
    answer.sales_rep_script = _sanitize_script(answer.sales_rep_script, user_display)
    return ok(QuestionAnswerData(answer=answer))


@router.post(
    "/today-questions/answer/stream",
    summary="SMI-Bot v2 — LangGraph 4단계 Agent SSE 스트리밍",
)
async def post_answer_stream(
    body: AnswerRequest,
    user: SessionUser = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> StreamingResponse:
    """LangGraph plan→analyze→briefing→script 체인을 SSE 로 스트리밍.

    이벤트:
      {"type": "step",   "node": "...", "message": "..."}  — 단계별 진행
      {"type": "result", "answer": {...}}                   — 최종 답변
      [DONE]
    """
    if (await db.get(Product, body.product)) is None:
        raise ApiException(ErrorCode.DATA_001, detail=f"product={body.product} 미정의")

    user_display = user.name or user.user_id

    # 선택된 고객사 프로필 조회 (있을 때만)
    customer_profile: dict | None = None
    if body.customer_id:
        cp_row = await db.get(CustomerProfileORM, body.customer_id)
        if cp_row is not None:
            customer_profile = {
                "customer_id": cp_row.customer_id,
                "industry": cp_row.industry,
                "market_region": cp_row.market_region,
                "sensitive_topics": list(cp_row.sensitive_topics or []),
                "risk_factors": list(cp_row.risk_factors or []),
            }

    initial: QAState = {
        "qid": body.qid,
        "question_text": body.text,
        "user_name": user_display,
        "product": body.product,
        "customer_profile": customer_profile,
        "collected_indicators": [],
        "collected_news": [],
        "market_analysis": "",
        "briefing": "",
        "sources": [],
        "sales_rep_script": "",
        "confidence": 0.0,
    }

    agent = QAAgent(get_llm_service(), db, get_news_service())

    async def generate():
        async for chunk in agent.astream_sse(initial):
            yield chunk

    return StreamingResponse(
        generate(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "X-Accel-Buffering": "no",
        },
    )


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
    if not text:
        return text
    cleaned = text.split(_LABEL_PATTERN, 1)[0].replace("\n", " ").strip()
    for prefix in _LABEL_PREFIXES:
        if cleaned.startswith(prefix):
            cleaned = cleaned[len(prefix):].strip()
    expected = f"{user_name} 담당자님, "
    if cleaned.startswith(expected):
        return cleaned
    for bad in _BAD_HONORIFICS:
        if cleaned.startswith(bad):
            cleaned = cleaned[len(bad):].strip()
            break
    return f"{expected}{cleaned}"


__all__ = ["router"]
