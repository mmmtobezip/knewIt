import type { DashboardResponse } from '@/types/dashboard.types';
import { mockDashboardResponse } from '@/mocks/fixtures/dashboard.fixture';

const SIMULATED_DELAY_MS = 800;

const delay = (ms: number) =>
  new Promise<void>((resolve) => setTimeout(resolve, ms));

export const mockGetDashboardData = async (): Promise<DashboardResponse> => {
  await delay(SIMULATED_DELAY_MS);
  return { ...mockDashboardResponse };
};
