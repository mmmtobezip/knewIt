import { http } from 'msw';
import { getQuestionAnswer, getStrategy, getAnalysisResult, CUSTOMER_DATA } from '../mocks/data';
import type { CustomerId, ProductCode } from '../mocks/data';

/**
 * MSW 핸들러 - 채팅 SSE (API-09, API-10)
 *
 * 청크 단위로 텍스트를 흘려보내며, [DONE] 마커로 종료.
 * 사전 정의된 customer-specific 답변을 mock 으로 사용.
 *
 * main-ipo.md § P-05, P-06 / Q7 SSE 스트리밍
 */

const BASE = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3001';

function makeTextStream(fullText: string, chunkSize = 8, delayMs = 35): ReadableStream<Uint8Array> {
  const encoder = new TextEncoder();
  let cursor = 0;
  return new ReadableStream({
    async pull(controller) {
      if (cursor >= fullText.length) {
        controller.enqueue(encoder.encode('data: [DONE]\n\n'));
        controller.close();
        return;
      }
      const piece = fullText.slice(cursor, cursor + chunkSize);
      cursor += chunkSize;
      controller.enqueue(encoder.encode(`data: ${JSON.stringify({ delta: piece })}\n\n`));
      await new Promise((r) => setTimeout(r, delayMs));
    },
  });
}

const SSE_HEADERS = {
  'Content-Type': 'text/event-stream; charset=utf-8',
  'Cache-Control': 'no-cache, no-transform',
  Connection: 'keep-alive',
};

/** 자유 질문 mock 답변 — 현재 컨텍스트(customer/product)를 반영 */
function buildFreeAnswer(customerId: string, productCode: string, query: string): string {
  const cust = CUSTOMER_DATA[customerId as CustomerId];
  const analysis = getAnalysisResult(productCode as ProductCode);
  const strategy = getStrategy(customerId as CustomerId);

  const custName = cust ? customerId : '해당 고객사';
  const trend = analysis ? analysis.what : '';
  const tip = strategy ? strategy.negotiation_point : '';

  return `'${query}' 에 대한 답변입니다.\n\n현재 ${custName} 컨텍스트와 시장 상황을 종합하면 다음과 같이 정리할 수 있습니다.\n\n${trend ? `시장 상황: ${trend}\n\n` : ''}${tip ? `협상 가이드: ${tip}\n\n` : ''}추가로 궁금한 점이 있으시면 자유롭게 질문해주세요.`;
}

export const chatHandlers = [
  // API-10: 추천 질문 답변 (P-05)
  http.post(`${BASE}/api/chat/question`, async ({ request }) => {
    const body = (await request.json()) as { customer_id: string; question_id: string };
    const answer =
      getQuestionAnswer(body.customer_id, body.question_id) ?? '답변을 준비 중입니다. 잠시 후 다시 시도해주세요.';
    return new Response(makeTextStream(answer), { headers: SSE_HEADERS });
  }),

  // API-09: 자유 질문 (P-06)
  http.post(`${BASE}/api/chat`, async ({ request }) => {
    const body = (await request.json()) as {
      customer_id: string;
      product_code: string;
      query: string;
    };
    const answer = buildFreeAnswer(body.customer_id, body.product_code, body.query);
    return new Response(makeTextStream(answer), { headers: SSE_HEADERS });
  }),
];
