/**
 * MSW 핸들러 통합 export.
 *
 * .env.local: NEXT_PUBLIC_API_MOCKING=enabled 일 때 활성.
 * disabled 인 경우 worker 자체가 시작하지 않으므로 실제 BE 로 직결.
 */
import { dashboardHandlers } from './dashboard';

export const handlers = [...dashboardHandlers] as const;
