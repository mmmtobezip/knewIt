# 화면 흐름도 - POS-Pricing Navigator

| 항목 | 내용 |
|------|------|
| **작성일** | 2026-05-13 |
| **참조 문서** | `main.prd` / `main-ipo.md` / `wireframe-spec.md` |
| **표기법** | Mermaid Diagram (마크다운 렌더러에서 자동 시각화) |

> Mermaid는 GitHub, VS Code, Notion 등 대부분의 마크다운 뷰어에서 자동 렌더링됩니다.

---

## 1. 전체 사이트맵 (화면 간 이동)

```mermaid
graph TD
    Login[🔐 로그인 화면<br/>SCR-LOGIN]
    Main[📊 메인 대시보드<br/>SCR-MAIN-001]
    Guide[📘 판매 가이드<br/>SCR-GUIDE-001]
    Mail[✉️ 메일 초안 작성<br/>SCR-MAIL-001]

    Login -->|로그인 성공| Main
    Main -->|진입카드 클릭<br/>NAV-01| Guide
    Main -->|진입카드 클릭<br/>NAV-02| Mail
    Guide -->|로고 클릭| Main
    Mail -->|로고 클릭| Main
    Guide -->|탭 클릭| Mail
    Mail -->|탭 클릭| Guide

    Main -->|뉴스 클릭<br/>NWS-03| External[🔗 외부 뉴스 사이트<br/>새 탭]

    Login -.->|인증 만료<br/>E_AUTH_001| Main

    classDef screen fill:#E8F3FF,stroke:#3182F6,stroke-width:2px,color:#191F28
    classDef external fill:#F2F4F6,stroke:#8B95A1,stroke-width:1px,color:#4E5968
    class Login,Main,Guide,Mail screen
    class External external
```

---

## 2. 메인 대시보드 진입 흐름 (P-01)

```mermaid
flowchart TD
    Start([페이지 로드]) --> Auth{인증 검증}
    Auth -->|만료/무효| Redirect[/login 리다이렉트/]
    Auth -->|유효| ExtractUser[user_id, user_role 추출]

    ExtractUser --> CheckRole{user_role?}
    CheckRole -->|manager| QueryWithTeam[본인 + 직속 팀원<br/>고객사 매핑 UNION]
    CheckRole -->|sales/admin| QueryOwn[본인 매핑 조회]

    QueryWithTeam --> SortKR[가나다순 정렬]
    QueryOwn --> SortKR

    SortKR --> CheckEmpty{고객사 0건?}
    CheckEmpty -->|예| EmptyMsg[💬 담당 고객사 없음 안내]
    CheckEmpty -->|아니오| Restore[localStorage 복원<br/>또는 가나다순 첫번째]

    Restore --> LoadProduct[customer_profile.product 조회<br/>제품 드롭다운 세팅]

    LoadProduct --> ParallelFetch[병렬 데이터 조회<br/>API-01, API-02, API-03]

    ParallelFetch --> CheckTrigger{trigger_event<br/>존재?}

    CheckTrigger -->|있음| FullFetch[병렬 분석 데이터 조회<br/>API-04~08<br/>Redis 캐시 우선]
    CheckTrigger -->|없음| EmptyState[💬 오늘은 주요 변동이 없습니다<br/>placeholder 표시]

    FullFetch --> Render[화면 렌더링<br/>첫 추천 질문 active 표시]
    EmptyState --> Render
    Render --> End([완료])

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef decision fill:#FFF8E5,stroke:#FFB020
    classDef process fill:#E8F3FF,stroke:#3182F6
    classDef error fill:#FEF1F2,stroke:#F04452
    classDef endNode fill:#F2F4F6,stroke:#8B95A1

    class Start,End start
    class Auth,CheckRole,CheckEmpty,CheckTrigger decision
    class ExtractUser,QueryWithTeam,QueryOwn,SortKR,Restore,LoadProduct,ParallelFetch,FullFetch,Render process
    class Redirect,EmptyMsg,EmptyState error
```

---

## 3. 사용자 이벤트별 흐름

### 3-1. 고객사 변경 흐름 (P-02)

```mermaid
flowchart LR
    Start([고객사 드롭다운 변경]) --> Validate{권한 내<br/>customer_id?}
    Validate -->|아니오| Forbidden[403 Forbidden]
    Validate -->|예| Save[localStorage 저장]

    Save --> ResetChat[💬 채팅 세션 새로 시작<br/>Redis chat_session 즉시 삭제<br/>새 session_id 발급]

    ResetChat --> AutoProduct[제품 첫번째 자동 선택]
    AutoProduct --> ReFetch[P-01 5~7단계 재실행]
    ReFetch --> End([완료])

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef decision fill:#FFF8E5,stroke:#FFB020
    classDef process fill:#E8F3FF,stroke:#3182F6
    classDef error fill:#FEF1F2,stroke:#F04452
    class Start,End start
    class Validate decision
    class Save,ResetChat,AutoProduct,ReFetch process
    class Forbidden error
```

### 3-2. 제품 변경 흐름 (P-03)

```mermaid
flowchart LR
    Start([제품 드롭다운 변경]) --> Save[localStorage 저장]
    Save --> ResetChat[💬 채팅 세션 새로 시작<br/>Q2 정책 동일]
    ResetChat --> ReFetch[제품 기준 데이터 재조회<br/>trigger_events / analysis<br/>causal_chain / news / strategy]
    ReFetch --> Render[부분 재렌더링<br/>추천 질문은 변경 X]
    Render --> End([완료])

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef process fill:#E8F3FF,stroke:#3182F6
    class Start,End start
    class Save,ResetChat,ReFetch,Render process
```

### 3-3. 새로고침 흐름 (P-04)

```mermaid
flowchart TD
    Start([🔄 새로고침 버튼 클릭]) --> Debounce{5초 debounce<br/>활성?}
    Debounce -->|중복 클릭| Ignore[💬 이미 갱신 중입니다<br/>MSG-ERR-02]
    Debounce -->|첫 클릭| Lock[5초 잠금 활성화]

    Lock --> Overlay[화면 오버레이 표시<br/>최신 데이터를 불러오는 중...]
    Overlay --> Invalidate[POST /api/cache/invalidate<br/>scope: analysis, causal_chain,<br/>news, strategy<br/>※ today_questions 제외]

    Invalidate --> Refetch[no-cache 헤더로 재조회<br/>LLM 재호출]

    Refetch --> Success{성공?}
    Success -->|예| Toast1[✅ 데이터가 갱신되었습니다<br/>HH:MM 기준<br/>MSG-TST-01]
    Success -->|아니오| Toast2[❌ MSG-ERR-03]

    Toast1 --> End([완료])
    Toast2 --> End

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef decision fill:#FFF8E5,stroke:#FFB020
    classDef process fill:#E8F3FF,stroke:#3182F6
    classDef error fill:#FEF1F2,stroke:#F04452
    classDef success fill:#E8FAF3,stroke:#00C896
    class Start,End start
    class Debounce,Success decision
    class Lock,Overlay,Invalidate,Refetch process
    class Ignore,Toast2 error
    class Toast1 success
```

### 3-4. 추천 질문 선택 흐름 (P-05)

```mermaid
flowchart LR
    Start([추천 질문 카드 클릭]) --> UI[즉시 UI 반응<br/>카드 active 스타일<br/>질문 버블 표시<br/>로딩 메시지]

    UI --> Call[POST /api/chat/question<br/>SSE 스트리밍 요청<br/>※ 사전 생성 X 매번 호출]

    Call --> Stream[chunk 단위<br/>답변 영역 갱신]
    Stream --> Done{완료?}
    Done -->|성공| Save[chat_session<br/>Redis 저장 TTL 30분]
    Done -->|타임아웃 30s| Err[💬 응답 시간 초과<br/>MSG-ERR-04]
    Save --> End([완료])
    Err --> End

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef decision fill:#FFF8E5,stroke:#FFB020
    classDef process fill:#E8F3FF,stroke:#3182F6
    classDef error fill:#FEF1F2,stroke:#F04452
    class Start,End start
    class Done decision
    class UI,Call,Stream,Save process
    class Err error
```

### 3-5. 채팅 질의 흐름 (P-06)

```mermaid
flowchart TD
    Start([사용자 입력 + 전송]) --> ValidateEmpty{빈 문자열?}
    ValidateEmpty -->|예| ErrEmpty[💬 메시지를 입력해주세요<br/>MSG-INL-02]
    ValidateEmpty -->|아니오| ValidateLen{500자 초과?}
    ValidateLen -->|예| ErrLen[💬 최대 500자까지 입력 가능합니다<br/>MSG-INL-01]
    ValidateLen -->|아니오| UI[즉시 UI 반응<br/>사용자 버블 표시<br/>입력창 초기화 / 비활성화<br/>로딩 메시지]

    UI --> Call[POST /api/chat<br/>SSE 스트리밍 호출<br/>context: trigger_event,<br/>analysis_result, customer_profile]

    Call --> Stream[chunk 단위 표시]
    Stream --> CheckTimeout{30초 경과?}
    CheckTimeout -->|예| Timeout[💬 응답 시간 초과<br/>MSG-ERR-04]
    CheckTimeout -->|아니오| Complete[chat_session messages 갱신<br/>Redis TTL 30분<br/>입력창 재활성화]

    Timeout --> End([완료])
    Complete --> End
    ErrEmpty --> End
    ErrLen --> End

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef decision fill:#FFF8E5,stroke:#FFB020
    classDef process fill:#E8F3FF,stroke:#3182F6
    classDef error fill:#FEF1F2,stroke:#F04452
    class Start,End start
    class ValidateEmpty,ValidateLen,CheckTimeout decision
    class UI,Call,Stream,Complete process
    class ErrEmpty,ErrLen,Timeout error
```

### 3-6. 뉴스 클릭 흐름 (P-07)

```mermaid
flowchart LR
    Start([뉴스 카드 클릭]) --> Open[window.open<br/>target=_blank<br/>noopener,noreferrer]
    Open --> External([🔗 외부 뉴스 사이트<br/>새 탭으로 이동])

    Note[※ 로깅 없음<br/>Q13 결정]

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef process fill:#E8F3FF,stroke:#3182F6
    classDef external fill:#F2F4F6,stroke:#8B95A1
    classDef note fill:#FFF8E5,stroke:#FFB020,stroke-dasharray:5 5
    class Start start
    class Open process
    class External external
    class Note note
```

### 3-7. 화면 이동 흐름 (P-08)

```mermaid
flowchart LR
    Start([진입 카드 클릭]) --> Save[localStorage 상태 보존<br/>customer / product 유지]
    Save --> Branch{어느 카드?}
    Branch -->|NAV-01| Guide([→ guide.html])
    Branch -->|NAV-02| Mail([→ mail.html])

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef decision fill:#FFF8E5,stroke:#FFB020
    classDef process fill:#E8F3FF,stroke:#3182F6
    classDef screen fill:#E8F3FF,stroke:#3182F6,stroke-width:2px
    class Start start
    class Branch decision
    class Save process
    class Guide,Mail screen
```

---

## 4. 일일 배치 흐름 (P-09)

```mermaid
flowchart TD
    Start([⏰ cron: 매일 06:00<br/>Asia/Seoul]) --> LoadCSV[MIH CSV 적재<br/>/data/indicators/YYYY-MM-DD.csv<br/>→ DB indicators upsert]

    LoadCSV --> ForEach[활성 고객사 순회 시작]
    ForEach --> Customer{각 고객사}

    Customer --> Detect[Trigger Event 탐지<br/>customer.key_features 별<br/>change_rate 계산]

    Detect --> Threshold{abs<br/>change_rate<br/> ≥ 3%?}

    Threshold -->|아니오| NextCustomer[다음 고객사]
    Threshold -->|예| Insert[trigger_events INSERT<br/>※ severity 미부여]

    Insert --> McpNews[MCP-News 호출<br/>retrieved_docs 수집<br/>※ 자체 구현]
    McpNews --> Llm1[LLM 호출<br/>analysis_result 생성]
    Llm1 --> Llm2[LLM 호출<br/>causal_chain 생성<br/>최대 5단계]
    Llm2 --> Llm3[LLM 호출<br/>strategy 생성<br/>sensitivity 반영]
    Llm3 --> CacheAnalysis[Redis 저장 TTL 24h<br/>analysis / causal_chain<br/>news / strategy]

    CacheAnalysis --> NextCustomer
    NextCustomer --> Customer

    Customer -->|모두 완료| GenQuestions[추천 질문 생성<br/>고객사별 LLM 호출<br/>질문 3개<br/>※ 답변은 미생성]

    GenQuestions --> CacheQuestions[Redis 저장<br/>today_questions TTL 24h]

    CacheQuestions --> End([배치 완료])

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef decision fill:#FFF8E5,stroke:#FFB020
    classDef process fill:#E8F3FF,stroke:#3182F6
    classDef llm fill:#F4F9FF,stroke:#3182F6,stroke-dasharray:3 3
    class Start,End start
    class Threshold,Customer decision
    class LoadCSV,ForEach,Detect,Insert,McpNews,CacheAnalysis,GenQuestions,CacheQuestions,NextCustomer process
    class Llm1,Llm2,Llm3 llm
```

---

## 5. 상태 전환 다이어그램 (State Machine)

### 5-1. 메인 대시보드 상태

```mermaid
stateDiagram-v2
    [*] --> Loading: 페이지 진입
    Loading --> Empty: 담당 고객사 없음
    Loading --> NoTrigger: trigger_event 없음
    Loading --> Normal: trigger_event 있음
    Loading --> Error: API 실패

    Empty --> [*]: 페이지 이탈

    NoTrigger --> Normal: 새로고침으로 변동 발견
    NoTrigger --> NoTrigger: 새로고침 (변동 없음 유지)
    NoTrigger --> Loading: 고객사/제품 변경

    Normal --> Normal: 새로고침 (성공)
    Normal --> Loading: 고객사/제품 변경
    Normal --> CacheFallback: LLM 일시 장애

    CacheFallback --> Normal: LLM 복구
    CacheFallback --> Error: 캐시도 없음

    Error --> Loading: 재시도
    Error --> [*]: 페이지 이탈
```

### 5-2. 채팅 세션 상태

```mermaid
stateDiagram-v2
    [*] --> Idle: 세션 생성
    Idle --> InputValid: 사용자 입력 (≤500자)
    Idle --> InputInvalid: 빈 입력 또는 500자 초과

    InputInvalid --> Idle: 인라인 에러 표시 후 재입력 대기
    InputValid --> Streaming: SSE 호출 시작

    Streaming --> Complete: chunk 완료
    Streaming --> Timeout: 30초 초과
    Streaming --> ErrorState: LLM 실패

    Complete --> Idle: 입력 가능 재개
    Timeout --> Idle: 토스트 후 재개
    ErrorState --> Idle: 토스트 후 재개

    Idle --> [*]: 30분 TTL 만료 / 고객사·제품 변경
```

---

## 6. 에러 처리 흐름

```mermaid
flowchart TD
    Start([API 호출 / 사용자 동작]) --> Try{성공?}
    Try -->|성공| Normal[정상 흐름]
    Try -->|실패| ErrorType{에러 종류?}

    ErrorType -->|401 인증 만료<br/>E_AUTH_001| Auth[💬 MSG-ERR-07<br/>3초 후 /login 리다이렉트]
    ErrorType -->|403 권한 없음<br/>E_PERM_001| Perm[💬 MSG-ERR-05<br/>메인 강제 이동]
    ErrorType -->|400 입력 검증<br/>E_VALD_*| Vald[💬 인라인 에러<br/>MSG-INL-*]
    ErrorType -->|404 데이터 없음<br/>E_DATA_001| Data[💬 MSG-ERR-01]
    ErrorType -->|408 LLM 타임아웃<br/>E_LLM_002| LlmTime[💬 MSG-ERR-04<br/>재시도 버튼]
    ErrorType -->|429 Rate Limit<br/>E_LLM_003 / E_CACH_001| Rate[💬 MSG-ERR-02 / 01]
    ErrorType -->|500 서버 오류<br/>E_SYS_001| Sys[💬 MSG-ERR-01<br/>재시도 버튼]
    ErrorType -->|502 LLM/News 외부<br/>E_LLM_001 / E_NEWS_001| Ext[💬 MSG-ERR-03 / MSG-INF-03<br/>캐시 폴백 시도]
    ErrorType -->|503 점검 중<br/>E_SYS_002| Maint[💬 MSG-ERR-01]
    ErrorType -->|네트워크 오류| Net[💬 MSG-ERR-06<br/>재시도 버튼]

    Ext --> CacheCheck{직전 캐시<br/>존재?}
    CacheCheck -->|예| Fallback[캐시 사용<br/>+ 상단 배너 MSG-INF-02]
    CacheCheck -->|아니오| EmptyState[빈 상태 표시]

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef decision fill:#FFF8E5,stroke:#FFB020
    classDef error fill:#FEF1F2,stroke:#F04452
    classDef recovery fill:#F4F9FF,stroke:#3182F6
    class Start start
    class Try,ErrorType,CacheCheck decision
    class Auth,Perm,Vald,Data,LlmTime,Rate,Sys,Ext,Maint,Net,EmptyState error
    class Normal,Fallback recovery
```

---

## 7. 캐시 정책 흐름

```mermaid
flowchart LR
    Request([API 요청]) --> RedisCheck{Redis 캐시<br/>hit?}
    RedisCheck -->|hit + 유효| Return[캐시 반환]
    RedisCheck -->|miss / 만료| DbCheck{DB에 데이터<br/>존재?}

    DbCheck -->|있음| ComputeOrFetch[필요 시 LLM/MCP 호출<br/>결과 생성]
    DbCheck -->|없음| Empty[빈 응답]

    ComputeOrFetch --> StoreCache[Redis 저장<br/>TTL 24h]
    StoreCache --> Return

    Return --> End([응답])
    Empty --> End

    Invalidate([P-04 새로고침<br/>또는 06:00 배치]) --> DeleteCache[Redis 캐시 삭제<br/>scope 별]
    DeleteCache --> RecomputeNote[다음 요청 시<br/>재계산]

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef decision fill:#FFF8E5,stroke:#FFB020
    classDef process fill:#E8F3FF,stroke:#3182F6
    classDef cache fill:#F4F9FF,stroke:#3182F6
    class Request,Invalidate,End start
    class RedisCheck,DbCheck decision
    class ComputeOrFetch,Empty,RecomputeNote process
    class Return,StoreCache,DeleteCache cache
```

---

## 8. 권한 분기 흐름

```mermaid
flowchart TD
    Start([로그인 / API 요청]) --> CheckRole{user_role}

    CheckRole -->|admin| AdminScope[전체 고객사 조회 가능]
    CheckRole -->|manager| ManagerScope[본인 + 직속 팀원<br/>고객사 매핑 합산<br/>org_hierarchy 참조]
    CheckRole -->|sales| SalesScope[본인 매핑만 조회]

    AdminScope --> Filter[assigned_customers<br/>가나다순 정렬]
    ManagerScope --> Filter
    SalesScope --> Filter

    Filter --> Empty{0건?}
    Empty -->|예| EmptyMsg[💬 담당 고객사 없음 안내<br/>MSG-INF-04]
    Empty -->|아니오| Render[고객사 드롭다운 표시<br/>모든 role 동일 화면]

    classDef start fill:#E8FAF3,stroke:#00C896
    classDef decision fill:#FFF8E5,stroke:#FFB020
    classDef process fill:#E8F3FF,stroke:#3182F6
    classDef error fill:#FEF1F2,stroke:#F04452
    class Start start
    class CheckRole,Empty decision
    class AdminScope,ManagerScope,SalesScope,Filter,Render process
    class EmptyMsg error
```

---

## 9. 변경 이력

| 버전 | 일자 | 변경 내용 |
|------|------|---------|
| v1.0 | 2026-05-13 | 최초 작성 (사이트맵 + Process P-01~P-09 + 상태/에러/캐시/권한 흐름) |
