/**
 * 판매량 가이드 대시보드 Mock 데이터 — MSW 핸들러 전용.
 *
 * 이가은 / 철강1팀 / 후판 담당 시나리오 기반.
 * 5개 고객사: 한화오션, 현대중공업, 삼성중공업, 포스코건설, 포스코인터내셔널
 */

import type {
  CustomerAchievement,
  CustomerOpportunity,
  KeyFeature,
  MarketSummaryItem,
  SalesGuidePayload,
  SimilarityPoint,
  SimilarPeriod,
} from '@/types';

// ── Module 1 고객사별 달성률 ─────────────────────────────

const CUSTOMER_ACHIEVEMENTS: CustomerAchievement[] = [
  {
    customer_id: '한화오션',
    customer_name: '한화오션',
    industry: '조선 (특수선)',
    achievement_rate: 0.88,
    actual_volume: 26.4,
    guide_volume: 30,
    volume_unit: '천톤',
    yoy_change: 0.18,
    status: 'normal',
  },
  {
    customer_id: '현대중공업',
    customer_name: '현대중공업',
    industry: '조선 (상선)',
    achievement_rate: 0.72,
    actual_volume: 14.4,
    guide_volume: 20,
    volume_unit: '천톤',
    yoy_change: 0.05,
    status: 'warning',
  },
  {
    customer_id: '삼성중공업',
    customer_name: '삼성중공업',
    industry: '조선 (LNG선)',
    achievement_rate: 0.65,
    actual_volume: 19.5,
    guide_volume: 30,
    volume_unit: '천톤',
    yoy_change: -0.03,
    status: 'warning',
  },
  {
    customer_id: '포스코건설',
    customer_name: '포스코건설',
    industry: '건설 (플랜트)',
    achievement_rate: 0.38,
    actual_volume: 7.6,
    guide_volume: 20,
    volume_unit: '천톤',
    yoy_change: -0.11,
    status: 'danger',
  },
  {
    customer_id: '포스코인터내셔널',
    customer_name: '포스코인터내셔널',
    industry: '글로벌 트레이딩',
    achievement_rate: 0.47,
    actual_volume: 25.9,
    guide_volume: 55,
    volume_unit: '천톤',
    yoy_change: -0.06,
    status: 'danger',
  },
];

// ── Module 2 KEY_FEATURES ─────────────────────────────────

const KEY_FEATURES: KeyFeature[] = [
  // DAILY
  { rank: 2, name: '중국 철광석 수입가 (호주산 62% 분광)', weight: 15, direction: 'UP', change: '+3.8%', cycle: 'DAILY' },
  { rank: 3, name: '열연(HR) Coil 선물가 (상하이 선물거래소)', weight: 15, direction: 'FLAT', change: '+1.2%', cycle: 'DAILY' },
  { rank: 8, name: '미국 10년 만기 국채 수익률', weight: 8, direction: 'DOWN', change: '-0.18%p', cycle: 'DAILY' },
  { rank: 9, name: '다우존스 산업평균지수', weight: 6, direction: 'UP', change: '+2.1%', cycle: 'DAILY' },
  // WEEKLY
  { rank: 1, name: '중국 중후판(Plate) 20mm 유통가', weight: 20, direction: 'FLAT', change: '+0.8%', cycle: 'WEEKLY' },
  { rank: 4, name: '중국 후판(Plate) Mill 재고', weight: 10, direction: 'DOWN', change: '-2.4%', cycle: 'WEEKLY' },
  { rank: 5, name: '동아시아 벌크선 운임지수 (BDI)', weight: 9, direction: 'UP', change: '+2.2%', cycle: 'WEEKLY' },
  // MONTHLY
  { rank: 10, name: '한국은행 기준금리', weight: 6, direction: 'DOWN', change: '-0.25%p', cycle: 'MONTHLY' },
];

// ── Module 2 고객사 기회/리스크 ─────────────────────────────

const CUSTOMER_OPPORTUNITIES: CustomerOpportunity[] = [
  {
    customer_id: '한화오션',
    customer_name: '한화오션',
    grade: 'A',
    score: 87,
    industry: '조선 (특수선/상선)',
    achievement_rate: 0.88,
    opportunity_tags: ['추가 발주 가능', '단가 협상 우호적', 'LNG선 수주 증가'],
    risk_tags: [],
    rule_tag: '선가(Newbuilding Price) 추이 → 후판가 연동성',
    rule_tag_type: 'info',
    sensitivity_tags: ['수주량', '선가 지수', '환율(USD/KRW)'],
    metrics: [
      { label: '당월 수주 (D)', value: '91점', sub: '전월 대비 +12' },
      { label: '전년 대비 (①)', value: '+18%', sub: '전년 동기 기준' },
      { label: '시황 영향 ②', value: '+1.8%', sub: '간접 영향' },
    ],
  },
  {
    customer_id: '현대중공업',
    customer_name: '현대중공업',
    grade: 'A-',
    score: 63,
    industry: '조선 (상선/컨테이너)',
    achievement_rate: 0.72,
    opportunity_tags: ['컨테이너선 수주 확대', '4Q 대규모 발주 가능성'],
    risk_tags: [],
    rule_tag: '선가(Newbuilding Price) 추이 → 후판가 연동성',
    rule_tag_type: 'info',
    sensitivity_tags: ['수주량', '철광석 가격', '납기 일정'],
    metrics: [
      { label: '당월 수주 (D)', value: '61점', sub: '전월 대비 +5' },
      { label: '전년 대비 (①)', value: '+5%', sub: '전년 동기 기준' },
      { label: '시황 영향 ②', value: '+1.8%', sub: '간접 영향' },
    ],
  },
  {
    customer_id: '삼성중공업',
    customer_name: '삼성중공업',
    grade: 'B+',
    score: 57,
    industry: '조선 (LNG선)',
    achievement_rate: 0.65,
    opportunity_tags: [],
    risk_tags: ['단가 재협상 요청', '경쟁사 견제'],
    rule_tag: 'LNG선 발주 사이클 → 후판 발주 연동',
    rule_tag_type: 'warning',
    sensitivity_tags: ['LNG 가격', '수주 사이클', '원자재 조달'],
    metrics: [
      { label: '당월 수주 (D)', value: '55점', sub: '전월 대비 -3' },
      { label: '전년 대비 (①)', value: '-3%', sub: '전년 동기 기준' },
      { label: '시황 영향 ②', value: '+1.8%', sub: '간접 영향' },
    ],
  },
  {
    customer_id: '포스코건설',
    customer_name: '포스코건설',
    grade: 'B',
    score: 38,
    industry: '건설 (플랜트)',
    achievement_rate: 0.38,
    opportunity_tags: ['6월 발주 준비'],
    risk_tags: ['5월 예산 소진', '잔여 발주 소규모'],
    rule_tag: '플랜트 발주 → 후판가 협상 연동',
    rule_tag_type: 'danger',
    sensitivity_tags: ['예산 집행 일정', '플랜트 수주', '환율'],
    metrics: [
      { label: '당월 수주 (D)', value: '32점', sub: '전월 대비 -8' },
      { label: '전년 대비 (①)', value: '-11%', sub: '전년 동기 기준' },
      { label: '시황 영향 ②', value: '+1.8%', sub: '간접 영향' },
    ],
  },
  {
    customer_id: '포스코인터내셔널',
    customer_name: '포스코인터내셔널',
    grade: 'C',
    score: 44,
    industry: '글로벌 트레이딩',
    achievement_rate: 0.47,
    opportunity_tags: [],
    risk_tags: ['발주 일정 지연', '내부 승인 변경', '달성률 52% 위험'],
    rule_tag: '글로벌 트레이딩 → 환율 변동 민감',
    rule_tag_type: 'danger',
    sensitivity_tags: ['환율(USD/KRW)', '글로벌 수요', '트레이딩 마진'],
    metrics: [
      { label: '당월 수주 (D)', value: '40점', sub: '전월 대비 -6' },
      { label: '전년 대비 (①)', value: '-6%', sub: '전년 동기 기준' },
      { label: '시황 영향 ②', value: '+1.8%', sub: '간접 영향' },
    ],
  },
];

// ── Module 3 현재 시황 요약 ─────────────────────────────────

const MARKET_SUMMARY: MarketSummaryItem[] = [
  { name: '중국 중후판 20mm 유통가', value: '3,210 —', direction: 'FLAT' },
  { name: '중국 철광석 수입가 (62%)', value: '104 USD', direction: 'UP' },
  { name: '열연 Coil 선물가 (상하이)', value: '3,210 —', direction: 'FLAT' },
  { name: '중국 후판 Mill 재고', value: '↓ 감소', direction: 'DOWN' },
  { name: '미국 10년 국채 수익률', value: '4.2%', direction: 'DOWN' },
  { name: '한국은행 기준금리', value: '2.75%', direction: 'DOWN' },
];

// ── Module 3 유사도 타임라인 ─────────────────────────────────

const SIMILARITY_TIMELINE: SimilarityPoint[] = [
  { label: '25.03', score: 14, highlighted: false, is_current: false },
  { label: '04', score: 9, highlighted: false, is_current: false },
  { label: '05', score: 12, highlighted: false, is_current: false },
  { label: '06', score: 8, highlighted: false, is_current: false },
  { label: '07', score: 16, highlighted: false, is_current: false },
  { label: '08', score: 20, highlighted: false, is_current: false },
  { label: '09', score: 70, highlighted: true, is_current: false },
  { label: '10', score: 22, highlighted: false, is_current: false },
  { label: '11', score: 14, highlighted: false, is_current: false },
  { label: '12', score: 50, highlighted: true, is_current: false },
  { label: '26.01', score: 18, highlighted: false, is_current: false },
  { label: '02', score: 59, highlighted: true, is_current: false },
  { label: '03', score: 28, highlighted: false, is_current: false },
  { label: '04', score: 11, highlighted: false, is_current: false },
  { label: '05▸', score: 34, highlighted: false, is_current: true },
];

// ── Module 3 TOP3 유사 시황 ─────────────────────────────────

const SIMILAR_PERIODS: SimilarPeriod[] = [
  {
    rank: 1,
    period: '2025년 9월',
    cosine_similarity: 0.88,
    description: '조선 수주 급증 + 중국 수출 감소 구간. 후판 수요 우위 형성, 가이드 초과 달성.',
    tags: ['조선 수주 급증', '중국 수출 감소', '수요 우위'],
    actual_volume: 336,
    guide_volume: 300,
    achievement_rate: 1.12,
    focus_customers: ['한화오션', '현대중공업', '삼성중공업', '포스코인터내셔널', '포스코건설'],
    market_features: [
      { name: '중국 중후판 20mm 유통가', value: '3,190 CNY' },
      { name: '후판 Mill 재고', value: '128만톤' },
      { name: '후판 Mill 생산량', value: '1,240만톤' },
      { name: '후판 Mill 운영률', value: '74.2%' },
      { name: '동아시아 철스크랩 수입가', value: '312 USD' },
      { name: '미국 10년 국채 수익률', value: '4.1%' },
      { name: '다우존스', value: '38,200' },
      { name: '한국은행 기준금리', value: '3.0%' },
    ],
  },
  {
    rank: 2,
    period: '2025년 12월',
    cosine_similarity: 0.62,
    description: '연말 예산 소진 + 계절성 수요 둔화. 일부 고객사 발주 지연 발생.',
    tags: ['연말 예산 소진', '계절성 둔화', '발주 지연'],
    actual_volume: 222,
    guide_volume: 300,
    achievement_rate: 0.74,
    focus_customers: ['포스코인터내셔널', '한화오션', '현대중공업'],
    market_features: [
      { name: '중국 중후판 20mm 유통가', value: '3,420 CNY' },
      { name: '철광석 수입가 (62%)', value: '88 USD' },
      { name: '후판 Mill 생산량', value: '1,180만톤' },
      { name: '후판 Mill 재고', value: '145만톤' },
      { name: '동아시아 철스크랩 수입가', value: '295 USD' },
      { name: '미국 10년 국채 수익률', value: '4.6%' },
      { name: '다우존스', value: '37,800' },
      { name: '한국은행 기준금리', value: '3.25%' },
    ],
  },
  {
    rank: 3,
    period: '2026년 3월',
    cosine_similarity: 0.74,
    description: '분기 초 발주 회복 + 철광석 가격 안정. 완만한 상승세로 목표 근접 달성.',
    tags: ['분기 초 회복', '철광석 안정', '목표 근접'],
    actual_volume: 294,
    guide_volume: 300,
    achievement_rate: 0.98,
    focus_customers: ['삼성중공업', '한화오션'],
    market_features: [
      { name: '중국 중후판 20mm 유통가', value: '3,280 CNY' },
      { name: '철광석 수입가 (62%)', value: '91 USD' },
      { name: '후판 Mill 생산량', value: '1,210만톤' },
      { name: '후판 Mill 재고', value: '132만톤' },
      { name: '동아시아 철스크랩 수입가', value: '305 USD' },
      { name: '미국 10년 국채 수익률', value: '4.3%' },
      { name: '다우존스', value: '39,100' },
      { name: '한국은행 기준금리', value: '2.75%' },
    ],
  },
];

// ── Builder ───────────────────────────────────────────────

export function buildSalesGuidePayload(customerId: string): SalesGuidePayload {
  return {
    customer: customerId,
    product: '후판',
    generated_at: new Date().toISOString(),
    achievement_kpi: {
      achievement_rate: 0.61,
      yoy_change: 0.09,
      actual_volume: 183,
      guide_volume: 300,
      volume_unit: '천톤',
    },
    customer_achievements: CUSTOMER_ACHIEVEMENTS,
    market_signal: {
      status: '중립',
      score: 1.8,
      description: '일부 지표 상승, 전반적 보합세',
      responsible: '이가은',
    },
    key_features: KEY_FEATURES,
    grade_summary: { grade_a: 1, grade_b: 2, grade_c: 2 },
    customer_opportunities: CUSTOMER_OPPORTUNITIES,
    market_summary: MARKET_SUMMARY,
    similarity_timeline: SIMILARITY_TIMELINE,
    similar_periods: SIMILAR_PERIODS,
  };
}
