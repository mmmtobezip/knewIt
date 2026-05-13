import { create } from 'zustand';
import type { ChatMessage } from '@/types';

/**
 * 채팅 세션 상태
 *
 * main-ipo.md § 1-3-10 chat_context / Q2 / Q7 / Q11
 *
 * 핵심 정책:
 * - 채팅 이력은 영속 저장 X (Redis 휘발성 30분, 클라이언트도 메모리만 보관)
 * - 고객사/제품 변경 시 무조건 새 세션 시작 (이전 메시지 모두 삭제)
 * - SSE 스트리밍 중에는 마지막 assistant 메시지를 실시간 업데이트
 */
interface ChatState {
  sessionId: string | null;
  messages: ChatMessage[];
  /** SSE 스트리밍 진행 상태 */
  isStreaming: boolean;
  /** 새 세션 시작 (고객사/제품 변경 또는 명시적 reset) */
  startNewSession: () => void;
  /** 사용자 메시지 추가 */
  appendUserMessage: (content: string) => void;
  /** assistant 메시지 시작 (빈 버블 생성 → 스트리밍 시작) */
  startAssistantMessage: () => void;
  /** assistant 메시지 청크 누적 */
  appendAssistantDelta: (delta: string) => void;
  /** 스트리밍 종료 (완료/타임아웃/에러) */
  finishStreaming: () => void;
  /** 메시지 초기화 (단, 세션은 유지) */
  clearMessages: () => void;
}

export const useChatStore = create<ChatState>((set) => ({
  sessionId: null,
  messages: [],
  isStreaming: false,

  startNewSession: () =>
    set({
      sessionId: `chat_${crypto.randomUUID()}`,
      messages: [],
      isStreaming: false,
    }),

  appendUserMessage: (content) =>
    set((state) => ({
      messages: [
        ...state.messages,
        {
          role: 'user',
          content,
          timestamp: formatTimeHM(new Date()),
        },
      ],
    })),

  startAssistantMessage: () =>
    set((state) => ({
      isStreaming: true,
      messages: [
        ...state.messages,
        {
          role: 'assistant',
          content: '',
          timestamp: formatTimeHM(new Date()),
        },
      ],
    })),

  // SSE 청크가 도착할 때마다 마지막 assistant 메시지에 누적
  // (별도 메시지로 push 하지 않고 기존 버블의 content 를 incremental update)
  appendAssistantDelta: (delta) =>
    set((state) => {
      const last = state.messages.at(-1);
      if (!last || last.role !== 'assistant') return state;
      const updated = [...state.messages.slice(0, -1), { ...last, content: last.content + delta }];
      return { messages: updated };
    }),

  finishStreaming: () => set({ isStreaming: false }),

  clearMessages: () => set({ messages: [], isStreaming: false }),
}));

function formatTimeHM(d: Date): string {
  const h = String(d.getHours()).padStart(2, '0');
  const m = String(d.getMinutes()).padStart(2, '0');
  return `${h}:${m}`;
}
