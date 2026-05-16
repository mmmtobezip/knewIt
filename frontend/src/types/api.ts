/**
 * PRD 0514 API 응답 wrapper + 에러 코드.
 */

import type {
  CustomerProfile,
  DashboardPayload,
  QuestionAnswer,
  TodayQuestionsPayload,
  TopMover,
} from './domain';

export interface ApiMeta {
  request_id: string;
  timestamp: string;
  cache_hit?: boolean | null;
}

export interface ApiSuccess<T> {
  success: true;
  data: T;
  error: null;
  meta: ApiMeta;
}

export interface ApiFailure {
  success: false;
  data: null;
  error: ApiError;
  meta: ApiMeta;
}

export type ApiResponse<T> = ApiSuccess<T> | ApiFailure;

export type ErrorCode =
  | 'E_AUTH_001' | 'E_AUTH_002'
  | 'E_PERM_001'
  | 'E_VALD_001' | 'E_VALD_002'
  | 'E_DATA_001' | 'E_DATA_002'
  | 'E_LLM_001'  | 'E_LLM_002'  | 'E_LLM_003'
  | 'E_NEWS_001'
  | 'E_CACH_001'
  | 'E_SYS_001'  | 'E_SYS_002';

export interface ApiError {
  code: ErrorCode;
  message: string;
  detail?: string;
}

export type CustomerProfileResponse = ApiResponse<{ customer_profile: CustomerProfile }>;
export type DashboardResponse = ApiResponse<DashboardPayload>;
export type TopMoversResponse = ApiResponse<{ product: string; top_movers: TopMover[] }>;
export type TodayQuestionsResponse = ApiResponse<TodayQuestionsPayload>;
export type QuestionAnswerResponse = ApiResponse<{ answer: QuestionAnswer }>;
export type CacheInvalidateResponse = ApiResponse<{ invalidated_keys: string[] }>;

export type CacheScope =
  | 'top_movers'
  | 'cause_flow'
  | 'interpretation'
  | 'strategy'
  | 'news'
  | 'questions';

export interface CacheInvalidateRequest {
  customer_id?: string;
  product_code?: string;
  scope: CacheScope[];
}

export const API_ENDPOINTS = {
  CUSTOMER_PROFILE: (id: string) => `/api/customers/${encodeURIComponent(id)}/profile`,
  DASHBOARD: `/api/dashboard`,
  TOP_MOVERS: `/api/top-movers`,
  TODAY_QUESTIONS: `/api/today-questions`,
  TODAY_QUESTIONS_ANSWER: `/api/today-questions/answer`,
  CACHE_INVALIDATE: `/api/cache/invalidate`,
} as const;
