import { dashboardHandlers } from './dashboard';
import { chatHandlers } from './chat';

/**
 * MSW 핸들러 통합 export
 *
 * - dashboardHandlers: API-01 ~ API-08, API-11 (REST mock)
 * - chatHandlers: API-09, API-10 (SSE 스트리밍 mock)
 *
 * 브라우저 워커(browser.ts) 가 이 배열을 setupWorker 에 전달.
 */
export const handlers = [...dashboardHandlers, ...chatHandlers];
