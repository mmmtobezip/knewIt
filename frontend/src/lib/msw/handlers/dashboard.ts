import { http, HttpResponse, delay } from 'msw';
import type { ApiResponse, CustomerProfile, TriggerEvent, AnalysisResult, CausalChain, Strategy, NewsDoc, TodayQuestion, IndicatorTimeseries } from '@/types';
import {
  CUSTOMER_PROFILES,
  NEWS_DOCS,
  getTriggerEvent,
  getIndicatorTimeseries,
  getAnalysisResult,
  getCausalChain,
  getStrategy,
  getTodayQuestions,
} from '../mocks/data';

/**
 * MSW 핸들러 - 대시보드 API
 *
 * 분기 규칙 (index.html mockup 패턴):
 * - 제품 코드 기반: indicators, trigger_events, analysis, causal_chain
 * - 고객사 ID 기반: profile, today_questions, strategy
 * - 글로벌: news
 *
 * event_id 포맷: `EVT-20260508-{product}` → 핸들러에서 product 추출
 */

const BASE = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3001';

function ok<T>(data: T, cacheHit = false): ApiResponse<T> {
  return {
    success: true,
    data,
    error: null,
    meta: {
      request_id: `req_${crypto.randomUUID()}`,
      timestamp: new Date().toISOString(),
      cache_hit: cacheHit,
    },
  };
}

async function jitter(): Promise<void> {
  await delay(50 + Math.random() * 200);
}

/** event_id 에서 product 추출 (`EVT-20260508-hotrolled` → `hotrolled`) */
function productFromEventId(eventId: string): string {
  return eventId.split('-').slice(2).join('-') || '';
}

export const dashboardHandlers = [
  // API-01: 고객사 프로필 조회 (고객사 ID 기반)
  http.get(`${BASE}/api/customers/:id/profile`, async ({ params }) => {
    await jitter();
    const id = params.id as string;
    const profile = CUSTOMER_PROFILES[id];
    if (!profile) {
      return HttpResponse.json({ success: false, error: { code: 'E_DATA_001', message: '미존재' } }, { status: 404 });
    }
    return HttpResponse.json(ok<{ customer_profile: CustomerProfile }>({ customer_profile: profile }));
  }),

  // API-02: trigger_event 조회 (제품 코드 기반)
  http.get(`${BASE}/api/trigger-events`, async ({ request }) => {
    await jitter();
    const url = new URL(request.url);
    const product = url.searchParams.get('product') ?? '';
    const event = getTriggerEvent(product);
    return HttpResponse.json(ok<{ trigger_event: TriggerEvent | null }>({ trigger_event: event }));
  }),

  // API-03: 추천 질문 (고객사 ID 기반)
  http.get(`${BASE}/api/today-questions`, async ({ request }) => {
    await jitter();
    const url = new URL(request.url);
    const customer = url.searchParams.get('customer') ?? '';
    const questions = getTodayQuestions(customer);
    return HttpResponse.json(ok<{ today_questions: TodayQuestion[] }>({ today_questions: questions }, true));
  }),

  // API-04: 지표 시계열 (제품 코드 기반)
  http.get(`${BASE}/api/indicators`, async ({ request }) => {
    await jitter();
    const url = new URL(request.url);
    const product = url.searchParams.get('product') ?? '';
    const series = getIndicatorTimeseries(product);
    if (!series) {
      return HttpResponse.json({ success: false, error: { code: 'E_DATA_001', message: '데이터 없음' } }, { status: 404 });
    }
    return HttpResponse.json(ok<{ indicators: IndicatorTimeseries }>({ indicators: series }));
  }),

  // API-05: 분석 결과 (event_id 에서 product 추출)
  http.get(`${BASE}/api/analysis`, async ({ request }) => {
    await jitter();
    const url = new URL(request.url);
    const eventId = url.searchParams.get('event_id') ?? '';
    const product = productFromEventId(eventId);
    const result = getAnalysisResult(product);
    if (!result) {
      return HttpResponse.json({ success: false, error: { code: 'E_LLM_001', message: '분석 불가' } }, { status: 502 });
    }
    return HttpResponse.json(ok<{ analysis_result: AnalysisResult }>({ analysis_result: result }, true));
  }),

  // API-06: 원인 흐름 (event_id 에서 product 추출)
  http.get(`${BASE}/api/causal-chain`, async ({ request }) => {
    await jitter();
    const url = new URL(request.url);
    const eventId = url.searchParams.get('event_id') ?? '';
    const product = productFromEventId(eventId);
    const chain = getCausalChain(product);
    if (!chain) {
      return HttpResponse.json({ success: false, error: { code: 'E_LLM_001', message: '분석 불가' } }, { status: 502 });
    }
    return HttpResponse.json(ok<{ causal_chain: CausalChain }>({ causal_chain: chain }, true));
  }),

  // API-07: 뉴스 (글로벌)
  http.get(`${BASE}/api/news`, async () => {
    await jitter();
    return HttpResponse.json(ok<{ retrieved_docs: NewsDoc[] }>({ retrieved_docs: NEWS_DOCS }, true));
  }),

  // API-08: 전략 (고객사 ID 기반)
  http.get(`${BASE}/api/strategy`, async ({ request }) => {
    await jitter();
    const url = new URL(request.url);
    const customer = url.searchParams.get('customer_id') ?? '';
    const strategy = getStrategy(customer);
    if (!strategy) {
      return HttpResponse.json({ success: false, error: { code: 'E_LLM_001', message: '전략 생성 실패' } }, { status: 502 });
    }
    return HttpResponse.json(ok<{ strategy: Strategy }>({ strategy }, true));
  }),

  // API-11: 캐시 무효화
  http.post(`${BASE}/api/cache/invalidate`, async ({ request }) => {
    await delay(300);
    const body = (await request.json()) as { scope: string[] };
    return HttpResponse.json(ok<{ invalidated_keys: string[] }>({ invalidated_keys: body.scope.map((s) => `cache:${s}:*`) }));
  }),
];
