# Q&A Agent 개선 — LangGraph + tool_use

> 해커톤 결승 대응 개발 (2026-06-07)
> 추천 질문 생성 및 답변 기능을 AI Agent 방식으로 전환

---

## 배경 및 목적

기존 추천 질문·답변은 단발성 LLM 호출 방식이었다.

- **질문 생성**: 같은 제품 담당자면 모두 동일한 질문 3개
- **답변 생성**: Python이 데이터를 미리 골라 넘기면 LLM이 브리핑 + 영업 멘트를 한 번에 생성

이를 두 가지 방향으로 개선했다.

1. **질문 개인화** — 담당자의 고객사 프로필(업종, 민감 토픽)을 반영해 담당자별 맞춤 질문 생성
2. **답변 Agent화** — LangGraph 4단계 체인 + Anthropic tool_use로 AI가 필요한 데이터를 스스로 수집하고 단계적으로 분석

---

## 기술 선택

| 선택 | 이유 |
|------|------|
| LangGraph | 단계별 상태(State) 관리 + 노드 간 결과 연결 |
| Anthropic tool_use | 이미 codebase에 있는 기능. MCP 대비 단일 시스템에 적합 |
| SSE 스트리밍 | 단계별 진행 상황을 프론트엔드에 실시간 전달 |
| MCP 미사용 | 단일 시스템 내 사용이므로 과한 선택. tool_use로 동일 효과 |

---

## 변경된 파일 목록

### 백엔드

| 파일 | 종류 | 내용 |
|------|------|------|
| `pyproject.toml` | 수정 | `langgraph>=0.2.0` 의존성 추가 |
| `app/services/qa_agent.py` | **신규** | LangGraph Agent 본체 |
| `app/prompts/qa_plan.md` | **신규** | plan 노드 프롬프트 |
| `app/prompts/qa_analyze.md` | **신규** | analyze 노드 프롬프트 |
| `app/prompts/qa_briefing.md` | **신규** | briefing 노드 프롬프트 |
| `app/prompts/qa_script.md` | **신규** | script 노드 프롬프트 |
| `app/prompts/questions.md` | 수정 | 고객사 프로필 섹션 추가 |
| `app/services/llm_service.py` | 수정 | `generate_questions()`에 `customer_profiles` 파라미터 추가 |
| `app/api/v1/questions.py` | 수정 | 질문 개인화 + `/answer/stream` 엔드포인트 추가 |

### 프론트엔드

| 파일 | 종류 | 내용 |
|------|------|------|
| `src/stores/chat-store.ts` | 수정 | `replaceLastAssistantMessage` 액션 추가 |
| `src/features/main-dashboard/components/questions-panel.tsx` | 수정 | mutation → SSE fetch 스트리밍으로 교체 |

---

## 변경 1 — 질문 개인화

### 기존 방식

```
top_movers_for_product(top_n=5)
→ LLM에 지표 5개만 전달
→ 같은 제품 담당자 전원 동일 질문 3개
캐시 키: (QUESTIONS, 날짜, product, "_")
```

### 변경 후

```
top_movers_for_product(top_n=5)
+ 담당자의 고객사 프로필 최대 3개 (업종, 민감 토픽, 지역)
→ LLM이 담당 고객사 특성을 고려해 질문 3개 생성
캐시 키: (QUESTIONS, 날짜, product, user_id)  ← 담당자별 캐시
```

### 관련 파일

- `app/api/v1/questions.py` — `get_today_questions()`
- `app/services/llm_service.py` — `generate_questions(customer_profiles=...)`
- `app/prompts/questions.md` — 고객사 프로필 섹션 추가

---

## 변경 2 — 답변 Agent (LangGraph 4단계 체인)

### 기존 방식

```
Python이 지표 3개 선택 (category_big 다양성 기준, 고정 로직)
→ LLM 1회 호출
→ 브리핑 + 영업 멘트 동시 생성
```

### 변경 후

```
[1단계: plan]
  AI가 질문을 읽고 tool_use로 지표·뉴스 자율 수집 (최대 5회 반복)
  도구: fetch_indicator, search_news

[2단계: analyze]
  수집된 데이터 + 고객사 프로필 → 시황 분석 텍스트 생성

[3단계: briefing]
  분석 결과 → 1분 브리핑 작성 (tool_use 구조화)

[4단계: script]
  확정된 브리핑 → 영업 멘트 작성 (tool_use 구조화)
```

브리핑이 확정된 후 멘트를 작성하므로 두 텍스트 간 일관성이 높아진다.

### Agent가 사용하는 도구 (tool_use)

| 도구명 | 역할 |
|--------|------|
| `fetch_indicator` | 지표명으로 최신 값·변동률 조회 (DB) |
| `search_news` | 키워드로 관련 뉴스 검색 (Naver / NewsAPI) |

### QAState — 단계 간 공유 메모장

```
입력값:       qid, question_text, user_name, product, customer_profile
plan 결과:    collected_indicators, collected_news
analyze 결과: market_analysis
briefing 결과: briefing, sources
script 결과:  sales_rep_script, confidence
```

### 관련 파일

- `app/services/qa_agent.py` — Agent 본체 (LangGraph 그래프 + 4개 노드)
- `app/prompts/qa_plan.md` — plan 노드 시스템 프롬프트
- `app/prompts/qa_analyze.md` — analyze 노드 프롬프트
- `app/prompts/qa_briefing.md` — briefing 노드 프롬프트
- `app/prompts/qa_script.md` — script 노드 프롬프트

---

## 변경 3 — SSE 스트리밍 엔드포인트

### 신규 엔드포인트

```
POST /api/today-questions/answer/stream
```

기존 `POST /api/today-questions/answer`는 하위 호환을 위해 유지.

### SSE 이벤트 포맷

```
data: {"type": "step",   "node": "plan",     "message": "데이터 수집 중..."}
data: {"type": "step",   "node": "plan",     "message": "시황 분석 중..."}
data: {"type": "step",   "node": "analyze",  "message": "브리핑 작성 중..."}
data: {"type": "step",   "node": "briefing", "message": "영업 멘트 작성 중..."}
data: {"type": "result", "answer": { briefing, sales_rep_script, sources, confidence }}
data: [DONE]
```

### 프론트엔드 처리 흐름

```
질문 클릭
→ fetch() 로 SSE 스트림 연결
→ step 이벤트 수신 시: 채팅창에 단계 메시지 표시 (replaceLastAssistantMessage)
→ result 이벤트 수신 시: 채팅창에 최종 답변으로 교체
→ [DONE] 수신 시: 스트리밍 종료
```

### 관련 파일

- `app/api/v1/questions.py` — `post_answer_stream()`
- `app/services/qa_agent.py` — `astream_sse()`
- `src/features/main-dashboard/components/questions-panel.tsx` — SSE fetch 처리
- `src/stores/chat-store.ts` — `replaceLastAssistantMessage` 추가

---

## 변경하지 않은 범위

- 메인 대시보드 (cause_flow / interpretation / strategy)
- 판매 가이드
- 일일 배치 (daily_batch.py)
- 인증 / 고객사 권한

---

## 심사 포인트 요약

| 항목 | 기존 | 변경 후 |
|------|------|---------|
| 질문 | 제품 단위 동일 | 담당자 고객사 특성 반영 |
| 데이터 수집 | Python 하드코딩 | AI가 질문에 따라 자율 결정 |
| 브리핑·멘트 | 동시 생성 | 순차 생성 (일관성 향상) |
| 진행 가시성 | 없음 (로딩만) | 단계별 메시지 실시간 표시 |
