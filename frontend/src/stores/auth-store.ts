import { create } from 'zustand';
import type { SessionUser } from '@/types';

/**
 * 사용자 세션 상태.
 *
 * PRD 0516: 초기값은 null. `SyncAuthFromMe` 가 `/api/users/me` 응답으로
 * 자동 채움 (UserBootstrap 이후 마운트). 토큰이 바뀌면 응답도 다른 사용자로 옴.
 *
 * Phase 2: JWT/SSO 통합 시 실제 토큰 디코딩으로 교체
 */
interface AuthState {
  user: SessionUser | null;
  setUser: (user: SessionUser | null) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  setUser: (user) => set({ user }),
  logout: () => set({ user: null }),
}));
