import { fetchTriggers } from '@/mocks/api/trigger.mock-api';
import type { TriggerListResponse } from '@/types/trigger.types';

export const triggerService = {
  getAll: (): Promise<TriggerListResponse> => fetchTriggers(),
};
