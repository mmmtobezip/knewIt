import type { PricingGuideResponse } from '@/types/pricing.types';
import { mockPricingGuideResponse } from '@/mocks/fixtures/pricing.fixture';

export const fetchPricingGuide = (_customerId: string): Promise<PricingGuideResponse> =>
  new Promise((resolve) => setTimeout(() => resolve(mockPricingGuideResponse), 300));
