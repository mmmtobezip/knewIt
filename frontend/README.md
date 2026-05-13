# POS-Pricing Navigator (Frontend)

POSCO 영업 협상 지원 AI 대시보드의 프론트엔드 프로젝트입니다.

## 기술 스택

- **Next.js 15** (App Router) + **React 19** + **TypeScript** strict
- **Tailwind CSS** + Toss 디자인 시스템 토큰
- **shadcn/ui** + **Radix UI** + **Lucide Icons**
- **Zustand** (클라이언트 상태) + **TanStack Query v5** (서버 상태)
- **ky** (HTTP) + **MSW** (Mock API) + **SSE 스트리밍** (포석호 채팅)
- **Recharts** (가격 차트), **Framer Motion** (애니메이션)
- **Vitest** + **Testing Library**

상세: [tech-stack.md](../tech-stack.md)

## 빠른 시작

```bash
# 의존성 설치 (pnpm 권장)
pnpm install

# MSW 서비스 워커 생성 (최초 1회)
pnpm dlx msw init public/ --save

# 환경 변수 (.env.local)
cp .env.local.example .env.local

# 개발 서버 실행
pnpm dev
# → http://localhost:3000
```

## 폴더 구조

```
src/
  app/                       Next.js App Router (페이지 + layout)
    page.tsx                 메인 대시보드 (SCR-MAIN-001)
    guide/page.tsx           판매 가이드 (Phase 2)
    mail/page.tsx            메일 초안 작성 (Phase 2)
    layout.tsx
    providers.tsx            QueryClient + MSW 부팅
    globals.css              Toss 디자인 토큰 (CSS 변수)

  components/
    ui/                      재사용 UI primitive (Button, Card, Select, Toaster, ...)
    layout/                  AppHeader, QuickNav
    chart/                   PriceChart (Recharts 래퍼)
    chat/                    ChatPanel, PoseokhoAvatar

  features/
    main-dashboard/          메인 대시보드 feature 모듈
      components/            QuestionsPanel, PriceChartCard, CauseFlowCard,
                             NewsSlider, AiDiagnosis, StrategyCard
      main-dashboard.tsx     루트 컴포넌트
    sales-guide/             (Phase 2)
    mail-draft/              (Phase 2)

  hooks/                     useDebouncedCallback 등 일반 훅
  services/                  chat-stream.service.ts (SSE)
  stores/                    Zustand 스토어 (selection, chat, toast, auth)

  lib/
    api/
      client.ts              ky 인스턴스 + 응답 unwrap
      queries/dashboard.ts   TanStack Query 훅 (API-01~11)
    msw/
      browser.ts             MSW Worker
      handlers/              dashboard, chat (SSE)
      mocks/                 mock data

  types/                     도메인/API/UI 타입 (IPO Input 명세 1:1)
  shared/
    constants/               캐시 정책, 채팅 제약 등 상수
    utils/                   format(숫자/날짜/변동률), cn(클래스 병합)
  styles/
    tokens.ts                JS/TS 참조용 디자인 토큰
```

## 핵심 아키텍처 결정

### 1. 상태 관리 분리
- **서버 상태**: TanStack Query (캐싱, 무효화, refetch)
- **선택 상태**: Zustand persist (localStorage 영속)
- **채팅 상태**: Zustand 메모리 (휘발성, IPO Q11 정책)
- **알림**: Zustand 외부 호출 패턴 (`toast.show(...)`)

### 2. SSE 스트리밍
EventSource는 POST/인증 헤더를 지원하지 않아 **fetch + ReadableStream + AbortController** 로 구현했습니다.
- 30초 타임아웃 (Q11)
- 청크 단위 텍스트 누적 → assistant 메시지 실시간 업데이트
- `[DONE]` 마커로 종료 인지

→ `src/services/chat-stream.service.ts`

### 3. MSW Mock 레이어
백엔드 부재 시에도 FE 단독 개발 가능. 실제 API 연동 시 `NEXT_PUBLIC_API_MOCKING=disabled` 만 변경.
- 11개 엔드포인트 + 2개 SSE 엔드포인트 mock 구현
- 50~250ms 랜덤 지연으로 실시간성 시뮬레이션
- main.prd 의 CUSTOMER_PROFILE 4개 고객사 데이터

### 4. 디자인 토큰
- CSS 변수 (`globals.css`) → Tailwind 컬러 매핑 (`tailwind.config.ts`)
- JS/TS 참조용 (`styles/tokens.ts`) — 차트 색상 등 인라인 스타일에서만 사용

### 5. 변동률 색상 (한국 금융권 관습)
- **상승**: 빨강 (`text-change-up`)
- **하락**: 파랑 (`text-change-down`)
- 헬퍼: `getChangeTextClass(rate)` / `formatChangeRate(rate)`

## 화면

| 경로 | 화면 | 상태 |
|------|------|------|
| `/` | 메인 대시보드 (SCR-MAIN-001) | ✅ 풀 구현 |
| `/guide` | 판매 가이드 | 🚧 Placeholder |
| `/mail` | 메일 초안 작성 | 🚧 Placeholder |

## IPO 명세서와의 매핑

본 코드는 [main-ipo.md](../main-ipo.md) 의 다음 항목을 모두 구현합니다.

| IPO 항목 | 구현 위치 |
|---------|---------|
| INPUT 정의 (§ 1) | `src/types/` (도메인 타입) |
| P-01 화면 진입 | `features/main-dashboard/main-dashboard.tsx` |
| P-02 고객사 변경 | `components/layout/app-header.tsx` `handleCustomerChange` |
| P-03 제품 변경 | 동일 파일 `handleProductChange` |
| P-04 새로고침 (debounce 5s) | 동일 파일 `handleRefresh` + `useInvalidateCache` |
| P-05 추천 질문 선택 (SSE) | `features/main-dashboard/components/questions-panel.tsx` |
| P-06 채팅 질의 (SSE) | `components/chat/chat-panel.tsx` |
| P-07 뉴스 클릭 | `features/main-dashboard/components/news-slider.tsx` |
| P-08 화면 이동 | `components/layout/quick-nav.tsx` |
| 캐싱 정책 (§ 2-11) | `lib/api/queries/dashboard.ts` (staleTime + invalidate) |
| 메시지 표준 (§ 3-5) | `types/messages.ts` + `stores/toast-store.ts` |
| 에러 코드 (§ 3-7) | `types/api.ts` + `lib/api/client.ts` |

## 개발 명령어

```bash
pnpm dev          # 개발 서버
pnpm build        # 프로덕션 빌드
pnpm start        # 프로덕션 서버
pnpm lint         # ESLint
pnpm typecheck    # TypeScript 검증
pnpm test         # Vitest
pnpm format       # Prettier
```

## 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `NEXT_PUBLIC_API_BASE_URL` | `http://localhost:3001` | 백엔드 API 베이스 URL |
| `NEXT_PUBLIC_API_MOCKING` | `enabled` | MSW 활성화 여부 |
| `NEXT_PUBLIC_DEFAULT_USER_ROLE` | `sales` | 개발용 기본 권한 |

## 다음 단계

1. **MSW 서비스 워커 생성**: `pnpm dlx msw init public/ --save`
2. **실제 백엔드 연동**: `.env.local` 의 `NEXT_PUBLIC_API_MOCKING=disabled`
3. **추가 화면 구현**: 판매 가이드 / 메일 초안 작성 IPO 정의 후 개발
4. **Storybook 셋업**: 컴포넌트 카탈로그
5. **E2E 테스트**: Playwright (선택)
