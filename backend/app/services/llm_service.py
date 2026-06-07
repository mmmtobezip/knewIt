"""PRD 0514 LLM 서비스.

5개 .md 프롬프트(cause_flow / interpretation / strategy / questions / answer)를
Pydantic 검증 응답으로 변환. OAuth Bearer / API Key 자동 분기.
"""
from __future__ import annotations

import logging
from pathlib import Path
from typing import Any

import anthropic
import orjson

from app.config import get_settings
from app.core.errors import ApiException, ErrorCode
from app.schemas.domain import (
    CauseFlowStep,
    FlowEvidence,
    Interpretation,
    QuestionAnswer,
    Strategy,
    TodayQuestion,
)

logger = logging.getLogger(__name__)
SETTINGS = get_settings()
PROMPTS_DIR = Path(__file__).resolve().parent.parent / "prompts"


def _load_prompt(name: str) -> str:
    return (PROMPTS_DIR / f"{name}.md").read_text(encoding="utf-8")


def _render(template: str, **vars: str) -> str:
    out = template
    for key, value in vars.items():
        out = out.replace("{" + key + "}", value)
    return out


def _to_json(obj: Any) -> str:
    return orjson.dumps(obj, default=str).decode("utf-8")


def _extract_json(text: str) -> Any:
    s = text.strip()
    if s.startswith("```"):
        s = s.split("\n", 1)[1] if "\n" in s else s
        if s.endswith("```"):
            s = s.rsplit("```", 1)[0]
        if s.startswith("json"):
            s = s[4:]
    try:
        return orjson.loads(s)
    except orjson.JSONDecodeError as e:
        logger.warning("LLM JSON parse fail: %s | raw=%s", e, text[:200])
        raise ApiException(ErrorCode.LLM_001, detail="LLM 응답 JSON 파싱 실패") from e


class LLMService:
    def __init__(self) -> None:
        token = SETTINGS.anthropic_api_key
        if not token:
            raise RuntimeError("ANTHROPIC_API_KEY 미설정")
        is_oauth = token.startswith("sk-ant-oat")
        kwargs: dict[str, Any] = {"timeout": SETTINGS.llm_timeout_sec}
        if is_oauth:
            kwargs["auth_token"] = token
        else:
            kwargs["api_key"] = token
        self.client = anthropic.AsyncAnthropic(**kwargs)
        self.model = SETTINGS.llm_model
        self.max_tokens = SETTINGS.llm_max_tokens

    async def _complete_json(self, prompt: str) -> Any:
        try:
            resp = await self.client.messages.create(
                model=self.model,
                max_tokens=self.max_tokens,
                messages=[{"role": "user", "content": prompt}],
            )
        except anthropic.APITimeoutError as e:
            raise ApiException(ErrorCode.LLM_002) from e
        except anthropic.RateLimitError as e:
            raise ApiException(ErrorCode.LLM_003) from e
        except anthropic.APIError as e:
            logger.exception("anthropic api error")
            raise ApiException(ErrorCode.LLM_001, detail=str(e)) from e
        text = "".join(
            b.text for b in resp.content if getattr(b, "type", None) == "text"
        )
        return _extract_json(text)

    async def generate_cause_flow(
        self,
        *,
        indicator_name: str,
        change_rate: float,
        period: str,
        news: list[dict],
        adjacent_indicators: list[dict] | None = None,
        axis_name: str | None = None,
    ) -> list[CauseFlowStep]:
        prompt = _render(
            _load_prompt("cause_flow"),
            indicator_name=indicator_name,
            r=str(change_rate),
            period=period,
            news_json=_to_json(news),
            adjacent_json=_to_json(adjacent_indicators or []),
            axis_name=axis_name or "(미분류)",
        )
        data = await self._complete_json(prompt)
        steps_raw = data.get("flow", []) if isinstance(data, dict) else []
        steps: list[CauseFlowStep] = []
        for s in steps_raw:
            ev_ids = s.get("evidence_news_ids", []) or []
            evidences: list[FlowEvidence] = []
            for nid in ev_ids:
                try:
                    n = news[int(nid)]
                except (ValueError, IndexError):
                    continue
                evidences.append(
                    FlowEvidence(
                        news_id=str(nid),
                        title=n.get("title", ""),
                        date=str(n.get("published_at", ""))[:10],
                        url=n.get("url", ""),
                    )
                )
            steps.append(
                CauseFlowStep(step=int(s.get("step", 0)), node=s.get("node", ""), evidence=evidences)
            )
        return steps

    async def generate_interpretation(
        self,
        *,
        customer: str,
        industry: str,
        market_region: str,
        risk_factors: list[str],
        indicator: str,
        change_rate: float,
        period: str,
        flow_text: str,
    ) -> Interpretation:
        """PRD 0518 — AI 진단 구조화 (WhatBlock + WhyDriver[3] + ImpactItem with priority).

        Anthropic tool_use 로 schema 강제. Few-Shot 예시는 프롬프트 안에 포함.
        """
        prompt = _render(
            _load_prompt("interpretation"),
            customer=customer,
            industry=industry,
            market_region=market_region,
            risk_factors_json=_to_json(risk_factors),
            indicator=indicator,
            r=str(change_rate),
            period=period,
            flow_text=flow_text,
        )
        tool_def = {
            "name": "submit_interpretation",
            "description": "AI 진단 (WHAT/WHY/IMPACT) 구조화 응답 제출",
            "input_schema": {
                "type": "object",
                "required": ["what", "why", "impact"],
                "properties": {
                    "what": {
                        "type": "object",
                        "required": ["headline", "key_metrics"],
                        "properties": {
                            "headline": {"type": "string"},
                            "key_metrics": {
                                "type": "array",
                                "items": {"type": "string"},
                                "minItems": 2,
                                "maxItems": 3,
                            },
                        },
                    },
                    "why": {
                        "type": "array",
                        "minItems": 3,
                        "maxItems": 3,
                        "items": {
                            "type": "object",
                            "required": ["rank", "title", "consequence"],
                            "properties": {
                                "rank": {"type": "integer", "minimum": 1, "maximum": 3},
                                "title": {"type": "string"},
                                "consequence": {"type": "string"},
                            },
                        },
                    },
                    "impact": {
                        "type": "array",
                        "minItems": 1,
                        "items": {
                            "type": "object",
                            "required": ["risk_factor", "direction", "priority", "reason"],
                            "properties": {
                                "risk_factor": {"type": "string"},
                                "direction": {"type": "string", "enum": ["증폭", "완화", "중립"]},
                                "priority": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW"]},
                                "reason": {"type": "string"},
                            },
                        },
                    },
                },
            },
        }
        try:
            resp = await self.client.messages.create(
                model=self.model,
                max_tokens=self.max_tokens,
                tools=[tool_def],
                tool_choice={"type": "tool", "name": "submit_interpretation"},
                messages=[{"role": "user", "content": prompt}],
            )
        except anthropic.APITimeoutError as e:
            raise ApiException(ErrorCode.LLM_002) from e
        except anthropic.RateLimitError as e:
            raise ApiException(ErrorCode.LLM_003) from e
        except anthropic.APIError as e:
            logger.exception("anthropic api error (interpretation tool_use)")
            raise ApiException(ErrorCode.LLM_001, detail=str(e)) from e

        tool_block = next(
            (b for b in resp.content if getattr(b, "type", None) == "tool_use"),
            None,
        )
        if tool_block is None:
            raise ApiException(ErrorCode.LLM_001, detail="interpretation tool_use 미반환")
        return Interpretation.model_validate(dict(tool_block.input))

    async def generate_strategy(
        self,
        *,
        customer: str,
        industry: str,
        market_region: str,
        sensitive_topics: list[str],
        risk_factors: list[str],
        indicator: str,
        change_rate: float,
        impact: list[dict],
    ) -> Strategy:
        prompt = _render(
            _load_prompt("strategy"),
            customer=customer,
            industry=industry,
            market_region=market_region,
            sensitive_topics_json=_to_json(sensitive_topics),
            risk_factors_json=_to_json(risk_factors),
            indicator=indicator,
            r=str(change_rate),
            impact_json=_to_json(impact),
        )
        data = await self._complete_json(prompt)
        return Strategy.model_validate(data)

    async def generate_questions(
        self,
        *,
        product: str,
        top_indicators: list[dict],
        customer_profiles: list[dict] | None = None,
    ) -> list[TodayQuestion]:
        prompt = _render(
            _load_prompt("questions"),
            product=product,
            top_indicators_json=_to_json(top_indicators),
            customer_profiles_json=_to_json(customer_profiles or []),
        )
        data = await self._complete_json(prompt)
        if not isinstance(data, list) or len(data) != 3:
            raise ApiException(
                ErrorCode.LLM_001,
                detail=f"questions 응답 길이 비정상: {len(data) if hasattr(data, '__len__') else 'NA'}",
            )
        return [TodayQuestion.model_validate(q) for q in data]

    async def generate_answer(
        self,
        *,
        qid: str,
        question_text: str,
        user_name: str,
        trigger_indicators: list[dict],
        related_indicators: list[dict],
        adjacent_indicators: list[dict],
    ) -> QuestionAnswer:
        """PRD 0516 Phase A — Structured Output (Anthropic tool_use) + Few-Shot.

        - tool_use 로 schema 강제 → free-form JSON 파싱 실패/형식 위반 0%
        - user_name 으로 호칭 동적 주입 ("박지은 담당자님, ...")
        """
        prompt = _render(
            _load_prompt("answer"),
            qid=qid,
            user_name=user_name,
            question_text=question_text,
            trigger_indicators_json=_to_json(trigger_indicators),
            related_indicators_json=_to_json(related_indicators),
            adjacent_indicators_json=_to_json(adjacent_indicators),
        )
        tool_def = {
            "name": "submit_answer",
            "description": "철강 시황 분석 답변 제출",
            "input_schema": {
                "type": "object",
                "required": ["briefing", "sales_rep_script", "sources", "confidence"],
                "properties": {
                    "briefing": {
                        "type": "string",
                        "description": "1분 브리핑 (단일 단락, 3문장, 250~300자)",
                    },
                    "sales_rep_script": {
                        "type": "string",
                        "description": (
                            f"추천 대응 방안 (단일 멘트, 150~200자, "
                            f"'{user_name} 담당자님, ' 으로 시작)"
                        ),
                    },
                    "sources": {
                        "type": "object",
                        "required": ["indicators"],
                        "properties": {
                            "indicators": {"type": "array", "items": {"type": "string"}},
                        },
                    },
                    "confidence": {"type": "number", "minimum": 0, "maximum": 1},
                },
            },
        }
        try:
            resp = await self.client.messages.create(
                model=self.model,
                max_tokens=self.max_tokens,
                tools=[tool_def],
                tool_choice={"type": "tool", "name": "submit_answer"},
                messages=[{"role": "user", "content": prompt}],
            )
        except anthropic.APITimeoutError as e:
            raise ApiException(ErrorCode.LLM_002) from e
        except anthropic.RateLimitError as e:
            raise ApiException(ErrorCode.LLM_003) from e
        except anthropic.APIError as e:
            logger.exception("anthropic api error (answer tool_use)")
            raise ApiException(ErrorCode.LLM_001, detail=str(e)) from e

        tool_block = next(
            (b for b in resp.content if getattr(b, "type", None) == "tool_use"),
            None,
        )
        if tool_block is None:
            raise ApiException(ErrorCode.LLM_001, detail="LLM 이 tool_use 응답 미반환")
        data = dict(tool_block.input)
        data["qid"] = qid
        return QuestionAnswer.model_validate(data)

    async def compute_market_impact(
        self,
        *,
        product: str,
        customer_industry: str,
        market_region: str,
        sensitive_topics: list[str],
        features: list[dict],
    ) -> dict:
        """판매량 가이드 Module 2 — 고객사별 시황영향 (노션 4.2.4).

        features: [{name, change_pct, cycle, weight}, ...]
        반환: {"directions": {feat_name: +1/-1/0, ...}, "market_score": float%}
        temperature=0 으로 결정론적 응답 (LLM 응답 일관성).
        """
        prompt = _render(
            _load_prompt("market_impact"),
            product=product,
            customer_industry=customer_industry,
            market_region=market_region,
            sensitive_topics_json=_to_json(sensitive_topics),
            features_json=_to_json(features),
        )
        tool_def = {
            "name": "submit_market_impact",
            "description": "시황영향 방향 부호 + market_score 제출",
            "input_schema": {
                "type": "object",
                "required": ["directions", "market_score"],
                "properties": {
                    "directions": {
                        "type": "object",
                        "additionalProperties": {
                            "type": "integer",
                            "enum": [-1, 0, 1],
                        },
                        "description": "각 지표명 → +1/-1/0 방향 부호",
                    },
                    "market_score": {
                        "type": "number",
                        "description": "Σ(변화율 × 가중치 × 부호) 의 % 값",
                    },
                },
            },
        }
        try:
            resp = await self.client.messages.create(
                model=self.model,
                max_tokens=800,
                temperature=0,
                tools=[tool_def],
                tool_choice={"type": "tool", "name": "submit_market_impact"},
                messages=[{"role": "user", "content": prompt}],
            )
        except anthropic.APITimeoutError as e:
            raise ApiException(ErrorCode.LLM_002) from e
        except anthropic.RateLimitError as e:
            raise ApiException(ErrorCode.LLM_003) from e
        except anthropic.APIError as e:
            logger.exception("anthropic api error (market_impact tool_use)")
            raise ApiException(ErrorCode.LLM_001, detail=str(e)) from e

        tool_block = next(
            (b for b in resp.content if getattr(b, "type", None) == "tool_use"),
            None,
        )
        if tool_block is None:
            raise ApiException(ErrorCode.LLM_001, detail="market_impact tool_use 미반환")
        data = dict(tool_block.input)
        directions = {str(k): int(v) for k, v in (data.get("directions") or {}).items()}
        score = float(data.get("market_score") or 0.0)
        return {"directions": directions, "market_score": score}


    async def generate_proposal(
        self,
        *,
        customer_name: str,
        industry: str,
        market_region: str,
        sensitive_topics: list[str],
        risk_factors: list[str],
        user_name: str,
        product: str,
        achievement_rate_pct: float,
        yoy_change_pct: float,
        actual_volume_kt: float,
        guide_volume_kt: float,
        market_signal_status: str,
        market_signal_score_pct: float,
        customer_market_impact_pct: float,
        key_features: list[dict],
        past_pattern: list[dict] | None = None,
    ) -> str:
        """PRD 4.2.7 — 제안 시작 기능. 4종 컨텍스트(고객사/실적/시황/과거) 기반 3~4줄 행동 지침.

        PRD 명시:
          - 모델: claude-sonnet-4-20250514 (settings.llm_model 사용)
          - max_tokens: 1000
          - 출력: 3~4줄 자연어 (인사말 없이 지침만)
          - 호출 직접: free-form text (tool_use 미사용, BLUF 단락 보장이 핵심)
          - temperature=0 (재현성)
        """
        prompt = _render(
            _load_prompt("proposal"),
            customer_name=customer_name,
            industry=industry or "—",
            market_region=market_region or "—",
            sensitive_topics_json=_to_json(sensitive_topics),
            risk_factors_json=_to_json(risk_factors),
            user_name=user_name,
            product=product,
            achievement_rate_pct=f"{achievement_rate_pct:.1f}",
            yoy_change_pct=f"{yoy_change_pct:+.1f}",
            actual_volume_kt=f"{actual_volume_kt:.1f}",
            guide_volume_kt=f"{guide_volume_kt:.1f}",
            market_signal_status=market_signal_status,
            market_signal_score_pct=f"{market_signal_score_pct:+.2f}",
            customer_market_impact_pct=f"{customer_market_impact_pct:+.2f}",
            key_features_json=_to_json(key_features),
            past_pattern_json=_to_json(past_pattern or []),
        )
        try:
            resp = await self.client.messages.create(
                model=self.model,
                max_tokens=1000,
                temperature=0,
                messages=[{"role": "user", "content": prompt}],
            )
        except anthropic.APITimeoutError as e:
            raise ApiException(ErrorCode.LLM_002) from e
        except anthropic.RateLimitError as e:
            raise ApiException(ErrorCode.LLM_003) from e
        except anthropic.APIError as e:
            logger.exception("anthropic api error (proposal)")
            raise ApiException(ErrorCode.LLM_001, detail=str(e)) from e

        text = "".join(
            b.text for b in resp.content if getattr(b, "type", None) == "text"
        ).strip()
        # 인사말 prefix 방어 후처리 (PRD: 인사말 절대 금지)
        for bad in (f"{user_name} 담당자님, ", f"{user_name} 담당자님,",
                    "안녕하세요. ", "안녕하세요, ", "안녕하세요"):
            if text.startswith(bad):
                text = text[len(bad):].lstrip()
        return text


_llm: LLMService | None = None


def get_llm_service() -> LLMService:
    global _llm
    if _llm is None:
        _llm = LLMService()
    return _llm
