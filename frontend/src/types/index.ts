/**
 * PRD 0514 — FE 타입 진입점.
 *
 * SessionUser/UserRole 은 domain.ts 가 단일 진실 (auth.ts 의 AssignedCustomer 만 별도 export).
 */

export * from './domain';
export type { AssignedCustomer, AssignmentRole } from './auth';
export * from './api';
export * from './ui';
export * from './messages';

// 채팅 스토어에서 사용하는 메시지 형태 (이전 chat.ts 폐기 후 단순 재정의)
export type ChatRole = 'user' | 'assistant';

export interface ChatMessage {
  role: ChatRole;
  content: string;
  timestamp?: string;
}
