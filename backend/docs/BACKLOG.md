# Backend Backlog

진행 보류된 잔여 작업 추적. PR/리뷰 시 함께 살펴봅니다.

## High Priority — 다음 Sprint 진입 전 해결

- [ ] **#9 STS 304 / 냉연(CR) 거래처 매핑 부재**
  - 현재 CUSTOMER_PROFILE 10개 중 STS 304 / 냉연(CR) product_group 가진 거래처 0개
  - 영향: 메인 대시보드에서 STS/냉연 거래처 선택 시 빈 화면. 추천 질문(제품 단위)은 정상.
  - 액션: 기획자에게 STS/냉연 거래처 데이터 보강 요청 또는 기존 거래처 product_group 확장

- [ ] **#10 영업담당자별 거래처 N개 분할 매핑**
  - 현재 10 거래처 전체가 `emp_2026001` (이윤진) 1명에게 배정 — 단순 검증용
  - 액션: 영업 조직 시뮬레이션 시드 추가 (예: 영업 3명 × 거래처 3~4개 + 매니저 1명 직속 팀원 매핑)
  - 검증 대상: 매니저 권한 UNION (본인 + 직속 팀원의 assigned_customers)

## Medium Priority — Phase 5+

- [ ] **#7 뉴스 데이터 Vector DB(ChromaDB) 도입**
  - 현재 옵션 A (Naver + NewsAPI 직접 호출 → LLM 프롬프트 직주입)
  - 도입 시 효과: 의미적 유사도, 누적 archive, 다국어 robust, API 비용 절감
  - 액션:
    - `docker-compose.yml` 에 chromadb 컨테이너 추가
    - `app/services/news_service.py` 인터페이스 그대로 두고 backend 교체 (옵션 A → C)
    - 일배치(P-09)에 뉴스 임베딩·적재 단계 추가
    - 임베딩 모델: Voyage AI 또는 OpenAI ada-002

## Low Priority — 추후 검토

- [ ] PRODUCT_CONFIG 지표명과 external.xlsx 데이터 정합성 전수 검증
  - 일부 지표명 오타·공백 의심 (이미 확인된 `중국 수출 구매자 관리자 지수(PMI)` 등은 보정)
  - 적재 시점 매칭 실패 row 로그로 알림

- [ ] FE chat-stream.service.ts 대응
  - 현재 BE는 채팅 답변을 JSON으로 반환 (PRD 0514)
  - FE는 SSE 스트리밍 기대 → FE 측 수정 또는 BE에 SSE wrapper 별도 제공 검토

- [ ] 데이터 신선도 UI 표시
  - external.xlsx 최신 일자(`max_date`)를 응답 meta 또는 헤더에 노출 → FE가 배너 표시

## Done (참고)

- ✅ #1~#6, #8, #11, #12 — 노션 PRD 0514 반영 (2026-05-14 결정 완료)
