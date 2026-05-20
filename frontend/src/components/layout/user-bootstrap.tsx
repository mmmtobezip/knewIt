'use client';

import { useEffect } from 'react';
import { useSearchParams } from 'next/navigation';
import { useQueryClient } from '@tanstack/react-query';
import { useCurrentUserStore } from '@/stores/current-user-store';
import { useSelectionStore } from '@/stores/selection-store';

/**
 * URL ?user 파라미터 → currentUserStore + cache reset 동기화 (해커톤 시연용).
 *
 * useSearchParams 가 변경되면 useEffect 재실행 → 페이지 reload 없이
 * 모든 API 호출(X-User-Id 헤더)이 새 사용자로 바뀜.
 *
 * 시연 링크:
 *   http://localhost:3000/?user=emp_2026003   박지은 (선재)
 *   http://localhost:3000/?user=emp_2026004   박현웅 (후판)
 *   http://localhost:3000/?user=emp_2026001   이윤진 (기존)
 */
export function UserBootstrap() {
  const params = useSearchParams();
  const setUserId = useCurrentUserStore((s) => s.setUserId);
  const currentUserId = useCurrentUserStore((s) => s.userId);
  const resetSelection = useSelectionStore((s) => s.reset);
  const qc = useQueryClient();

  useEffect(() => {
    const userParam = params.get('user');
    // eslint-disable-next-line no-console
    console.log('[UserBootstrap] params change', { userParam, currentUserId });

    if (!userParam) return;
    if (userParam === currentUserId) return; // 이미 같으면 무동작

    // eslint-disable-next-line no-console
    console.log('[UserBootstrap] switching →', userParam);
    setUserId(userParam);
    resetSelection(); // 이전 사용자 cust/product 폐기
    qc.clear(); // 모든 query 캐시 무효화 → 새 X-User-Id 로 재호출
  }, [params, currentUserId, setUserId, resetSelection, qc]);

  return null;
}
