import { create } from 'zustand';
import type { MessageId } from '@/types';
import { MESSAGES_KO, MESSAGE_DURATION, getMessage } from '@/types';

/**
 * 토스트 알림 상태
 *
 * main-ipo.md § 3-5 메시지 표준
 * - MSG-TST-XX: 성공 토스트
 * - MSG-ERR-XX: 에러 토스트
 * - 노출 시간은 메시지 ID별로 지정 (MESSAGE_DURATION)
 *
 * 사용:
 *   useToastStore.getState().show('MSG-TST-01', { time: '14:30' });
 */

export interface ToastEntry {
  id: string;
  messageId: MessageId;
  text: string;
  category: 'success' | 'error' | 'info';
  duration_ms: number;
}

interface ToastState {
  toasts: ToastEntry[];
  show: (messageId: MessageId, vars?: Record<string, string | number>) => void;
  dismiss: (id: string) => void;
}

function categoryOf(messageId: MessageId): ToastEntry['category'] {
  if (messageId.startsWith('MSG-TST-')) return 'success';
  if (messageId.startsWith('MSG-ERR-')) return 'error';
  return 'info';
}

export const useToastStore = create<ToastState>((set, get) => ({
  toasts: [],

  show: (messageId, vars) => {
    const id = crypto.randomUUID();
    const text = getMessage(messageId, vars);
    const duration_ms = MESSAGE_DURATION[messageId] ?? 3_000;
    const entry: ToastEntry = {
      id,
      messageId,
      text,
      category: categoryOf(messageId),
      duration_ms,
    };
    set((state) => ({ toasts: [...state.toasts, entry] }));
    // 자동 dismiss
    setTimeout(() => get().dismiss(id), duration_ms);
  },

  dismiss: (id) => set((state) => ({ toasts: state.toasts.filter((t) => t.id !== id) })),
}));

/** 라이브러리 외부 (queryClient 등 비-React 환경)에서도 사용 가능하도록 export */
export const toast = {
  show: (messageId: MessageId, vars?: Record<string, string | number>) =>
    useToastStore.getState().show(messageId, vars),
  dismiss: (id: string) => useToastStore.getState().dismiss(id),
};

void MESSAGES_KO; // unused import guard
