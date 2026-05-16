/**
 * PRD 0514 도메인 타입 (FE).
 *
 * 새 메인 대시보드 통합 응답 + 추천 질문 Agent v1.1 구조.
 */

export type DateString = string;
export type DateTimeString = string;
export type UrlString = string;
export type Direction = 'UP' | 'DOWN';

// ── 고객사 프로필 (PRD 0514) ─────────────────────────────
export interface CustomerProfile {
  customer_id: string;
  industry: string;
  market_region: string;
  product_group: string[];
  sensitive_topics: string[];
  risk_factors: string[];
}

// ── Top Mover (차트1) ────────────────────────────────────
export interface IndicatorPoint {
  date: string;
  value: number;
}

export interface TopMover {
  indicator: string;
  value: number;
  unit: string;
  change_d1: number | null;
  change_w1: number;
  change_m1: number | null;
  score: number;
  series: IndicatorPoint[];
}

// ── Cause Flow (차트2) ───────────────────────────────────
export interface FlowEvidence {
  news_id: string;
  title: string;
  date: string;
  url: string;
}

export interface CauseFlowStep {
  step: number;
  node: string;
  evidence: FlowEvidence[];
}

// ── Interpretation (What/Why/Impact) ─────────────────────
export interface ImpactItem {
  risk_factor: string;
  direction: '증폭' | '완화' | '중립';
  reason: string;
}

export interface Interpretation {
  what: string;
  why: string;
  impact: ImpactItem[];
}

// ── Strategy ─────────────────────────────────────────────
export interface Strategy {
  strategy_summary: string;
  recommended_actions: string[];
  negotiation_points: string[];
}

// ── 통합 Dashboard ───────────────────────────────────────
export interface DashboardPayload {
  customer: string;
  product: string;
  generated_at: DateTimeString;
  chart1_top_movers: TopMover[];
  chart2_cause_flow: CauseFlowStep[];
  interpretation: Interpretation;
  strategy: Strategy;
}

// ── 추천 질문 (SMI-Bot v1.1) ─────────────────────────────
export interface TodayQuestion {
  qid: string;
  text: string;
  trigger_indicators: string[];
  related_groups_internal: string[];
  score: number;
}

export interface TodayQuestionsPayload {
  product: string;
  generated_at: DateTimeString;
  questions: TodayQuestion[];
}

// ── 답변 (SMI-Bot v1.1) ──────────────────────────────────
export interface QuestionAnswerSources {
  indicators: string[];
}

export interface QuestionAnswer {
  qid: string;
  briefing: string;
  sales_rep_script: string;
  sources: QuestionAnswerSources;
  confidence: number;
}

// ── 세션 ─────────────────────────────────────────────────
export type UserRole = 'sales' | 'manager' | 'admin';

export interface SessionUser {
  user_id: string;
  user_role: UserRole;
  name?: string;
}
