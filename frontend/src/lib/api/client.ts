import ky, { type KyInstance } from 'ky';
import type { ApiResponse, ApiFailure } from '@/types';
import { useCurrentUserStore } from '@/stores/current-user-store';

/**
 * 중앙 API 클라이언트.
 *
 * PRD 0516 — auth 미사용 (해커톤 시연). 매 요청마다 zustand store 에서
 * 현재 user_id 읽어 X-User-Id 헤더로 주입. URL ?user 가 바뀌면 즉시 반영.
 */

const BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3001';

export const apiClient: KyInstance = ky.create({
  prefixUrl: BASE_URL,
  timeout: 30_000,
  retry: {
    limit: 2,
    methods: ['get'],
    statusCodes: [408, 502, 503],
    backoffLimit: 3_000,
  },
  hooks: {
    beforeRequest: [
      (request) => {
        // 매 요청 zustand getState() 로 최신 값 (subscribe 아님 → 항상 fresh).
        const userId = useCurrentUserStore.getState().userId;
        request.headers.set('X-User-Id', userId);
        request.headers.set('X-Request-ID', crypto.randomUUID());
      },
    ],
  },
});

/**
 * 응답 unwrap 헬퍼.
 * 백엔드 ApiResponse<T> 에서 data 필드만 반환. 실패 응답이면 ApiClientError throw.
 */
export async function unwrap<T>(promise: Promise<ApiResponse<T>>): Promise<T> {
  const res = await promise;
  if (!res.success) {
    throw new ApiClientError(res);
  }
  return res.data;
}

export class ApiClientError extends Error {
  readonly code: ApiFailure['error']['code'];
  readonly detail?: string;

  constructor(response: ApiFailure) {
    super(response.error.message);
    this.name = 'ApiClientError';
    this.code = response.error.code;
    this.detail = response.error.detail;
  }
}
