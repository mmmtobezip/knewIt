# Backend — POS-Pricing Navigator (PRD 0514)

POSCO 영업 협상 지원 AI 대시보드 백엔드.
**FastAPI + PostgreSQL + Redis + Claude Haiku 4.5**.

---

## 1. 사전 요구사항

| 요구 | 버전 |
|---|---|
| **Python** | 3.11+ (코드에서 사용. 3.13 권장) |
| **uv** | 최신 (Astral) |
| **PostgreSQL 16** | Docker 또는 네이티브 |
| **Redis 7** | Docker 또는 네이티브 |
| **Anthropic API Key** | OAuth(`sk-ant-oat...`) 또는 API Key(`sk-ant-api...`) |
| (선택) Naver / NewsAPI 키 | 뉴스 수집용 |

## 2. PostgreSQL / Redis 가동 — 4가지 옵션 중 택1

### 옵션 A. Docker 호환 런타임 (가장 빠름)
백엔드 폴더에 포함된 `docker-compose.yml` 사용.

| 플랫폼 | 권장 런타임 |
|---|---|
| macOS | **OrbStack** (https://orbstack.dev/) — 가볍고 빠름 |
| macOS | **Docker Desktop** (https://www.docker.com/products/docker-desktop) |
| macOS | **Colima** — `brew install colima && colima start` |
| Windows | **Docker Desktop** |
| Linux | 네이티브 Docker Engine — `apt install docker.io` 또는 https://docs.docker.com/engine/install/ |

설치 후:
```bash
cd backend
docker compose up -d
docker compose ps   # postgres / redis 가 healthy 인지 확인
```

> **macOS 포트 5432 충돌 주의**: 호스트에 brew postgresql 등이 떠 있으면 **Docker는 호스트 포트 5433** 으로 매핑함 (`.env.example` 참조).

### 옵션 B. 네이티브 설치 (Docker 없이) — macOS
```bash
brew install postgresql@16 redis
brew services start postgresql@16
brew services start redis

# DB / role 생성
createdb pos_pricing_navigator
psql -d pos_pricing_navigator -c "CREATE ROLE pos LOGIN PASSWORD 'pos' SUPERUSER;"

# .env 의 DATABASE_URL 을 5432 로 변경 (Docker 안 쓰는 경우)
# postgresql+asyncpg://pos:pos@localhost:5432/pos_pricing_navigator
```

### 옵션 C. 네이티브 설치 — Linux
```bash
sudo apt install postgresql-16 redis-server
sudo systemctl start postgresql redis-server

sudo -u postgres psql -c "CREATE USER pos WITH PASSWORD 'pos' SUPERUSER;"
sudo -u postgres createdb -O pos pos_pricing_navigator
```

### 옵션 D. 클라우드 / 원격 DB
`.env` 에 클라우드 DB URL 직접 지정. 코드 변경 불필요.

---

## 3. 환경변수 (`.env`)

`backend/.env.example` 복사 후 채워 넣기:
```bash
cd backend
cp .env.example .env
# 그 후 ANTHROPIC_API_KEY, NAVER_CLIENT_ID/SECRET, NEWSAPI_KEY 설정
```

| 변수 | 설명 | 기본 |
|---|---|---|
| `DATABASE_URL` | `postgresql+asyncpg://pos:pos@localhost:5433/...` | Docker 매핑 5433 |
| `REDIS_URL` | `redis://localhost:6379/0` | - |
| `ANTHROPIC_API_KEY` | OAuth (Claude Max) 또는 API Key | **필수** |
| `LLM_MODEL` | `claude-haiku-4-5-20251001` | - |
| `NAVER_CLIENT_ID/SECRET` | 한글 뉴스 | (선택) |
| `NEWSAPI_KEY` | 영문 뉴스 | (선택) |

> 자세한 항목은 `.env.example` 참조.

---

## 4. 첫 실행 (5분)

```bash
# 1. 저장소 클론
git clone git@github.com:mmmtobezip/knewIt.git
cd knewIt/backend

# 2. 의존성 설치
uv sync                       # .venv/ 생성 + 패키지 설치

# 3. 환경변수
cp .env.example .env
# (.env 편집해서 ANTHROPIC_API_KEY 입력)

# 4. PG/Redis 가동 (옵션 A 기준)
docker compose up -d

# 5. DB 마이그레이션
uv run alembic upgrade head

# 6. 시드 데이터 (10 거래처 + 5 제품 + 3 유저)
uv run python -m scripts.seed_customers

# 7. 외부 지표 시계열 적재 (external.xlsx → indicators 2,072행)
#    external.xlsx 가 backend/external.xlsx 에 존재해야 함 (별도 제공)
uv run python -m scripts.seed_from_xlsx

# 8. 서버 실행
uv run uvicorn app.main:app --host 127.0.0.1 --port 3001 --reload
```

> 매번 `uv run` 접두어를 붙입니다 (활성화된 venv 자동 사용).

---

## 5. 동작 확인

```bash
# 헬스 체크
curl http://127.0.0.1:3001/health
# → {"success":true,"data":{"status":"ok","db":true,"redis":true}, ...}

# Swagger UI
open http://127.0.0.1:3001/docs

# 통합 대시보드 (실 LLM 호출, 15~20초)
curl -G -H "X-User-Id: emp_2026001" \
  --data-urlencode "customer=Borcelik Celik Sanayii VE Ticaret AS" \
  http://127.0.0.1:3001/api/dashboard | python3 -m json.tool

# 추천 질문
curl -G -H "X-User-Id: emp_2026001" \
  --data-urlencode "product=HR(고로밀)" \
  http://127.0.0.1:3001/api/today-questions | python3 -m json.tool
```

| 사용자 ID | 권한 | 담당 거래처 |
|---|---|---|
| `emp_2026001` | sales | 10개 전체 (현 시드) |
| `emp_2026002` | manager | (BACKLOG #10) |
| `emp_2026099` | admin | 전체 |

---

## 6. 프론트엔드 연동

`frontend/.env.local` 생성:
```bash
NEXT_PUBLIC_API_BASE_URL=http://localhost:3001
NEXT_PUBLIC_API_MOCKING=disabled
NEXT_PUBLIC_DEFAULT_USER_ROLE=sales
```

그 후:
```bash
cd frontend
npm install
npm run dev      # http://localhost:3000
```

---

## 7. API 요약

| Method | Path | 용도 |
|---|---|---|
| GET | `/api/customers/{id}/profile` | 거래처 프로필 |
| GET | `/api/dashboard?customer=...` | **통합** (차트1 + 차트2 + 해석 + 전략) |
| GET | `/api/top-movers?customer=...` | 차트1 단독 (디버그) |
| GET | `/api/today-questions?product=...` | 추천 질문 3개 |
| POST | `/api/today-questions/answer` | 추천 질문 클릭 답변 (JSON) |
| POST | `/api/cache/invalidate` | 새로고침 (5초 debounce) |
| GET | `/health` | DB + Redis ping |

상세: `http://127.0.0.1:3001/docs` (Swagger UI)

---

## 8. 트러블슈팅

### Q. `psql ... role "pos" does not exist`
- 호스트 PostgreSQL 과 Docker 컨테이너 둘 다 5432 점유 → Docker 호스트 매핑이 5433 으로 자동 변경됨
- `.env` 의 `DATABASE_URL` 포트 확인 (5432 vs 5433)
- 또는 호스트 PG 정지: `brew services stop postgresql@16`

### Q. `ANTHROPIC_API_KEY 미설정`
- shell 환경변수가 빈 값으로 export 되어 `.env` 를 가리는 경우:
  ```bash
  unset ANTHROPIC_API_KEY
  ```
- `~/.zshrc` 등 init 스크립트에 빈 export 가 있는지 확인

### Q. Anthropic 401 `invalid x-api-key`
- `sk-ant-oat...` (OAuth) vs `sk-ant-api...` (API Key) 자동 분기됨
- Claude Max 구독자는 OAuth 토큰 그대로 사용 가능
- 단, OAuth 토큰은 만료될 수 있음 → Claude Code 재로그인 후 새 토큰

### Q. Docker compose 컨테이너가 `read-only file system` 에러
- VM 디스크 손상. OrbStack/Docker Desktop 재시작 + Reclaim disk space

### Q. `/api/dashboard` 가 `product=선재 지표 없음` 404
- BACKLOG #9 (`docs/BACKLOG.md` 참조) — "선재" PRODUCT_CONFIG 미정의
- 현재 6개 거래처 (고려제강, Nissan, New Best Wire, JFE Techno Wire, 동일제강, Ningbo Dafeng) 영향
- 임시: 다른 4개 거래처 (Borcelik, Berg Steel, 썬시멘트, 세아씨엠) 로 검증

---

## 9. 잔여 작업

`backend/docs/BACKLOG.md` 참조.
