/**
 * API 공통 응답 / 에러 코드 / 엔드포인트 타입 정의
 *
 * 참조: main-ipo.md
 * - § 3-6 API 응답 표준
 * - § 3-7 표준 에러 코드 체계
 * - Q7 공통 응답 wrapper 사용
 * - Q8 표준 에러 코드 체계
 */

import type {
  CustomerProfile,
  IndicatorTimeseries,
  TriggerEvent,
  NewsDoc,
  AnalysisResult,
  CausalChain,
  Strategy,
  TodayQuestion,
  DateTimeString,
} from './domain';

// ─────────────────────────────────────────────────────────
// 공통 응답 Wrapper
// ─────────────────────────────────────────────────────────

/**
 * API 응답 메타 정보
 */
export interface ApiMeta {
  request_id: string;
  timestamp: DateTimeString;
  cache_hit?: boolean;
}

/**
 * 성공 응답
 */
export interface ApiSuccess<T> {
  success: true;
  data: T;
  error: null;
  meta: ApiMeta;
}

/**
 * 실패 응답
 */
export interface ApiFailure {
  success: false;
  data: null;
  error: ApiError;
  meta: ApiMeta;
}

/**
 * API 응답 (성공 | 실패)
 */
export type ApiResponse<T> = ApiSuccess<T> | ApiFailure;

// ─────────────────────────────────────────────────────────
// 표준 에러 코드 체계
// ─────────────────────────────────────────────────────────

/**
 * 에러 코드 (§ 3-7-2)
 *
 * 형식: E_{도메인}_{3자리 일련번호}
 */
export type ErrorCode =
  // 인증
  | 'E_AUTH_001'  // 401 세션 만료
  | 'E_AUTH_002'  // 401 인증 실패
  // 권한
  | 'E_PERM_001'  // 403 고객사 권한 없음
  // 입력 검증
  | 'E_VALD_001'  // 400 빈 메시지
  | 'E_VALD_002'  // 400 500자 초과
  // 데이터
  | 'E_DATA_001'  // 404 미존재
  | 'E_DATA_002'  // 204 변동 없음
  // LLM
  | 'E_LLM_001'   // 502 LLM 호출 실패
  | 'E_LLM_002'   // 408 타임아웃
  | 'E_LLM_003'   // 429 Rate limit
  // News (MCP)
  | 'E_NEWS_001'  // 502 MCP-News 실패
  // 캐시
  | 'E_CACH_001'  // 429 새로고침 debounce
  // 시스템
  | 'E_SYS_001'   // 500 일반 오류
  | 'E_SYS_002';  // 503 점검

/**
 * 에러 객체
 */
export interface ApiError {
  code: ErrorCode;
  message: string;
  /** 디버깅용 상세 (운영 환경에서는 마스킹 가능) */
  detail?: string;
}

// ─────────────────────────────────────────────────────────
// API 엔드포인트별 응답 데이터 타입
//
// 각 API는 위 ApiResponse<T> 로 감싸짐
// (예: API-01 응답 = ApiResponse<Api01Data>)
// ─────────────────────────────────────────────────────────

/**
 * API-01: GET /api/customers/{id}/profile
 */
export type Api01Response = ApiResponse<{
  customer_profile: CustomerProfile;
}>;

/**
 * API-02: GET /api/trigger-events?customer={c}&product={p}&date={d}
 */
export type Api02Response = ApiResponse<{
  /** trigger_event 가 없으면 null */
  trigger_event: TriggerEvent | null;
}>;

/**
 * API-03: GET /api/today-questions?customer={c}
 */
export type Api03Response = ApiResponse<{
  /** 항상 길이 3 (Q9) */
  today_questions: TodayQuestion[];
}>;

/**
 * API-04: GET /api/indicators?feature={f}&period=1M
 *
 * MVP 단계는 period=1M 고정
 */
export type Api04Response = ApiResponse<{
  indicators: IndicatorTimeseries;
}>;

/**
 * API-05: GET /api/analysis?event_id={e}
 */
export type Api05Response = ApiResponse<{
  analysis_result: AnalysisResult;
}>;

/**
 * API-06: GET /api/causal-chain?event_id={e}
 */
export type Api06Response = ApiResponse<{
  causal_chain: CausalChain;
}>;

/**
 * API-07: GET /api/news?event_id={e}
 */
export type Api07Response = ApiResponse<{
  retrieved_docs: NewsDoc[];
}>;

/**
 * API-08: GET /api/strategy?event_id={e}&customer_id={c}
 */
export type Api08Response = ApiResponse<{
  strategy: Strategy;
}>;

/**
 * API-09: POST /api/chat (SSE)
 * → ChatStreamChunk 타입은 ./chat.ts 참조
 */

/**
 * API-10: POST /api/chat/question (SSE)
 * → ChatStreamChunk 타입은 ./chat.ts 참조
 */

/**
 * API-11: POST /api/cache/invalidate
 *
 * Body: { customer_id, product_code, scope: CacheScope[] }
 */
export type Api11Response = ApiResponse<{
  invalidated_keys: string[];
}>;

// ─────────────────────────────────────────────────────────
// 캐시 무효화
// ─────────────────────────────────────────────────────────

/**
 * 캐시 무효화 범위
 *
 * P-04 새로고침 시 사용
 * ※ today_questions, indicators 는 새로고침 대상 아님 (Q6)
 */
export type CacheScope =
  | 'analysis'
  | 'causal_chain'
  | 'news'
  | 'strategy';

export interface CacheInvalidateRequest {
  customer_id: string;
  product_code: string;
  scope: CacheScope[];
}

// ─────────────────────────────────────────────────────────
// HTTP Status Code (참조용)
// ─────────────────────────────────────────────────────────

/**
 * § 3-6-3 HTTP Status Code 매핑
 */
export const HTTP_STATUS = {
  OK: 200,
  NO_CONTENT: 204,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  REQUEST_TIMEOUT: 408,
  TOO_MANY_REQUESTS: 429,
  INTERNAL_ERROR: 500,
  BAD_GATEWAY: 502,
  SERVICE_UNAVAILABLE: 503,
} as const;

export type HttpStatus = typeof HTTP_STATUS[keyof typeof HTTP_STATUS];

// ─────────────────────────────────────────────────────────
// API 엔드포인트 경로 (상수)
// ─────────────────────────────────────────────────────────

export const API_ENDPOINTS = {
  CUSTOMER_PROFILE: (id: string) => `/api/customers/${id}/profile`,
  TRIGGER_EVENTS:   `/api/trigger-events`,
  TODAY_QUESTIONS:  `/api/today-questions`,
  INDICATORS:       `/api/indicators`,
  ANALYSIS:         `/api/analysis`,
  CAUSAL_CHAIN:     `/api/causal-chain`,
  NEWS:             `/api/news`,
  STRATEGY:         `/api/strategy`,
  CHAT:             `/api/chat`,           // SSE
  CHAT_QUESTION:    `/api/chat/question`,  // SSE
  CACHE_INVALIDATE: `/api/cache/invalidate`,
} as const;
