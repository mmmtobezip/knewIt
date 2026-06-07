"""Cause Flow Agent — LangGraph 2단계 체인 + Anthropic tool_use 자율 데이터 수집.

흐름:
  plan    → AI가 tool_use로 원인 지표·뉴스를 자율 수집 (agentic loop)
  analyze → 수집 데이터로 인과관계 흐름(CauseFlowStep) 생성
"""
from __future__ import annotations

import json
import logging
from typing import Any, TypedDict

from langgraph.graph import END, StateGraph
from sqlalchemy.ext.asyncio import AsyncSession

from app.schemas.domain import CauseFlowStep
from app.services.indicator_service import fetch_indicator
from app.services.llm_service import LLMService, _load_prompt, _render, _to_json
from app.services.news_service import NewsService

logger = logging.getLogger(__name__)


class CauseFlowState(TypedDict):
    indicator_name: str
    change_rate: float
    product: str
    adjacent_indicators: list[dict]
    # plan 수집 결과
    collected_indicators: list[dict]
    collected_news: list[dict]
    # analyze 결과
    steps: list[dict]


class CauseFlowAgent:
    def __init__(self, llm: LLMService, db: AsyncSession, news: NewsService) -> None:
        self._llm = llm
        self._db = db
        self._news = news
        self._graph = self._build()

    def _build(self):
        g = StateGraph(CauseFlowState)
        g.add_node("plan", self._plan_node)
        g.add_node("analyze", self._analyze_node)
        g.set_entry_point("plan")
        g.add_edge("plan", "analyze")
        g.add_edge("analyze", END)
        return g.compile()

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
                    "url": getattr(d, "url", ""),
                }
                for d in docs[:5]
            ]
        return None

    async def _plan_node(self, state: CauseFlowState) -> dict:
        """AI가 tool_use로 변동 원인 관련 지표·뉴스를 자율 수집."""
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
                            "description": "조회할 지표명 (예: 철광석 CFR China, 원료탄 HCC)",
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
            _load_prompt("cause_flow_plan"),
            indicator_name=state["indicator_name"],
            change_rate=str(state["change_rate"]),
            product=state["product"],
            adjacent_json=_to_json(state.get("adjacent_indicators") or []),
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
            if not tool_results:
                break
            messages.append({"role": "user", "content": tool_results})

        return {
            "collected_indicators": collected_indicators,
            "collected_news": collected_news,
        }

    async def _analyze_node(self, state: CauseFlowState) -> dict:
        """수집된 지표·뉴스로 인과관계 흐름 생성."""
        all_indicators = state["collected_indicators"] + (state.get("adjacent_indicators") or [])
        steps = await self._llm.generate_cause_flow(
            indicator_name=state["indicator_name"],
            change_rate=state["change_rate"],
            period="W-1",
            news=state["collected_news"],
            adjacent_indicators=all_indicators,
            axis_name=None,
        )
        return {"steps": [s.model_dump() for s in steps]}

    async def run(
        self,
        *,
        indicator_name: str,
        change_rate: float,
        product: str,
        adjacent_indicators: list[dict],
    ) -> list[CauseFlowStep]:
        initial: CauseFlowState = {
            "indicator_name": indicator_name,
            "change_rate": change_rate,
            "product": product,
            "adjacent_indicators": adjacent_indicators,
            "collected_indicators": [],
            "collected_news": [],
            "steps": [],
        }
        final = await self._graph.ainvoke(initial)
        return [CauseFlowStep(**s) for s in final.get("steps", [])]


__all__ = ["CauseFlowAgent", "CauseFlowState"]
