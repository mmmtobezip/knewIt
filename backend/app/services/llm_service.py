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
        data = await self._complete_json(prompt)
        return Interpretation.model_validate(data)

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
        self, *, product: str, top_indicators: list[dict]
    ) -> list[TodayQuestion]:
        prompt = _render(
            _load_prompt("questions"),
            product=product,
            top_indicators_json=_to_json(top_indicators),
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
        trigger_indicators: list[dict],
        related_indicators: list[dict],
        adjacent_indicators: list[dict],
    ) -> QuestionAnswer:
        prompt = _render(
            _load_prompt("answer"),
            qid=qid,
            question_text=question_text,
            trigger_indicators_json=_to_json(trigger_indicators),
            related_indicators_json=_to_json(related_indicators),
            adjacent_indicators_json=_to_json(adjacent_indicators),
        )
        data = await self._complete_json(prompt)
        data.setdefault("qid", qid)
        return QuestionAnswer.model_validate(data)


_llm: LLMService | None = None


def get_llm_service() -> LLMService:
    global _llm
    if _llm is None:
        _llm = LLMService()
    return _llm
