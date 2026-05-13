/**
 * SSE 채팅 스트리밍 서비스
 *
 * main-ipo.md § P-05, P-06 / Q7 SSE 스트리밍 / Q11 30초 타임아웃
 *
 * EventSource 는 GET + 인증 헤더 미지원이라, 채팅은 fetch + ReadableStream 로 구현.
 * 백엔드는 SSE 표준 포맷("data: {...}\n\n")으로 응답하며,
 * [DONE] 마커로 종료를 알림.
 */

import { CHAT } from '@/shared/constants';

const BASE = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3001';

export interface StreamChatRequest {
  session_id: string;
  customer_id: string;
  product_code: string;
  /** 자유 질문일 때 사용 (P-06) */
  query?: string;
  /** 추천 질문 클릭일 때 사용 (P-05) */
  question_id?: string;
}

export interface StreamHandlers {
  /** 청크 도착마다 호출 */
  onDelta: (delta: string) => void;
  /** 정상 종료 */
  onComplete: () => void;
  /** 에러 (타임아웃, 네트워크, LLM 실패) */
  onError: (error: Error) => void;
  /** 스트림 시작 알림 (로딩 UI 해제 등) */
  onStart?: () => void;
}

/** 청크 텍스트에서 SSE data 라인 파싱 */
function* parseSseChunk(chunk: string): Generator<string> {
  for (const line of chunk.split('\n\n')) {
    const trimmed = line.trim();
    if (!trimmed.startsWith('data:')) continue;
    yield trimmed.slice(5).trim();
  }
}

/**
 * 채팅 스트리밍 시작
 *
 * @returns AbortController — 호출자가 .abort() 로 중단 가능 (P-06 타임아웃 / 사용자 취소)
 */
export function streamChat(
  endpoint: '/api/chat' | '/api/chat/question',
  body: StreamChatRequest,
  handlers: StreamHandlers,
): AbortController {
  const controller = new AbortController();

  // 30초 타임아웃 (Q11)
  const timeoutId = setTimeout(() => {
    controller.abort('timeout');
    handlers.onError(new Error('TIMEOUT'));
  }, CHAT.STREAM_TIMEOUT_MS);

  void (async () => {
    try {
      const res = await fetch(`${BASE}${endpoint}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'text/event-stream',
        },
        body: JSON.stringify(body),
        signal: controller.signal,
      });

      if (!res.ok) {
        throw new Error(`HTTP ${res.status}`);
      }
      if (!res.body) {
        throw new Error('NO_BODY');
      }

      handlers.onStart?.();

      const reader = res.body.getReader();
      const decoder = new TextDecoder();
      let buffer = '';

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        buffer += decoder.decode(value, { stream: true });

        // 완성된 SSE 이벤트 단위(빈 줄 구분)로 끊어서 처리
        const events = buffer.split('\n\n');
        buffer = events.pop() ?? '';

        for (const event of events) {
          for (const data of parseSseChunk(`${event}\n\n`)) {
            if (data === '[DONE]') {
              clearTimeout(timeoutId);
              handlers.onComplete();
              return;
            }
            try {
              const parsed = JSON.parse(data) as { delta?: string };
              if (parsed.delta) handlers.onDelta(parsed.delta);
            } catch {
              // JSON 파싱 실패 시 raw 텍스트로 폴백
              handlers.onDelta(data);
            }
          }
        }
      }
      clearTimeout(timeoutId);
      handlers.onComplete();
    } catch (err) {
      clearTimeout(timeoutId);
      // AbortController.abort() 호출은 정상 종료로 처리하지 않음
      if (err instanceof Error && err.name === 'AbortError') {
        return;
      }
      handlers.onError(err instanceof Error ? err : new Error(String(err)));
    }
  })();

  return controller;
}
