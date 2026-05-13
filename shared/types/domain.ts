/**
 * 도메인 엔티티 타입 정의
 *
 * 참조: main-ipo.md § 1-3 (Backend Data Source)
 * - 1-3-1 customer_profile
 * - 1-3-2 indicators
 * - 1-3-3 trigger_events
 * - 1-3-4 retrieved_docs (news)
 * - 1-3-5 analysis_result
 * - 1-3-6 causal_chain
 * - 1-3-7 strategy
 * - 1-3-8 today_questions
 */

// ─────────────────────────────────────────────────────────
// 공통 타입
// ─────────────────────────────────────────────────────────

/** ISO 8601 날짜 문자열 (예: "2026-05-08") */
export type DateString = string;

/** ISO 8601 날짜+시간 문자열 (예: "2026-05-08T09:30:00+09:00") */
export type DateTimeString = string;

/** URL 문자열 */
export type UrlString = string;

/** 변동 방향 */
export type Direction = 'UP' | 'DOWN';

// ─────────────────────────────────────────────────────────
// 1-3-1. CUSTOMER_PROFILE
// ─────────────────────────────────────────────────────────

/**
 * 고객사 프로필
 *
 * @example
 * {
 *   customer_id: "고려제강",
 *   product: "선재",
 *   industry: "와이어/건설",
 *   region: "한국",
 *   sensitivity: ["건설 경기", "원가", "국내 수요"],
 *   key_features: ["상하이 열연 선물가", "중국 부동산 개발 투자율", ...],
 *   negotiation_style: "가격 방어형"
 * }
 */
export interface CustomerProfile {
  /** PK */
  customer_id: string;
  /** 취급 제품 (예: 선재 / HR / 후판 / 부산물) */
  product: string;
  /** 산업군 */
  industry: string;
  /** 지역 */
  region: string;
  /** 협상 민감 요소 */
  sensitivity: string[];
  /** 모니터링 지표 */
  key_features: string[];
  /** 협상 스타일 */
  negotiation_style: string;
}

// ─────────────────────────────────────────────────────────
// 1-3-2. INDICATORS (지표 시계열)
// ─────────────────────────────────────────────────────────

/**
 * 지표 데이터 한 row
 */
export interface IndicatorPoint {
  /** key_features 와 매칭되는 지표명 */
  feature_name: string;
  /** 일자 */
  date: DateString;
  /** 지표 값 */
  value: number;
  /** 단위 (예: "USD/톤") */
  unit: string;
  /** 전일/전주 대비 % */
  change_rate: number;
}

/**
 * 지표 시계열 (차트용)
 */
export interface IndicatorTimeseries {
  feature_name: string;
  unit: string;
  /** 최신 값 */
  latest: {
    date: DateString;
    value: number;
    change_rate: number;
  };
  /** 시계열 포인트들 (period 범위 내) */
  series: Array<{
    date: DateString;
    value: number;
  }>;
}

// ─────────────────────────────────────────────────────────
// 1-3-3. TRIGGER EVENT
// ─────────────────────────────────────────────────────────

/**
 * 변동 이벤트 (조건: |change_rate| ≥ 3%)
 *
 * ※ severity 필드는 사용하지 않음 (Q8 결정).
 */
export interface TriggerEvent {
  /** PK (예: "EVT-20260508-001") */
  event_id: string;
  /** 변동 지표명 */
  feature: string;
  /** 변동률 % */
  change_rate: number;
  /** 변동 방향 */
  direction: Direction;
  /** 발생일 */
  date: DateString;
}

// ─────────────────────────────────────────────────────────
// 1-3-4. RETRIEVED DOCS (NEWS)
// ─────────────────────────────────────────────────────────

/**
 * MCP-News에서 수집한 뉴스 문서
 */
export interface NewsDoc {
  /** 뉴스 출처 (예: "Reuters", "Bloomberg") */
  source: string;
  /** 제목 */
  title: string;
  /** 요약 */
  summary: string;
  /** 원문 링크 */
  url: UrlString;
  /** 발행일시 */
  published_at: DateTimeString;
}

// ─────────────────────────────────────────────────────────
// 1-3-5. ANALYSIS RESULT
// ─────────────────────────────────────────────────────────

/**
 * LLM 분석 결과 (AI 진단 영역)
 */
export interface AnalysisResult {
  /** 무슨 일이 (단문) */
  what: string;
  /** 원인 (불릿 리스트) */
  why: string[];
  /** 영향 (불릿 리스트) */
  impact: string[];
}

// ─────────────────────────────────────────────────────────
// 1-3-6. CAUSAL CHAIN
// ─────────────────────────────────────────────────────────

/**
 * 원인 흐름 (변동 발생 원인 플로우)
 */
export interface CausalChain {
  /** 최대 5단계 */
  chain: string[];
  /** 핵심 해석 */
  interpretation: string;
}

// ─────────────────────────────────────────────────────────
// 1-3-7. STRATEGY
// ─────────────────────────────────────────────────────────

/**
 * 권장 대응 전략
 */
export interface Strategy {
  /** 전략 요약 */
  summary: string;
  /** 추천 행동 (번호 리스트) */
  actions: string[];
  /** 협상 포인트 */
  negotiation_point: string;
  /** 협상 멘트 예시 (인용) */
  quote: string;
}

// ─────────────────────────────────────────────────────────
// 1-3-8. TODAY QUESTIONS
// ─────────────────────────────────────────────────────────

/**
 * 오늘의 추천 질문
 *
 * ※ 답변은 사전 생성하지 않음 (Q3 결정). 클릭 시 LLM 호출.
 * ※ 항상 3개 (Q9 결정).
 */
export interface TodayQuestion {
  /** PK (예: "Q-001") */
  question_id: string;
  /** 질문 텍스트 */
  question: string;
  /** 추천 순위 (1, 2, 3) */
  priority: number;
}
