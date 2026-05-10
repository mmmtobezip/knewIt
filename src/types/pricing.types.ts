import type { ChangeDirection } from './common.types';

export interface PriceGuide {
  customerId: string;
  customerName: string;
  product: string;
  ruleBasePrice: number;
  aiAdjustedPrice: number;
  negotiationMinPrice: number;
  negotiationMaxPrice: number;
  negotiationDifficulty: 'EASY' | 'MEDIUM' | 'HARD';
  currency: 'KRW';
  unit: '톤';
}

export interface SimilarSituation {
  similarityPercent: number;
  period: string;
  description: string;
  agreedPrice: number;
  strategyUsed: string;
  marginRetentionRate: number;
  radarData: RadarDataPoint[];
}

export interface RadarDataPoint {
  subject: string;
  current: number;
  past: number;
  fullMark: number;
}

export interface IndicatorComparison {
  indicatorName: string;
  currentValue: string;
  pastValue: string;
  changePercent: number;
  changeDirection: ChangeDirection;
}

export interface PricingGuideResponse {
  priceGuide: PriceGuide;
  similarSituation: SimilarSituation;
  indicatorComparisons: IndicatorComparison[];
}
