'use client';

import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';
import { useEffect, useState, type ReactNode } from 'react';
import { CACHE_POLICY } from '@/shared/constants';
import { ApiClientError } from '@/lib/api/client';
import { toast } from '@/stores/toast-store';
import { ERROR_CODE_TO_MESSAGE } from '@/types';

/**
 * 앱 전역 Provider
 *
 * - TanStack Query Client (캐시 정책 24h, 글로벌 onError)
 * - MSW 활성화 (NEXT_PUBLIC_API_MOCKING=enabled 시)
 * - DevTools (개발 환경)
 */

function makeQueryClient(): QueryClient {
  return new QueryClient({
    defaultOptions: {
      queries: {
        staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
        retry: (failureCount, error) => {
          // 인증/권한 에러는 재시도하지 않음
          if (error instanceof ApiClientError) {
            if (error.code.startsWith('E_AUTH_') || error.code.startsWith('E_PERM_')) return false;
          }
          return failureCount < 2;
        },
        refetchOnWindowFocus: false,
      },
      mutations: {
        onError: (error) => {
          if (error instanceof ApiClientError) {
            const messageId = ERROR_CODE_TO_MESSAGE[error.code];
            toast.show(messageId);
          }
        },
      },
    },
  });
}

export function Providers({ children }: { children: ReactNode }) {
  // SSR 안전한 QueryClient 생성 (Next.js App Router 권장 패턴)
  const [queryClient] = useState(makeQueryClient);
  const [mswReady, setMswReady] = useState(false);

  useEffect(() => {
    // MSW Mock 활성화 정책:
    // - NEXT_PUBLIC_API_MOCKING=disabled 면 명시적 비활성
    // - 그 외에는 개발/스테이징 환경에서 기본 활성 (BE 부재 가정)
    const mockingFlag = process.env.NEXT_PUBLIC_API_MOCKING;
    const mockingEnabled = mockingFlag !== 'disabled';
    if (!mockingEnabled) {
      console.info('[MSW] disabled');
      setMswReady(true);
      return;
    }
    void (async () => {
      try {
        const { worker } = await import('@/lib/msw/browser');
        await worker.start({
          onUnhandledRequest: 'bypass',
          serviceWorker: { url: '/mockServiceWorker.js' },
          quiet: false,
        });
        console.info('[MSW] mock worker started');
      } catch (err) {
        console.error('[MSW] failed to start, falling back to live fetch', err);
      }
      setMswReady(true);
    })();
  }, []);

  // MSW 준비 전에는 빈 화면 (실제 fetch가 mock 으로 가지 않을 위험 회피)
  if (!mswReady) {
    return <div className="flex min-h-screen items-center justify-center text-sm text-gray-500">초기화 중...</div>;
  }

  return (
    <QueryClientProvider client={queryClient}>
      {children}
      {process.env.NODE_ENV === 'development' && <ReactQueryDevtools initialIsOpen={false} />}
    </QueryClientProvider>
  );
}
