import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { ApiClientError, apiClient, unwrap } from '@/lib/api/client';
import type {
  CacheInvalidateRequest,
  CacheInvalidateResponse,
  CustomerProfileResponse,
  CustomersCatalogResponse,
  DashboardResponse,
  LoginRequest,
  LoginResponse,
  QuestionAnswerResponse,
  TodayQuestionsResponse,
  UserMeResponse,
} from '@/types';
import { CACHE_POLICY } from '@/shared/constants';
import { toast } from '@/stores/toast-store';
import { ERROR_CODE_TO_MESSAGE } from '@/types';

/**
 * PRD 0523 — 현재 사용자 프로필 (X-User-Id 헤더 또는 Authorization Bearer mock-token-XXX).
 */
export function useUsersMe(enabled = true) {
  return useQuery({
    queryKey: ['users', 'me'],
    enabled,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(apiClient.get('api/users/me').json<UserMeResponse>()).then((d) => d.user),
  });
}

/**
 * PRD 0516 — 사용자 권한 내 거래처 (product 필터 적용).
 *  product=null 이면 본인 매핑 전체 거래처.
 */
export function useCatalogCustomers(product: string | null | undefined) {
  return useQuery({
    queryKey: ['catalog', 'customers', product ?? '_all'],
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(
        apiClient
          .get('api/catalog/customers', {
            searchParams: product ? { product } : undefined,
          })
          .json<CustomersCatalogResponse>(),
      ).then((d) => d.customers),
  });
}

/**
 * PRD 0523 — 로그인 (mock 비밀번호 "1234" 일괄).
 *  사번(301096) 또는 user_id(emp_2026003) 둘 다 login_id 로 가능.
 */
export function useLogin() {
  return useMutation({
    mutationFn: async (body: LoginRequest) => {
      const res = await apiClient
        .post('api/auth/login', { json: body, timeout: 10_000 })
        .json<LoginResponse>();
      return unwrap(Promise.resolve(res));
    },
  });
}

/**
 * PRD 0514 — 통합 메인 대시보드 응답 (chart1 + chart2 + interpretation + strategy 일괄).
 */
export function useDashboard(customerId: string | null) {
  return useQuery({
    queryKey: customerId ? ['dashboard', customerId] : ['dashboard', 'idle'],
    enabled: !!customerId,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(
        apiClient
          .get('api/dashboard', { searchParams: { customer: customerId ?? '' } })
          .json<DashboardResponse>(),
      ),
  });
}

/**
 * 추천 질문 (제품 단위 — PRD 0514).
 */
export function useTodayQuestions(productCode: string | null) {
  return useQuery({
    queryKey: productCode ? ['today-questions', productCode] : ['today-questions', 'idle'],
    enabled: !!productCode,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(
        apiClient
          .get('api/today-questions', { searchParams: { product: productCode ?? '' } })
          .json<TodayQuestionsResponse>(),
      ),
  });
}

/**
 * 추천 질문 답변 (JSON 응답, SSE 아님).
 */
export interface AnswerRequestBody {
  product: string;
  qid: string;
  text: string;
  trigger_indicators: string[];
  related_groups_internal: string[];
}

export function useAnswerQuestion() {
  return useMutation({
    mutationFn: async (body: AnswerRequestBody) => {
      const res = await apiClient
        .post('api/today-questions/answer', { json: body, timeout: 60_000 })
        .json<QuestionAnswerResponse>();
      return unwrap(Promise.resolve(res));
    },
    onError: (err) => {
      if (err instanceof ApiClientError) {
        toast.show(ERROR_CODE_TO_MESSAGE[err.code]);
      } else {
        toast.show('MSG-ERR-01');
      }
    },
  });
}

/**
 * 고객사 프로필 (PRD 0514 스키마).
 */
export function useCustomerProfile(customerId: string | null) {
  return useQuery({
    queryKey: customerId ? ['customer-profile', customerId] : ['customer-profile', 'idle'],
    enabled: !!customerId,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(
        apiClient
          .get(`api/customers/${encodeURIComponent(customerId ?? '')}/profile`)
          .json<CustomerProfileResponse>(),
      ).then((d) => d.customer_profile),
  });
}

/**
 * 캐시 무효화 (새로고침).
 */
export function useInvalidateCache() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: async (params: CacheInvalidateRequest) => {
      const res = await apiClient.post('api/cache/invalidate', { json: params }).json<CacheInvalidateResponse>();
      return unwrap(Promise.resolve(res));
    },
    onSuccess: (_data, vars) => {
      if (vars.customer_id) {
        queryClient.invalidateQueries({ queryKey: ['dashboard', vars.customer_id] });
      }
      if (vars.product_code) {
        queryClient.invalidateQueries({ queryKey: ['today-questions', vars.product_code] });
      }
    },
    onError: (err) => {
      if (err instanceof ApiClientError) {
        toast.show(ERROR_CODE_TO_MESSAGE[err.code]);
      } else {
        toast.show('MSG-ERR-01');
      }
    },
  });
}
