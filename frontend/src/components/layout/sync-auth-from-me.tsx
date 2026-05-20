'use client';

import { useEffect } from 'react';
import { useUsersMe } from '@/lib/api/queries/dashboard';
import { useAuthStore } from '@/stores/auth-store';

/**
 * /api/users/me 응답을 useAuthStore 와 동기화.
 *
 * PRD 0516 — 좌측 상단 사용자 이름 등 화면 표시가 현재 token 의 실제 사용자와 일치하도록 함.
 * UserBootstrap 이 토큰 교체 → 새 mount → useUsersMe fetch → 이 컴포넌트가 store 갱신.
 */
export function SyncAuthFromMe() {
  const { data } = useUsersMe();
  const setUser = useAuthStore((s) => s.setUser);

  useEffect(() => {
    if (!data) return;
    setUser({
      user_id: data.user_id,
      user_role: data.role,
      name: data.name ?? data.user_id,
    });
  }, [data, setUser]);

  return null;
}
