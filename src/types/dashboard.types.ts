import type { AlertLevel, ChangeDirection, ProductType } from './common.types';
import type { CustomerRisk } from './customer.types';

export interface CoreMessage {
  id: string;
  headline: string;
  subText: string;
  level: AlertLevel;
  ctaLabel: string;
  ctaRoute: string;
  triggerId?: string;
}

export interface Indicator {
  id: string;
  name: string;
  currentValue: string;
  unit: string;
  changePercent: number;
  changeDirection: ChangeDirection;
  alertLevel: AlertLevel;
  triggerId?: string;
}

export interface NewsItem {
  id: string;
  title: string;
  source: string;
  publishedAt: string;
  sentiment: 'POSITIVE' | 'NEGATIVE' | 'NEUTRAL';
  tags: string[];
  triggerId?: string;
}

export interface Question {
  id: string;
  text: string;
  weightedScore: number;
  answerSummary: string;
  customerId: string;
  product: ProductType;
}

export interface QuestionAnswer {
  questionId: string;
  answerText: string;
  fetchedAt: string;
}

export interface DashboardResponse {
  coreMessage: CoreMessage;
  indicators: Indicator[];
  news: NewsItem[];
  questions: Question[];
  customerRisks: CustomerRisk[];
}
