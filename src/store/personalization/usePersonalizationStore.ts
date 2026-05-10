import { create } from 'zustand';
import type { ProductConfig, WeightMap, AlertPreviewItem } from '@/types/personalization.types';
import type { ProductType } from '@/types/common.types';
import { personalizationService } from '@/services/personalization.service';

interface PersonalizationState {
  productConfigs: ProductConfig[];
  weights: WeightMap;
  selectedProduct: ProductType;
  alertPreview: AlertPreviewItem[];
  loading: boolean;
  error: string | null;
}

interface PersonalizationActions {
  loadConfigs: () => Promise<void>;
  setWeight: (product: ProductType, indicatorId: string, value: number) => void;
  resetWeights: (product: ProductType) => void;
  setSelectedProduct: (product: ProductType) => void;
}

export type PersonalizationStore = PersonalizationState & PersonalizationActions;

const buildDefaultWeights = (configs: ProductConfig[]): WeightMap =>
  Object.fromEntries(
    configs.map((c) => [
      c.product,
      Object.fromEntries(c.indicators.map((ind) => [ind.id, ind.defaultWeight])),
    ])
  );

export const usePersonalizationStore = create<PersonalizationStore>()((set, get) => ({
  productConfigs: [],
  weights: {},
  selectedProduct: '선재',
  alertPreview: [],
  loading: false,
  error: null,

  loadConfigs: async () => {
    set({ loading: true, error: null });
    try {
      const [configs, preview] = await Promise.all([
        personalizationService.getProductConfigs(),
        personalizationService.getAlertPreview(),
      ]);
      set({
        productConfigs: configs,
        weights: buildDefaultWeights(configs),
        alertPreview: preview,
        loading: false,
      });
    } catch {
      set({ error: '개인화 설정을 불러오지 못했습니다.', loading: false });
    }
  },

  setWeight: (product, indicatorId, value) => {
    const { weights } = get();
    set({
      weights: {
        ...weights,
        [product]: { ...weights[product], [indicatorId]: value },
      },
    });
  },

  resetWeights: (product) => {
    const { productConfigs, weights } = get();
    const config = productConfigs.find((c) => c.product === product);
    if (!config) return;
    set({
      weights: {
        ...weights,
        [product]: Object.fromEntries(config.indicators.map((i) => [i.id, i.defaultWeight])),
      },
    });
  },

  setSelectedProduct: (product) => set({ selectedProduct: product }),
}));
