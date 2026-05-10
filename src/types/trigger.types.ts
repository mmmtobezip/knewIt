import type { AlertLevel, StrategyTone } from './common.types';
import type { AffectedCustomer } from './customer.types';

export interface CauseStep {
  id: string;
  label: string;
  sublabel: string;
  type: 'TRIGGER' | 'INTERMEDIATE' | 'KEY' | 'OUTCOME';
}

export interface NegotiationStrategy {
  tone: StrategyTone;
  title: string;
  description: string;
  expectedRisk: '낮음' | '중간' | '높음';
  expectedMarginRate: string;
}

export interface Trigger {
  id: string;
  indicatorName: string;
  changePercent: number;
  changeDirection: 'UP' | 'DOWN';
  alertLevel: AlertLevel;
  detectedAt: string;
  source: string;
  causeFlow: CauseStep[];
  affectedCustomers: AffectedCustomer[];
  strategies: NegotiationStrategy[];
}

export interface TriggerListResponse {
  triggers: Trigger[];
  alertCount: number;
}
