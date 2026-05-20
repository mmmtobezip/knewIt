import { create } from 'zustand';

/**
 * 현재 사용자 ID (해커톤 시연용 — auth 미사용).
 *
 * URL 파라미터 ?user=emp_2026003 진입 시 UserBootstrap 이 setUserId 호출 →
 * 모든 API 호출에 X-User-Id 헤더로 자동 주입 (api/client.ts beforeRequest).
 *
 * default 는 emp_2026001 (이윤진) — URL 미지정 진입 시 호환.
 */
const DEFAULT_USER_ID = 'emp_2026001';

interface CurrentUserState {
  userId: string;
  setUserId: (id: string) => void;
  reset: () => void;
}

export const useCurrentUserStore = create<CurrentUserState>((set) => ({
  userId: DEFAULT_USER_ID,
  setUserId: (id) => set({ userId: id }),
  reset: () => set({ userId: DEFAULT_USER_ID }),
}));
