import type { UserContext } from '@/types/user.types';
import { mockUserContext } from '@/mocks/fixtures/user.fixture';

const USE_MOCK = import.meta.env.VITE_USE_MOCK !== 'false';

export const userService = {
  getCurrentUser: async (): Promise<UserContext> => {
    if (USE_MOCK) {
      return mockUserContext;
    }
    throw new Error('Real API not implemented yet. Set VITE_USE_MOCK=true.');
  },
};
