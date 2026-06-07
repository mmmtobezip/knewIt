"""Q&A Agent — LangGraph 4단계 체인 + Anthropic tool_use 자율 데이터 수집.

흐름:
  plan     → AI가 tool_use 로 지표·뉴스를 자율 수집 (agentic loop)
  analyze  → 수집 데이터 기반 시황 분석
  briefing → 분석 결과로 1분 브리핑 (tool_use 구조화)
  script   → 확정된 브리핑 기반 영업 멘트 (tool_use 구조화)

SSE 이벤트 포맷:
  data: {"type": "step",   "node": "plan",   "message": "데이터 수집 중..."}
  data: {"type": "step",   "node": "plan",   "message": "시황 분석 중..."}
  ...
  data: {"type": "result", "answer": {...}}
  data: [DONE]
"""
from __future__ import annotations

import json
import logging
from typing import Any, AsyncIterator, TypedDict

from langgraph.graph import END, StateGraph
from sqlalchemy.ext.asyncio import AsyncSession

from app.schemas.domain import AnswerSources, QuestionAnswer
from app.services.indicator_service import fetch_indicator
from app.services.llm_service import LLMService, _load_prompt, _render, _to_json
from app.services.news_service import NewsService

logger = logging.getLogger(__name__)

# 노드 완료 후 다음 단계 안내 메시지
_NEXT_STEP_MSG: dict[str, str] = {
    "plan": "시황 분석 중...",
    "analyze": "브리핑 작성 중...",
    "briefing": "영업 멘트 작성 중...",
}


class QAState(TypedDict):
    qid: str
    question_text: str
    user_name: str
    product: str
    customer_profile: dict | None
    # plan 수집 결과
    collected_indicators: list[dict]
    collected_news: list[dict]
    # analyze 결과
    market_analysis: str
    # briefing 결과
    briefing: str
    sources: list[str]
    # script 결과
    sales_rep_script: str
    confidence: float


class QAAgent:
    def __init__(self, llm: LLMService, db: AsyncSession, news: NewsService) -> None:
        self._llm = llm
        self._db = db
        self._news = news
        self._graph = self._build()

    def _build(self):
        g = StateGraph(QAState)
        g.add_node("plan", self._plan_node)
        g.add_node("analyze", self._analyze_node)
        g.add_node("briefing", self._briefing_node)
        g.add_node("script", self._script_node)
        g.set_entry_point("plan")
        g.add_edge("plan", "analyze")
        g.add_edge("analyze", "briefing")
        g.add_edge("briefing", "script")
        g.add_edge("script", END)
        return g.compile()

    # ── tool 실행 ────────────────────────────────────────────
    async def _execute_tool(self, name: str, inputs: dict) -> Any:
        if name == "fetch_indicator":
            snap = await fetch_indicator(self._db, inputs.get("indicator_name", ""))
            if snap is None:
                return {"error": "지표 없음"}
            return {
                "indicator": snap.feature_name,
                "value": snap.latest_value,
                "unit": snap.unit,
                "change_w1": snap.change_w1,
                "change_m1": snap.change_m1,
                "category": snap.category_big,
            }
        if name == "search_news":
            docs = await self._news.search(inputs.get("query", ""))
            return [
                {
                    "title": d.title,
                    "summary": d.summary,
                    "published_at": str(d.published_at)[:10],
                }
                for d in docs[:5]
            ]
        return None

    # ── 노드 1: plan ─────────────────────────────────────────
    async def _plan_node(self, state: QAState) -> dict:
        """AI 가 tool_use 로 필요한 지표·뉴스를 자율 수집."""
        tool_defs = [
            {
                "name": "fetch_indicator",
                "description": "특정 지표의 최신 값과 변동률을 조회합니다.",
                "input_schema": {
                    "type": "object",
                    "required": ["indicator_name"],
                    "properties": {
                        "indicator_name": {
                            "type": "string",
                            "description": "조회할 지표명 (예: 철광석 CFR China, HR스프레드)",
                        }
                    },
                },
            },
            {
                "name": "search_news",
                "description": "철강 시황 관련 최신 뉴스를 검색합니다.",
                "input_schema": {
                    "type": "object",
                    "required": ["query"],
                    "properties": {
                        "query": {
                            "type": "string",
                            "description": "검색 키워드 (한국어 또는 영어)",
                        }
                    },
                },
            },
        ]

        prompt = _render(
            _load_prompt("qa_plan"),
            question=state["question_text"],
            product=state["product"],
            customer_profile_json=_to_json(state.get("customer_profile") or {}),
        )
        messages: list[dict] = [{"role": "user", "content": prompt}]
        collected_indicators: list[dict] = []
        collected_news: list[dict] = []

        for _ in range(5):
            resp = await self._llm.client.messages.create(
                model=self._llm.model,
                max_tokens=2000,
                tools=tool_defs,
                messages=messages,
            )
            messages.append({"role": "assistant", "content": resp.content})

            if resp.stop_reason == "end_turn":
                break

            tool_results = []
            for block in resp.content:
                if getattr(block, "type", None) != "tool_use":
                    continue
                result = await self._execute_tool(block.name, block.input)
                if block.name == "fetch_indicator" and isinstance(result, dict) and "error" not in result:
                    collected_indicators.append(result)
                elif block.name == "search_news" and isinstance(result, list):
                    collected_news.extend(result)
                tool_results.append({
                    "type": "tool_result",
                    "tool_use_id": block.id,
                    "content": json.dumps(result, default=str, ensure_ascii=False),
                })
            messages.append({"role": "user", "content": tool_results})

        return {
            "collected_indicators": collected_indicators,
            "collected_news": collected_news,
        }

    # ── 노드 2: analyze ──────────────────────────────────────
    async def _analyze_node(self, state: QAState) -> dict:
        """수집된 데이터로 시황 분석 텍스트 생성."""
        prompt = _render(
            _load_prompt("qa_analyze"),
            question=state["question_text"],
            indicators_json=_to_json(state["collected_indicators"]),
            news_json=_to_json(state["collected_news"]),
            customer_profile_json=_to_json(state.get("customer_profile") or {}),
        )
        resp = await self._llm.client.messages.create(
            model=self._llm.model,
            max_tokens=1000,
            messages=[{"role": "user", "content": prompt}],
        )
        text = "".join(b.text for b in resp.content if getattr(b, "type", None) == "text")
        return {"market_analysis": text}

    # ── 노드 3: briefing ─────────────────────────────────────
    async def _briefing_node(self, state: QAState) -> dict:
        """시황 분석 기반 1분 브리핑 작성 (tool_use 구조화)."""
        tool_def = {
            "name": "submit_briefing",
            "description": "1분 브리핑 제출",
            "input_schema": {
                "type": "object",
                "required": ["briefing", "sources"],
                "properties": {
                    "briefing": {"type": "string", "description": "250~300자, 단일 단락"},
                    "sources": {
                        "type": "array",
                        "items": {"type": "string"},
                        "description": "사용한 지표명 목록",
                    },
                },
            },
        }
        prompt = _render(
            _load_prompt("qa_briefing"),
            question=state["question_text"],
            market_analysis=state["market_analysis"],
            indicators_json=_to_json(state["collected_indicators"]),
        )
        resp = await self._llm.client.messages.create(
            model=self._llm.model,
            max_tokens=800,
            tools=[tool_def],
            tool_choice={"type": "tool", "name": "submit_briefing"},
            messages=[{"role": "user", "content": prompt}],
        )
        block = next((b for b in resp.content if getattr(b, "type", None) == "tool_use"), None)
        if block is None:
            return {"briefing": state["market_analysis"], "sources": []}
        return {
            "briefing": str(block.input.get("briefing", "")),
            "sources": list(block.input.get("sources", [])),
        }

    # ── 노드 4: script ───────────────────────────────────────
    async def _script_node(self, state: QAState) -> dict:
        """확정된 브리핑 기반 영업 멘트 작성 (tool_use 구조화)."""
        tool_def = {
            "name": "submit_script",
            "description": "영업 멘트 제출",
            "input_schema": {
                "type": "object",
                "required": ["sales_rep_script", "confidence"],
                "properties": {
                    "sales_rep_script": {
                        "type": "string",
                        "description": f"150~200자, '{state['user_name']} 담당자님, ' 으로 시작",
                    },
                    "confidence": {"type": "number", "minimum": 0, "maximum": 1},
                },
            },
        }
        prompt = _render(
            _load_prompt("qa_script"),
            user_name=state["user_name"],
            question=state["question_text"],
            briefing=state["briefing"],
            customer_profile_json=_to_json(state.get("customer_profile") or {}),
        )
        resp = await self._llm.client.messages.create(
            model=self._llm.model,
            max_tokens=600,
            tools=[tool_def],
            tool_choice={"type": "tool", "name": "submit_script"},
            messages=[{"role": "user", "content": prompt}],
        )
        block = next((b for b in resp.content if getattr(b, "type", None) == "tool_use"), None)
        if block is None:
            return {"sales_rep_script": "", "confidence": 0.5}
        return {
            "sales_rep_script": str(block.input.get("sales_rep_script", "")),
            "confidence": float(block.input.get("confidence", 0.5)),
        }

    # ── SSE 스트리밍 ─────────────────────────────────────────
    async def astream_sse(self, initial: QAState) -> AsyncIterator[str]:
        """LangGraph astream 으로 노드별 진행상황을 SSE data 라인으로 yield.

        이벤트 순서:
          1. "데이터 수집 중..." (plan 시작 직후)
          2. "시황 분석 중..."   (plan 완료)
          3. "브리핑 작성 중..."  (analyze 완료)
          4. "영업 멘트 작성 중..." (briefing 완료)
          5. {"type": "result", "answer": {...}} (script 완료)
          6. [DONE]
        """
        yield f"data: {json.dumps({'type': 'step', 'node': 'plan', 'message': '데이터 수집 중...'}, ensure_ascii=False)}\n\n"

        final_state: dict = {}
        try:
            async for chunk in self._graph.astream(initial):
                for node_name, node_output in chunk.items():
                    if not isinstance(node_output, dict):
                        continue
                    final_state.update(node_output)
                    next_msg = _NEXT_STEP_MSG.get(node_name)
                    if next_msg:
                        payload = json.dumps(
                            {"type": "step", "node": node_name, "message": next_msg},
                            ensure_ascii=False,
                        )
                        yield f"data: {payload}\n\n"
        except Exception as e:
            logger.exception("QAAgent astream error")
            err_payload = json.dumps({"type": "error", "message": str(e)}, ensure_ascii=False)
            yield f"data: {err_payload}\n\n"
            yield "data: [DONE]\n\n"
            return

        answer = QuestionAnswer(
            qid=initial["qid"],
            briefing=final_state.get("briefing", ""),
            sales_rep_script=final_state.get("sales_rep_script", ""),
            sources=AnswerSources(indicators=final_state.get("sources", [])),
            confidence=float(final_state.get("confidence", 0.5)),
        )
        result_payload = json.dumps(
            {"type": "result", "answer": answer.model_dump()},
            ensure_ascii=False,
            default=str,
        )
        yield f"data: {result_payload}\n\n"
        yield "data: [DONE]\n\n"


__all__ = ["QAAgent", "QAState"]
