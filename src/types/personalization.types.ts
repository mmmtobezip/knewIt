import type { ProductType } from './common.types';

export interface IndicatorConfig {
  id: string;
  label: string;
  defaultWeight: number;
}

export interface ProductConfig {
  product: ProductType;
  indicators: IndicatorConfig[];
}

export type WeightMap = Record<string, Record<string, number>>;

export interface AlertPreviewItem {
  questionId: string;
  questionText: string;
  score: number;
  rank: number;
}
