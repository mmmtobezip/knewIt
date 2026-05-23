import { useQuery } from '@tanstack/react-query';
import { apiClient, unwrap } from '@/lib/api/client';
import type { SalesGuideResponse } from '@/types';
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
