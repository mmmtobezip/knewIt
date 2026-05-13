# 기술 스택 결정서 (Frontend) - POS-Pricing Navigator

| 항목 | 내용 |
|------|------|
| **프로젝트** | POS-Pricing Navigator (POSCO 영업 협상 지원 도구) |
| **범위** | **Frontend Only** |
| **작성일** | 2026-05-13 |
| **참조 문서** | `main.prd` / `main-ipo.md` / `wireframe-spec.md` / `types/` |
| **MVP 목표** | 메인 대시보드 + 판매 가이드 + 메일 초안 작성 (3개 화면) |
| **상태** | ⏳ 의사결정 필요 |

> 각 항목별 ⭐ 추천안 / 대안 / **결정란** 으로 구성. 결정란에 ✅ 표시 후 확정.

---

## 0. 빠른 결정 표 (한눈에 보기)

| 항목 | 추천 ⭐ | 결정 |
|------|---------|------|
| 프레임워크 | Next.js 14 (App Router) | ☐ |
| 언어 | TypeScript 5.x | ✅ (확정) |
| 스타일링 | Tailwind CSS 3.x | ☐ |
| 상태 관리 | Zustand | ☐ |
| 서버 상태 / 캐시 | TanStack Query v5 | ☐ |
| API 클라이언트 | ky (또는 axios) | ☐ |
| 차트 | Chart.js + react-chartjs-2 | ☐ |
| 컴포넌트 라이브러리 | 자체 구축 (Toss 스타일) | ☐ |
| 폼 / 검증 | (해당 없음 - 폼 적음) | - |
| API Mock | MSW (Mock Service Worker) | ☐ |
| 패키지 매니저 | pnpm | ☐ |
| 코드 품질 | ESLint + Prettier | ☐ |
| 테스트 | Vitest + Testing Library | ☐ |
| Git 워크플로우 | 단순화 Git Flow (main + feature/*) | ☐ |
| CI | GitHub Actions | ☐ |

---

## 1. 프레임워크

| 옵션 | 장점 | 단점 |
|------|------|------|
| ⭐ **Next.js 14 (App Router)** | SSR/SSG 가능, 라우팅·번들링 통합, 한국 생태계 활성 | 학습 곡선, 일부 제약 |
| Vite + React 18 | 가장 가볍고 빠른 개발 | SSR 별도 설정 필요 |
| Remix | DX 좋음 | 한국 사용자 적음 |

**추천 사유**: 사내 영업 도구라 SEO 불필요하지만, **App Router의 server components**로 LLM 호출 같은 무거운 작업을 서버에서 처리 가능. 향후 모바일 대응 시 Next.js의 이미지 최적화 등 활용도 높음.

**결정**: ☐ Next.js 14  /  ☐ Vite + React  /  ☐ 기타

---

## 2. 언어

✅ **TypeScript 5.x** (이미 결정 완료 - `types/` 디렉토리 작성됨)

- 엄격 모드 (`strict: true`) 활성화 권장
- IPO Input 정의 → `types/domain.ts` 로 코드화 완료

---

## 3. 스타일링

| 옵션 | 장점 | 단점 |
|------|------|------|
| ⭐ **Tailwind CSS 3.x** | 빠른 프로토타입, 토큰 기반 일관성 | 초기 클래스 길어짐 |
| CSS Modules | 표준 CSS, 격리 | Token 관리 별도 |
| styled-components | 컴포넌트 단위 | 런타임 오버헤드 |
| vanilla-extract | 정적 추출, 타입 안정 | 학습 곡선 |

**추천 사유**: 현재 [index.html](index.html) 의 Toss 스타일 CSS 변수를 그대로 `tailwind.config.js` 에 토큰화 가능. 디자인 시스템 토큰과 매핑이 깔끔.

**결정**: ☐ Tailwind  /  ☐ CSS Modules  /  ☐ 기타

---

## 4. 상태 관리

| 옵션 | 장점 | 단점 |
|------|------|------|
| ⭐ **Zustand** | 가장 가볍고 단순, boilerplate 거의 없음 | DevTools 다소 부족 |
| Jotai | atomic, React 친화적 | 학습 곡선 |
| Redux Toolkit | 엔터프라이즈 표준, DevTools 강력 | boilerplate 많음 |
| Context API | 추가 의존성 없음 | 성능 이슈 가능 |

**추천 사유**: 메인 대시보드는 **선택 상태(고객사/제품)** 정도만 글로벌. 나머지는 서버 상태 (TanStack Query). Zustand 1~2 store면 충분.

**결정**: ☐ Zustand  /  ☐ Jotai  /  ☐ Redux Toolkit

---

## 5. 서버 상태 / 캐싱

⭐ **TanStack Query v5** (구 React Query) 강력 추천

**이유**:
- 서버 상태(API 응답) 캐싱·재검증·refetch 자동화
- 새로고침(P-04), 캐시 무효화(P-04 invalidate) 패턴 그대로 매핑
- SSE는 별도 처리 (TanStack Query는 일회성 fetch에 적합)
- IPO 캐시 정책(24h TTL)을 `staleTime` 으로 미러링 가능

**대안**: SWR (가벼움), Apollo Client (GraphQL이면)

**결정**: ☐ TanStack Query  /  ☐ SWR  /  ☐ 기타

---

## 6. API 클라이언트 (HTTP)

| 옵션 | 장점 | 단점 |
|------|------|------|
| ⭐ **ky** | 가벼움(8kb), 네이티브 fetch 기반, hooks 지원 | 한국 자료 적음 |
| axios | 풍부한 기능, 한국 자료 많음 | 무거움(45kb) |
| 네이티브 fetch | 의존성 0 | 보일러플레이트 |

**추천 사유**: 공통 응답 wrapper(`{success, data, error, meta}`) 가공 시 ky의 hook 시스템이 깔끔. SSE는 EventSource 별도 사용.

**결정**: ☐ ky  /  ☐ axios  /  ☐ fetch

---

## 7. 차트

⭐ **Chart.js + react-chartjs-2**

**이유**:
- 현재 [index.html](index.html) 에서 이미 Chart.js 사용 중 → 마이그레이션 비용 0
- 라인 차트만 필요한 MVP에 충분
- 번들 크기 적당

**대안**: Recharts (선언형, React 친화), Visx (D3 기반 커스텀)

**결정**: ☐ Chart.js  /  ☐ Recharts  /  ☐ Visx

---

## 8. 컴포넌트 라이브러리

⭐ **자체 구축** (Toss 스타일)

**이유**:
- shadcn/ui, Material UI 등은 이미 모양이 정해져 있어 Toss 스타일 재현이 오히려 어려움
- 현재 [index.html](index.html) 의 컴포넌트들이 이미 80% 작성된 상태
- Storybook 셋업 + 자체 컴포넌트 catalog 운영

**대안**:
- **shadcn/ui** + 커스터마이징 (베이스 깔고 디자인 토큰 덮어쓰기) — 시간 절약
- **Radix UI primitives** + Tailwind (헤드리스, 접근성 자동)

**결정**: ☐ 자체 구축  /  ☐ shadcn/ui  /  ☐ Radix + Tailwind

---

## 9. API Mock (개발 시)

⭐ **MSW (Mock Service Worker)**

**이유**:
- BE 미완성 시 FE 단독 개발 가능
- 실제 fetch 가로채기 → 실제 API 교체 시 코드 변경 0
- IPO 정의된 11개 엔드포인트 mock handler 작성

**결정**: ☐ MSW  /  ☐ json-server  /  ☐ 기타

---

## 10. 패키지 매니저

⭐ **pnpm**

**이유**: 디스크 효율, 빠른 설치, monorepo 지원. npm/yarn 대비 명확한 우위.

**결정**: ☐ pnpm  /  ☐ npm  /  ☐ yarn

---

## 11. 코드 품질

- **ESLint** (`next/recommended` 베이스)
- **Prettier**
- **TypeScript strict mode**
- **husky + lint-staged** (커밋 전 자동 검사)

**결정**: ☐ 추천안 그대로  /  ☐ 다른 구성

---

## 12. 테스트

| 영역 | 도구 | 범위 |
|------|------|------|
| 단위 | Vitest + Testing Library | 컴포넌트, 헬퍼 (포맷터 등) |
| E2E | Playwright (선택) | 핵심 플로우 (로그인 → 메인 진입 → 채팅) |

**MVP 권장**: 단위 테스트는 헬퍼/포맷터 (`formatChangeRate` 등) 위주. 컴포넌트 테스트는 핵심 인터랙션만.

**결정**: ☐ 추천안  /  ☐ 다른 구성

---

## 13. Git 워크플로우

⭐ **단순화된 Git Flow**:
```
main          ← 운영 배포
└── feature/* ← 기능 단위 브랜치
└── hotfix/*  ← 긴급 수정
```

- PR 기반 리뷰
- main 직접 push 금지
- Squash merge 권장 (히스토리 깔끔)

**결정**: ☐ 추천안  /  ☐ Git Flow 정식  /  ☐ 트렁크 기반

---

## 14. CI

⭐ **GitHub Actions**

**MVP 파이프라인**:
```yaml
on: [push, pull_request]
jobs:
  fe-check:
    steps:
      - pnpm install
      - pnpm lint
      - pnpm typecheck
      - pnpm test
      - pnpm build
```

**결정**: ☐ GitHub Actions  /  ☐ GitLab CI  /  ☐ Jenkins (사내)

---

## 15. 환경 분리

⭐ **3단계**: `local` → `staging` → `production`

- `.env.local` / `.env.staging` / `.env.production` 분리
- 환경별 API base URL 분기
- Secret 관리: GitHub Secrets / Vault (사내 정책 따름)

---

## 16. 권장 의존성 버전 (작성일 기준)

### `package.json` 핵심

```json
{
  "dependencies": {
    "next": "^14.2.0",
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "typescript": "^5.4.0",
    "tailwindcss": "^3.4.0",
    "zustand": "^4.5.0",
    "@tanstack/react-query": "^5.40.0",
    "ky": "^1.2.0",
    "chart.js": "^4.4.0",
    "react-chartjs-2": "^5.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.3.0",
    "@types/node": "^20.12.0",
    "msw": "^2.3.0",
    "vitest": "^1.6.0",
    "@testing-library/react": "^16.0.0",
    "@testing-library/jest-dom": "^6.4.0",
    "eslint": "^8.57.0",
    "eslint-config-next": "^14.2.0",
    "prettier": "^3.3.0",
    "prettier-plugin-tailwindcss": "^0.5.0",
    "husky": "^9.0.0",
    "lint-staged": "^15.2.0"
  }
}
```

---

## 17. 결정 후 다음 단계

결정란 모두 채워지면:

1. **Next.js 프로젝트 초기화**
   ```bash
   pnpm create next-app@latest --typescript --tailwind --app
   ```

2. **권장 폴더 구조**
   ```
   /src
     /app                  ← Next.js App Router
       /(main)/page.tsx    ← 메인 대시보드
       /guide/page.tsx     ← 판매 가이드
       /mail/page.tsx      ← 메일 초안
       /layout.tsx
     /components           ← 재사용 컴포넌트
       /ui                 ← Button, Card, Dropdown 등
       /chart              ← PriceChart 등
       /chat               ← 채팅 패널
     /features             ← 기능 단위 모듈
       /main-dashboard
       /sales-guide
       /mail-draft
     /hooks                ← React Query hooks
     /lib                  ← API 클라이언트, 유틸
       /api.ts
       /msw                ← Mock handlers
     /stores               ← Zustand stores
     /types                ← (현재 types/ 디렉토리 이전)
   /tests
   ```

3. **MSW Mock Handlers 작성** (11개 엔드포인트, IPO § 3-6-2 기반)

4. **현재 [index.html](index.html) → React 컴포넌트화 시작**

5. **Storybook 셋업** (컴포넌트 카탈로그)

---

## 18. 미해결 / 확인 필요 사항

| 항목 | 확인 대상 | 영향 |
|------|---------|------|
| 모바일 대응 시점 | MVP / Phase 2 | 반응형 정책 결정 |
| 사내 CI 표준 | GitHub Actions / Jenkins / GitLab? | CI 도구 선택 |
| FE 배포 환경 | 사내 정적 호스팅 / Vercel / S3 등? | 빌드 산출물 형태 |
| 브라우저 지원 범위 | 최신 Chrome only? IE 호환? | 폴리필 / 빌드 타겟 |

---

## 19. 변경 이력

| 버전 | 일자 | 변경 내용 |
|------|------|---------|
| v1.0 | 2026-05-13 | 최초 작성 (FE/BE 통합) |
| v2.0 | 2026-05-13 | **Frontend Only로 범위 축소** (BE/공통/인프라 섹션 제거) |
