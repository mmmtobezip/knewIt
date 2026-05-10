import type { TriggerListResponse } from '@/types/trigger.types';
import { mockTriggerListResponse } from '@/mocks/fixtures/trigger.fixture';

export const fetchTriggers = (): Promise<TriggerListResponse> =>
  new Promise((resolve) => setTimeout(() => resolve(mockTriggerListResponse), 300));
