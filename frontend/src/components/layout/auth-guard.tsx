'use client';

import { useEffect, useState } from 'react';
import { useRouter, usePathname } from 'next/navigation';

/**
 * 인증 가드 (PRD 0523).
 *
 * localStorage 의 `auth-token` 이 없으면 `/login` 으로 리다이렉트.
 * 마운트 직후 잠시 빈 화면(splash) 표시 후 통과/리다이렉트 분기.
 */
export function AuthGuard({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const [checked, setChecked] = useState(false);

  useEffect(() => {
    if (typeof window === 'undefined') return;
    const token = localStorage.getItem('auth-token');
    if (!token) {
      router.replace('/login');
      return;
    }
    setChecked(true);
  }, [router, pathname]);

  if (!checked) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50">
        <div className="text-sm font-medium text-gray-400">로딩 중…</div>
      </div>
    );
  }
  return <>{children}</>;
}
