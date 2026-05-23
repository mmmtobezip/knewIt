"""Phase C 평가 — 5개 프롬프트 개선 전/후 LLM 응답 비교.

처리 흐름:
    1. /tmp/prompts_before/*.md (개선 전) → 임시로 PROMPTS_DIR 로 swap → LLM 호출
    2. 원본 PROMPTS_DIR (개선 후) 복원 → 같은 입력으로 LLM 호출
    3. 두 응답을 /tmp/prompt_eval/{name}_{before,after}.json 으로 저장
    4. 메트릭 산출: 일치율(format compliance) + 개선율(정보 밀도/구조/근거)

실행:
    cd backend && uv run python -m scripts.compare_prompts
"""
from __future__ import annotations

import asyncio
import json
import shutil
from pathlib import Path
from typing import Any

from app.services import llm_service as llm_mod

BEFORE_DIR = Path("/tmp/prompts_before")
AFTER_BACKUP = Path("/tmp/prompts_after")
EVAL_DIR = Path("/tmp/prompt_eval")
ORIG_PROMPTS_DIR = llm_mod.PROMPTS_DIR


# ─────────────────────────── 동일 입력 ───────────────────────────

QUESTIONS_INPUT = dict(
    product="선재",
    top_indicators=[
        {"indicator": "중국 철근(Rebar) 선물가", "change_w1": -3.2, "score": 0.312},
        {"indicator": "중국 10일 주기 주요 제철소 철강 재고(CISA)", "change_w1": 5.85, "score": 0.108},
        {"indicator": "미국 10년 만기 국채 수익률", "change_w1": -2.1, "score": 0.093},
        {"indicator": "중국 철광석 수입가 - 호주산 62% 분광", "change_w1": -4.5, "score": 0.210},
        {"indicator": "다우존스 산업평균지수", "change_w1": 1.1, "score": 0.055},
    ],
)

ANSWER_INPUT = dict(
    qid="Q1",
    question_text="중국 제철소 재고 증가가 선재 가격에 미치는 영향은?",
    user_name="박지은",
    trigger_indicators=[
        {
            "indicator": "중국 10일 주기 주요 제철소 철강 재고(CISA)",
            "value": 1863.0,
            "unit": "만톤",
            "change_w1": 5.85,
        }
    ],
    related_indicators=[
        {"indicator": "동아시아 철스크랩 수입가", "value": 345.0, "unit": "USD/톤", "change_w1": -1.2},
        {"indicator": "중국 철근(Rebar) 선물가", "value": 3420.0, "unit": "위안/톤", "change_w1": -3.2},
        {"indicator": "한국은행 기준금리", "value": 3.5, "unit": "%", "change_w1": 0.0},
    ],
    adjacent_indicators=[],
)

CAUSE_FLOW_INPUT = dict(
    indicator_name="중국 10일 주기 주요 제철소 철강 재고(CISA)",
    change_rate=5.85,
    period="W-1",
    news=[
        {"title": "中 부동산 투자 감소 지속, 4월 -10.3% YoY", "published_at": "2026-05-10", "url": "https://news/1"},
        {"title": "CISA: 5월 중순 주요 제철소 재고 1863만톤", "published_at": "2026-05-12", "url": "https://news/2"},
        {"title": "중국 5월 수출 쿼터 발급, 통관 가속", "published_at": "2026-05-11", "url": "https://news/3"},
        {"title": "철근 선물가 약세 — 단기 매수 위축", "published_at": "2026-05-09", "url": "https://news/4"},
        {"title": "중국 PMI 5월 49.8 — 위축 국면 지속", "published_at": "2026-05-13", "url": "https://news/5"},
    ],
    adjacent_indicators=[
        {"indicator": "중국 철근(Rebar) 선물가", "change_w1": -3.2},
        {"indicator": "중국 철광석 수입가 - 호주산 62% 분광", "change_w1": -4.5},
    ],
    axis_name="수급현황",
)

INTERPRETATION_INPUT = dict(
    customer="고려제강",
    industry="와이어로프/스프링/타이어보강재",
    market_region="국내 + 동남아",
    risk_factors=["중국 저가 수출 압박", "전방산업 자동차 수요 둔화"],
    indicator="중국 10일 주기 주요 제철소 철강 재고(CISA)",
    change_rate=5.85,
    period="W-1",
    flow_text="중국 부동산 투자 감소 → 내수 흡수 부진 → 제철소 재고 누적 → 단기 공급 과잉 신호",
)

STRATEGY_INPUT = dict(
    customer="고려제강",
    industry="와이어로프/스프링/타이어보강재",
    market_region="국내 + 동남아",
    sensitive_topics=["슬라이드 가격 조항", "장기계약", "중국 대체 헷지"],
    risk_factors=["중국 저가 수출 압박", "전방산업 자동차 수요 둔화"],
    indicator="중국 10일 주기 주요 제철소 철강 재고(CISA)",
    change_rate=5.85,
    impact=[
        {"risk_factor": "중국 저가 수출 압박", "direction": "증폭", "priority": "HIGH",
         "reason": "제철소 재고 누적 → 단기 수출 전환 압력 ↑"},
        {"risk_factor": "전방산업 자동차 수요 둔화", "direction": "중립", "priority": "LOW",
         "reason": "본 시그널은 공급측, 수요와는 약한 인과"},
    ],
)


# ─────────────────────────── runner ───────────────────────────

async def _run_once(label: str) -> dict[str, Any]:
    """현재 PROMPTS_DIR 상태로 5개 LLM 호출 → dict 결과."""
    svc = llm_mod.LLMService()
    out: dict[str, Any] = {}

    print(f"[{label}] questions ...", flush=True)
    qs = await svc.generate_questions(**QUESTIONS_INPUT)
    out["questions"] = [q.model_dump() for q in qs]

    print(f"[{label}] answer ...", flush=True)
    ans = await svc.generate_answer(**ANSWER_INPUT)
    out["answer"] = ans.model_dump()

    print(f"[{label}] cause_flow ...", flush=True)
    flow = await svc.generate_cause_flow(**CAUSE_FLOW_INPUT)
    out["cause_flow"] = [s.model_dump() for s in flow]

    print(f"[{label}] interpretation ...", flush=True)
    interp = await svc.generate_interpretation(**INTERPRETATION_INPUT)
    out["interpretation"] = interp.model_dump()

    print(f"[{label}] strategy ...", flush=True)
    strat = await svc.generate_strategy(**STRATEGY_INPUT)
    out["strategy"] = strat.model_dump()

    return out


def _swap_to(src: Path) -> None:
    """PROMPTS_DIR 의 5개 .md 를 src/ 의 동일 이름으로 덮어쓴다."""
    for name in ("questions", "answer", "cause_flow", "interpretation", "strategy"):
        shutil.copyfile(src / f"{name}.md", ORIG_PROMPTS_DIR / f"{name}.md")


# ─────────────────────────── metrics ───────────────────────────

def _len_or_zero(x: Any) -> int:
    return len(x) if isinstance(x, (str, list)) else 0


def _score(payload: dict[str, Any]) -> dict[str, float | int]:
    """간단 평가 — 형식 일치율 + 정보 밀도 지표."""
    m: dict[str, float | int] = {}

    # questions: 3개 + 50자 이내 + MECE 다양성 (related_groups 합집합 개수)
    qs = payload.get("questions", [])
    m["q_count"] = len(qs)
    m["q_under_50"] = sum(1 for q in qs if _len_or_zero(q.get("text", "")) <= 50)
    groups = set()
    for q in qs:
        for g in q.get("related_groups_internal", []) or []:
            groups.add(g)
    m["q_unique_groups"] = len(groups)

    # answer: briefing 250~300, sales 150~200, 호칭 prefix, 라벨 없음
    a = payload.get("answer", {})
    brief = a.get("briefing", "") or ""
    script = a.get("sales_rep_script", "") or ""
    m["a_brief_len"] = len(brief)
    m["a_brief_in_range"] = int(220 <= len(brief) <= 320)
    m["a_script_len"] = len(script)
    m["a_script_in_range"] = int(120 <= len(script) <= 220)
    m["a_script_starts_with_user"] = int(script.startswith("박지은 담당자님,"))
    m["a_script_has_label"] = int(any(p in script for p in ["[추천", "1)", "①"]))
    m["a_sources_count"] = _len_or_zero(a.get("sources", []))
    m["a_confidence"] = float(a.get("confidence", 0.0))

    # cause_flow: 5 단계, 각 evidence 1+
    flow = payload.get("cause_flow", [])
    m["cf_steps"] = len(flow)
    m["cf_steps_with_evidence"] = sum(1 for s in flow if (s.get("evidence") or []))

    # interpretation: WHY 3개, key_metrics 2~3, impact 모든 risk_factor 커버
    interp = payload.get("interpretation", {})
    m["i_why_count"] = _len_or_zero(interp.get("why", []))
    m["i_km_count"] = _len_or_zero(interp.get("what", {}).get("key_metrics", []))
    m["i_impact_count"] = _len_or_zero(interp.get("impact", []))
    headline = interp.get("what", {}).get("headline", "") or ""
    m["i_headline_len"] = len(headline)
    m["i_headline_under_80"] = int(len(headline) <= 80)

    # strategy: actions 3, points 3, action 동사 시작
    strat = payload.get("strategy", {})
    actions = strat.get("recommended_actions", []) or []
    points = strat.get("negotiation_points", []) or []
    m["s_actions"] = len(actions)
    m["s_points"] = len(points)
    verbs = ("제안", "확보", "협의", "공유", "검토", "관철", "추진", "안내", "압박", "선제")
    m["s_actions_verb_start"] = sum(1 for a in actions if any(a.startswith(v) for v in verbs))

    return m


# ─────────────────────────── main ───────────────────────────

async def main() -> None:
    EVAL_DIR.mkdir(parents=True, exist_ok=True)
    AFTER_BACKUP.mkdir(parents=True, exist_ok=True)

    # 현재 (개선 후) 프롬프트 백업
    for name in ("questions", "answer", "cause_flow", "interpretation", "strategy"):
        shutil.copyfile(ORIG_PROMPTS_DIR / f"{name}.md", AFTER_BACKUP / f"{name}.md")
    print(f"[backup] 개선 후 프롬프트 → {AFTER_BACKUP}", flush=True)

    try:
        # ─── BEFORE 실행 ───
        _swap_to(BEFORE_DIR)
        before = await _run_once("BEFORE")
        (EVAL_DIR / "before.json").write_text(json.dumps(before, ensure_ascii=False, indent=2))

        # ─── AFTER 실행 (원본 복원) ───
        _swap_to(AFTER_BACKUP)
        after = await _run_once("AFTER")
        (EVAL_DIR / "after.json").write_text(json.dumps(after, ensure_ascii=False, indent=2))
    finally:
        # 어떤 경우든 개선 후 프롬프트 복원
        _swap_to(AFTER_BACKUP)
        print("[restore] 개선 후 프롬프트 복원 완료", flush=True)

    # ─── metrics ───
    m_before = _score(before)
    m_after = _score(after)
    table = []
    for k in sorted(set(m_before) | set(m_after)):
        b = m_before.get(k, 0)
        a = m_after.get(k, 0)
        delta = (a - b) if isinstance(b, (int, float)) and isinstance(a, (int, float)) else ""
        table.append((k, b, a, delta))

    # print as table
    print()
    print(f"{'metric':32s}  {'before':>10s}  {'after':>10s}  {'Δ':>8s}")
    print("-" * 66)
    for k, b, a, d in table:
        bs = f"{b:.2f}" if isinstance(b, float) else str(b)
        as_ = f"{a:.2f}" if isinstance(a, float) else str(a)
        ds = f"{d:+.2f}" if isinstance(d, float) else f"{d:+d}" if isinstance(d, int) else ""
        print(f"{k:32s}  {bs:>10s}  {as_:>10s}  {ds:>8s}")

    (EVAL_DIR / "metrics.json").write_text(
        json.dumps({"before": m_before, "after": m_after}, ensure_ascii=False, indent=2)
    )
    print(f"\n[saved] {EVAL_DIR}/before.json / after.json / metrics.json")


if __name__ == "__main__":
    asyncio.run(main())
