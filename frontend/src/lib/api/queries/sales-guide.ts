import { useMutation, useQuery } from '@tanstack/react-query';
import { apiClient, unwrap } from '@/lib/api/client';
import type { ApiResponse, SalesGuideResponse } from '@/types';
import { CACHE_POLICY } from '@/shared/constants';

export function useSalesGuide(customerId: string | null) {
  return useQuery({
    queryKey: customerId ? ['sales-guide', customerId] : ['sales-guide', 'idle'],
    enabled: !!customerId,
    staleTime: CACHE_POLICY.STALE_TIME_24H_MS,
    queryFn: () =>
      unwrap(
        apiClient
          .get('api/sales-guide', { searchParams: { customer: customerId ?? '' } })
          .json<SalesGuideResponse>(),
      ),
  });
}

/**
 * PRD 4.2.7 — 제안 시작 기능
 *
 * POST /api/sales-guide/proposal
 *   body: { customer: string }
 *   ← { customer, script, generated_at }
 *
 * 4종 컨텍스트(고객사 프로필 + 실적 현황 + 시황 컨텍스트 + 과거 패턴)를
 * BE 가 모두 수집해 LLM 에 전달, 3~4줄 자연어 행동 지침을 반환.
 */
export interface ProposalData {
  customer: string;
  script: string;
  generated_at: string;
}

export function useProposalScript() {
  return useMutation({
    mutationFn: (customer: string) =>
      unwrap(
        apiClient
          .post('api/sales-guide/proposal', { json: { customer }, timeout: 60_000 })
          .json<ApiResponse<ProposalData>>(),
      ),
  });
}
