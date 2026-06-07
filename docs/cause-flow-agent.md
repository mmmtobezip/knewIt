# Cause Flow Agent
> 고정 키워드 매핑 방식 → LangGraph 2단계 Agent로 전환

---

## 배경 및 문제

기존 cause_flow(차트2 인과관계 흐름)는 두 단계가 코드에 분리되어 있었다.

```
1단계: 제품별 고정 키워드로 뉴스 검색 (dashboard.py가 직접 호출)
          ↓
2단계: 그 뉴스를 가지고 흐름 생성 (dashboard.py가 결과를 넘겨줌)
```

**문제점**:
- 어떤 지표가 왜 변동했는지와 무관하게 항상 같은 키워드로 검색
- "원인 탐색"이 아닌 "제품 일반 뉴스 수집" 수준
- dashboard.py가 두 단계 사이에서 중간 전달자 역할을 해야 함

---

## 변경 후

LangGraph `CauseFlowAgent`가 두 단계를 하나의 Agent 안에서 처리한다.

```
[1단계: plan]
  AI가 "철광석이 -4.2% 하락했다"는 맥락을 보고
  fetch_indicator + search_news 도구를 자율적으로 호출해 원인 데이터 수집
    → "중국 조강생산량" 지표 조회
    → "중국 부동산 침체" 뉴스 검색
    → "iron ore demand China" 뉴스 검색

[2단계: analyze]
  수집된 지표 + 뉴스를 종합해 인과관계 흐름 생성
    → 중국 부동산 침체 → 조강 수요 감소 → 철광석 하락 → 열연 원가 하락
```

---

## 기술 구현

### LangGraph 2노드 구조

```
plan → analyze → END
```

| 노드 | 역할 | 도구 |
|------|------|------|
| plan | AI가 원인 관련 데이터 자율 수집 | fetch_indicator, search_news |
| analyze | 수집 데이터로 CauseFlowStep 생성 | 없음 (LLM 직접 분석) |

### CauseFlowState — 노드 간 공유 메모장

```
입력값:       indicator_name, change_rate, product, adjacent_indicators
plan 결과:    collected_indicators, collected_news
analyze 결과: steps (CauseFlowStep 목록)
```

### plan 노드 동작

- `cause_flow_plan.md` 프롬프트: "이 지표가 X% 변동했다. 원인을 찾아라"
- LLM이 어떤 지표를 조회할지, 어떤 키워드로 검색할지 스스로 결정
- 최대 5회 도구 호출 (지표명 직접 검색 금지, 중복 금지)

---

## 변경된 파일 목록

| 파일 | 종류 | 내용 |
|------|------|------|
| `app/prompts/cause_flow_plan.md` | **신규** | plan 노드 프롬프트 |
| `app/services/cause_flow_agent.py` | **신규** | LangGraph 2노드 Agent 본체 |
| `app/api/v1/dashboard.py` | 수정 | `_resolve_news` 제거, `CauseFlowAgent.run()` 호출로 교체 |

---

## dashboard.py 변경 요약

**변경 전**:
```python
news_wrap = await _resolve_news(customer, product, top.indicator, top.change_w1)  # 고정 키워드 검색
...
steps = await llm.generate_cause_flow(news=news_wrap.items, ...)  # 결과 직접 전달
```

**변경 후**:
```python
agent = CauseFlowAgent(llm, db, get_news_service())
steps = await agent.run(
    indicator_name=top.indicator,
    change_rate=top.change_w1,
    product=product,
    adjacent_indicators=adjacent,
)
```

---

## Q&A Agent와의 비교

| | CauseFlowAgent | QAAgent |
|---|---|---|
| 노드 수 | 2개 (plan → analyze) | 4개 (plan → analyze → briefing → script) |
| plan 도구 | fetch_indicator + search_news | fetch_indicator + search_news |
| 목적 | 인과관계 흐름 차트 생성 | 판매담당자 Q&A 답변 생성 |
| SSE 스트리밍 | 없음 (동기 호출) | 있음 (단계별 메시지 실시간 전달) |

---

## 변경하지 않은 범위

- `generate_cause_flow()` 프롬프트 및 로직 (analyze 노드가 내부적으로 재사용)
- interpretation, strategy 생성 단계
- Q&A Agent, 판매 가이드, 인증
