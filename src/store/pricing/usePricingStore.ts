import { create } from 'zustand';
import type { PriceGuide, SimilarSituation, IndicatorComparison } from '@/types/pricing.types';
import { pricingService } from '@/services/pricing.service';

interface PricingState {
  priceGuide: PriceGuide | null;
  similarSituation: SimilarSituation | null;
  indicatorComparisons: IndicatorComparison[];
  loading: boolean;
  error: string | null;
}

interface PricingActions {
  loadGuide: (customerId: string) => Promise<void>;
}

export type PricingStore = PricingState & PricingActions;

export const usePricingStore = create<PricingStore>()((set) => ({
  priceGuide: null,
  similarSituation: null,
  indicatorComparisons: [],
  loading: false,
  error: null,

  loadGuide: async (customerId) => {
    set({ loading: true, error: null });
    try {
      const { priceGuide, similarSituation, indicatorComparisons } =
        await pricingService.getGuide(customerId);
      set({ priceGuide, similarSituation, indicatorComparisons, loading: false });
    } catch {
      set({ error: '가격 가이드를 불러오지 못했습니다.', loading: false });
    }
  },
}));
