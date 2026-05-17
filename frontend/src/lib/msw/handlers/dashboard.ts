import { delay, http, HttpResponse } from 'msw';
import type {
  ApiFailure,
  ApiResponse,
  CacheInvalidateResponse,
  CustomerProfileResponse,
  DashboardResponse,
  QuestionAnswerResponse,
  TodayQuestionsResponse,
  TopMoversResponse,
} from '@/types';
import {
  buildAnswerForQuestion,
  buildCustomerProfile,
  buildDashboardPayload,
  buildTodayQuestionsPayload,
  buildTopMoversPayload,
} from '../mocks/data';

/**
 * MSW 핸들러 — PRD 0514 통합 대시보드 API.
 *
 * 활성 조건: .env.local 의 NEXT_PUBLIC_API_MOCKING=enabled.
 * 비활성 시 (disabled) MSW worker 자체가 시작하지 않음 → 실제 백엔드 호출.
 */

const BASE = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3001';

function ok<T>(data: T, cacheHit = false): ApiResponse<T> {
  return {
    success: true,
    data,
    error: null,
    meta: {
      request_id: `req_${crypto.randomUUID().replace(/-/g, '').slice(0, 24)}`,
      timestamp: new Date().toISOString(),
      cache_hit: cacheHit,
    },
  };
}

function notFound(code: ApiFailure['error']['code'], message: string, detail?: string): ApiFailure {
  return {
    success: false,
    data: null,
    error: { code, message, detail },
    meta: {
      request_id: `req_${crypto.randomUUID().replace(/-/g, '').slice(0, 24)}`,
      timestamp: new Date().toISOString(),
      cache_hit: null,
    },
  };
}

async function jitter(): Promise<void> {
  await delay(60 + Math.random() * 220);
}

export const dashboardHandlers = [
  // GET /api/customers/{id}/profile
  http.get(`${BASE}/api/customers/:id/profile`, async ({ params }) => {
    await jitter();
    const id = decodeURIComponent(params.id as string);
    const profile = buildCustomerProfile(id);
    return HttpResponse.json<CustomerProfileResponse>(ok({ customer_profile: profile }, true));
  }),

  // GET /api/dashboard?customer=...
  http.get(`${BASE}/api/dashboard`, async ({ request }) => {
    await jitter();
    const url = new URL(request.url);
    const customerId = url.searchParams.get('customer') ?? '';
    if (!customerId) {
      return HttpResponse.json<ApiFailure>(
        notFound('E_VALD_001', '요청 파라미터가 올바르지 않습니다.', 'customer query param missing'),
        { status: 400 },
      );
    }
    const payload = buildDashboardPayload(customerId);
    return HttpResponse.json<DashboardResponse>(ok(payload, true));
  }),

  // GET /api/top-movers?customer=...
  http.get(`${BASE}/api/top-movers`, async ({ request }) => {
    await jitter();
    const url = new URL(request.url);
    const customerId = url.searchParams.get('customer') ?? '';
    const payload = buildTopMoversPayload(customerId);
    return HttpResponse.json<TopMoversResponse>(ok(payload, true));
  }),

  // GET /api/today-questions?product=...
  http.get(`${BASE}/api/today-questions`, async ({ request }) => {
    await jitter();
    const url = new URL(request.url);
    const product = url.searchParams.get('product') ?? '';
    if (!product) {
      return HttpResponse.json<ApiFailure>(
        notFound('E_VALD_001', '요청 파라미터가 올바르지 않습니다.', 'product query param missing'),
        { status: 400 },
      );
    }
    const payload = buildTodayQuestionsPayload(product);
    return HttpResponse.json<TodayQuestionsResponse>(ok(payload, true));
  }),

  // POST /api/today-questions/answer
  http.post(`${BASE}/api/today-questions/answer`, async ({ request }) => {
    await delay(800 + Math.random() * 600);
    const body = (await request.json()) as {
      product: string;
      qid: string;
      text: string;
      trigger_indicators?: string[];
    };
    const answer = buildAnswerForQuestion({
      qid: body.qid,
      text: body.text,
      product: body.product,
      trigger_indicators: body.trigger_indicators ?? [],
    });
    return HttpResponse.json<QuestionAnswerResponse>(ok({ answer }));
  }),

  // POST /api/cache/invalidate
  http.post(`${BASE}/api/cache/invalidate`, async ({ request }) => {
    await delay(180);
    const body = (await request.json()) as { customer_id?: string; product_code?: string; scope: string[] };
    const keys = body.scope.map((scope) => {
      const parts = ['cache', scope];
      if (body.customer_id) parts.push(body.customer_id);
      if (body.product_code) parts.push(body.product_code);
      return parts.join(':');
    });
    return HttpResponse.json<CacheInvalidateResponse>(ok({ invalidated_keys: keys }));
  }),
];
