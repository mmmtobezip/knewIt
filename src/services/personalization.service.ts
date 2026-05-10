import type { ProductConfig, AlertPreviewItem } from '@/types/personalization.types';
import {
  mockGetProductConfigs,
  mockGetAlertPreview,
} from '@/mocks/api/personalization.mock-api';

const USE_MOCK = import.meta.env.VITE_USE_MOCK !== 'false';

export const personalizationService = {
  getProductConfigs: async (): Promise<ProductConfig[]> => {
    if (USE_MOCK) {
      return mockGetProductConfigs();
    }
    throw new Error('Real API not implemented yet. Set VITE_USE_MOCK=true.');
  },

  getAlertPreview: async (): Promise<AlertPreviewItem[]> => {
    if (USE_MOCK) {
      return mockGetAlertPreview();
    }
    throw new Error('Real API not implemented yet. Set VITE_USE_MOCK=true.');
  },
};
