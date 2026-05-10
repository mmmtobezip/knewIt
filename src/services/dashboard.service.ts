import type { DashboardResponse } from '@/types/dashboard.types';
import { mockGetDashboardData } from '@/mocks/api/dashboard.mock-api';

const USE_MOCK = import.meta.env.VITE_USE_MOCK !== 'false';

export const getDashboardData = async (): Promise<DashboardResponse> => {
  if (USE_MOCK) {
    return mockGetDashboardData();
  }
  // Real API implementation placeholder:
  // return apiClient.get<DashboardResponse>('/api/dashboard');
  throw new Error('Real API not implemented yet. Set VITE_USE_MOCK=true.');
};
