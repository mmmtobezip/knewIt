import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { apiClient, unwrap, ApiClientError } from '@/lib/api/client';
import type {
  Api01Response,
  Api02Response,
  Api03Response,
  Api04Response,
  Api05Response,
  Api06Response,
  Api07Response,
  Api08Response,
  Api11Response,
  CacheScope,
} from '@/types';
import { CACHE_POLICY } from '@/shared/constants';
import { toast } from '@/stores/toast-store';
import { ERROR_CODE_TO_MESSAGE } from '@/types';

/**
 * 대시보드 데이터 조회 훅 모음
 *
 * 분기 규칙 (index.html mockup 패턴):
 * - 제품 코드 기반: trigger_event, indicators, analysis, causal_chain
 * - 고객사 ID 기반: profile, today_questions, strategy
 * - 글로벌: news
 */

export const QK = {
  profile: (customerId: string) => ['customer-profile', customerId] as const,
  triggerEvent: (product: string, date: string) => ['trigger-event', product, date] as const,
  todayQuestions: (customerId: string) => ['today-questions', customerId] as const,
  indicators: (product: string) => ['indicators', product] as const,
  analysis: (eventId: string) => ['analysis', eventId] as const,
  causalChain: (eventId: string) => ['causal-chain', eventId] as const,
  news: (eventId: string) => ['news', eventId] as const,
  strategy: (customerId: string) => ['strategy', customerId] as const,
};

// API-01: 고객사 프로필
export function useCustomerProfile(customerId: string | null) {
  return useQuery({
    queryKey: customerId ? QK.profile(customerId) : ['customer-profile', 'idle'],
    enabled: !!customerId,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(apiClient.get(`api/customers/${customerId}/profile`).json<Api01Response>()).then(
        (d) => d.customer_profile,
      ),
  });
}

// API-02: trigger event (제품 기반)
export function useTriggerEvent(productCode: string | null, date: string) {
  return useQuery({
    queryKey: productCode ? QK.triggerEvent(productCode, date) : ['trigger-event', 'idle'],
    enabled: !!productCode,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(
        apiClient
          .get('api/trigger-events', { searchParams: { product: productCode ?? '', date } })
          .json<Api02Response>(),
      ).then((d) => d.trigger_event),
  });
}

// API-03: 추천 질문 (고객사 기반)
export function useTodayQuestions(customerId: string | null) {
  return useQuery({
    queryKey: customerId ? QK.todayQuestions(customerId) : ['today-questions', 'idle'],
    enabled: !!customerId,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(
        apiClient.get('api/today-questions', { searchParams: { customer: customerId ?? '' } }).json<Api03Response>(),
      ).then((d) => d.today_questions),
  });
}

// API-04: 지표 시계열 (제품 기반)
export function useIndicators(productCode: string | null) {
  return useQuery({
    queryKey: productCode ? QK.indicators(productCode) : ['indicators', 'idle'],
    enabled: !!productCode,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(
        apiClient
          .get('api/indicators', { searchParams: { product: productCode ?? '', period: '1M' } })
          .json<Api04Response>(),
      ).then((d) => d.indicators),
  });
}

// API-05: 분석 결과 (event_id 기반)
export function useAnalysis(eventId: string | null) {
  return useQuery({
    queryKey: eventId ? QK.analysis(eventId) : ['analysis', 'idle'],
    enabled: !!eventId,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(apiClient.get('api/analysis', { searchParams: { event_id: eventId ?? '' } }).json<Api05Response>()).then(
        (d) => d.analysis_result,
      ),
  });
}

// API-06: 원인 흐름
export function useCausalChain(eventId: string | null) {
  return useQuery({
    queryKey: eventId ? QK.causalChain(eventId) : ['causal-chain', 'idle'],
    enabled: !!eventId,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(
        apiClient.get('api/causal-chain', { searchParams: { event_id: eventId ?? '' } }).json<Api06Response>(),
      ).then((d) => d.causal_chain),
  });
}

// API-07: 뉴스 (글로벌이지만 캐시 키는 event_id 로 묶음)
export function useNews(eventId: string | null) {
  return useQuery({
    queryKey: eventId ? QK.news(eventId) : ['news', 'global'],
    enabled: true, // 항상 호출 (event 없어도 글로벌 뉴스 표시 가능)
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(apiClient.get('api/news', { searchParams: { event_id: eventId ?? '' } }).json<Api07Response>()).then(
        (d) => d.retrieved_docs,
      ),
  });
}

// API-08: 전략 (고객사 기반)
export function useStrategy(customerId: string | null) {
  return useQuery({
    queryKey: customerId ? QK.strategy(customerId) : ['strategy', 'idle'],
    enabled: !!customerId,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(
        apiClient.get('api/strategy', { searchParams: { customer_id: customerId ?? '' } }).json<Api08Response>(),
      ).then((d) => d.strategy),
  });
}

// API-11: 캐시 무효화 (P-04)
export function useInvalidateCache() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (params: { customer_id: string; product_code: string; scope: CacheScope[] }) => {
      const res = await apiClient.post('api/cache/invalidate', { json: params }).json<Api11Response>();
      return unwrap(Promise.resolve(res));
    },
    onSuccess: (_data, vars) => {
      // ※ today_questions, indicators 는 새로고침 대상 아님 (Q6 결정)
      vars.scope.forEach((s) => {
        if (s === 'analysis') queryClient.invalidateQueries({ queryKey: ['analysis'] });
        if (s === 'causal_chain') queryClient.invalidateQueries({ queryKey: ['causal-chain'] });
        if (s === 'news') queryClient.invalidateQueries({ queryKey: ['news'] });
        if (s === 'strategy') queryClient.invalidateQueries({ queryKey: ['strategy', vars.customer_id] });
      });
    },
    onError: (err) => {
      if (err instanceof ApiClientError) {
        const messageId = ERROR_CODE_TO_MESSAGE[err.code];
        toast.show(messageId);
      } else {
        toast.show('MSG-ERR-01');
      }
    },
  });
}
