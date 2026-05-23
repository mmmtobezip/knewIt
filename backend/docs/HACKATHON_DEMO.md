# 🎯 해커톤 시연 가이드 (PRD 0516 + 0518)

이 문서는 팀원이 자신의 PC에서 데모 환경을 셋업하고 시연 시나리오를 검증할 때 따라가는 표준 절차입니다. **약 15분** 안에 완료 가능합니다.

---

## 0. 한 줄 요약

- 백엔드: FastAPI + PostgreSQL + Redis + Claude Haiku 4.5
- 프런트엔드: Next.js (App Router) + Tailwind + TanStack Query
- 시연 URL 3개로 박지은(선재) / 박현웅(후판) / 이윤진(기존) 시나리오 전환

---

## 1. 사전 요구사항

| 도구 | 버전 | 비고 |
|---|---|---|
| Python | 3.11+ (3.13 권장) | `uv` 가 자동 관리 |
| **uv** | 최신 (Astral) | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Node.js | 20+ | `npm` 포함 |
| PostgreSQL 16 | (Docker 권장) | 네이티브 가능 |
| Redis 7 | (Docker 권장) | 네이티브 가능 |
| **Anthropic API Key** | OAuth(`sk-ant-oat...`) 또는 API Key(`sk-ant-api...`) | **필수** |
| (선택) Naver / NewsAPI 키 | | 뉴스 수집용. 없어도 시연 가능 |

> macOS 사용자 권장: **OrbStack** (가벼움) 또는 **Docker Desktop**
> Windows 사용자: **Docker Desktop** 또는 **WSL2 + Docker**

---

## 2. 클론 + 브랜치 체크아웃

```bash
git clone git@github.com:mmmtobezip/knewIt.git
cd knewIt
git checkout feat/hackathon-demo-0518   # ← 이번 PR 브랜치
```

---

## 3. PostgreSQL / Redis 가동 (Docker 옵션)

```bash
cd backend
docker compose up -d
docker compose ps   # postgres / redis 가 healthy 인지 확인
```

> **5432 포트 충돌 주의**: 호스트에 brew postgresql 등이 떠 있으면 Docker는 호스트 포트를 **5433**으로 매핑합니다. `.env` 의 `DATABASE_URL` 포트와 일치 확인.

---

## 4. 백엔드 셋업

### 4-1. 의존성 + 환경변수

```bash
cd backend         # 현재 위치 확인
uv sync            # .venv 생성 + 패키지 설치

cp .env.example .env
# .env 편집 → ANTHROPIC_API_KEY 채움 (필수)
# (선택) NAVER_CLIENT_ID/SECRET, NEWSAPI_KEY
```

### 4-2. 외부 데이터 파일 (별도 전달)

`backend/external.xlsx` 파일이 **별도 제공** 됩니다 (Slack / Drive). 받은 파일을 `backend/` 폴더에 그대로 두기.

### 4-3. DB 초기화 + 시드

```bash
# 마이그레이션 (스키마 생성)
uv run alembic upgrade head

# 시드 1: customer_profiles 15 + products 6 + users 5 + assignments 16
uv run python -m scripts.seed_customers

# 시드 2: external.xlsx → indicators 2,072 행
uv run python -m scripts.seed_from_xlsx
```

### 4-4. 서버 가동

```bash
uv run uvicorn app.main:app --host 127.0.0.1 --port 3001 --reload
```

**확인**:
```bash
curl http://127.0.0.1:3001/health
# → {"success":true,"data":{"status":"ok","db":true,"redis":true}, ...}
```

> 빈 환경변수 shadow 가 있으면 `.env` 가 안 읽힙니다. 그 경우 `unset ANTHROPIC_API_KEY` 후 다시 실행.

---

## 5. 프런트엔드 셋업

새 터미널 열기:

```bash
cd ../frontend
npm install

# .env.local 생성
cat > .env.local <<'EOF'
NEXT_PUBLIC_API_BASE_URL=http://localhost:3001
NEXT_PUBLIC_API_MOCKING=disabled
NEXT_PUBLIC_DEFAULT_USER_ROLE=sales
EOF

npm run dev     # → http://localhost:3000
```

---

## 6. 시연 URL (사용자 전환)

브라우저 즐겨찾기에 3개 등록:

| 사용자 | URL | 시나리오 |
|---|---|---|
| **박지은** (선재) | `http://localhost:3000/?user=emp_2026003` | 선재 5개 거래처 |
| **박현웅** (후판) | `http://localhost:3000/?user=emp_2026004` | 후판 5개 거래처 |
| **이윤진** (기존) | `http://localhost:3000/?user=emp_2026001` | HR/후판/부산물 6개 거래처 |

URL 진입 시 자동:
1. localStorage `auth-token` 교체
2. selection-store reset (이전 사용자 cust/product 폐기)
3. React Query 캐시 전체 무효화
4. `?user=` 파라미터 제거된 깨끗한 URL 로 hard reload

---

## 7. 시연 시나리오

### 시나리오 A — 박지은(선재) 메인 대시보드
1. `?user=emp_2026003` 진입
2. 헤더 확인
   - 제품 드롭다운: **선재 1개** (다른 옵션 숨김)
   - 고객사 드롭다운: **5개** (포스코인터 / 고려제강 / Nissan / NBW / 동일제강)
3. 첫 진입 자동 선택: **고려제강** (가나다 첫 번째)
4. 약 18~20초 후 대시보드 표시 (첫 호출만 LLM 4회 직렬)
5. 화면 검증
   - **차트1** Top 지표 carousel (cycle 배지 daily/weekly/monthly)
   - **차트2** 5단계 인과 + 근거 데이터 슬라이더 (출처 R/B/M/C/F)
   - **AI 진단** WHAT(헤드라인 + bullets) / WHY(3 드라이버 번호) / IMPACT(좌측 stripe)
   - **권장 전략** 추천 행동 3개 + 협상 멘트 3개 (복사 버튼)
   - **추천 질문** 좌측 패널 3개 자동 표시

### 시나리오 B — 박현웅(후판) + 포스코인터 분기 ⭐ 핵심
1. `?user=emp_2026004` 진입
2. 거래처: **포스코인터내셔널** 클릭
3. 차트1 = **후판** 데이터 (박지은과 같은 customer 인데 다른 product)
4. 박지은으로 다시 전환 → 포스코인터 클릭 → **선재** 데이터
5. **PRD "담당자:제품 = 1:1" 매핑 시연 핵심**

### 시나리오 C — 추천 질문
1. 좌측 추천 질문 카드 3개 표시 — **24h 캐시 (같은 날 동일)**
2. 새로고침 / 다른 customer 선택해도 같은 질문 (제품 단위 캐시)
3. 카드 클릭 → 우측 채팅에 답변 표시 (~ 5초 LLM)
4. 답변 형식 검증
   - **"박지은 담당자님, "** 또는 **"박현웅 담당자님, "** 으로 시작 (담당자 이름 동적)
   - 단일 단락 (라벨 중복 없음)
   - "[추천 대응 방안]" prefix 표시 (FE 가 prepend)

### 시나리오 D — 새로고침 동작
1. 헤더 새로고침 버튼 클릭
2. 5초 debounce (연속 클릭 차단)
3. 캐시 무효화 scope: 차트1 / 차트2 / 인과 / 해석 / 전략 / 뉴스
4. **추천 질문은 무효화 대상 아님** (1Day 단위 고정)

---

## 8. 시연 중 확인 포인트 체크리스트

- [ ] URL ?user 변경 → 사용자 자동 전환 (페이지 reload)
- [ ] 박지은: 제품 = 선재 고정, 거래처 5개만 표시
- [ ] 박현웅: 제품 = 후판 고정, 거래처 5개만 표시
- [ ] 포스코인터내셔널을 두 사용자가 클릭 → 서로 다른 product 데이터
- [ ] 차트1 좌우 화살표 / 도트 인디케이터로 Top 지표 전환
- [ ] 차트1 기간 탭 1D / 1M / 1Y (데이터 부족 시 자동 비활성)
- [ ] 차트1 단위가 가격 옆 작은 글씨로 (지표명 옆 X)
- [ ] AI 진단 새 구조 — WHAT/WHY/IMPACT 직관적 시각
- [ ] AI 진단 카드 = 권장 전략 카드 동일 높이, 공백 없음
- [ ] 협상 멘트 복사 버튼 동작
- [ ] 새로고침 후 추천 질문 동일 (1Day 단위)
- [ ] 추천 질문 답변 호칭 "박지은 담당자님," / "박현웅 담당자님,"

---

## 9. 트러블슈팅

### Q. `/health` 가 503 또는 `db: false`
- `docker compose ps` 로 postgres / redis healthy 확인
- `.env` 의 `DATABASE_URL` 포트 (5433 vs 5432) 점검
- 호스트 PG 가 5432 점유: `brew services stop postgresql@16`

### Q. 모든 응답이 이윤진 (사용자 전환 안 됨)
- DevTools → **Application → Storage → Clear site data** 한 번
- URL 의 `?user=emp_xxx` 명시
- DevTools Console 에 `[UserBootstrap] switching token →` 로그 확인

### Q. `/api/dashboard` 첫 호출이 18~20초
- 정상. LLM 4회 직렬 호출 (cause_flow + interpretation + strategy + 뉴스)
- 두 번째 호출부터 Redis 캐시 hit → 즉시
- 24h TTL

### Q. `ANTHROPIC_API_KEY 미설정` 또는 401
- shell 환경변수가 빈 값으로 `.env` 를 가리는 경우: `unset ANTHROPIC_API_KEY` 후 uvicorn 재기동
- OAuth (`sk-ant-oat...`) vs API Key (`sk-ant-api...`) 자동 분기 — 둘 다 지원

### Q. 추천 질문 답변이 같은 멘트 반복 / 라벨 중복
- 이미 fix 됨 (Phase A — tool_use + sanitize). 만약 발생 시 BE 재기동
- BE 후처리 `_sanitize_script` 가 첫 단락만 살리고 자체 라벨 제거

### Q. 박지은인데 박지은 데이터 안 나오고 빈 화면
- DevTools Console `[AppHeader] state` 로그 확인
  - `productOptions: ['선재']` 가 안 보이면 사용자 전환 실패
- Network 탭에서 `/api/users/me` 응답의 `user_id` 가 `emp_2026003` 인지 확인
- 응답이 `emp_2026001` 이면 토큰 교체 실패 → Clear site data + URL 재진입

### Q. `product=선재 지표 없음` 404
- `seed_from_xlsx` 가 미실행. 4-3 단계 재확인
- 또는 PRODUCT_CONFIG 의 key_features 가 CSV feature_name 과 매칭 안 됨 → 콘솔 로그 확인

---

## 10. 시연용으로만 적용된 임시 동작 (정식 운영 전 복원 필요)

| 항목 | 시연 동작 | 정식 동작 |
|---|---|---|
| `assert_customer_access` | 통과 (시연 우회) | 본인 매핑 거래처만 |
| `useAuthStore` 초기값 | null (`/users/me` 응답으로 동기화) | SSO/JWT 토큰 디코딩 |
| `apiClient` 인증 | `X-User-Id` 헤더 + `mock-token-{user_id}` | 실 JWT |

→ 운영 배포 전 `git revert` 또는 별도 commit 으로 복원 권장.

---

## 11. 데이터 카탈로그 (시연 시 사용 가능)

### 사용자 (5명)
| user_id | 이름 | role | primary | 담당 거래처 |
|---|---|---|---|---|
| `emp_2026003` | **박지은** | sales | **선재** | 5개 (선재) |
| `emp_2026004` | **박현웅** | sales | **후판** | 5개 (후판) |
| `emp_2026001` | 이윤진 | sales | (없음) | 6개 (HR/후판/부산물) |
| `emp_2026002` | 김매니저 | manager | (없음) | - |
| `emp_2026099` | 관리자 | admin | (없음) | - |

### 거래처 (15개)
- **선재**: 고려제강, Nissan Motor, New Best Wire, 동일제강, JFE Techno Wire, Ningbo Dafeng, 포스코인터내셔널
- **후판**: 현대중공업, 삼성중공업, 한화오션, 포스코건설, Berg Steel Pipe, 포스코인터내셔널
- **HR(고로밀)**: Borcelik, 세아씨엠
- **부산물(철스크랩)**: 썬시멘트주식회사
- ※ 포스코인터내셔널은 `product_group = ["선재", "후판"]` 단일 행 — 박지은/박현웅이 각각 다른 제품으로 본다

### 제품 (6종)
선재 / 후판 / HR(고로밀) / 냉연(CR) / STS 304 / 부산물(철스크랩)

각 제품마다 10개 key_features + key_feature_cycle (D/W/M) + key_feature_importance.

---

## 12. 주요 API 엔드포인트

| Method | Path | 용도 |
|---|---|---|
| GET | `/health` | DB + Redis ping |
| GET | `/api/users` | 사용자 목록 (인증 면제) |
| GET | `/api/users/me` | 현재 사용자 + primary_product_code |
| GET | `/api/catalog/products` | 전체 제품 목록 |
| GET | `/api/catalog/customers?product=...` | 제품별 거래처 (본인 매핑) |
| GET | `/api/dashboard?customer=...&product=...` | 통합 메인 대시보드 (LLM 4회) |
| GET | `/api/top-movers?customer=...` | 차트1 단독 |
| GET | `/api/today-questions?product=...` | 추천 질문 3개 (24h KST 자정 boundary) |
| POST | `/api/today-questions/answer` | 추천 질문 답변 |
| POST | `/api/cache/invalidate` | 새로고침 (5초 debounce) |

상세 schema: `http://127.0.0.1:3001/docs` (Swagger UI)

---

## 13. 빠른 검증 (5분 안에 끝)

```bash
# 0) 두 서버 가동 후
curl http://127.0.0.1:3001/health
# 1) 사용자 목록
curl http://127.0.0.1:3001/api/users
# 2) 박지은의 거래처 (선재 5개)
curl -H "X-User-Id: emp_2026003" "http://127.0.0.1:3001/api/catalog/customers?product=선재"
# 3) 박현웅의 거래처 (후판 5개)
curl -H "X-User-Id: emp_2026004" "http://127.0.0.1:3001/api/catalog/customers?product=후판"
# 4) 통합 dashboard (실 LLM, 15~20초)
curl -H "X-User-Id: emp_2026003" "http://127.0.0.1:3001/api/dashboard?customer=고려제강"
```

---

## 14. 문의

이슈 발견 또는 환경 셋업 막힘 → 채널 (Slack `#hackathon-knewit`)
