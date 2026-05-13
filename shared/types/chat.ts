/**
 * 채팅 (포석호 AI) 관련 타입 정의
 *
 * 참조: main-ipo.md
 * - § 1-3-10 chat_context
 * - § 2-6 P-05 추천 질문 선택
 * - § 2-7 P-06 채팅 질의
 * - Q2  변경 시 새 세션 시작
 * - Q7  SSE 스트리밍
 * - Q11 입력 500자, 30초 타임아웃, 영속 저장 X (Redis 30분)
 */

import type { TriggerEvent, AnalysisResult, CustomerProfile } from './domain';

// ─────────────────────────────────────────────────────────
// 채팅 메시지
// ─────────────────────────────────────────────────────────

/**
 * 메시지 역할
 */
export type ChatRole = 'user' | 'assistant';

/**
 * 채팅 메시지 한 건
 */
export interface ChatMessage {
  role: ChatRole;
  content: string;
  /** 표시용 시각 (HH:MM) */
  timestamp?: string;
}

// ─────────────────────────────────────────────────────────
// 채팅 세션
// ─────────────────────────────────────────────────────────

/**
 * 채팅 세션 식별자 구성 요소
 * - (user_id, customer_id, tab_id) 조합 (Q16)
 */
export interface ChatSessionKey {
  user_id: string;
  customer_id: string;
  /** 브라우저 탭 식별자 (다중 탭 동시 사용 지원) */
  tab_id: string;
}

/**
 * 채팅 세션 (Redis TTL 30분, 영속 저장 X)
 *
 * § 1-3-10
 */
export interface ChatSession {
  session_id: string;
  customer_id: string;
  /** 대화 이력 */
  messages: ChatMessage[];
  /** 현재 분석 컨텍스트 (LLM에 주입) */
  analysis_context: ChatAnalysisContext;
}

/**
 * 채팅에 주입되는 분석 컨텍스트
 */
export interface ChatAnalysisContext {
  trigger_event: TriggerEvent | null;
  analysis_result: AnalysisResult | null;
  customer_profile: CustomerProfile;
}

// ─────────────────────────────────────────────────────────
// 채팅 요청 / 응답
// ─────────────────────────────────────────────────────────

/**
 * 채팅 입력 제한
 */
export const CHAT_CONSTRAINTS = {
  /** 입력 최대 길이 (Q11) */
  MAX_INPUT_LENGTH: 500,
  /** LLM 응답 타임아웃 (Q11) */
  TIMEOUT_MS: 30_000,
  /** 세션 TTL (분) */
  SESSION_TTL_MIN: 30,
} as const;

/**
 * 일반 채팅 요청 (P-06)
 *
 * POST /api/chat (SSE)
 */
export interface ChatRequest {
  session_id: string;
  customer_id: string;
  product_code: string;
  /** 사용자 입력 (≤500자) */
  query: string;
  context: ChatAnalysisContext;
}

/**
 * 추천 질문 답변 요청 (P-05)
 *
 * POST /api/chat/question (SSE)
 *
 * ※ 답변은 사전 생성 X. 매번 LLM 호출 (Q3)
 */
export interface ChatQuestionRequest {
  session_id: string;
  question_id: string;
  customer_id: string;
  product_code: string;
  context: ChatAnalysisContext;
}

/**
 * SSE 스트리밍 청크 (Server-Sent Events)
 *
 * 응답: text/event-stream
 *
 * Server → Client 가 chunk 단위로 전송
 */
export interface ChatStreamChunk {
  /** 누적 텍스트 또는 증분 텍스트 */
  delta: string;
  /** 완료 여부 */
  done: boolean;
}
