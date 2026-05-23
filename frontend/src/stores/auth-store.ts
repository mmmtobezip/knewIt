import { create } from 'zustand';
import type { SessionUser } from '@/types';

/**
 * 사용자 세션 상태 (MVP: mock)
 *
 * Phase 2: JWT/SSO 통합 시 실제 토큰 디코딩으로 교체
 */
interface AuthState {
  user: SessionUser | null;
  setUser: (user: SessionUser) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: {
    user_id: 'emp_2026001',
    user_role: 'sales',
    name: '영업담당자',
  },
  setUser: (user) => set({ user }),
  logout: () => set({ user: null }),
}));
