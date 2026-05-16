import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { ApiClientError, apiClient, unwrap } from '@/lib/api/client';
import type {
  CacheInvalidateRequest,
  CacheInvalidateResponse,
  CustomerProfileResponse,
  DashboardResponse,
  QuestionAnswerResponse,
  TodayQuestionsResponse,
} from '@/types';
import { CACHE_POLICY } from '@/shared/constants';
import { toast } from '@/stores/toast-store';
import { ERROR_CODE_TO_MESSAGE } from '@/types';

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
