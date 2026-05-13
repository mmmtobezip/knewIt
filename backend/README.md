# Backend - POS-Pricing Navigator

Backend 서비스 작업 공간입니다. **현재는 placeholder 상태이며, 본격 구현 예정.**

---

## 🎯 시작 전 필독 (순서대로)

1. **[../docs/main-ipo.md](../docs/main-ipo.md)** ⭐
   확정된 모든 결정사항(Q1~Q18) + API 11개 + 에러 코드 + 캐시 정책.
   **이 문서 하나로 BE 구현 범위의 80% 가 정의되어 있습니다.**

2. **[../docs/tech-stack.md](../docs/tech-stack.md)**
   권장 스택 (Python + FastAPI 기반).

3. **[../shared/types/](../shared/types/)**
   FE/BE 공유 TypeScript 인터페이스. Pydantic 모델로 변환해서 사용.

4. **[../frontend/src/lib/msw/mocks/data.ts](../frontend/src/lib/msw/mocks/data.ts)**
   Mock 응답 데이터. **BE 가 반환해야 할 응답 형식을 그대로 따라하면 됩니다.**

---

## 🛠 구현해야 할 것

### REST API (9개)
| API ID | Method | Endpoint |
|--------|--------|----------|
| API-01 | GET | `/api/customers/{id}/profile` |
| API-02 | GET | `/api/trigger-events?customer&product&date` |
| API-03 | GET | `/api/today-questions?customer` |
| API-04 | GET | `/api/indicators?product&period` |
| API-05 | GET | `/api/analysis?event_id` |
| API-06 | GET | `/api/causal-chain?event_id` |
| API-07 | GET | `/api/news?event_id` |
| API-08 | GET | `/api/strategy?customer_id` |
| API-11 | POST | `/api/cache/invalidate` |

### SSE 스트리밍 (2개)
| API ID | Method | Endpoint | 용도 |
|--------|--------|----------|------|
| API-09 | POST | `/api/chat` (SSE) | 자유 질문 채팅 |
| API-10 | POST | `/api/chat/question` (SSE) | 추천 질문 답변 |

상세: [../docs/main-ipo.md](../docs/main-ipo.md) § 3-6

### 일일 배치 (P-09)
- 매일 **06:00 Asia/Seoul** cron
- MIH CSV 적재 → trigger_event 탐지 → LLM 분석 사전 생성 → today_questions 생성
- 상세: [../docs/main-ipo.md](../docs/main-ipo.md) § 2-10

### MCP-News 서버 (자체 구현)
- Anthropic MCP Python SDK 사용
- 뉴스 소스: Reuters/Bloomberg/Mysteel/CRU/FT 등
- 별도 스펙 문서 작성 필요

---

## 🗄️ 저장소 구성 (확정)

| 데이터 | 저장소 | 비고 |
|--------|--------|------|
| 지표 CSV | 로컬 FS (`/data/indicators/YYYY-MM-DD.csv`) | MIH 자동 수집 |
| `customer_profile`, `trigger_events`, `users`, `assigned_customers` | PostgreSQL | 영속 |
| `analysis_result`, `causal_chain`, `strategy`, `news`, `today_questions` | Redis (TTL 24h) | 캐시 |
| `chat_session` | Redis (TTL 30분) | 휘발성 |

---

## 🌐 API 응답 표준

모든 API 는 다음 wrapper 형식으로 응답:

**성공**
```json
{
  "success": true,
  "data": { ... },
  "error": null,
  "meta": { "request_id": "...", "timestamp": "...", "cache_hit": true }
}
```

**실패**
```json
{
  "success": false,
  "data": null,
  "error": { "code": "E_LLM_001", "message": "...", "detail": "..." },
  "meta": { ... }
}
```

에러 코드 체계: [../docs/main-ipo.md](../docs/main-ipo.md) § 3-7

---

## 🧪 권장 스택

- **언어/프레임워크**: Python 3.11 + FastAPI
- **DB**: PostgreSQL 16 + asyncpg + SQLAlchemy 2.x + Alembic
- **캐시**: Redis 7
- **검증**: Pydantic 2.x
- **스케줄러**: APScheduler
- **LLM**: Anthropic Python SDK (또는 사내 LLM)
- **MCP**: Anthropic MCP Python SDK

상세: [../docs/tech-stack.md](../docs/tech-stack.md)

---

## ✅ FE 가 기대하는 동작 체크리스트

- [ ] HTTP 401 → FE 가 자동으로 /login 리다이렉트 처리 (인증 만료)
- [ ] HTTP 403 → 권한 외 고객사 접근 차단
- [ ] HTTP 429 → 새로고침 debounce / Rate limit
- [ ] SSE 응답은 `data: {"delta":"..."}\n\n` 청크 + `data: [DONE]\n\n` 종료 마커
- [ ] 캐시 무효화 (POST /api/cache/invalidate) 시 scope 별 Redis 삭제
- [ ] 매니저 권한은 본인 + 직속 팀원의 assigned_customers UNION 으로 반환
