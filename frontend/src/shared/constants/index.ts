/**
 * 전역 상수 정의
 * main-ipo.md 의 결정 사항을 상수화
 */

export const APP = {
  NAME: 'POS-Pricing Navigator',
  SUBTITLE: 'AI 시장 분석 & 협상 전략',
} as const;

/** 캐시 정책 (main-ipo.md § 2-11) */
export const CACHE_POLICY = {
  /** Redis TTL 24h → TanStack Query staleTime */
  STALE_TIME_24H_MS: 24 * 60 * 60 * 1000,
  /** 채팅 세션 30분 */
  CHAT_SESSION_TTL_MS: 30 * 60 * 1000,
} as const;

/** 새로고침 정책 (Q12) */
export const REFRESH = {
  DEBOUNCE_MS: 5_000,
  TOAST_DURATION_MS: 2_200,
  OVERLAY_MIN_MS: 900,
} as const;

/** 채팅 제약 (Q11) */
export const CHAT = {
  MAX_INPUT_LENGTH: 500,
  STREAM_TIMEOUT_MS: 30_000,
} as const;

/** 추천 질문 (Q9) */
export const QUESTIONS = {
  COUNT: 3,
} as const;

/** 뉴스 슬라이더 (Q9) */
export const NEWS_SLIDER = {
  ITEMS_PER_PAGE: 5,
  ANIMATION_MS: 300,
} as const;

/** Trigger Event 임계값 (main.prd) */
export const TRIGGER = {
  THRESHOLD: 3,
} as const;

/** localStorage 키 */
export const STORAGE_KEYS = {
  LAST_SELECTION: 'pos-navigator:last-selection',
  TAB_ID: 'pos-navigator:tab-id',
} as const;
