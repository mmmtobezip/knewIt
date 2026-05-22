import { delay, http, HttpResponse } from 'msw';
import type { ApiFailure, ApiResponse, SalesGuideResponse } from '@/types';
import { buildSalesGuidePayload } from '../mocks/sales-guide-data';

const BASE = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3001';

function ok<T>(data: T): ApiResponse<T> {
  return {
    success: true,
    data,
    error: null,
    meta: {
      request_id: `req_${crypto.randomUUID().replace(/-/g, '').slice(0, 24)}`,
      timestamp: new Date().toISOString(),
      cache_hit: true,
    },
  };
}

function badRequest(detail: string): ApiFailure {
  return {
    success: false,
    data: null,
    error: { code: 'E_VALD_001', message: '요청 파라미터가 올바르지 않습니다.', detail },
    meta: {
      request_id: `req_${crypto.randomUUID().replace(/-/g, '').slice(0, 24)}`,
      timestamp: new Date().toISOString(),
      cache_hit: null,
    },
  };
}

export const salesGuideHandlers = [
  // GET /api/sales-guide?customer=...
  http.get(`${BASE}/api/sales-guide`, async ({ request }) => {
    await delay(80 + Math.random() * 200);
    const url = new URL(request.url);
    const customerId = url.searchParams.get('customer') ?? '';
    if (!customerId) {
      return HttpResponse.json<ApiFailure>(
        badRequest('customer query param missing'),
        { status: 400 },
      );
    }
    const payload = buildSalesGuidePayload(customerId);
    return HttpResponse.json<SalesGuideResponse>(ok(payload));
  }),
];
