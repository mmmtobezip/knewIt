/**
 * Mock 데이터 (개발용)
 *
 * 원본 index.html mockup 의 productData / customerData 구조 유지.
 *
 * 분기 규칙 (index.html 패턴):
 * - 제품(product)  → 차트, 변동률, 변동 원인 플로우, AI 진단 (WHAT/WHY/IMPACT)
 * - 고객사(customer) → 추천 질문, 답변, 권장 전략
 *
 * 제품과 고객사는 서로 독립적으로 선택 가능.
 */

import type {
  CustomerProfile,
  TriggerEvent,
  AnalysisResult,
  CausalChain,
  Strategy,
  NewsDoc,
  TodayQuestion,
  IndicatorTimeseries,
} from '@/types';

// ──────────────────────────────────────────────────────
// 제품 카탈로그 (고정 4종)
// ──────────────────────────────────────────────────────
export const PRODUCTS = [
  { code: 'hotrolled', name: '열연강판' },
  { code: 'coldrolled', name: '냉연강판' },
  { code: 'galvanized', name: '아연도금강판' },
  { code: 'rebar', name: '철근' },
] as const;

export type ProductCode = (typeof PRODUCTS)[number]['code'];

// ──────────────────────────────────────────────────────
// 고객사 카탈로그 (고정 4종, index.html 매핑)
// ──────────────────────────────────────────────────────
export const CUSTOMERS = [
  { id: 'hyundai', name: '현대자동차' },
  { id: 'kia', name: '기아' },
  { id: 'samsung', name: '삼성중공업' },
  { id: 'hyundaiheavy', name: '현대중공업' },
] as const;

export type CustomerId = (typeof CUSTOMERS)[number]['id'];

/** 권한 기반 고객사 매핑 (mock: 모든 사용자가 전체 조회) */
export const ASSIGNED_CUSTOMER_IDS: string[] = CUSTOMERS.map((c) => c.id);

// ──────────────────────────────────────────────────────
// 고객사 프로필 (협상 컨텍스트용)
// ──────────────────────────────────────────────────────
export const CUSTOMER_PROFILES: Record<string, CustomerProfile> = {
  hyundai: {
    customer_id: 'hyundai',
    product: '강판 전반',
    industry: '자동차',
    region: '한국',
    sensitivity: ['공급 안정성', '품질', '장기 파트너십'],
    key_features: ['열연 가격', '냉연 가격', '환율', '자동차 생산량'],
    negotiation_style: '안정 공급형',
  },
  kia: {
    customer_id: 'kia',
    product: '강판 전반',
    industry: '자동차/EV',
    region: '한국',
    sensitivity: ['EV 수요', '경량화', '글로벌 공급'],
    key_features: ['고장력 강판 수요', 'EV 생산량', '환율'],
    negotiation_style: 'R&D 협력형',
  },
  samsung: {
    customer_id: 'samsung',
    product: '후판',
    industry: '조선/해양',
    region: '한국',
    sensitivity: ['LNG선 수주', '특수강', '납기'],
    key_features: ['후판 가격', '9% Ni강 수요', 'LNG 수주량'],
    negotiation_style: '슈퍼사이클 대응형',
  },
  hyundaiheavy: {
    customer_id: 'hyundaiheavy',
    product: '후판/특수강',
    industry: '조선/엔진',
    region: '한국',
    sensitivity: ['신규 도크', '품질 일관성', '긴급 납기'],
    key_features: ['후판 가격', '극저온 강재', '친환경 강재 수요'],
    negotiation_style: '품질 차별화형',
  },
};

// ──────────────────────────────────────────────────────
// 제품별 데이터 (index.html productData 1:1 매핑)
// ──────────────────────────────────────────────────────

const DATES_1M = [
  '2026-04-08', '2026-04-10', '2026-04-12', '2026-04-14', '2026-04-16',
  '2026-04-18', '2026-04-20', '2026-04-22', '2026-04-24', '2026-04-26',
  '2026-04-28', '2026-04-30', '2026-05-02', '2026-05-04', '2026-05-05',
  '2026-05-06', '2026-05-07', '2026-05-08', '2026-05-08',
];

interface ProductDataEntry {
  name: string;
  price: number;
  change_rate: number;
  feature: string;
  unit: string;
  chartData: number[];
  flow: string[];
  interpretation: string;
  diag: AnalysisResult;
}

export const PRODUCT_DATA: Record<ProductCode, ProductDataEntry> = {
  hotrolled: {
    name: '열연강판',
    price: 580,
    change_rate: -4.2,
    feature: '상하이 열연 선물가',
    unit: 'USD/톤',
    chartData: [635, 638, 642, 645, 648, 652, 650, 645, 640, 635, 628, 620, 615, 608, 600, 595, 590, 585, 580],
    flow: [
      '중국 제조업 PMI 지수 하락',
      '중국 철강 수요 둔화 우려',
      '수출 물량 증가 (공급 과잉)',
      '글로벌 열연 강판 가격 하락',
    ],
    interpretation:
      '중국 내수 둔화로 인한 수요 감소 우려가 수출 증가로 이어지며, 글로벌 공급 과잉이 심화되어 가격 하락 압력으로 작용',
    diag: {
      what: '열연강판 가격은 전주 대비 4.2% 하락하여 톤당 $580 기록. 향후 2~4주 추가 하락 가능성 높음',
      why: ['중국 제조업 PMI 하락', '내수 수요 둔화 우려 확대', '수출 증가로 공급 과잉 심화', '원료(철광석/원료탄) 가격 약세 지속'],
      impact: ['글로벌 열연 가격 추가 하락 압력', '고객사 가격 인하 요구 증가 가능성', '마진 압박 확대 및 수익성 악화 위험'],
    },
  },
  coldrolled: {
    name: '냉연강판',
    price: 720,
    change_rate: -2.8,
    feature: '냉연강판 시세',
    unit: 'USD/톤',
    chartData: [760, 758, 755, 752, 750, 748, 745, 742, 740, 738, 735, 732, 730, 728, 725, 724, 722, 721, 720],
    flow: ['글로벌 자동차 생산 감소', '냉연 수요 위축', '재고 부담 가중', '냉연강판 가격 약세'],
    interpretation:
      '자동차 및 가전 수요 둔화로 냉연강판 수요가 위축되며, 제조사 재고 부담이 가격 하락 압력으로 작용',
    diag: {
      what: '냉연강판 가격은 전주 대비 2.8% 하락하여 톤당 $720 기록. 자동차 수요 둔화 영향 지속',
      why: ['글로벌 자동차 생산 감소', '가전 수요 둔화', '냉연 재고 누적', '대체재(수입재) 가격 경쟁 심화'],
      impact: ['고급 강재 마진 압박 확대', '자동차사 가격 인하 요구', '재고 회전율 저하 우려'],
    },
  },
  galvanized: {
    name: '아연도금강판',
    price: 810,
    change_rate: -1.5,
    feature: '아연도금강판 시세',
    unit: 'USD/톤',
    chartData: [830, 828, 826, 824, 822, 820, 819, 818, 817, 816, 815, 814, 813, 812, 811, 811, 810, 810, 810],
    flow: ['아연 LME 가격 하락', '건설 수요 둔화', '재고 증가', '아연도금강판 가격 하락'],
    interpretation: '아연 원자재 가격 하락과 건설 경기 부진이 겹치며, 아연도금강판 가격 약세가 점진적으로 진행',
    diag: {
      what: '아연도금강판 가격은 전주 대비 1.5% 하락하여 톤당 $810 기록. 건설 수요 회복 지연',
      why: ['아연 LME 시세 하락', '건설 경기 둔화', '재고 누적 부담', '수출 단가 압박'],
      impact: ['건설용 강재 마진 축소', '가격 인하 요구 증가', '판매량 회복 지연 우려'],
    },
  },
  rebar: {
    name: '철근',
    price: 495,
    change_rate: -5.6,
    feature: '철근 시세',
    unit: 'USD/톤',
    chartData: [540, 538, 535, 532, 528, 525, 522, 520, 518, 515, 512, 510, 508, 505, 502, 500, 498, 496, 495],
    flow: ['국내 건설 착공 감소', '철근 수요 급감', '제강사 가동률 하락', '철근 시세 급락'],
    interpretation: '건설 경기 침체로 철근 수요가 급감하며, 제강사 가동률 하락에도 가격 방어가 어려운 상황',
    diag: {
      what: '철근 가격은 전주 대비 5.6% 하락하여 톤당 $495 기록. 건설 침체로 단기 반등 어려움',
      why: ['국내 건설 착공 감소', '주택 분양 부진', '제강사 재고 누적', '수입재 저가 공세'],
      impact: ['철근 수익성 악화', '제강 가동률 추가 하락 위험', '건설사 단가 인하 요구 강화'],
    },
  },
};

// ──────────────────────────────────────────────────────
// 제품별 파생 데이터 (API 응답용)
// ──────────────────────────────────────────────────────

/** 제품-기반 trigger_event (change_rate >= 3% 만 발생) */
export function getTriggerEvent(product: ProductCode | string): TriggerEvent | null {
  const p = PRODUCT_DATA[product as ProductCode];
  if (!p) return null;
  if (Math.abs(p.change_rate) < 3) return null;
  return {
    event_id: `EVT-20260508-${product}`,
    feature: p.feature,
    change_rate: p.change_rate,
    direction: p.change_rate < 0 ? 'DOWN' : 'UP',
    date: '2026-05-08',
  };
}

/** 제품-기반 지표 시계열 */
export function getIndicatorTimeseries(product: ProductCode | string): IndicatorTimeseries | null {
  const p = PRODUCT_DATA[product as ProductCode];
  if (!p) return null;
  return {
    feature_name: p.feature,
    unit: p.unit,
    latest: { date: '2026-05-08', value: p.price, change_rate: p.change_rate },
    series: p.chartData.map((value, i) => ({
      date: DATES_1M[i] ?? '2026-05-08',
      value,
    })),
  };
}

/** 제품-기반 분석 결과 */
export function getAnalysisResult(product: ProductCode | string): AnalysisResult | null {
  return PRODUCT_DATA[product as ProductCode]?.diag ?? null;
}

/** 제품-기반 원인 흐름 */
export function getCausalChain(product: ProductCode | string): CausalChain | null {
  const p = PRODUCT_DATA[product as ProductCode];
  if (!p) return null;
  return { chain: p.flow, interpretation: p.interpretation };
}

// ──────────────────────────────────────────────────────
// 고객사별 데이터 (index.html customerData 1:1 매핑)
// ──────────────────────────────────────────────────────

interface CustomerDataEntry {
  questions: TodayQuestion[];
  /** 추천 질문 idx 별 사전 답변 (mock: SSE 청크로 흘려보냄) */
  answers: string[];
  strategy: Strategy;
}

export const CUSTOMER_DATA: Record<CustomerId, CustomerDataEntry> = {
  hyundai: {
    questions: [
      { question_id: 'Q-hyundai-1', priority: 1, question: '열연 가격 하락세는 언제까지 지속될 가능성이 높을까요?' },
      { question_id: 'Q-hyundai-2', priority: 2, question: '현대자동차와 가격 협상 시 어떤 포인트를 강조해야 할까요?' },
      { question_id: 'Q-hyundai-3', priority: 3, question: '원가 하락 요인이 반영되기 전, 마진 방어 전략은 무엇이 효과적일까요?' },
    ],
    answers: [
      '현재 가격 하락세는 단기적으로 2~4주 추가 지속될 가능성이 높습니다.\n중국 내수 둔화와 수출 증가로 인한 공급 과잉이 주요 요인으로 작용하고 있으며, 글로벌 원료 가격 하락 압력도 이어지고 있습니다.\n다만, 6월 이후 중국의 정책 대응과 계절적 수요 회복 여부에 따라 하락 폭은 점진적으로 둔화될 것으로 예상됩니다.',
      '현대자동차와의 협상에서는 장기 안정 공급과 품질 신뢰도를 핵심 포인트로 강조해야 합니다.\n단기 가격 인하 압박에 응대하기보다는, 차세대 전기차 강판 협력과 JIT 납입 안정성을 카드로 활용하는 전략이 효과적입니다.',
      '원가 하락 반영 시점을 늦추기 위해 물량 연동 계약 및 장기 ASP 협정 체결을 추천드립니다.\n내부적으로는 원가 절감 TF 가동과 고부가가치 강종 비중 확대로 마진 방어선을 구축하는 전략이 유효합니다.',
    ],
    strategy: {
      summary:
        '단기 가격 방어보다 고객 신뢰 유지에 집중하며, 시장 변동성 속에서 공급 안정성과 차별화된 가치를 강조하는 전략이 필요합니다.',
      actions: [
        '선제 커뮤니케이션 진행',
        '시장 및 원가 변동 데이터 공유',
        '장기 계약 또는 물량 연동 조건 제안',
        '내부 원가 절감 및 효율화 추진',
      ],
      negotiation_point: '단기 가격보다 공급 안정성과 파트너십 가치를 강조하세요.',
      quote: "'가격보다 공급 안정성이 더 큰 가치를 제공합니다.'",
    },
  },
  kia: {
    questions: [
      { question_id: 'Q-kia-1', priority: 1, question: '기아 EV 라인 강판 수요는 어떤 추세인가요?' },
      { question_id: 'Q-kia-2', priority: 2, question: '기아와의 단가 협상 시 어떤 카드를 활용해야 할까요?' },
      { question_id: 'Q-kia-3', priority: 3, question: '소형 SUV 차종 확대에 따른 강종 믹스 전략은?' },
    ],
    answers: [
      '기아의 EV 라인 강판 수요는 전년 대비 18% 성장하고 있으며, 특히 고장력 강판 비중이 빠르게 확대되는 추세입니다.\nEV9, EV6 등 주력 모델의 글로벌 생산 확대로 향후 12개월간 안정적 수요가 지속될 것으로 전망됩니다.',
      '기아와의 협상에서는 EV 전용 강종 공동 개발과 해외 공장 글로벌 공급망을 카드로 활용하는 것이 효과적입니다.\n가격보다는 신차 모델 공동 R&D를 강조해 협상 우위를 확보하세요.',
      '소형 SUV 비중 확대에 따라 경량화 고장력 강판 비중을 30% 이상으로 늘리는 믹스 전환이 필요합니다.\n동시에 도금재 라인업 확장을 통해 단가 인상 여력을 확보하는 전략이 유효합니다.',
    ],
    strategy: {
      summary: '기아의 EV 라인 성장에 맞춰 고부가가치 강종 비중 확대와 전략적 파트너십 강화에 집중하는 전략이 필요합니다.',
      actions: [
        'EV 전용 강종 공동 개발 제안',
        '글로벌 공장 공급 확대 협의',
        '경량화 강판 단가 차별화',
        '신규 강종 인증 일정 가속화',
      ],
      negotiation_point: '신차 R&D 협력과 EV 전용 강종 공급 역량을 어필하세요.',
      quote: "'기아의 EV 성공 파트너로 함께하겠습니다.'",
    },
  },
  samsung: {
    questions: [
      { question_id: 'Q-samsung-1', priority: 1, question: '조선용 후판 가격 전망은 어떻게 봐야 할까요?' },
      { question_id: 'Q-samsung-2', priority: 2, question: '삼성중공업 LNG선 수주 확대에 따른 공급 전략은?' },
      { question_id: 'Q-samsung-3', priority: 3, question: '해양플랜트 강재 수요 회복 시점은 언제일까요?' },
    ],
    answers: [
      '조선용 후판 가격은 LNG선 수주 호조로 견조한 흐름을 유지할 전망입니다.\n다만, 중국산 후판의 저가 공세가 변수로 작용하고 있어 국내 후판 가격은 강보합 흐름이 예상됩니다.',
      'LNG선 수주 확대에 대응해 고장력 후판 우선 배정 협약을 체결하고, 분기별 공급 물량 사전 합의로 안정적 공급망을 구축하는 전략이 필요합니다.\n특히 9% Ni강 등 특수 강종 공급 역량을 적극 어필하세요.',
      '해양플랜트 강재 수요는 2026년 하반기부터 회복될 것으로 전망됩니다.\n중동 및 동남아 지역 신규 프로젝트 발주가 본격화되면서 고급 후판 수요 확대가 예상됩니다.',
    ],
    strategy: {
      summary: '조선업 슈퍼사이클에 맞춰 고급 후판 우선 공급과 장기 협력 기반 구축에 집중하는 전략이 필요합니다.',
      actions: [
        'LNG선용 후판 우선 배정 협약',
        '특수 강종 공동 인증 추진',
        '분기별 물량 사전 합의',
        '신규 프로젝트 사전 영업 강화',
      ],
      negotiation_point: '조선 슈퍼사이클 대응을 위한 안정적 공급 파트너십을 제안하세요.',
      quote: "'슈퍼사이클의 든든한 동반자가 되겠습니다.'",
    },
  },
  hyundaiheavy: {
    questions: [
      { question_id: 'Q-hh-1', priority: 1, question: '현대중공업 신규 도크 가동에 따른 강재 수요 전망은?' },
      { question_id: 'Q-hh-2', priority: 2, question: '특수 후판 단가 인상 협상 타이밍은 언제가 좋을까요?' },
      { question_id: 'Q-hh-3', priority: 3, question: '경쟁사 대비 차별화 포인트는 무엇인가요?' },
    ],
    answers: [
      '현대중공업 신규 도크 가동으로 연간 후판 수요가 약 25% 증가할 것으로 예상됩니다.\n특히 컨테이너선과 LNG선 동시 건조 체제 구축으로 고장력 후판 수요가 큰 폭으로 증가할 전망입니다.',
      '특수 후판 단가 인상은 3분기 초가 최적 타이밍입니다.\n원료가 반등과 환율 상승 효과를 근거로 활용할 수 있으며, 경쟁사 대비 품질 우위를 강조해 협상력을 확보하세요.',
      '주요 차별화 포인트는 품질 일관성, 긴급 대응 능력, R&D 협력 역량입니다.\n특히 극저온용 강재와 친환경 선박용 강재 라인업이 경쟁사 대비 우위 요소로 작용할 수 있습니다.',
    ],
    strategy: {
      summary: '신규 도크 가동 수요에 맞춘 안정적 공급 약속과 품질 차별화 기반 협상력 강화 전략이 필요합니다.',
      actions: [
        '신규 도크 전용 공급 협약',
        '극저온/친환경 강재 라인업 제안',
        '품질 일관성 데이터 공유',
        '긴급 납기 대응 SLA 협의',
      ],
      negotiation_point: '품질 차별화와 긴급 대응 역량을 핵심 강점으로 어필하세요.',
      quote: "'품질로 증명하는 든든한 파트너입니다.'",
    },
  },
};

export function getTodayQuestions(customer: CustomerId | string): TodayQuestion[] {
  return CUSTOMER_DATA[customer as CustomerId]?.questions ?? [];
}

export function getStrategy(customer: CustomerId | string): Strategy | null {
  return CUSTOMER_DATA[customer as CustomerId]?.strategy ?? null;
}

export function getQuestionAnswer(customer: CustomerId | string, questionId: string): string | null {
  const c = CUSTOMER_DATA[customer as CustomerId];
  if (!c) return null;
  const idx = c.questions.findIndex((q) => q.question_id === questionId);
  if (idx < 0) return null;
  return c.answers[idx] ?? null;
}

// ──────────────────────────────────────────────────────
// 뉴스 (글로벌)
// ──────────────────────────────────────────────────────
export const NEWS_DOCS: NewsDoc[] = [
  {
    source: 'Reuters',
    title: 'China steel demand wanes as property investment slows',
    summary: '중국 부동산 투자 둔화로 철강 수요 약세 지속',
    url: 'https://www.reuters.com/markets/commodities/',
    published_at: '2025-05-07T10:00:00+09:00',
  },
  {
    source: 'Bloomberg',
    title: 'Hot-rolled coil prices slide as Chinese exports surge',
    summary: '중국 수출 증가로 글로벌 열연 강판 가격 하락',
    url: 'https://www.bloomberg.com/markets/commodities',
    published_at: '2025-05-06T09:00:00+09:00',
  },
  {
    source: 'Mysteel',
    title: '5월 중국 철강 수출 전월비 12% 증가 전망',
    summary: '중국 내수 둔화에 따른 수출 드라이브 본격화',
    url: 'https://www.mysteel.net/',
    published_at: '2025-05-06T14:00:00+09:00',
  },
  {
    source: 'CRU',
    title: 'Steel margins under pressure across Asia',
    summary: '아시아 철강사 마진 압박 심화',
    url: 'https://www.crugroup.com/analysis/steel/',
    published_at: '2025-05-05T11:00:00+09:00',
  },
  {
    source: 'Financial Times',
    title: 'Iron ore prices fall as China demand worries deepen',
    summary: '중국 수요 우려로 철광석 가격 약세',
    url: 'https://www.ft.com/commodities',
    published_at: '2025-05-03T08:00:00+09:00',
  },
  {
    source: 'Nikkei',
    title: '아시아 철강 시장 전망: 2분기 보합 흐름 예상',
    summary: '계절적 수요 회복 가능성과 공급 과잉 우려가 혼재',
    url: 'https://asia.nikkei.com/',
    published_at: '2025-05-02T15:00:00+09:00',
  },
  {
    source: 'WSJ',
    title: 'Global steel inventory builds raise oversupply alarm',
    summary: '글로벌 철강 재고 누적으로 공급 과잉 경고음',
    url: 'https://www.wsj.com/',
    published_at: '2025-05-01T13:00:00+09:00',
  },
];
