# Frontend 변경 — Backend 영향 / 인계 사항

프론트엔드에서 발생한 변경 중, 백엔드 API 계약(엔드포인트, 요청·응답 스키마, 에러 코드) 또는 백엔드 동작에 영향을 미치는 항목을 시간순으로 기록한다.

## 2026-05-17 — TopMover 응답에 `cycle` 필드 노출 요청

**유형**: 응답 스키마 확장 (BE 작업 필요)

**프론트 변경**:

- [frontend/src/types/domain.ts](../frontend/src/types/domain.ts) `TopMover` 인터페이스에 `cycle?: string` 옵셔널 필드 추가.
- [frontend/src/features/main-dashboard/components/price-chart-card.tsx](../frontend/src/features/main-dashboard/components/price-chart-card.tsx) — 지표명 옆에 수집 주기 배지 표시 (값을 소문자로 — `d / w / m / q / y`).
- mock 데이터([frontend/src/lib/msw/mocks/data.ts](../frontend/src/lib/msw/mocks/data.ts))에는 모든 TopMover 에 `cycle` 값 채워둠 (`D` 일별 / `W` 주별 / `M` 월별).

**BE 에 미치는 영향**:

- (필수) `app/schemas/domain.py` 의 Pydantic `TopMover` 모델에 `cycle: str` 필드 추가 — 이미 DB `indicators.cycle` 컬럼이 존재하므로 ([backend/app/models/indicator.py:32](../backend/app/models/indicator.py)) 서비스 레이어에서 매핑만 추가하면 됨.
- (필수) `app/services/indicator_service.py` 의 `top_movers_for_product` 가 반환하는 `TopMover` 인스턴스 빌드 시 `cycle=indicator_row.cycle` 추가.
- (참고) DB 마이그레이션 불필요 (`cycle` 컬럼은 이미 NOT NULL String(2) 로 존재).
- (참고) 캐시 키 영향 없음 (응답 스키마 확장만, 키는 동일).

**FE 호환성**: BE 가 이 필드를 아직 안 보내도 FE 는 깨지지 않음 (옵셔널 + 조건부 렌더링). BE 가 추가하는 즉시 자동 표시됨.

**우선순위**: 다음 스프린트

---

## 2026-05-17 — Strategy 카드에서 `strategy_summary` 표시 제거

**유형**: BE 데이터 불필요 (정보 제공)

**프론트 변경**:

- [frontend/src/features/main-dashboard/components/strategy-card.tsx](../frontend/src/features/main-dashboard/components/strategy-card.tsx) — "전략 요약" 패널 삭제. `strategy.strategy_summary` 필드를 더 이상 렌더링하지 않음.
- "추천 행동 Top 3" / "협상 포인트 Top 3" 두 패널만 유지.

**BE 에 미치는 영향**:

- (필수) 없음. 응답 스키마 그대로 유지해도 무방. 프론트는 `strategy_summary` 필드가 응답에 있어도 무시.
- (참고) 향후 BE 가 LLM 토큰을 절약하고 싶다면 `strategy.strategy_summary` 생성을 생략해도 됨. 단, `recommended_actions` 와 `negotiation_points` 는 여전히 필수.
- (참고) 타입 정의([frontend/src/types/domain.ts](../frontend/src/types/domain.ts) `Strategy` 인터페이스)에는 `strategy_summary` 필드가 남아있음 (응답에 포함되어 들어와도 깨지지 않도록). 추후 BE 가 응답에서 빼기로 확정하면 `Strategy` 타입에서 `strategy_summary` 를 옵셔널(`strategy_summary?: string`)로 바꿔주면 됨.

**우선순위**: 정보 제공
