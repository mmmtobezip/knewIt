import { setupWorker } from 'msw/browser';
import { handlers } from './handlers';

/**
 * MSW 브라우저 워커
 *
 * 클라이언트 사이드에서 fetch 를 가로채 mock 응답을 반환.
 * 활성화 조건: process.env.NEXT_PUBLIC_API_MOCKING === 'enabled'
 */
export const worker = setupWorker(...handlers);
