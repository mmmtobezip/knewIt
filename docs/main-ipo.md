# IPO 명세서 - 메인 대시보드

| 항목 | 내용 |
|------|------|
| **화면 ID** | `SCR-MAIN-001` |
| **화면명** | 메인 대시보드 (Market Dashboard) |
| **화면 설명** | 영업담당자가 로그인 후 진입하는 통합 대시보드. 담당 고객사의 key_features 지표를 분석하여 변동 원인, 영향, 권장 전략을 제공. |
| **문서 버전** | v1.1 |
| **작성일** | 2026-05-13 |

---

## 0. 확정 사항 요약

### 0-1. Process 결정 (Q1~Q18)

| Q | 항목 | 결정 |
|---|------|------|
| Q1 | trigger_event 없는 날 처리 | 빈 상태 화면 ("오늘은 주요 변동이 없습니다") |
| Q2 | 고객사·제품 변경 시 채팅 처리 | 무조건 새 세션 시작 (이전 대화 삭제), 제품 변경 동일 적용 |
| Q3 | 추천 질문 답변 생성 시점 | 질문만 일일 배치 사전 생성 / **답변은 클릭 시 LLM 호출** |
| Q4 | 일일 배치 시각 / 타임존 | 매일 **06:00 Asia/Seoul** / 글로벌 마감시간 미고려 (MIH 일배치 데이터) |
| Q5 | 고객사 자동 선택 우선순위 | 가나다순 첫 번째 (`ORDER BY customer_id ASC`) |
| Q6 | 새로고침으로 추천 질문 갱신 여부 | **추천 질문은 일일 배치만**, 새로고침으로 갱신 X |
| Q7 | 채팅 응답 방식 | **SSE 스트리밍** (ChatGPT 방식) |
| Q8 | severity 레벨 임계값 | **severity 개념 미사용** (관련 로직 모두 제거) |
| Q9 | 추천 질문 개수 | 항상 **3개 고정** |
| Q10 | 캐시 TTL | 분석/뉴스/전략 모두 **24h** |
| Q11 | 채팅 관련 제한 | 입력 **500자** / LLM 타임아웃 **30초** / 채팅 이력 **영속 저장 X** |
| Q12 | 새로고침 debounce | **5초** |
| Q13 | 뉴스 클릭 로깅 | **로깅 없음** |
| Q14 | 외부 링크 이동 방식 | 새 탭 (`target="_blank"`) |
| Q15 | 권한 체계 | 모든 role(sales/manager/admin) 동일 화면 / **매니저는 팀원의 모든 고객사 조회 가능** |
| Q16 | 동시성 / 다중 사용자 | 한 고객사 N담당자 가능 (primary/support) / 한 사람 N탭 동시 정상 동작 |
| Q17 | 데이터 출처 / 저장 위치 | CSV는 MIH 자동 수집 (외부 API 직접 호출 X) / 권장 저장소 구성 채택 |
| Q18 | MCP-News 구현 범위 | **자체 MCP 서버 구현 포함** (개발 범위) |

### 0-2. Output 결정 (Output-Q1~Q22)

| Q | 항목 | 결정 |
|---|------|------|
| Q1 | Output 카테고리 | UI 출력 + API 응답 + 사용자 알림/메시지 |
| Q2 | UI 컴포넌트 매핑 수준 | 매핑 + 표시 포맷 |
| Q3 | 영역 ID 부여 | `AREA-MAIN-XX` 체계로 부여 |
| Q4 | 빈/로딩/에러 상태 | 빈 상태만 정의 (로딩/에러는 공통 정책) |
| Q5 | 표시 포맷 표준 | 숫자/통화/날짜/변동률/빈값 모두 정의 |
| Q6 | API 응답 정의 위치 | IPO 필드 목록 요약 + 별도 Swagger |
| Q7 | API 표준 | 공통 응답 wrapper (`{success, data, error, meta}`) |
| Q8 | 에러 응답 표준 | 표준 에러 코드 체계 (`E_AUTH_001` 등) |
| Q9 | 페이지네이션 / 정렬 | **뉴스: 도트 인디케이터 슬라이더 (인플레이스, 새 화면 X)** |
| Q10 | 메시지 종류 | 성공 토스트 / 에러 토스트 / 정보 안내 / 인라인 에러 (다이얼로그 제외) |
| Q11 | 메시지 다국어 | i18n 구조 + MVP는 한국어만 |
| Q12 | 메시지 텍스트 정의 수준 | 모든 메시지 일일이 정의 |
| Q13 | 로그 종류 | **로그 IPO 미포함** (DevOps에서 별도 설계) |
| Q16 | 외부 출력 채널 | 메인 대시보드 외부 출력 없음 |
| Q17 | 다운로드 항목 | 다운로드 기능 없음 |
| Q18 | 분석 메트릭 | 미포함 (Phase 2) |
| Q19 | Output 표현 형식 | 표 + 와이어프레임 영역 매핑 |
| Q20 | 산출물 저장 형태 | 마크다운 + 별도 Swagger YAML |
| Q21 | MVP 범위 | 표준 (UI + API + 알림/에러) |
| Q22 | 정의 순서 | UI → API → 알림 |

### 0-3. 추가 표시 포맷 결정

- **숫자 소수점**: **2자리**까지 표시 (예: `1,234.56`)
- **변동률 색상**: **상승=빨강 / 하락=파랑** (한국 금융권 관습)

---

## 1. INPUT 정의

### 1-1. 사용자 입력 (User Input)

| No | 입력 항목 | 영문 키 | 데이터 타입 | 필수 | 입력 방식 | 입력 예시 | 비고 |
|----|----------|--------|----------|------|----------|----------|------|
| 1 | 고객사 선택 | `customer_id` | String | Y | 드롭다운 | `"고려제강"` | CUSTOMER_PROFILE 의 key |
| 2 | 제품 선택 | `product_code` | String | Y | 드롭다운 | `"HR"` | 선재/HR/후판/부산물. 고객사 1:N 제품 가능 |
| 3 | 추천 질문 선택 | `question_idx` | Number | N | 카드 클릭 | `0`, `1`, `2` | 0~2 인덱스 (항상 3개) |
| 4 | 추가 질문 입력 | `chat_query` | String(500) | N | 텍스트 입력 | `"단가 인하 요구 대응법은?"` | 채팅창. 별도 LLM 호출 |
| 5 | 차트 기간 변경 | `period` | Enum | N | 탭 클릭 | `"1M"` | **MVP 단계: `"1M"` 고정 (UI 비활성화 또는 미노출)** |
| 6 | 뉴스 출처 클릭 | `news_url` | URL | N | 링크 클릭 | `"https://..."` | 새 탭 외부 이동 (로깅 없음) |
| 7 | 새로고침 클릭 | `refresh_event` | Event | N | 버튼 클릭 | - | 캐시 무효화 후 재조회 트리거 (debounce 5초) |
| 8 | 화면 이동 | `nav_target` | Enum | N | 카드 클릭 | `"guide"`, `"mail"` | 판매가이드/메일초안 |

### 1-2. 시스템 입력 (Session / Context Input)

| No | 입력 항목 | 영문 키 | 데이터 타입 | 필수 | 출처 | 입력 예시 | 비고 |
|----|----------|--------|----------|------|------|----------|------|
| 1 | 로그인 사용자 ID | `user_id` | String | Y | 세션 | `"emp_2026001"` | JWT/SSO |
| 2 | 사용자 권한 | `user_role` | String | Y | 세션 | `"sales"` | sales/manager/admin (모두 동일 화면) |
| 3 | 담당 고객사 리스트 | `assigned_customers` | Array | Y | DB | `["고려제강","동일제강"]` | 권한 기반 필터링. 매니저는 본인 + 직속 팀원 매핑 합산 |
| 4 | 기준 일자 | `base_date` | Date | Y | 시스템 | `"2026-05-13"` | 분석 기준일 |
| 5 | 직전 선택 상태 | `last_selection` | Object | N | localStorage | `{customer, product}` | 화면 재진입 시 복원 |

### 1-3. 데이터 입력 (Backend Data Source)

#### 1-3-1. 고객사 프로필 (CUSTOMER_PROFILE)

| 필드 | 타입 | 예시 | 비고 |
|------|------|------|------|
| `customer_id` | String | `"고려제강"` | PK |
| `product` | String | `"선재"` | 취급 제품 |
| `industry` | String | `"와이어/건설"` | 산업군 |
| `region` | String | `"한국"` | 지역 |
| `sensitivity` | Array<String> | `["건설 경기","원가","국내 수요"]` | 협상 민감 요소 |
| `key_features` | Array<String> | `["상하이 열연 선물가","중국 부동산 개발 투자율",...]` | 모니터링 지표 |
| `negotiation_style` | String | `"가격 방어형"` | 협상 스타일 |

#### 1-3-2. 지표 시계열 (CSV / DB)

| 필드 | 타입 | 예시 | 비고 |
|------|------|------|------|
| `feature_name` | String | `"상하이 열연 선물가"` | key_features 와 매칭 |
| `date` | Date | `"2026-05-08"` | 일자 |
| `value` | Number | `580.0` | 지표 값 |
| `unit` | String | `"USD/톤"` | 단위 |
| `change_rate` | Number | `-4.2` | 전일/전주 대비 % |

#### 1-3-3. Trigger Event (조건 충족 시 생성)

조건: `abs(change_rate) >= 3%`

| 필드 | 타입 | 예시 | 비고 |
|------|------|------|------|
| `event_id` | String | `"EVT-20260508-001"` | PK |
| `feature` | String | `"상하이 열연 선물가"` | 변동 지표명 |
| `change_rate` | Number | `-4.2` | 변동률 |
| `direction` | Enum | `"DOWN"` | UP / DOWN |
| `date` | Date | `"2026-05-08"` | 발생일 |

> ※ severity 필드는 사용하지 않음 (Q8 결정).

#### 1-3-4. 수집 뉴스 (retrieved_docs from MCP-News)

| 필드 | 타입 | 예시 | 비고 |
|------|------|------|------|
| `source` | String | `"Reuters"` | 뉴스 출처 |
| `title` | String | `"중국 부동산 투자 둔화..."` | 제목 |
| `summary` | String | `"..."` | 요약 |
| `url` | URL | `"https://reuters.com/..."` | 원문 링크 |
| `published_at` | DateTime | `"2026-05-07T10:00:00Z"` | 발행일시 |

#### 1-3-5. LLM 분석 결과 (analysis_result)

| 필드 | 타입 | 예시 | 비고 |
|------|------|------|------|
| `what` | String | `"열연 가격 4.2% 하락"` | 무슨 일이 |
| `why` | Array<String> | `["중국 PMI 하락","수요 둔화",...]` | 원인 |
| `impact` | Array<String> | `["마진 압박 확대",...]` | 영향 |

#### 1-3-6. 원인 흐름 (causal_chain)

| 필드 | 타입 | 예시 | 비고 |
|------|------|------|------|
| `chain` | Array<String> | `["중국 부동산 투자 부진","건설 수요 감소","시장 심리 약화","열연 수요 감소","열연 가격 하락"]` | 최대 5단계 |
| `interpretation` | String | `"..."` | 핵심 해석 |

#### 1-3-7. 전략 제안 (strategy)

| 필드 | 타입 | 예시 | 비고 |
|------|------|------|------|
| `summary` | String | `"단기 가격 방어보다..."` | 전략 요약 |
| `actions` | Array<String> | `["선제 커뮤니케이션",...]` | 추천 행동 |
| `negotiation_point` | String | `"공급 안정성과 파트너십 가치 강조"` | 협상 포인트 |
| `quote` | String | `"가격보다 공급 안정성이..."` | 협상 멘트 예시 |

#### 1-3-8. 추천 질문 (today_questions)

| 필드 | 타입 | 예시 | 비고 |
|------|------|------|------|
| `question_id` | String | `"Q-001"` | PK |
| `question` | String | `"열연 가격 하락세는..."` | 질문 텍스트 |
| `priority` | Number | `1` | 추천 순위 |

> ※ 답변은 사전 생성하지 않음 (Q3 결정). 클릭 시 LLM 호출.

#### 1-3-9. 사용자-고객사 매핑 (assigned_customers)

| 필드 | 타입 | 예시 | 비고 |
|------|------|------|------|
| `user_id` | String | `"emp_2026001"` | FK → users |
| `customer_id` | String | `"고려제강"` | FK → customer_profile |
| `role` | Enum | `"primary"` | primary/support |
| `assigned_at` | Date | `"2026-01-01"` | 배정일 |

#### 1-3-10. 채팅 컨텍스트 (chat_context)

| 필드 | 타입 | 예시 | 비고 |
|------|------|------|------|
| `session_id` | String | `"chat_xxx"` | 세션 식별자. (user_id, customer_id, tab_id) 조합 |
| `messages` | Array<{role, content}> | `[{role:"user",content:"..."}]` | 대화 이력 (Redis TTL 30분, 영속 X) |
| `customer_id` | String | `"고려제강"` | 컨텍스트 |
| `analysis_context` | Object | `{trigger_event, analysis_result}` | 현재 분석 컨텍스트 주입 |

---

## 2. PROCESS 정의

### 2-0. 저장소 구성

| 데이터 | 저장소 | 비고 |
|--------|--------|------|
| 지표 CSV | 로컬 FS (`/data/indicators/YYYY-MM-DD.csv`) | MIH 자동 수집 |
| `customer_profile`, `trigger_events`, `users`, `assigned_customers`, `org_hierarchy` | PostgreSQL | 영속 |
| `analysis_result`, `causal_chain`, `strategy`, `retrieved_docs`, `today_questions` | Redis (TTL 24h) | 캐시 |
| `chat_session` | Redis (TTL 30분) | 휘발성, (user_id, customer_id, tab_id) 키 |

### 2-1. Process 목록

| Process ID | 명칭 | 트리거 | 우선순위 |
|-----------|------|-------|---------|
| `P-01` | 화면 초기 진입 | 페이지 로드 | High |
| `P-02` | 고객사 변경 | 고객사 드롭다운 변경 | High |
| `P-03` | 제품 변경 | 제품 드롭다운 변경 | High |
| `P-04` | 새로고침 | 새로고침 버튼 클릭 | Medium |
| `P-05` | 추천 질문 선택 | 질문 카드 클릭 | Medium |
| `P-06` | 채팅 질의 | 채팅 입력 + 전송 | Medium |
| `P-07` | 뉴스 출처 이동 | 뉴스 카드 클릭 | Low |
| `P-08` | 화면 이동 | 진입 카드 클릭 | Low |
| `P-09` | 일일 배치 (백그라운드) | 매일 06:00 Asia/Seoul cron | High |

### 2-2. `P-01` 화면 초기 진입

**트리거**: 사용자가 메인 대시보드 URL 접근 또는 로그인 후 리다이렉트

**처리 단계**:
```
1. 인증 검증
   ├─ JWT/세션 유효성 확인
   ├─ 만료 → /login 리다이렉트
   └─ 유효 → user_id, user_role 추출

2. 권한 기반 고객사 목록 조회
   IF user_role = 'manager':
      assigned_customers = 본인 + org_hierarchy.subordinates 의 매핑 UNION
   ELSE:
      assigned_customers = WHERE user_id = ?
   ├─ 가나다순 정렬 (ORDER BY customer_id ASC)
   ├─ 비어있으면 → "담당 고객사 없음" 안내
   └─ 결과 → 고객사 드롭다운

3. 직전 선택 상태 복원 (localStorage)
   ├─ last_selection 존재 + 권한 내 → 사용
   └─ 없으면 → assigned_customers[0] (가나다순 첫 번째)

4. 선택 고객사의 product 옵션 조회
   └─ customer_profile.product → 제품 드롭다운

5. 병렬 데이터 조회 (Promise.all)
   ├─ [API-01] GET /api/customers/{id}/profile
   ├─ [API-02] GET /api/trigger-events?customer={id}&product={p}&date={today}
   └─ [API-03] GET /api/today-questions?customer={id} (Redis 캐시)

6-A. trigger_event 존재 → 분석 데이터 조회 (Redis 캐시 우선)
   ├─ [API-04] GET /api/indicators?feature={f}&period=1M
   ├─ [API-05] GET /api/analysis?event_id={e}
   ├─ [API-06] GET /api/causal-chain?event_id={e}
   ├─ [API-07] GET /api/news?event_id={e}
   └─ [API-08] GET /api/strategy?event_id={e}&customer_id={c}

6-B. trigger_event 없음 → 빈 상태 화면
   ├─ "오늘은 주요 변동이 없습니다" 안내 표시
   ├─ 추천 질문은 그대로 표시 (변동과 무관하게 생성됨)
   └─ 차트/원인흐름/진단/전략 영역은 placeholder

7. 화면 렌더링
   └─ 첫 번째 추천 질문 active 표시 (답변은 아직 X)
```

**에러 처리**:

| 케이스 | 처리 |
|-------|------|
| 인증 실패 | 로그인 페이지 리다이렉트 |
| 권한 고객사 0건 | 빈 상태 안내 화면 |
| API 일부 실패 | 해당 영역만 스켈레톤/에러 메시지, 나머지는 정상 표시 |
| LLM 응답 실패 | 직전 캐시 사용 + "데이터 갱신 중" 배너 표시 |

### 2-3. `P-02` 고객사 변경

**트리거**: 사용자가 고객사 드롭다운에서 다른 고객사 선택

**처리 단계**:
```
1. 입력 검증
   └─ customer_id ∈ assigned_customers (보안)

2. localStorage 저장
   └─ last_selection.customer = new_customer_id

3. 채팅 세션 무조건 새로 시작
   ├─ 기존 chat_session 키 Redis 즉시 삭제
   └─ 새 session_id 발급: (user_id, new_customer_id, tab_id)

4. 제품 옵션 갱신
   └─ 자동으로 첫 번째 product 선택

5. P-01의 5~7단계 재실행
```

**에러 처리**: 권한 외 customer_id 요청 시 → 403 Forbidden

### 2-4. `P-03` 제품 변경

**트리거**: 제품 드롭다운 변경

**처리 단계**:
```
1. localStorage 저장
   └─ last_selection.product = new_product

2. 채팅 세션 무조건 새로 시작 (Q2 정책 동일)
   └─ Redis chat_session 삭제 + 새 세션 발급

3. 데이터 재조회 (제품 기준)
   ├─ trigger_events 재조회
   ├─ analysis / causal_chain / news / strategy 재조회
   └─ 추천 질문은 변경 없음

4. 화면 영역 부분 재렌더링
```

### 2-5. `P-04` 새로고침

**트리거**: 헤더 새로고침 버튼 클릭

**처리 단계**:
```
1. debounce 5초 잠금 (중복 클릭 방지)

2. 오버레이 표시 ("최신 데이터를 불러오는 중...")

3. 캐시 무효화
   └─ POST /api/cache/invalidate
       scope: ["analysis","causal_chain","news","strategy"]
       (today_questions, indicators 는 제외)

4. 데이터 재조회 (Cache-Control: no-cache)
   └─ LLM 재호출하여 analysis_result / causal_chain / strategy 재생성

5. 토스트 알림
   └─ "데이터가 갱신되었습니다 (HH:MM 기준)"
```

> ※ 추천 질문(`today_questions`)은 새로고침 대상에서 제외 (Q6 결정)

### 2-6. `P-05` 추천 질문 선택

**트리거**: 추천 질문 카드(1/2/3) 클릭

**처리 단계**:
```
1. UI 즉시 반응
   ├─ 카드 active 스타일
   ├─ 채팅 영역에 사용자 질문 버블 즉시 표시
   └─ AI 답변 영역에 "포석호가 답변 작성 중..." 로딩

2. LLM 호출 (사전 생성 X, 매번 호출)
   POST /api/chat/question
   body: {
     session_id,
     question_id,
     customer_id,
     product_code,
     context: { trigger_event, analysis_result, customer_profile }
   }
   응답: SSE 스트리밍

3. 스트리밍 표시
   └─ chunk 단위로 답변 영역 갱신

4. 완료 시
   └─ chat_session 의 messages 배열에 추가 (Redis, TTL 30분)
```

### 2-7. `P-06` 채팅 질의

**트리거**: 사용자가 채팅 입력창에 질문 입력 후 Enter / 전송 클릭

**처리 단계**:
```
1. 입력 검증
   ├─ 빈 문자열 차단
   └─ 500자 초과 차단

2. UI 즉시 반응
   ├─ 사용자 버블 표시
   ├─ 입력창 초기화 + 비활성화
   └─ "포석호가 답변 작성 중..." 로딩

3. SSE 스트리밍 호출
   POST /api/chat
   body: {
     session_id,
     customer_id,
     product_code,
     query: chat_query,
     context: { trigger_event, analysis_result, customer_profile }
   }
   Accept: text/event-stream

4. chunk 단위 표시
   └─ 30초 타임아웃 시 중단 + "응답 시간 초과" 표시

5. 완료 시
   ├─ chat_session messages 갱신 (Redis, TTL 30분)
   └─ 입력창 재활성화
```

**에러 처리**:

| 케이스 | 처리 |
|-------|------|
| LLM Rate limit | "잠시 후 다시 시도해주세요" 안내 |
| LLM 응답 실패 | 폴백 메시지 + 재시도 버튼 |
| 타임아웃 (>30초) | 중단 + 에러 표시 |

### 2-8. `P-07` 뉴스 출처 이동

**트리거**: 근거 데이터 영역의 뉴스 카드 클릭

**처리 단계**:
```
1. window.open(news_url, '_blank', 'noopener,noreferrer')
   (로깅 없음)
```

### 2-9. `P-08` 화면 이동

**트리거**: 진입 카드(판매가이드/메일초안) 클릭

**처리 단계**:
```
1. localStorage 상태 보존 확인 (customer, product 유지)
2. 이동
   ├─ guide.html
   └─ mail.html
```

### 2-10. `P-09` 일일 배치

**스케줄**: `cron: 0 6 * * * Asia/Seoul` (매일 06:00)

**처리 단계**:
```
1. MIH CSV 적재
   ├─ /data/indicators/YYYY-MM-DD.csv 읽기
   └─ DB indicators 테이블 upsert

2. 활성 고객사 순회
   FOR EACH customer:

3. Trigger Event 탐지
   ├─ customer.key_features 별 change_rate 계산
   ├─ |change_rate| ≥ 3% → trigger_events 테이블 INSERT
   └─ severity 미부여

4. trigger_event 발생 시 LLM 분석 사전 생성 (Redis 저장)
   ├─ MCP-News 호출 → retrieved_docs 수집 (자체 구현)
   ├─ LLM 호출 → analysis_result 생성
   ├─ LLM 호출 → causal_chain 생성 (최대 5단계)
   ├─ LLM 호출 → strategy 생성 (sensitivity 반영)
   └─ Redis 저장 (TTL 24h)

5. 추천 질문 동적 생성 (질문만, 답변 X)
   ├─ 고객사별 trigger_event + customer_profile 기반 LLM 호출
   ├─ 질문 3개 생성 (답변은 미생성)
   └─ today_questions 저장 (Redis, TTL 24h)

[알림 발송 단계 제거 — severity 미사용으로 분기 없음]
```

### 2-11. 캐싱 정책

| 데이터 | 저장소 | TTL | 무효화 트리거 |
|--------|-------|-----|------------|
| `customer_profile` | PostgreSQL | - | 관리자 수정 |
| `indicators` (지표) | PostgreSQL | - | 매일 06:00 배치 |
| `trigger_events` | PostgreSQL | - | 매일 06:00 배치 |
| `analysis_result` | Redis | 24h | P-04 새로고침, 06:00 배치 |
| `causal_chain` | Redis | 24h | P-04 새로고침, 06:00 배치 |
| `retrieved_docs` (news) | Redis | 24h | P-04 새로고침, 06:00 배치 |
| `strategy` | Redis | 24h | P-04 새로고침, 06:00 배치 |
| `today_questions` | Redis | 24h | **06:00 배치만** (새로고침 ❌) |
| `chat_session` | Redis | 30분 | 고객사/제품 변경 즉시 삭제 |

### 2-12. 에러 처리 / 폴백 전략

| 시나리오 | 폴백 |
|---------|------|
| LLM API 장애 | 직전 캐시 사용 + "분석 갱신 중" 배너 |
| MCP-News 장애 | 뉴스 영역 빈 상태 + "출처 데이터 일시 미수집" |
| MIH CSV 미수신 | 06:00 배치 스킵 + 직전일 데이터 유지 + 알림 |
| 권한 외 접근 | 403 + 메인으로 강제 이동 |
| 네트워크 오류 | 재시도 버튼 |
| 채팅 30초 타임아웃 | 중단 + "응답 시간 초과" 표시 |

---

## 3. OUTPUT 정의

### 3-1. 와이어프레임 영역 ID

```
┌─────────────────────────────────────────────────────────────┐
│ AREA-MAIN-01  헤더 (로고, 셀렉터, 새로고침, 프로필)           │
├─────────────────────────────────────────────────────────────┤
│ AREA-MAIN-02  진입 카드 (판매가이드 / 메일초안)              │
├─────────────────────────────────────────────────────────────┤
│ ┌─────────────────────┬─────────────────────────────────┐   │
│ │ AREA-MAIN-03        │ AREA-MAIN-04                    │   │
│ │ 추천 질문 패널       │ 채팅 패널 (포석호)              │   │
│ │ (질문 카드 3개)      │                                 │   │
│ └─────────────────────┴─────────────────────────────────┘   │
├─────────────────────────────────────────────────────────────┤
│ ┌─────────────────────┬─────────────────────────────────┐   │
│ │ AREA-MAIN-05        │ AREA-MAIN-06                    │   │
│ │ 가격 차트 카드       │ 변동 원인 플로우 카드            │   │
│ └─────────────────────┴─────────────────────────────────┘   │
├─────────────────────────────────────────────────────────────┤
│ AREA-MAIN-07  근거 데이터 (뉴스 슬라이더)                    │
├─────────────────────────────────────────────────────────────┤
│ ┌─────────────────────┬─────────────────────────────────┐   │
│ │ AREA-MAIN-08        │ AREA-MAIN-09                    │   │
│ │ AI 진단 (WHAT/WHY/  │ 권장 대응 전략                   │   │
│ │ IMPACT)             │ (요약/행동/협상)                 │   │
│ └─────────────────────┴─────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 3-2. 표시 포맷 표준

#### 3-2-1. 숫자 포맷

| 종류 | 포맷 | 예시 |
|------|------|------|
| 정수 | 천 단위 콤마 | `1,234` |
| 소수 | **소수점 2자리** + 콤마 | `1,234.56` |
| 가격 | 정수, 콤마 | `580` |

#### 3-2-2. 통화/단위 포맷

| 종류 | 포맷 | 예시 |
|------|------|------|
| USD | `$` 접두 | `$580` |
| 단위 표기 | 가격 라벨 옆 괄호 | `열연강판 가격 (USD/톤)` |

#### 3-2-3. 날짜/시간 포맷

| 용도 | 포맷 | 예시 |
|------|------|------|
| 화면 표시 | `YYYY.MM.DD` | `2026.05.08` |
| 시각 | `HH:MM` (24H) | `09:30` |
| API 통신 | ISO 8601 | `2026-05-08T09:30:00+09:00` |

#### 3-2-4. 변동률 포맷

| 방향 | 표시 | 색상 |
|------|------|------|
| **상승** | `▲ +X.XX%` | 🔴 **빨강** (`--red` `#F04452`) |
| **하락** | `▼ -X.XX%` | 🔵 **파랑** (`--blue` `#3182F6` = Toss Blue) |
| 보합 (≤0.1%) | `─ 0.00%` | `--gray-500` (`#8B95A1`) |
| 부가 표기 | `(WoW)` 등 비교 기준 명시 | - |

> 한국 금융권 관습 적용 (서양 표준과 반대). 다국어 확장 시 Phase 2에서 토글 옵션 검토.

CSS 변수:
```css
:root {
  --red: #F04452;     /* 상승 (가격 ↑) */
  --blue: #3182F6;    /* 하락 (가격 ↓) — Toss Blue 재사용 */
}
```

#### 3-2-5. 빈값 표시

| 케이스 | 표시 |
|--------|------|
| 데이터 없음 | `-` (하이픈) |
| 미계산 | `-` |
| 권한 없음 | `***` (마스킹) |

### 3-3. 영역별 UI 출력 정의

#### `AREA-MAIN-01` 헤더

| 컴포넌트 ID | 데이터 소스 | 표시 포맷 | 빈 상태 |
|-----------|-----------|---------|--------|
| `HDR-01` 로고 | 정적 | "POS-Pricing Navigator" | - |
| `HDR-02` 부제목 | 정적 | "AI 시장 분석 & 협상 전략" | - |
| `HDR-03` 제품 셀렉터 | `customer_profile.product` (배열) | 드롭다운, 선택값 표시 | "제품 없음" 비활성화 |
| `HDR-04` 고객사 셀렉터 | `assigned_customers` | 드롭다운, 가나다순 정렬 | "담당 고객사 없음" 비활성화 |
| `HDR-05` 새로고침 버튼 | - | 아이콘 + "새로고침" | - |
| `HDR-06` 알림 아이콘 | (Phase 2) | 🔔 | - |
| `HDR-07` 프로필 아이콘 | `user.name` | 👤 (호버 시 툴팁) | - |

#### `AREA-MAIN-02` 진입 카드

| 컴포넌트 ID | 데이터 | 표시 | 동작 |
|-----------|------|------|------|
| `NAV-01` 판매가이드 카드 | 정적 | 📊 "판매 가이드" / 부설명 | `→ guide.html` |
| `NAV-02` 메일초안 카드 | 정적 | ✉️ "메일 초안 작성" / 부설명 | `→ mail.html` |

#### `AREA-MAIN-03` 추천 질문 패널

| 컴포넌트 ID | 데이터 소스 | 표시 포맷 | 빈 상태 |
|-----------|-----------|---------|--------|
| `QST-01` 패널 타이틀 | 정적 | 💡 "오늘의 추천 질문" | - |
| `QST-02` 질문 카드 1 | `today_questions[0].question` | 번호(1) + 질문 텍스트 | "질문 생성 중..." (placeholder) |
| `QST-03` 질문 카드 2 | `today_questions[1].question` | 번호(2) + 질문 텍스트 | 위와 동일 |
| `QST-04` 질문 카드 3 | `today_questions[2].question` | 번호(3) + 질문 텍스트 | 위와 동일 |

**규칙**: 항상 3개 고정. active 카드는 Toss Blue 배경.

#### `AREA-MAIN-04` 채팅 패널 (포석호)

| 컴포넌트 ID | 데이터 소스 | 표시 포맷 | 빈 상태 |
|-----------|-----------|---------|--------|
| `CHT-01` 사용자 버블 | `chat_session.messages[role=user]` | Toss Blue 배경, 우측 정렬 | 첫 진입 시 미표시 |
| `CHT-02` 시각 | `messages[].timestamp` | `HH:MM` | - |
| `CHT-03` 포석호 아바타 | 정적 SVG | 곰 캐릭터 + "포석호" 라벨 | - |
| `CHT-04` AI 응답 버블 | `messages[role=assistant]` | 흰 배경, 좌측 정렬, **SSE 스트리밍** 표시 | "포석호가 답변 작성 중..." |
| `CHT-05` 채팅 입력창 | 사용자 입력 | placeholder: "추가 질문을 입력하세요..." | 비어있는 입력창 |
| `CHT-06` 전송 버튼 | - | ➤ 아이콘 (Toss Blue 원형) | 입력 시 활성화 |

**규칙**:
- 입력 길이 500자 제한 (초과 시 인라인 에러: `MSG-INL-01`)
- LLM 응답 30초 타임아웃 (초과 시 토스트: `MSG-ERR-04`)

#### `AREA-MAIN-05` 가격 차트 카드

| 컴포넌트 ID | 데이터 소스 | 표시 포맷 | 빈 상태 |
|-----------|-----------|---------|--------|
| `CHT-T-01` 카드 타이틀 | 정적 | 📊 "변동이 크게 발생한 지표 분석 결과" | - |
| `CHT-T-02` 가격 라벨 | `customer_profile.product` + 정적 | "{제품명} 가격 (USD/톤)" | "지표 미선택" |
| `CHT-T-03` 가격 값 | `indicators.latest.value` | 정수 + 천 단위 콤마 (큰 글씨, 800 weight) | `-` |
| `CHT-T-04` 변동률 | `trigger_event.change_rate` | `▼ -4.20% (WoW)` (파랑) / 상승 시 빨강 | 미표시 |
| `CHT-T-05` 기간 탭 | 정적 (MVP는 1M 고정) | 1D/1W/1M/3M/6M/1Y (1M만 active) | - |
| `CHT-T-06` 차트 영역 | `indicators.timeseries[1M]` | Line chart, Toss Blue, 호버 툴팁 | "데이터 없음" |

#### `AREA-MAIN-06` 변동 원인 플로우 카드

| 컴포넌트 ID | 데이터 소스 | 표시 포맷 | 빈 상태 |
|-----------|-----------|---------|--------|
| `FLW-01` 카드 타이틀 | 정적 | "변동 발생 원인 플로우 (순차 원인 분석)" | - |
| `FLW-02` 플로우 스텝 1~5 | `causal_chain.chain[0..4]` | 4열 그리드, 아이콘 + 텍스트 + 화살표 | "분석 데이터 준비 중" |
| `FLW-03` 핵심 해석 | `causal_chain.interpretation` | Toss Blue Bg 박스, 라벨 "핵심 해석" | 미표시 |

**규칙**: causal_chain.chain 길이 가변 (최대 5). 4 초과 시 슬라이드/2행 처리.

#### `AREA-MAIN-07` 근거 데이터 (뉴스 슬라이더)

| 컴포넌트 ID | 데이터 소스 | 표시 포맷 | 빈 상태 |
|-----------|-----------|---------|--------|
| `NWS-01` 패널 타이틀 | 정적 | 📰 "근거 데이터 (뉴스 출처)" | - |
| `NWS-02` 뉴스 슬라이더 | `retrieved_docs[]` | **가로 슬라이드 + 도트 인디케이터** | "출처 데이터 일시 미수집" |
| `NWS-03` 뉴스 아이템 | `retrieved_docs[i]` | 출처 로고 + `source` + `published_at` (`YYYY.MM.DD`) | - |
| `NWS-04` 도트 인디케이터 | `retrieved_docs.length / page_size` | ● ○ ○ ○ (active=Toss Blue, 나머지=Gray-300) | - |
| `NWS-05` 좌우 화살표 (선택) | - | < > 버튼 (호버 시 표시) | - |

**규칙**:
- **인플레이스 슬라이드** (새 화면 이동 X)
- 한 페이지에 5개 표시
- 도트 클릭 또는 좌우 스와이프로 페이지 전환
- 마지막 페이지에서 슬라이드 끝
- 뉴스 아이템 클릭 시 `target="_blank"` 외부 이동 (P-07)

#### `AREA-MAIN-08` AI 진단

| 컴포넌트 ID | 데이터 소스 | 표시 포맷 | 빈 상태 |
|-----------|-----------|---------|--------|
| `DIA-01` 카드 타이틀 | 정적 | 🔺 "AI 진단 (무슨 일이 일어나고 있는가?)" | - |
| `DIA-02` WHAT 카드 | `analysis_result.what` | 빨강 배경, 라벨 "WHAT" + 본문 | "분석 데이터 없음" |
| `DIA-03` WHY 카드 | `analysis_result.why[]` | 노랑 배경, 라벨 "WHY" + 불릿 리스트 | "분석 데이터 없음" |
| `DIA-04` IMPACT 카드 | `analysis_result.impact[]` | 초록 배경, 라벨 "IMPACT" + 불릿 리스트 | "분석 데이터 없음" |

#### `AREA-MAIN-09` 권장 대응 전략

| 컴포넌트 ID | 데이터 소스 | 표시 포맷 | 빈 상태 |
|-----------|-----------|---------|--------|
| `STR-01` 카드 타이틀 | 정적 | 💬 "권장 대응 전략 (무엇을 할 것인가?)" | - |
| `STR-02` 전략 요약 | `strategy.summary` | 회색 배경 카드, 라벨 "🛡️ 전략 요약" | "전략 생성 중" |
| `STR-03` 추천 행동 | `strategy.actions[]` | 회색 배경 카드, 라벨 "✅ 추천 행동" + 번호 리스트 | "행동 제안 없음" |
| `STR-04` 협상 포인트 | `strategy.negotiation_point` | 회색 배경 카드, 라벨 "💬 협상 포인트" + 본문 | - |
| `STR-05` 협상 멘트 인용 | `strategy.quote` | Toss Blue Bg 인용 박스 (`❝ ❞`) | 미표시 |

### 3-4. 빈 상태 출력 (Empty State)

| 케이스 | 트리거 | 표시 영역 | 메시지 | 액션 |
|--------|-------|----------|-------|------|
| 담당 고객사 없음 | `assigned_customers` = [] | 전체 | "담당 고객사가 배정되지 않았습니다. 관리자에게 문의해주세요." | - |
| trigger_event 없음 | API-02 결과 = null | AREA-MAIN-05/06/08/09 placeholder | "오늘은 주요 변동이 없습니다." | - |
| LLM 분석 미생성 | `analysis_result` = null | AREA-MAIN-08 | "분석 데이터를 불러오지 못했습니다." | "다시 시도" 버튼 |
| 뉴스 미수집 | `retrieved_docs` = [] | AREA-MAIN-07 | "출처 데이터 일시 미수집" | - |
| 추천 질문 미생성 | `today_questions` = [] | AREA-MAIN-03 | "추천 질문 생성 중..." (skeleton) | - |
| 채팅 첫 진입 | `chat_session.messages` = [] | AREA-MAIN-04 | (대화 영역 비움, 입력창만 표시) | - |

### 3-5. 사용자 알림 / 메시지 표준

#### 3-5-1. 메시지 ID 체계

- `MSG-TST-XX`: 토스트 (Toast)
- `MSG-INF-XX`: 정보 안내 (Inline Info)
- `MSG-ERR-XX`: 에러 토스트
- `MSG-INL-XX`: 입력 인라인 에러

#### 3-5-2. 메시지 정의

**성공 토스트**

| ID | 트리거 | 텍스트 | 노출 시간 |
|----|-------|-------|---------|
| `MSG-TST-01` | 새로고침 완료 (P-04) | "데이터가 갱신되었습니다 ({HH:MM} 기준)" | 2.2s |

**에러 토스트**

| ID | 트리거 | 텍스트 | 노출 시간 |
|----|-------|-------|---------|
| `MSG-ERR-01` | API 일반 실패 | "요청 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요." | 3s |
| `MSG-ERR-02` | 새로고침 debounce | "이미 갱신 중입니다. 잠시 후 다시 시도해주세요." | 2s |
| `MSG-ERR-03` | LLM 호출 실패 | "분석 데이터를 불러오지 못했습니다." | 3s |
| `MSG-ERR-04` | 채팅 30초 타임아웃 | "응답 시간이 초과되었습니다. 다시 시도해주세요." | 3s |
| `MSG-ERR-05` | 권한 없음 | "해당 고객사를 조회할 권한이 없습니다." | 3s |
| `MSG-ERR-06` | 네트워크 오류 | "네트워크 연결을 확인해주세요." | 3s |
| `MSG-ERR-07` | 인증 만료 | "세션이 만료되었습니다. 다시 로그인해주세요." | 3s (후 리다이렉트) |

**정보 안내 (인라인 / 영역 내)**

| ID | 트리거 | 표시 영역 | 텍스트 |
|----|-------|---------|-------|
| `MSG-INF-01` | trigger_event 없음 | AREA-MAIN-05~09 | "오늘은 주요 변동이 없습니다." |
| `MSG-INF-02` | LLM 캐시 폴백 | 상단 배너 | "최신 분석 갱신 중입니다. 직전 데이터를 표시합니다." |
| `MSG-INF-03` | 뉴스 미수집 | AREA-MAIN-07 | "출처 데이터 일시 미수집" |
| `MSG-INF-04` | 담당 고객사 0건 | 전체 화면 | "담당 고객사가 배정되지 않았습니다." |

**입력 인라인 에러**

| ID | 트리거 | 표시 위치 | 텍스트 |
|----|-------|---------|-------|
| `MSG-INL-01` | 채팅 입력 500자 초과 | 입력창 아래 | "최대 500자까지 입력 가능합니다." |
| `MSG-INL-02` | 채팅 빈 문자열 전송 | 입력창 아래 | "메시지를 입력해주세요." |

#### 3-5-3. i18n 구조 (Phase 2 대비)

모든 메시지는 다음 키 기반으로 관리:
```json
{
  "ko": {
    "MSG-TST-01": "데이터가 갱신되었습니다 ({time} 기준)",
    "MSG-ERR-01": "요청 처리 중 오류가 발생했습니다..."
  }
}
```
MVP는 `ko`만, Phase 2에서 `en` 등 추가.

### 3-6. API 응답 표준

#### 3-6-1. 공통 응답 Wrapper

**성공 응답**
```json
{
  "success": true,
  "data": { ... },
  "error": null,
  "meta": {
    "request_id": "req_xxx",
    "timestamp": "2026-05-13T06:00:00+09:00",
    "cache_hit": true
  }
}
```

**실패 응답**
```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "E_LLM_001",
    "message": "LLM 호출에 실패했습니다.",
    "detail": "Anthropic API rate limit exceeded"
  },
  "meta": {
    "request_id": "req_xxx",
    "timestamp": "2026-05-13T06:00:00+09:00"
  }
}
```

#### 3-6-2. API 엔드포인트 요약

> 상세 스키마는 별도 Swagger YAML 파일로 관리

| API ID | Method | Endpoint | 응답 데이터 키 |
|--------|--------|----------|------------|
| API-01 | GET | `/api/customers/{id}/profile` | `customer_profile` |
| API-02 | GET | `/api/trigger-events?customer={c}&product={p}&date={d}` | `trigger_event` |
| API-03 | GET | `/api/today-questions?customer={c}` | `today_questions[3]` |
| API-04 | GET | `/api/indicators?feature={f}&period=1M` | `indicators.timeseries[]` |
| API-05 | GET | `/api/analysis?event_id={e}` | `analysis_result {what, why[], impact[]}` |
| API-06 | GET | `/api/causal-chain?event_id={e}` | `causal_chain {chain[], interpretation}` |
| API-07 | GET | `/api/news?event_id={e}` | `retrieved_docs[]` |
| API-08 | GET | `/api/strategy?event_id={e}&customer_id={c}` | `strategy {summary, actions[], negotiation_point, quote}` |
| API-09 | POST | `/api/chat` (SSE) | streaming text chunks |
| API-10 | POST | `/api/chat/question` (SSE) | streaming text chunks (추천 질문 답변) |
| API-11 | POST | `/api/cache/invalidate` | `{ invalidated_keys[] }` |

#### 3-6-3. HTTP Status Code 매핑

| Code | 의미 | 사용 케이스 |
|------|------|-----------|
| 200 | OK | 정상 응답 |
| 204 | No Content | trigger_event 없음 등 |
| 400 | Bad Request | 입력 검증 실패 |
| 401 | Unauthorized | 인증 만료 |
| 403 | Forbidden | 권한 외 고객사 접근 |
| 404 | Not Found | 존재하지 않는 리소스 |
| 408 | Request Timeout | LLM 30초 초과 |
| 429 | Too Many Requests | 새로고침 debounce |
| 500 | Internal Server Error | 서버 오류 |
| 502 | Bad Gateway | LLM/MCP 외부 호출 실패 |
| 503 | Service Unavailable | 일시 점검 |

### 3-7. 표준 에러 코드 체계

#### 3-7-1. 코드 명명 규칙

`E_{도메인}_{3자리 일련번호}`

| 도메인 | 코드 prefix | 설명 |
|-------|-----------|------|
| AUTH | `E_AUTH_` | 인증 |
| PERM | `E_PERM_` | 권한 |
| VALD | `E_VALD_` | 입력 검증 |
| DATA | `E_DATA_` | 데이터 조회 |
| LLM | `E_LLM_` | LLM 호출 |
| NEWS | `E_NEWS_` | MCP-News 호출 |
| CACH | `E_CACH_` | 캐시 |
| SYS | `E_SYS_` | 시스템 |

#### 3-7-2. 에러 코드 정의

| 코드 | HTTP | 메시지 (사용자) | 매핑 메시지 ID |
|------|------|-------------|------------|
| `E_AUTH_001` | 401 | 세션이 만료되었습니다. | MSG-ERR-07 |
| `E_AUTH_002` | 401 | 인증에 실패했습니다. | MSG-ERR-07 |
| `E_PERM_001` | 403 | 해당 고객사를 조회할 권한이 없습니다. | MSG-ERR-05 |
| `E_VALD_001` | 400 | 메시지를 입력해주세요. | MSG-INL-02 |
| `E_VALD_002` | 400 | 최대 500자까지 입력 가능합니다. | MSG-INL-01 |
| `E_DATA_001` | 404 | 요청하신 데이터를 찾을 수 없습니다. | MSG-ERR-01 |
| `E_DATA_002` | 204 | 오늘은 주요 변동이 없습니다. | MSG-INF-01 |
| `E_LLM_001` | 502 | 분석 데이터를 불러오지 못했습니다. | MSG-ERR-03 |
| `E_LLM_002` | 408 | 응답 시간이 초과되었습니다. | MSG-ERR-04 |
| `E_LLM_003` | 429 | 일시적으로 요청이 많습니다. 잠시 후 다시 시도해주세요. | MSG-ERR-01 |
| `E_NEWS_001` | 502 | 출처 데이터를 일시적으로 가져올 수 없습니다. | MSG-INF-03 |
| `E_CACH_001` | 429 | 이미 갱신 중입니다. | MSG-ERR-02 |
| `E_SYS_001` | 500 | 요청 처리 중 오류가 발생했습니다. | MSG-ERR-01 |
| `E_SYS_002` | 503 | 서비스 점검 중입니다. | MSG-ERR-01 |

---

## 4. 함께 산출되어야 할 추가 문서

이 IPO 정의서와 짝을 이루는 문서:

| 문서 | 역할 | 상태 |
|------|------|------|
| `main-ipo.md` | IPO 통합 명세 (이 문서) | ✅ 완료 |
| `api-spec.yaml` | Swagger / OpenAPI 3.0 | 별도 작성 필요 |
| `wireframe-main.fig` | 와이어프레임 + 영역 ID | 디자인 산출물 |
| `i18n-ko.json` | 한국어 메시지 사전 | 별도 |
| `error-codes.md` | 에러 코드 통합 관리 | 별도 |
| `mcp-news-spec.md` | MCP-News 서버 명세서 | 자체 구현 (Q18) |
| `mih-csv-spec.md` | MIH CSV 포맷 명세서 | 별도 |
| `org-hierarchy-schema.md` | org_hierarchy 테이블 설계 | 매니저 권한용 |
| `llm-prompt-spec.md` | LLM 프롬프트 명세서 | analysis / causal_chain / strategy / chat |

---

## 5. 변경 이력

| 버전 | 일자 | 변경 내용 | 작성자 |
|------|------|---------|-------|
| v1.0 | 2026-05-13 | 최초 작성 (Input + Process + Output) | - |
| v1.1 | 2026-05-13 | 숫자 포맷 소수점 2자리 통일 / 변동률 색상 한국 금융권 관습 적용 (상승=빨강, 하락=파랑) | - |
