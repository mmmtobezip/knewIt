import { fetchPricingGuide } from '@/mocks/api/pricing.mock-api';
import type { PricingGuideResponse } from '@/types/pricing.types';

export const pricingService = {
  getGuide: (customerId: string): Promise<PricingGuideResponse> =>
    fetchPricingGuide(customerId),
};
