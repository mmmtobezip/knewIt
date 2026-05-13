# POS-Pricing Navigator

POSCO 영업 협상 지원 AI 대시보드.
영업담당자가 담당 고객사의 시장 변동을 실시간 파악하고, AI 기반 협상 전략을 추천받을 수 있는 통합 대시보드입니다.

---

## 📦 폴더 구조

```
pos-pricing-navigator/
├── docs/                    📚 명세서 (모든 팀 공통)
│   ├── main-ipo.md           ⭐ 핵심 계약 문서 (필독)
│   ├── tech-stack.md         권장 기술 스택
│   ├── flow-chart.md         사용자/시스템 흐름도 (Mermaid)
│   └── mockup/index.html     원본 UI 목업 (시각 참조)
│
├── shared/types/            🔁 FE/BE 공유 TypeScript 인터페이스
│
├── frontend/                🎨 Next.js 15 + React 19 + TypeScript
│
└── backend/                 🛠️ Backend 작업 공간 (구현 예정)
```

---

## 🚀 빠른 시작

### Frontend
```bash
cd frontend
npm install
npm run dev
# → http://localhost:3000
```

자세한 셋업: [frontend/README.md](./frontend/README.md)

### Backend
구현 예정 — [backend/README.md](./backend/README.md) 참고.

---

## 📖 필독 문서 (역할별)

### 🛠️ Backend 개발자
순서대로 읽으세요:
1. [docs/main-ipo.md](./docs/main-ipo.md) ⭐ — 모든 결정사항 + API 11개 + 에러코드
2. [docs/tech-stack.md](./docs/tech-stack.md) — 권장 스택
3. [shared/types/](./shared/types/) — 도메인 타입 (Pydantic 변환 참고)
4. [frontend/src/lib/msw/mocks/data.ts](./frontend/src/lib/msw/mocks/data.ts) — Mock 응답 형식 (BE 가 따라야 할 응답 형식)

### 🎨 Frontend 개발자
1. [frontend/README.md](./frontend/README.md) — 셋업/구조/스크립트
2. [docs/main-ipo.md](./docs/main-ipo.md) — 화면 동작 명세
3. [docs/mockup/index.html](./docs/mockup/index.html) — 원본 디자인 참조

### 🤝 PM / 디자이너
- [docs/main-ipo.md](./docs/main-ipo.md) § 0 (확정 사항 요약)
- [docs/flow-chart.md](./docs/flow-chart.md) — 흐름도

---

## 🔑 핵심 결정 사항 (main-ipo.md 요약)

| 항목 | 결정 |
|------|------|
| 채팅 응답 | SSE 스트리밍 (Q7) |
| 일일 배치 | 매일 06:00 Asia/Seoul |
| 캐시 TTL | 24h (Redis) |
| 채팅 이력 | 영속 X (Redis 30분 휘발성) |
| 추천 질문 | 항상 3개, 매일 LLM 동적 생성 |
| 새로고침 debounce | 5초 |
| MCP-News | 자체 구현 |

---

## 📐 화면 (3개)

| 화면 | 경로 | 상태 |
|------|------|------|
| 메인 대시보드 | `/` | ✅ 구현 완료 |
| 판매 가이드 | `/guide` | 🚧 Phase 2 |
| 메일 초안 작성 | `/mail` | 🚧 Phase 2 |

---

## 🧩 기술 스택 요약

**Frontend**: Next.js 15 (App Router) · React 19 · TypeScript · Tailwind · Zustand · TanStack Query · Recharts · MSW

**Backend (권장)**: Python 3.11 + FastAPI · PostgreSQL 16 + Redis 7 · Anthropic SDK · MCP Python SDK · APScheduler

---

## 🤝 협업

- 모든 명세 변경은 `docs/main-ipo.md` 의 변경 이력 섹션에 기록
- API 변경 시 `shared/types/` 도 함께 업데이트
- PR 기반 리뷰
