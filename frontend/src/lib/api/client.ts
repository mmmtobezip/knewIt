import ky, { type KyInstance } from 'ky';
import type { ApiResponse, ApiFailure } from '@/types';

/**
 * 중앙 API 클라이언트
 *
 * 모든 API 호출은 이 ky 인스턴스를 거침.
 * - 공통 응답 wrapper(ApiResponse) 자동 unwrap
 * - 인증 토큰 자동 첨부
 * - 401 시 /login 리다이렉트
 * - 에러 코드 매핑 후 toast로 위임
 *
 * main-ipo.md § 3-6 API 응답 표준 / § 3-7 에러 코드 체계
 */

const BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3001';

/**
 * 토큰 획득 훅 (실제 구현 시 SSO/JWT 스토어 연결)
 * MVP에서는 localStorage 또는 mock token 사용
 */
function getAuthToken(): string | null {
  if (typeof window === 'undefined') return null;
  return localStorage.getItem('auth-token') ?? 'mock-token-emp_2026001';
}

/**
 * 인증 만료 핸들러 — 세션 만료 시 로그인 페이지로 강제 이동
 * (main-ipo.md E_AUTH_001 → MSG-ERR-07)
 */
function handleAuthExpired(): void {
  if (typeof window === 'undefined') return;
  localStorage.removeItem('auth-token');
  // 약간 지연 후 리다이렉트 (토스트가 보이도록)
  setTimeout(() => {
    window.location.href = '/login';
  }, 3_000);
}

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
        const token = getAuthToken();
        if (token) {
          request.headers.set('Authorization', `Bearer ${token}`);
        }
        request.headers.set('X-Request-ID', crypto.randomUUID());
      },
    ],
    afterResponse: [
      async (_request, _options, response) => {
        if (response.status === 401) {
          handleAuthExpired();
        }
        return response;
      },
    ],
  },
});

/**
 * 응답 unwrap 헬퍼
 *
 * 백엔드가 ApiResponse<T> 로 감싸서 보내면 data 필드만 반환.
 * 실패 응답이면 에러를 throw 하여 TanStack Query 의 onError 트리거.
 */
export async function unwrap<T>(promise: Promise<ApiResponse<T>>): Promise<T> {
  const res = await promise;
  if (!res.success) {
    throw new ApiClientError(res);
  }
  return res.data;
}

/** API 응답 에러 — Query/Mutation 에서 catch 후 toast 매핑 */
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
