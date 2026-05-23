/**
 * 판매량 가이드 대시보드 도메인 타입 (SCR-GUIDE-001).
 *
 * Module 1 — 가이드값 달성률
 * Module 2 — 고객사 현황 & 기회 탐지
 * Module 3 — 과거 시황 학습 리포트
 */

// ── Module 1 ─────────────────────────────────────────────

export type AchievementStatus = 'normal' | 'warning' | 'danger';

export interface AchievementKpi {
  achievement_rate: number;
  yoy_change: number;
  actual_volume: number;
  guide_volume: number;
  volume_unit: string;
}

export interface CustomerAchievement {
  customer_id: string;
  customer_name: string;
  industry: string;
  achievement_rate: number;
  actual_volume: number;
  guide_volume: number;
  volume_unit: string;
  yoy_change: number;
  status: AchievementStatus;
}

// ── Module 2 ─────────────────────────────────────────────

export interface MarketSignal {
  status: '강세' | '중립' | '약세';
  score: number;
  description: string;
  responsible: string;
}

export type FeatureCycle = 'DAILY' | 'WEEKLY' | 'MONTHLY';
export type FeatureDirection = 'UP' | 'DOWN' | 'FLAT';

export interface KeyFeature {
  rank: number;
  name: string;
  weight: number;
  direction: FeatureDirection;
  change: string;
  cycle: FeatureCycle;
}

export type CustomerGrade = 'A' | 'A-' | 'B+' | 'B' | 'C' | 'D';

export interface GradeSummary {
  grade_a: number;
  grade_b: number;
  grade_c: number;
}

export interface CustomerMetric {
  label: string;
  value: string;
  sub?: string;
}

export type RuleTagType = 'info' | 'warning' | 'danger';

export interface CustomerOpportunity {
  customer_id: string;
  customer_name: string;
  grade: CustomerGrade;
  score: number;
  industry: string;
  achievement_rate: number;
  opportunity_tags: string[];
  risk_tags: string[];
  rule_tag: string;
  rule_tag_type: RuleTagType;
  sensitivity_tags: string[];
  metrics: CustomerMetric[];
}

// ── Module 3 ─────────────────────────────────────────────

export interface MarketSummaryItem {
  name: string;
  value: string;
  direction: FeatureDirection;
}

export interface SimilarityPoint {
  label: string;
  score: number;
  highlighted: boolean;
  is_current: boolean;
}

export interface MarketFeature {
  name: string;
  value: string;
}

export interface SimilarPeriod {
  rank: number;
  period: string;
  cosine_similarity: number;
  description: string;
  tags: string[];
  actual_volume: number;
  guide_volume: number;
  achievement_rate: number;
  focus_customers: string[];
  market_features: MarketFeature[];
}

// ── Unified payload ───────────────────────────────────────

export interface SalesGuidePayload {
  customer: string;
  product: string;
  generated_at: string;
  // Module 1
  achievement_kpi: AchievementKpi;
  customer_achievements: CustomerAchievement[];
  // Module 2
  market_signal: MarketSignal;
  key_features: KeyFeature[];
  grade_summary: GradeSummary;
  customer_opportunities: CustomerOpportunity[];
  // Module 3
  market_summary: MarketSummaryItem[];
  similarity_timeline: SimilarityPoint[];
  similar_periods: SimilarPeriod[];
}
