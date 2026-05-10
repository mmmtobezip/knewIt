# STEEL INSIGHT — 백엔드 개발자를 위한 프론트엔드 연동 가이드

> 이 문서는 프론트엔드 코드를 기반으로 작성된 백엔드 개발 연동 명세서입니다.
> API 설계, DB 스키마 설계, 기능 구현 전 참고용으로 작성되었습니다.

---

## 📌 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [공통 타입 정의](#2-공통-타입-정의)
3. [API 엔드포인트 목록](#3-api-엔드포인트-목록)
4. [탭별 UI 요소 및 API 연동 명세](#4-탭별-ui-요소-및-api-연동-명세)
   - [대시보드](#41-대시보드--get-apidashboard)
   - [AI 변동분석](#42-ai-변동분석--get-apitriggers)
   - [판매가격 가이드](#43-판매가격-가이드--get-apipricingguidecustomerid)
   - [메일 초안](#44-메일-초안--get-apimailblocks--get-apimaildefault-draft)
   - [개인화 설정](#45-개인화-설정--get-apipersonalizationconfigs)
5. [공통 UI 동작 명세](#5-공통-ui-동작-명세)
6. [Mock 데이터 위치](#6-mock-데이터-위치)

---

## 1. 프로젝트 개요

**STEEL INSIGHT**는 포스코DX 철강 영업 담당자를 위한 AI 기반 영업 지원 대시보드입니다.

| 항목 | 내용 |
|------|------|
| 화면 수 | 5개 탭 (대시보드 / AI 변동분석 / 판매가격 가이드 / 메일 초안 / 개인화 설정) |
| 사용자 | 포스코DX 철강 영업 담당자 1인 |
| 핵심 기능 | 시장 지표 모니터링 → 트리거 탐지 → 협상 전략 추천 → 메일 초안 생성 |

---

## 2. 공통 타입 정의

백엔드 API 응답 전반에 사용되는 공통 타입입니다.

```
AlertLevel  = "HIGH" | "MEDIUM" | "LOW"
  - HIGH   : 즉시 대응 필요 (빨간색)
  - MEDIUM : 주의 필요 (노란색)
  - LOW    : 안정 (초록색)

ChangeDirection = "UP" | "DOWN" | "FLAT"
  - 지표 변동 방향

ProductType = "선재" | "HR(고로밀)" | "후판" | "STS후판" | "냉연AP300"
  - 포스코DX 취급 철강 제품 종류

StrategyTone = "CONSERVATIVE" | "BALANCED" | "AGGRESSIVE"
  - 협상 전략 기조
```

---

## 3. API 엔드포인트 목록

| 메서드 | 엔드포인트 | 설명 | 사용 탭 |
|--------|-----------|------|---------|
| GET | `/api/user/me` | 현재 로그인 사용자 정보 | 전체 (GNB) |
| GET | `/api/dashboard` | 대시보드 전체 데이터 | 대시보드 |
| GET | `/api/triggers` | 트리거 목록 전체 | AI 변동분석, GNB 배지 |
| GET | `/api/pricing/guide/{customerId}` | 고객사별 가격 가이드 | 판매가격 가이드 |
| GET | `/api/mail/blocks` | 메일 블록 목록 | 메일 초안 |
| GET | `/api/mail/default-draft` | 기본 메일 초안 | 메일 초안 |
| GET | `/api/personalization/configs` | 제품별 지표 가중치 설정 | 개인화 설정 |
| GET | `/api/personalization/alert-preview` | 가중치 기반 추천 질문 미리보기 | 개인화 설정 |

---

## 4. 탭별 UI 요소 및 API 연동 명세

---

### 4.1 대시보드 — `GET /api/dashboard`

**화면 구성:** 핵심 메시지 배너 + 시장 지표 테이블 + 관련 뉴스 + 추천 질문 + 고객사 리스크

#### 응답 구조

```json
{
  "coreMessage": { ... },
  "indicators": [ ... ],
  "news": [ ... ],
  "questions": [ ... ],
  "customerRisks": [ ... ]
}
```

---

#### ① 핵심 메시지 배너 (CoreMessage)

화면 최상단에 가장 중요한 리스크/상황을 1줄로 강조 표시하는 배너입니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `id` | string | 메시지 고유 ID | - |
| `headline` | string | 굵은 제목 텍스트 | 배너 상단 강조 텍스트 |
| `subText` | string | 부연 설명 | 배너 하단 작은 텍스트 |
| `level` | AlertLevel | 배너 색상 결정 | HIGH=빨강, MEDIUM=노랑, LOW=초록 |
| `ctaLabel` | string | 버튼 텍스트 | 배너 우측 버튼 |
| `ctaRoute` | string | 버튼 클릭 시 이동 경로 | 예: "/triggers" |
| `triggerId` | string? | 연결된 트리거 ID (선택) | ctaRoute에 쿼리파라미터로 추가됨 |

> **동작:** CTA 버튼 클릭 시 `{ctaRoute}?triggerId={triggerId}` 로 이동

---

#### ② 시장 지표 테이블 (Indicators)

주요 원자재/환율 지표를 테이블 형태로 표시합니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `id` | string | 지표 고유 ID | - |
| `name` | string | 지표명 | 테이블 '지표' 컬럼 |
| `currentValue` | string | 현재 값 (단위 포함 문자열) | 테이블 '현재값' 컬럼 |
| `unit` | string | 단위 (예: "/t", "/bbl") | 현재값 우측 작은 텍스트 |
| `changePercent` | number | 변동률 (절댓값) | 테이블 '변동' 컬럼 |
| `changeDirection` | ChangeDirection | 변동 방향 | UP=▲빨강, DOWN=▼파랑, FLAT=—회색 |
| `alertLevel` | AlertLevel | 알림 수준 | 테이블 '알림' 컬럼 배지 색상 |
| `triggerId` | string? | 연결 트리거 ID (선택) | 행 클릭 시 해당 트리거로 이동 |

> **동작:** `triggerId`가 있는 행 클릭 시 `/triggers?triggerId={triggerId}` 이동

---

#### ③ 관련 뉴스 (News)

시장 지표와 연관된 최신 뉴스 목록입니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `id` | string | 뉴스 고유 ID | - |
| `title` | string | 뉴스 제목 | 카드 메인 텍스트 |
| `source` | string | 출처 (예: Reuters, Bloomberg) | 카드 하단 출처 텍스트 |
| `publishedAt` | string | 게시 시각 (예: "2시간 전") | 카드 하단 시간 텍스트 |
| `sentiment` | "POSITIVE" \| "NEGATIVE" \| "NEUTRAL" | 뉴스 감성 | POSITIVE=초록, NEGATIVE=빨강, NEUTRAL=회색 태그 |
| `tags` | string[] | 관련 제품/지표 태그 | 카드 하단 태그 목록 |
| `triggerId` | string? | 연결 트리거 ID (선택) | 카드 클릭 시 해당 트리거로 이동 |

> **동작:** `triggerId`가 있는 뉴스 카드 클릭 시 `/triggers?triggerId={triggerId}` 이동

---

#### ④ 추천 질문 (Questions)

영업 담당자가 고객과 미팅 전 확인해야 할 AI 추천 질문 목록입니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `id` | string | 질문 고유 ID | - |
| `text` | string | 질문 내용 | 아코디언 제목 |
| `weightedScore` | number | 관련도 점수 (0.0 ~ 1.0) | 진행 바 + "관련도 XX%" 텍스트 |
| `answerSummary` | string | AI 답변 요약 | 아코디언 펼치면 표시 |
| `customerId` | string | 관련 고객사 ID | - |
| `product` | ProductType | 관련 제품 | 아코디언 내 제품 태그 |

> **동작:** 질문 클릭 시 아코디언 펼침/접힘 (한 번에 1개만 펼쳐짐)

---

#### ⑤ 고객사 리스크 (CustomerRisks)

현재 리스크가 높은 고객사 목록입니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `customerId` | string | 고객사 ID | 클릭 시 사이드 드로어 오픈 key |
| `customerName` | string | 고객사명 | 리스트 이름 텍스트 |
| `riskLevel` | AlertLevel | 리스크 등급 | 이름 옆 배지 색상 |
| `riskScore` | number | 리스크 점수 (0~100) | 우측 숫자 |
| `affectedProducts` | ProductType[] | 영향 제품 목록 | 하단 제품 태그 |
| `riskReason` | string | 리스크 원인 설명 | 이름 하단 작은 텍스트 |

> **동작:** 고객사 행 클릭 시 우측에 고객사 상세 사이드 드로어 오픈

---

### 4.2 AI 변동분석 — `GET /api/triggers`

**화면 구성:** 트리거 목록 (좌) + 트리거 상세 (우)

#### 응답 구조

```json
{
  "triggers": [ ... ],
  "alertCount": 1
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| `triggers` | Trigger[] | 트리거 목록 |
| `alertCount` | number | HIGH 등급 트리거 수 (GNB 빨간 배지에 표시) |

---

#### ① 트리거 목록 (TriggerList)

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `id` | string | 트리거 고유 ID | URL 쿼리파라미터로 사용 |
| `indicatorName` | string | 지표명 | 목록 아이템 제목 |
| `changePercent` | number | 변동률 | 목록 변동 수치 |
| `changeDirection` | ChangeDirection | 변동 방향 | UP=▲, DOWN=▼ |
| `alertLevel` | AlertLevel | 알림 등급 | 목록 우측 배지 |
| `source` | string | 데이터 출처 | 목록 하단 출처 텍스트 |

> **GNB 빨간 배지:** `alertLevel === "HIGH"`인 트리거 개수를 GNB 'AI 변동분석' 탭에 빨간 배지로 표시
> **URL 연동:** 다른 탭에서 `/triggers?triggerId=xxx` 로 진입 시 해당 트리거 자동 선택

---

#### ② 트리거 상세 (TriggerDetailPanel)

목록에서 트리거 선택 시 우측에 표시되는 상세 정보입니다.

**원인 분석 흐름 (causeFlow)**

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `id` | string | 단계 ID | - |
| `label` | string | 단계 제목 | 플로우 차트 메인 텍스트 |
| `sublabel` | string | 단계 부제목 | 플로우 차트 작은 텍스트 |
| `type` | "TRIGGER" \| "INTERMEDIATE" \| "KEY" \| "OUTCOME" | 단계 유형 | 단계별 색상 구분 |

> `TRIGGER → KEY → INTERMEDIATE → OUTCOME` 순서로 화살표 연결 표시

**영향 고객사 (affectedCustomers)**

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `customerId` | string | 고객사 ID | - |
| `customerName` | string | 고객사명 | 목록 이름 |
| `product` | ProductType | 영향 제품 | 이름 하단 제품 태그 |
| `monthlyVolumeTon` | number | 월간 거래량(톤) | "XX,XXXt/월" 표시 |
| `riskLevel` | AlertLevel | 리스크 등급 | 우측 배지 |
| `riskScore` | number | 리스크 점수 | 우측 점수 숫자 |

**협상 전략 추천 (strategies)**

3가지 기조(방어적/균형/적극적)의 협상 전략 카드를 나란히 표시합니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `tone` | StrategyTone | 전략 기조 | 카드 상단 태그 |
| `title` | string | 전략명 | 카드 제목 |
| `description` | string | 전략 설명 | 카드 본문 |
| `expectedRisk` | "낮음" \| "중간" \| "높음" | 예상 리스크 | 카드 하단 메타 |
| `expectedMarginRate` | string | 예상 마진율 (예: "+1.2%") | 카드 하단 메타 |

---

### 4.3 판매가격 가이드 — `GET /api/pricing/guide/{customerId}`

**화면 구성:** 가격 가이드 카드 + 지표 비교 테이블 (좌) / 유사 상황 분석 (우)

#### 응답 구조

```json
{
  "priceGuide": { ... },
  "similarSituation": { ... },
  "indicatorComparisons": [ ... ]
}
```

---

#### ① 가격 가이드 카드 (PriceGuideCard)

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `customerId` | string | 고객사 ID | - |
| `customerName` | string | 고객사명 | 카드 상단 제목 |
| `product` | string | 제품명 | 카드 상단 제품 태그 |
| `ruleBasePrice` | number | Rule-base 기준가 (원/톤) | "XXX,XXX원" |
| `aiAdjustedPrice` | number | AI 추천 가격 (원/톤) | "XXX,XXX원" (강조 표시) |
| `negotiationMinPrice` | number | 협상 최소 가격 (원/톤) | 범위 바 좌측 |
| `negotiationMaxPrice` | number | 협상 최대 가격 (원/톤) | 범위 바 우측 |
| `negotiationDifficulty` | "EASY" \| "MEDIUM" \| "HARD" | 협상 난이도 | 카드 하단 배지 |
| `currency` | "KRW" | 통화 단위 | - |
| `unit` | "톤" | 가격 단위 | 가격 옆 단위 텍스트 |

---

#### ② 지표 비교 테이블 (IndicatorComparisonTable)

현재 시장 지표 vs 유사 과거 상황 지표를 비교합니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `indicatorName` | string | 지표명 | 테이블 첫 번째 컬럼 |
| `currentValue` | string | 현재 값 (문자열) | 테이블 '현재' 컬럼 |
| `pastValue` | string | 과거 값 (문자열) | 테이블 '과거' 컬럼 |
| `changePercent` | number | 변동률 | 테이블 '변동' 컬럼 |
| `changeDirection` | ChangeDirection | 변동 방향 | UP=▲빨강, DOWN=▼파랑 |

---

#### ③ 유사 상황 분석 (SimilarSituationCard)

AI가 찾은 과거 유사 협상 케이스를 표시합니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `similarityPercent` | number | 현재 상황과의 유사도 (%) | "XX% 유사" 텍스트 |
| `period` | string | 과거 시점 (예: "2023년 8월") | 카드 상단 날짜 |
| `description` | string | 유사 상황 설명 | 카드 본문 텍스트 |
| `agreedPrice` | number | 당시 합의 가격 (원/톤) | 결과 그리드 |
| `strategyUsed` | string | 사용한 협상 전략명 | 결과 그리드 |
| `marginRetentionRate` | number | 마진 유지율 (%) | 결과 그리드 "+X.X%" |
| `radarData` | RadarDataPoint[] | 레이더 차트 데이터 | 오각형 레이더 차트 |

**RadarDataPoint 구조:**

| 필드 | 타입 | 설명 |
|------|------|------|
| `subject` | string | 축 이름 (예: "시장 변동") |
| `current` | number | 현재 값 (0~100) |
| `past` | number | 과거 값 (0~100) |
| `fullMark` | number | 최대값 (100 고정) |

---

### 4.4 메일 초안 — `GET /api/mail/blocks` + `GET /api/mail/default-draft`

**화면 구성:** 블록 선택 패널 (좌) / 메일 편집기 (우)

---

#### ① 메일 블록 목록 — `GET /api/mail/blocks`

선택 가능한 메일 구성 블록 전체 목록입니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `type` | MailBlockType | 블록 유형 키 | 블록 토글 식별자 |
| `label` | string | 블록 이름 | 블록 카드 제목 |
| `description` | string | 블록 설명 | 블록 카드 부제목 |
| `defaultContent` | string | 기본 내용 (AI 생성 텍스트) | 블록 토글 시 편집기에 삽입 |

**MailBlockType 목록:**

| 값 | 한국어명 | 설명 |
|----|---------|------|
| `GREETING` | 인사말 | 수신자 맞춤 인사 |
| `MARKET_SUMMARY` | 시장 현황 | 최근 시장 지표 요약 |
| `NEGOTIATION_POSITION` | 협상 입장 | 당사 협상 기조 |
| `PRICE_PROPOSAL` | 가격 제안 | AI 추천 가격 기반 제안 |
| `QUALITY_STRENGTH` | 품질 강점 | 당사 제품 강점 |
| `MEETING_REQUEST` | 미팅 요청 | 대면 협의 제안 |
| `CLOSING` | 마무리 | 정중한 마무리 인사 |

> **동작:** 좌측 패널에서 블록 클릭 시 "포함/미포함" 토글. 포함된 블록만 우측 편집기에 표시

---

#### ② 기본 메일 초안 — `GET /api/mail/default-draft`

초기 로드 시 편집기에 표시할 기본 초안입니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `recipient` | string | 수신자 이메일 | 편집기 '받는사람' 입력칸 |
| `cc` | string | 참조 이메일 (빈 값 가능) | 편집기 '참조' 입력칸 |
| `subject` | string | 메일 제목 | 편집기 '제목' 입력칸 |
| `blocks` | MailContent[] | 기본 선택된 블록 목록 | 편집기 본문 블록들 |

**MailContent 구조:**

| 필드 | 타입 | 설명 |
|------|------|------|
| `blockType` | MailBlockType | 블록 유형 |
| `text` | string | 편집 가능한 블록 내용 |

> **기본 선택 블록:** GREETING, MARKET_SUMMARY, PRICE_PROPOSAL, CLOSING (4개)

---

### 4.5 개인화 설정 — `GET /api/personalization/configs`

**화면 구성:** 제품별 가중치 슬라이더 (좌) / 추천 질문 미리보기 (우)

---

#### ① 제품별 지표 가중치 설정 — `GET /api/personalization/configs`

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `product` | ProductType | 제품명 | 탭 버튼 제목 |
| `indicators` | IndicatorConfig[] | 해당 제품의 지표 목록 | 슬라이더 목록 |

**IndicatorConfig 구조:**

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `id` | string | 지표 고유 ID | 슬라이더 식별자 |
| `label` | string | 지표명 | 슬라이더 레이블 |
| `defaultWeight` | number | 기본 가중치 (0.0~1.0) | 슬라이더 초기값, "XX%" 표시 |

> **동작:** 슬라이더 조정 시 우측 미리보기 패널의 질문 점수가 실시간 반영  
> **초기화 버튼:** "기본값으로 초기화" 클릭 시 `defaultWeight` 값으로 복원

---

#### ② 추천 질문 미리보기 — `GET /api/personalization/alert-preview`

현재 가중치 설정 기준으로 계산된 추천 질문 순위 미리보기입니다.

| 필드 | 타입 | 설명 | 표시 위치 |
|------|------|------|----------|
| `questionId` | string | 질문 ID | - |
| `questionText` | string | 질문 내용 | 미리보기 목록 텍스트 |
| `score` | number | 점수 (0.0~1.0) | 진행 바 + "XX점" 표시 |
| `rank` | number | 순위 | "#1", "#2" 순위 표시 |

---

## 5. 공통 UI 동작 명세

### 🔴 GNB 빨간 배지 (AI 변동분석 탭)

```
표시 조건: GET /api/triggers 응답의 triggers 중 alertLevel === "HIGH" 인 항목 수
표시 위치: GNB 상단 'AI 변동분석' 탭 우측 상단
표시 형태: 빨간 원형 배지에 숫자
미표시 조건: HIGH 트리거가 0개일 때
```

### 👤 고객사 사이드 드로어

```
오픈 조건: 고객사 리스크 목록 클릭 또는 대시보드 탭 바 클릭
표시 데이터: GET /api/user/me 응답의 customers 배열에서 선택된 customerId로 필터링
닫힘 조건: 드로어 우측 X 버튼 클릭
표시 내용: 고객사명, 국가, 리스크 등급/점수, 담당자명/이메일, 거래 제품, 월간/연간 거래량, 메모
```

### 🔗 탭 간 이동 (URL 쿼리파라미터 연동)

```
대시보드 CoreMessage 버튼 클릭  → /triggers?triggerId={triggerId}
대시보드 시장 지표 행 클릭      → /triggers?triggerId={triggerId}
대시보드 뉴스 카드 클릭         → /triggers?triggerId={triggerId}

AI 변동분석 진입 시 triggerId 파라미터가 있으면 해당 트리거 자동 선택
```

---

## 6. Mock 데이터 위치

실제 API 응답 형태의 샘플 데이터는 아래 경로에 있습니다.

| 파일 | 대응 API |
|------|---------|
| `src/mocks/fixtures/user.fixture.ts` | `GET /api/user/me` |
| `src/mocks/fixtures/dashboard.fixture.ts` | `GET /api/dashboard` |
| `src/mocks/fixtures/trigger.fixture.ts` | `GET /api/triggers` |
| `src/mocks/fixtures/pricing.fixture.ts` | `GET /api/pricing/guide/{customerId}` |
| `src/mocks/fixtures/mail.fixture.ts` | `GET /api/mail/blocks`, `GET /api/mail/default-draft` |
| `src/mocks/fixtures/personalization.fixture.ts` | `GET /api/personalization/configs`, `GET /api/personalization/alert-preview` |
| `src/types/*.types.ts` | 전체 API 타입 스키마 |

> 프론트엔드 실 API 연동 방법: `VITE_USE_MOCK=false` 환경변수 설정 후 `src/services/*.service.ts` 내 주석 처리된 실 API 코드 활성화
