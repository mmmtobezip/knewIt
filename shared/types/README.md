# Shared Types

FE/BE 가 공유하는 도메인 타입 정의 (TypeScript).

---

## 사용 방법

### Frontend (TypeScript)
```ts
import type { CustomerProfile, TriggerEvent, AnalysisResult } from '@/types';
```
(`frontend/src/types/` 는 이 폴더를 가리키도록 동기화)

### Backend (Python / Pydantic)
이 .ts 파일들을 Pydantic 모델로 변환해서 사용. 권장 도구:
- `pydantic-typescript-converter` 또는 수동 변환
- 또는 OpenAPI/JSON Schema 로 추출 후 양쪽 생성

타입 변경은 항상 이 폴더에서 먼저 수정한 뒤 양 팀에 알림.

---

## 파일별 책임

| 파일 | 내용 |
|------|------|
| `domain.ts` | 도메인 엔티티 (CustomerProfile, TriggerEvent, AnalysisResult, CausalChain, Strategy, NewsDoc, TodayQuestion, IndicatorTimeseries) |
| `api.ts` | API 응답 wrapper (ApiResponse) + 에러 코드 + 엔드포인트 경로 |
| `auth.ts` | 사용자 권한 / 세션 / 매핑 |
| `chat.ts` | 채팅 세션 / SSE 스트림 청크 / 제약 |
| `ui.ts` | UI 상태 / 메시지 ID / 변동률 헬퍼 |
| `messages.ts` | i18n 메시지 사전 (한국어) + 에러코드↔메시지 매핑 |
| `index.ts` | 진입점 (re-exports) |

---

## 변경 시 체크리스트

- [ ] FE 빌드 정상 (typecheck)
- [ ] BE Pydantic 모델 동기화
- [ ] `main-ipo.md` 의 § 1-3 (데이터 입력) 동기화 여부 확인
- [ ] 변경 이력 코멘트 추가
