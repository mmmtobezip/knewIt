/**
 * PRD 0514 Mock 데이터 — MSW 핸들러 전용.
 *
 * .env.local: NEXT_PUBLIC_API_MOCKING=enabled 일 때 활성.
 *
 * 구성:
 * - CUSTOMERS / PRODUCTS: 카탈로그 (드롭다운, 라우팅 기준)
 * - CUSTOMER_PROFILES: 고객사 프로필 (PRD § 1-3-1)
 * - PRODUCT_MARKET_DATA: 제품 단위 — 차트1(TopMover), 차트2(CauseFlow), 해석(Interpretation)
 * - STRATEGY_BY_CUSTOMER: 고객사 단위 — 협상 전략
 * - TODAY_QUESTIONS_BY_PRODUCT: 제품별 추천 질문 3개
 *
 * 빌더:
 * - buildDashboardPayload(customerId): /api/dashboard 응답 조립
 * - buildTodayQuestionsPayload(productCode): /api/today-questions 응답 조립
 * - buildAnswerForQuestion(qid, text): /api/today-questions/answer 응답 조립
 */

import type {
  CauseFlowStep,
  CustomerProfile,
  DashboardPayload,
  IndicatorPoint,
  Interpretation,
  QuestionAnswer,
  Strategy,
  TodayQuestion,
  TodayQuestionsPayload,
  TopMover,
} from '@/types';

// ─────────────────────────────────────────────
// 카탈로그
// ─────────────────────────────────────────────

export const CUSTOMERS = [
  { id: '고려제강', name: '고려제강' },
  { id: 'Borcelik Celik Sanayii VE Ticaret AS', name: 'Borcelik (TR)' },
  { id: 'Nissan Motor Co., Ltd', name: 'Nissan Motor' },
  { id: 'Berg Steel Pipe Corp', name: 'Berg Steel Pipe' },
  { id: '썬시멘트주식회사', name: '썬시멘트' },
  { id: 'New Best Wire Industrial Co., Ltd', name: 'New Best Wire' },
  { id: 'JFE Techno Wire Corporation', name: 'JFE Techno Wire' },
  { id: '동일제강', name: '동일제강' },
  { id: '세아씨엠', name: '세아씨엠' },
  { id: 'Ningbo Dafeng Machinery Co., Ltd', name: 'Ningbo Dafeng' },
] as const;

export type CustomerId = (typeof CUSTOMERS)[number]['id'];

export const PRODUCTS = [
  { code: 'HR(고로밀)', name: 'HR(고로밀)' },
  { code: '후판', name: '후판' },
  { code: '냉연(CR)', name: '냉연(CR)' },
  { code: 'STS 304', name: 'STS 304' },
  { code: '부산물(철스크랩)', name: '부산물(철스크랩)' },
] as const;

export type ProductCode = (typeof PRODUCTS)[number]['code'];

// ─────────────────────────────────────────────
// 고객사 프로필
// ─────────────────────────────────────────────

export const CUSTOMER_PROFILES: Record<string, CustomerProfile> = {
  고려제강: {
    customer_id: '고려제강',
    industry: '와이어로프/PC강선 제조',
    market_region: '한국',
    product_group: ['HR(고로밀)', '부산물(철스크랩)'],
    sensitive_topics: ['원자재 가격 변동', '전력비', '환율'],
    risk_factors: ['철광석 가격 상승', '원/달러 환율 약세', '글로벌 와이어 수요 둔화'],
  },
  'Borcelik Celik Sanayii VE Ticaret AS': {
    customer_id: 'Borcelik Celik Sanayii VE Ticaret AS',
    industry: '자동차용 도금강판',
    market_region: '튀르키예',
    product_group: ['냉연(CR)', 'HR(고로밀)'],
    sensitive_topics: ['EU CBAM 관세', '리라화 환율', '反덤핑 조사'],
    risk_factors: ['CBAM 본격 시행', '리라화 추가 약세', 'EU 역내 수요 둔화'],
  },
  'Nissan Motor Co., Ltd': {
    customer_id: 'Nissan Motor Co., Ltd',
    industry: '자동차 완성차',
    market_region: '일본/글로벌',
    product_group: ['냉연(CR)', 'HR(고로밀)'],
    sensitive_topics: ['EV 전환 속도', '엔/달러', '글로벌 자동차 수요'],
    risk_factors: ['중국 자동차 수출 공세', '엔저 장기화 시 가격 압박', 'EV 전환 지연'],
  },
  'Berg Steel Pipe Corp': {
    customer_id: 'Berg Steel Pipe Corp',
    industry: '대구경 강관 (에너지 인프라)',
    market_region: '미국',
    product_group: ['HR(고로밀)', '후판'],
    sensitive_topics: ['美 인프라 법안', 'AD/CVD 관세', 'LNG 프로젝트'],
    risk_factors: ['美 인프라 예산 집행 지연', '유가 급락', 'AD 관세 강화'],
  },
  썬시멘트주식회사: {
    customer_id: '썬시멘트주식회사',
    industry: '시멘트',
    market_region: '한국',
    product_group: ['부산물(철스크랩)'],
    sensitive_topics: ['건설경기', '슬래그 수급', '탄소배출권'],
    risk_factors: ['국내 주택 착공 둔화', '슬래그 공급 차질', '탄소배출권 가격 급등'],
  },
  'New Best Wire Industrial Co., Ltd': {
    customer_id: 'New Best Wire Industrial Co., Ltd',
    industry: '와이어/케이블',
    market_region: '대만',
    product_group: ['HR(고로밀)'],
    sensitive_topics: ['원자재 변동', '중국 저가 수출', '대만 달러 환율'],
    risk_factors: ['중국 와이어 저가 공세', '글로벌 인프라 수요 둔화', '환율 변동성'],
  },
  'JFE Techno Wire Corporation': {
    customer_id: 'JFE Techno Wire Corporation',
    industry: '고강도 와이어 (자동차/타이어)',
    market_region: '일본',
    product_group: ['HR(고로밀)'],
    sensitive_topics: ['자동차 부품 수요', '엔/달러', '품질 인증'],
    risk_factors: ['일본 자동차 생산 감소', '엔저 장기화', '경쟁사 신규 진입'],
  },
  동일제강: {
    customer_id: '동일제강',
    industry: '전기로 제강 (봉형강)',
    market_region: '한국',
    product_group: ['부산물(철스크랩)'],
    sensitive_topics: ['전기료', '철스크랩 수급', '봉형강 수요'],
    risk_factors: ['전기료 추가 인상', '스크랩 가격 급변', '건설 봉형강 수요 둔화'],
  },
  세아씨엠: {
    customer_id: '세아씨엠',
    industry: '컬러/도금강판 (가전·건자재)',
    market_region: '한국',
    product_group: ['냉연(CR)'],
    sensitive_topics: ['가전 수요', '건자재 수요', '아연 가격'],
    risk_factors: ['글로벌 가전 수요 둔화', '아연/알루미늄 가격 상승', '중국 도금재 저가 공세'],
  },
  'Ningbo Dafeng Machinery Co., Ltd': {
    customer_id: 'Ningbo Dafeng Machinery Co., Ltd',
    industry: '조선·기계 부품',
    market_region: '중국',
    product_group: ['후판', 'STS 304'],
    sensitive_topics: ['조선 수주', '후판 가격', '중국 부동산'],
    risk_factors: ['중국 부동산 침체', '글로벌 신조선 발주 둔화', '인민폐 약세'],
  },
};

// ─────────────────────────────────────────────
// 시계열 헬퍼
// ─────────────────────────────────────────────

const TODAY = '2026-05-17';

function shiftDate(daysAgo: number): string {
  const d = new Date(TODAY);
  d.setDate(d.getDate() - daysAgo);
  return d.toISOString().slice(0, 10);
}

/**
 * 자연스러운 시계열 생성기 (지정 길이, 시드 기반 의사난수로 결정론적).
 */
function makeSeries(start: number, drift: number, volatility: number, days = 30, seed = 1): IndicatorPoint[] {
  const points: IndicatorPoint[] = [];
  let value = start;
  let s = seed * 9301 + 49297;
  for (let i = days; i >= 0; i -= 1) {
    s = (s * 9301 + 49297) % 233280;
    const rand = s / 233280 - 0.5;
    value += drift + rand * volatility;
    points.push({ date: shiftDate(i), value: Math.round(value * 100) / 100 });
  }
  return points;
}

// ─────────────────────────────────────────────
// 제품별 시장 데이터 (차트1 + 차트2 + 해석)
// ─────────────────────────────────────────────

interface ProductMarketData {
  top_movers: TopMover[];
  cause_flow: CauseFlowStep[];
  interpretation: Interpretation;
}

export const PRODUCT_MARKET_DATA: Record<ProductCode, ProductMarketData> = {
  'HR(고로밀)': {
    top_movers: [
      {
        indicator: '중국 철광석 수입가 - 호주산 62% 분광',
        value: 102.4,
        unit: 'USD/톤',
        change_d1: 0.8,
        change_w1: 3.6,
        change_m1: -2.1,
        score: 0.892,
        series: makeSeries(108, -0.18, 1.6, 30, 11),
        cycle: 'D',
      },
      {
        indicator: '상하이 열연 선물가 (HRC)',
        value: 3680,
        unit: 'CNY/톤',
        change_d1: -0.4,
        change_w1: 2.1,
        change_m1: 4.7,
        score: 0.834,
        series: makeSeries(3520, 5.0, 24, 30, 23),
        cycle: 'D',
      },
      {
        indicator: '글로벌 강점탄 수출가 (호주산 강점탄)',
        value: 218,
        unit: 'USD/톤',
        change_d1: 0.0,
        change_w1: -1.4,
        change_m1: 1.9,
        score: 0.711,
        series: makeSeries(212, 0.22, 1.9, 30, 31),
        cycle: 'D',
      },
    ],
    cause_flow: [
      {
        step: 1,
        node: '중국 부동산 신규 착공 감소 → 철강 수요 둔화 우려',
        evidence: [
          { news_id: 'n-hr-001', title: '中 4월 부동산 투자 전년比 -8.3%, 신규 착공 -24%', date: '2026-05-16', url: 'https://www.mysteel.net/news/cn-property-investment' },
          { news_id: 'n-hr-002', title: 'Bloomberg: China property crisis deepens as starts plunge', date: '2026-05-15', url: 'https://www.bloomberg.com/news/china-property-starts' },
        ],
      },
      {
        step: 2,
        node: '호주 사이클론 영향 → 철광석 일시 공급 차질',
        evidence: [
          { news_id: 'n-hr-003', title: 'Cyclone disrupts Pilbara iron ore exports for 5 days', date: '2026-05-14', url: 'https://www.reuters.com/markets/commodities/cyclone-pilbara' },
        ],
      },
      {
        step: 3,
        node: '중국 제철소 마진 회복 → 철광석 재고 보충 매수 증가',
        evidence: [
          { news_id: 'n-hr-004', title: '中 247개 고로사 가동률 91.2%, 4주 연속 상승', date: '2026-05-13', url: 'https://www.mysteel.net/cisa-blast-furnace-utilization' },
          { news_id: 'n-hr-005', title: 'S&P Global: Chinese mills replenish iron ore stocks', date: '2026-05-12', url: 'https://www.spglobal.com/commodityinsights/china-mills-restock' },
        ],
      },
      {
        step: 4,
        node: '철광석 단기 강세 → HRC 선물 동반 상승',
        evidence: [
          { news_id: 'n-hr-006', title: 'SHFE HRC 선물 주간 +2.1%, 5월 중순 반등', date: '2026-05-16', url: 'https://www.shfe.com.cn/news/hrc-weekly' },
        ],
      },
      {
        step: 5,
        node: '협상 영향: 단기(2~4주) 인상 압력, 중기(6~8주) 수요 둔화 시 조정 가능',
        evidence: [
          { news_id: 'n-hr-007', title: 'POSCO 마켓 리포트: HRC 단기 강세, 하반기 약세 전환 가능성', date: '2026-05-15', url: 'https://www.posco.co.kr/market-report/hrc-2026-05' },
        ],
      },
    ],
    interpretation: {
      what: '중국 철광석·HRC 가격이 주간 +3.6% / +2.1% 동반 상승. 단기 변동성 확대.',
      why: '호주 사이클론으로 인한 철광석 일시 공급 차질이 트리거.\n중국 제철소 가동률이 91%대로 회복되며 재고 보충 매수가 가세.\n다만 중국 부동산 신규 착공이 전년比 -24%로 수요 둔화는 여전.',
      impact: [
        { risk_factor: '철광석 가격 상승', direction: '증폭', reason: '주간 +3.6% 상승으로 원가 압박 확대. 협상에서 가격 인상 명분이 됨.' },
        { risk_factor: '원/달러 환율 약세', direction: '증폭', reason: '원/달러 1,360원대 약세 유지 시 원자재 수입 단가 추가 부담.' },
        { risk_factor: '글로벌 와이어 수요 둔화', direction: '완화', reason: '중국 부동산 약세는 와이어 수요에는 부정적이나, 단기 가격 상승은 마진 회복 기회.' },
      ],
    },
  },
  후판: {
    top_movers: [
      {
        indicator: '중국 후판(Plate) 20mm 유통가',
        value: 3820,
        unit: 'CNY/톤',
        change_d1: 0.3,
        change_w1: 1.2,
        change_m1: 3.1,
        score: 0.756,
        series: makeSeries(3700, 4.2, 22, 30, 41),
        cycle: 'D',
      },
      {
        indicator: '글로벌 신조선 수주량 (CGT)',
        value: 4.2,
        unit: '백만 CGT',
        change_d1: 0.0,
        change_w1: 0.0,
        change_m1: 8.5,
        score: 0.812,
        series: makeSeries(3.85, 0.012, 0.05, 30, 53),
        cycle: 'M',
      },
      {
        indicator: '중국 후판 Mill 운영률',
        value: 78.4,
        unit: '%',
        change_d1: -0.2,
        change_w1: -1.1,
        change_m1: -3.4,
        score: 0.604,
        series: makeSeries(82, -0.12, 0.7, 30, 67),
        cycle: 'W',
      },
    ],
    cause_flow: [
      {
        step: 1,
        node: '글로벌 LNG 수요 회복 → 신조선 발주 증가',
        evidence: [
          { news_id: 'n-pl-001', title: 'Clarksons: 2026년 1분기 LNG선 발주 전년比 +42%', date: '2026-05-14', url: 'https://www.clarksons.com/news/lng-orders-q1-2026' },
          { news_id: 'n-pl-002', title: '한국 조선 빅3, LNG선 수주 잔량 사상 최대', date: '2026-05-13', url: 'https://www.kshipbuilders.or.kr/news/lng-backlog' },
        ],
      },
      {
        step: 2,
        node: '중국 후판 mill 운영률 78% (전월比 -3.4%p) → 공급 타이트',
        evidence: [
          { news_id: 'n-pl-003', title: '中 후판 mill 운영률 5주 연속 하락, 정비 시즌 본격', date: '2026-05-12', url: 'https://www.mysteel.net/plate-mill-utilization' },
        ],
      },
      {
        step: 3,
        node: '아시아 후판 현물 강세 전환',
        evidence: [
          { news_id: 'n-pl-004', title: 'Platts: 동아시아 후판 FOB 가격 +US$15/톤', date: '2026-05-15', url: 'https://www.spglobal.com/platts/plate-asia-fob' },
        ],
      },
      {
        step: 4,
        node: '협상 영향: 조선향 후판은 인상 명분, 비조선향은 수요 둔화 우려 병존',
        evidence: [
          { news_id: 'n-pl-005', title: 'POSCO 후판 마켓 리포트: 조선 강세, 건설 약세', date: '2026-05-15', url: 'https://www.posco.co.kr/market-report/plate-2026-05' },
        ],
      },
    ],
    interpretation: {
      what: '후판 수요는 조선(강세)·건설(약세)로 양극화. 중국 mill 운영률 -3.4%p로 공급은 타이트.',
      why: 'LNG선·메탄올선 발주 증가로 조선향 후판 수요 견조.\n중국 mill 정비 시즌 진입으로 공급은 감소.\n반면 중국 부동산 침체로 건설용 후판은 약세 지속.',
      impact: [
        { risk_factor: '글로벌 신조선 발주 둔화', direction: '완화', reason: 'LNG선 발주가 사상 최대 잔량을 견인. 단기적으로 후판 수요 안정.' },
        { risk_factor: '중국 부동산 침체', direction: '증폭', reason: '건설용 후판 수요 약세로 비조선향 가격 협상은 어려움.' },
        { risk_factor: '인민폐 약세', direction: '중립', reason: '환율 영향은 수출입 양쪽에 작용, 단기 영향은 제한적.' },
      ],
    },
  },
  '냉연(CR)': {
    top_movers: [
      {
        indicator: '일본 냉연 Coil 현물가 - FOB',
        value: 720,
        unit: 'USD/톤',
        change_d1: -0.1,
        change_w1: -1.8,
        change_m1: -3.2,
        score: 0.683,
        series: makeSeries(742, -0.7, 4.2, 30, 79),
        cycle: 'W',
      },
      {
        indicator: '베트남 냉연 SPCC 1.0mm 가격',
        value: 685,
        unit: 'USD/톤',
        change_d1: 0.2,
        change_w1: -0.9,
        change_m1: -2.4,
        score: 0.622,
        series: makeSeries(700, -0.5, 3.5, 30, 89),
        cycle: 'W',
      },
      {
        indicator: '일본 자동차 생산량 YoY(월)',
        value: -4.2,
        unit: '%',
        change_d1: null,
        change_w1: -0.6,
        change_m1: -1.8,
        score: 0.741,
        series: makeSeries(-2.0, -0.08, 0.4, 30, 97),
        cycle: 'M',
      },
    ],
    cause_flow: [
      {
        step: 1,
        node: '일본 자동차 생산량 YoY -4.2% → 냉연 수요 감소',
        evidence: [
          { news_id: 'n-cr-001', title: '日 4월 자동차 생산 전년比 -4.2%, 4개월 연속 감소', date: '2026-05-15', url: 'https://www.jama.or.jp/release/production-april' },
          { news_id: 'n-cr-002', title: 'Nikkei: Toyota cuts output target by 5% for FY26', date: '2026-05-14', url: 'https://asia.nikkei.com/Business/Automobile/Toyota-output-cut' },
        ],
      },
      {
        step: 2,
        node: '중국 냉연 저가 수출 증가 → 동남아 가격 압박',
        evidence: [
          { news_id: 'n-cr-003', title: '中 냉연 수출량 4월 전년比 +18%, 동남아向 집중', date: '2026-05-13', url: 'https://www.mysteel.net/cr-export-april' },
        ],
      },
      {
        step: 3,
        node: '엔저 장기화 → 일본産 냉연의 가격 경쟁력',
        evidence: [
          { news_id: 'n-cr-004', title: '엔/달러 155엔대 약세, 일본 수출재 단가 압박 완화', date: '2026-05-12', url: 'https://www.reuters.com/markets/currencies/yen-dollar' },
        ],
      },
      {
        step: 4,
        node: '협상 영향: 단기 가격 하방 압력, 자동차향 신규 계약은 가격 동결 협상 우세',
        evidence: [
          { news_id: 'n-cr-005', title: 'POSCO 냉연 마켓 리포트: 단기 약보합, Q3 회복 전망', date: '2026-05-15', url: 'https://www.posco.co.kr/market-report/cr-2026-05' },
        ],
      },
    ],
    interpretation: {
      what: '냉연(CR) 가격은 전월比 -3.2% 약세. 일본 자동차 생산 감소와 중국 저가 수출이 동반 압박.',
      why: '일본 자동차 생산이 4개월 연속 YoY 감소.\n중국 냉연 수출이 동남아向으로 집중 증가.\n엔저로 일본 수출재의 가격 경쟁력도 강화.',
      impact: [
        { risk_factor: '중국 자동차 수출 공세', direction: '증폭', reason: '중국産 냉연 수출 증가로 동남아 가격이 압박. 협상에서 단가 동결/인하 요구 가능성.' },
        { risk_factor: '엔저 장기화', direction: '증폭', reason: '엔/달러 155엔대 약세 지속 시 일본 수출재 단가 압박이 한국産에도 전이.' },
        { risk_factor: 'EV 전환 지연', direction: '완화', reason: 'EV 전환이 늦어질수록 기존 냉연 수요 규모는 유지. 단가 인하 명분은 약화.' },
      ],
    },
  },
  'STS 304': {
    top_movers: [
      {
        indicator: 'LME 니켈 3개월 선물',
        value: 18420,
        unit: 'USD/톤',
        change_d1: 1.2,
        change_w1: 4.8,
        change_m1: 7.6,
        score: 0.918,
        series: makeSeries(17120, 43, 180, 30, 103),
        cycle: 'D',
      },
      {
        indicator: '중국 페로크롬 58-60% 현물가',
        value: 8420,
        unit: 'CNY/톤',
        change_d1: 0.6,
        change_w1: 2.3,
        change_m1: 4.1,
        score: 0.802,
        series: makeSeries(8080, 12, 38, 30, 113),
        cycle: 'D',
      },
      {
        indicator: '인니 니켈 광석 수출 (월)',
        value: 2.4,
        unit: '백만톤',
        change_d1: null,
        change_w1: 1.8,
        change_m1: 6.2,
        score: 0.748,
        series: makeSeries(2.25, 0.005, 0.04, 30, 127),
        cycle: 'M',
      },
    ],
    cause_flow: [
      {
        step: 1,
        node: '인니 니켈 광석 수출쿼터 강화 우려 → LME 니켈 강세',
        evidence: [
          { news_id: 'n-st-001', title: 'Indonesia weighs stricter nickel ore export quota for H2 2026', date: '2026-05-15', url: 'https://www.reuters.com/markets/commodities/indonesia-nickel-quota' },
          { news_id: 'n-st-002', title: 'LME 니켈 18,400 돌파, 5주 연속 상승', date: '2026-05-16', url: 'https://www.lme.com/news/nickel-weekly' },
        ],
      },
      {
        step: 2,
        node: '중국 페로크롬 강세 동반 → STS 원가 부담 가중',
        evidence: [
          { news_id: 'n-st-003', title: '중국 페로크롬 입찰가 +280 CNY/톤, 5월 中순 강세', date: '2026-05-14', url: 'https://www.mysteel.net/feroce-cn' },
        ],
      },
      {
        step: 3,
        node: '글로벌 STS 304 가격 인상 압력',
        evidence: [
          { news_id: 'n-st-004', title: 'Outokumpu 304 base price +€80/톤 인상 발표', date: '2026-05-13', url: 'https://www.outokumpu.com/news/price-increase-may-2026' },
          { news_id: 'n-st-005', title: 'POSCO STS 304 기준가 5월 +50,000원/톤 인상 검토', date: '2026-05-12', url: 'https://www.posco.co.kr/news/sts-price-may' },
        ],
      },
      {
        step: 4,
        node: '협상 영향: 원료 인상 명분 강함, 분기 단위 슬라이딩 조건 협의 권장',
        evidence: [
          { news_id: 'n-st-006', title: 'POSCO STS 마켓 리포트: Q2 추가 인상, Q3 안정 전망', date: '2026-05-15', url: 'https://www.posco.co.kr/market-report/sts-2026-05' },
        ],
      },
    ],
    interpretation: {
      what: 'STS 304 원가 지표(니켈·페로크롬) 동반 강세. 월간 +7.6% / +4.1%로 추가 인상 압력.',
      why: '인니 니켈 수출쿼터 강화 우려가 LME 니켈 가격을 견인.\n중국 페로크롬도 입찰가 +280 CNY로 동반 강세.\n글로벌 메이커들이 5월 가격 인상을 발표.',
      impact: [
        { risk_factor: '인니 니켈 정책 변동', direction: '증폭', reason: '쿼터 강화 시 추가 가격 상승. 분기 슬라이딩 가격 조건이 유리.' },
        { risk_factor: '중국 부동산 침체', direction: '완화', reason: 'STS는 자동차·가전·기계 중심으로 부동산 영향은 제한적.' },
        { risk_factor: '환율 변동', direction: '중립', reason: '원/달러 1,360원대에서 환율 단가 영향은 제한적.' },
      ],
    },
  },
  '부산물(철스크랩)': {
    top_movers: [
      {
        indicator: '동아시아 철스크랩 수입가 (HMS 1&2)',
        value: 412,
        unit: 'USD/톤',
        change_d1: 0.4,
        change_w1: 1.7,
        change_m1: -2.1,
        score: 0.694,
        series: makeSeries(420, -0.5, 3.2, 30, 137),
        cycle: 'W',
      },
      {
        indicator: '터키 수입 철스크랩 현물가',
        value: 398,
        unit: 'USD/톤',
        change_d1: 0.2,
        change_w1: 0.9,
        change_m1: -1.4,
        score: 0.612,
        series: makeSeries(404, -0.3, 2.8, 30, 149),
        cycle: 'W',
      },
      {
        indicator: '국내 생철 매입가 (수도권)',
        value: 480000,
        unit: 'KRW/톤',
        change_d1: 0.0,
        change_w1: 1.0,
        change_m1: 2.5,
        score: 0.587,
        series: makeSeries(472000, 240, 1800, 30, 163),
        cycle: 'D',
      },
    ],
    cause_flow: [
      {
        step: 1,
        node: '국내 전기로사 가동률 회복 → 생철 매입 경쟁 강화',
        evidence: [
          { news_id: 'n-sc-001', title: '국내 전기로사 4월 가동률 81%, 봉형강 수요 회복', date: '2026-05-14', url: 'https://www.steeldaily.co.kr/news/efh-utilization' },
        ],
      },
      {
        step: 2,
        node: '동아시아 수입 스크랩 강세',
        evidence: [
          { news_id: 'n-sc-002', title: '日 H2 수출가격 +US$8/톤, 5월 中순 강세 전환', date: '2026-05-13', url: 'https://www.tex-report.com/scrap/japan-h2' },
          { news_id: 'n-sc-003', title: '대만 인장 스크랩 입찰 +US$10/톤', date: '2026-05-12', url: 'https://www.mysteel.net/taiwan-scrap-bid' },
        ],
      },
      {
        step: 3,
        node: '슬래그 공급 안정, 시멘트사 재고 정상화',
        evidence: [
          { news_id: 'n-sc-004', title: '국내 시멘트사 슬래그 재고 30일분 확보', date: '2026-05-11', url: 'https://www.cement.or.kr/news/slag-stock' },
        ],
      },
      {
        step: 4,
        node: '협상 영향: 스크랩 단가는 단기 강세, 슬래그 공급은 안정',
        evidence: [
          { news_id: 'n-sc-005', title: 'POSCO 부산물 마켓 리포트: 스크랩 단기 강세, 슬래그 안정', date: '2026-05-15', url: 'https://www.posco.co.kr/market-report/byproduct-2026-05' },
        ],
      },
    ],
    interpretation: {
      what: '철스크랩은 주간 +1.7% 강세, 월간으로는 -2.1% 약보합. 국내 생철은 월 +2.5% 상승.',
      why: '국내 전기로사 가동률이 81%로 회복되며 생철 매입이 활발.\n동아시아 수입 스크랩도 일본·대만 입찰 강세로 추가 상승.\n시멘트向 슬래그는 재고 30일분 확보로 공급 안정.',
      impact: [
        { risk_factor: '전기료 추가 인상', direction: '증폭', reason: '전기로사 원가 부담이 가중되면 스크랩 매입 단가에 추가 전가될 수 있음.' },
        { risk_factor: '스크랩 가격 급변', direction: '증폭', reason: '월간 변동성 확대로 단기 가격 조정이 필요.' },
        { risk_factor: '건설 봉형강 수요 둔화', direction: '완화', reason: '봉형강 수요 회복으로 전기로사 가동률 상승, 스크랩 수요 견조.' },
      ],
    },
  },
};

// ─────────────────────────────────────────────
// 고객사별 전략 (Strategy)
// ─────────────────────────────────────────────

export const STRATEGY_BY_CUSTOMER: Record<string, Strategy> = {
  고려제강: {
    strategy_summary:
      '철광석·HRC 단기 강세 국면. 원가 상승 명분으로 분기 단위 슬라이딩 가격 조건을 제안하고, 장기 공급 안정성을 부각해 협상 우위를 확보.',
    recommended_actions: [
      '분기 단위 원자재 슬라이딩 조항 신규 도입 제안',
      '하반기 와이어 수요 회복 시점에 맞춰 6개월 장기 계약 갱신',
      '환율 변동성 헤지를 위한 USD 기준 일부 결제 비중 협의',
    ],
    negotiation_points: [
      '"호주 사이클론 → 철광석 +3.6% / 주간" 트리거를 명시',
      '중국 247개 고로사 가동률 91.2% 회복 → 단기 수요 견조',
      '안정 공급 실적(지난 24개월 결품률 0.2% 미만) 강조',
    ],
  },
  'Borcelik Celik Sanayii VE Ticaret AS': {
    strategy_summary:
      'CBAM 시행을 앞두고 한국産 저탄소 냉연의 가치 제고. 자동차강판 인증 트랙 레코드를 부각하고 분기 단위 환율·관세 조정 조항을 협상.',
    recommended_actions: [
      'CBAM 대응 저탄소 강재 우선 공급 옵션 제시',
      '리라화 변동성 대응 USD 기준 결제 + 분기 정산 조항',
      '자동차 OEM 인증 트랙 레코드 자료 패키지 제공',
    ],
    negotiation_points: [
      'CBAM 본격 시행 후 EU 역내 단가 +€80/톤 인상 동향',
      '한국産 평균 탄소배출 1.6 tCO2/톤 vs EU 평균 1.9 → 가격 프리미엄 명분',
      '튀르키예 자동차 생산 YoY +6.3% → 수요 견조',
    ],
  },
  'Nissan Motor Co., Ltd': {
    strategy_summary:
      '일본 자동차 생산 감소 국면이나 중국 저가 공세에 따른 품질·납기 차별화 강조. 엔/달러 변동성을 양사 공동 헤지 구조로 전환.',
    recommended_actions: [
      'JIT 납기 0결품 보장 + 품질 클레임 0% 트랙 자료 제출',
      '엔/달러 분기 가중평균 단가 정산 메커니즘 신규 도입',
      'EV 모델별 차종 단위 가격 협상 분리 (강종별 가격 차등화)',
    ],
    negotiation_points: [
      '중국 냉연 수출 +18% → 품질 변동성 사례 데이터 제시',
      '엔/달러 155엔대 약세 지속 → 일본 수출재 단가 메리트',
      '닛산 글로벌 생산 -4.2% → 기존 단가 동결이 양사 모두에 유리',
    ],
  },
  'Berg Steel Pipe Corp': {
    strategy_summary:
      '美 인프라·LNG 프로젝트 가시화 국면. AD 관세 회피 전략과 함께 대구경 강관용 후판·HRC의 장기 수급 안정성을 강조.',
    recommended_actions: [
      '美 IRA 적용 대상 인증 자료 사전 제공',
      'LNG 프로젝트 시공 일정 연동 분기 납기 락인 협상',
      'AD/CVD 영향 최소화 위한 멕시코 경유 옵션 검토',
    ],
    negotiation_points: [
      '美 LNG 신규 프로젝트 +8건 확정 → 강관 수요 가시성',
      'AD 관세 강화 시 멕시코 경유 옵션의 단가 비교 자료',
      '대구경 강관용 후판의 안정 공급 트랙 (지난 36개월 결품 0건)',
    ],
  },
  썬시멘트주식회사: {
    strategy_summary:
      '슬래그 공급은 안정. 건설경기 둔화에 따른 시멘트 수요 약세를 고려해 연간 물량 합의보다는 분기 단위 유연 계약으로 전환.',
    recommended_actions: [
      '분기 단위 슬래그 물량 합의 (연간 계약 → 분기 락인)',
      '탄소배출권 가격 변동 시 일부 단가 조정 조항 신규',
      '대체 원료(플라이애시) 동반 공급 옵션 패키지화',
    ],
    negotiation_points: [
      '국내 시멘트사 슬래그 재고 30일분 → 단기 공급 부담 적음',
      '건설 착공 -12% 둔화 → 양사 모두 분기 단위 유연성 필요',
      '탄소배출권 가격 ₩42,000/톤대 → 단가 인상 명분 약함',
    ],
  },
  'New Best Wire Industrial Co., Ltd': {
    strategy_summary:
      '대만 달러 강세와 중국 저가 공세 사이에서 품질·납기 차별화 부각. HRC 단기 강세를 활용해 분기 단위 슬라이딩 조항 도입.',
    recommended_actions: [
      'TWD 기준 결제 + 분기 정산 가중평균 조항 도입',
      '품질 인증(JIS/CNS) 자료 패키지 제공',
      '중국産 대비 품질·납기 우위 비교 데이터 자료화',
    ],
    negotiation_points: [
      '중국 와이어 저가 수출 +18% → 품질 변동성 리스크',
      'HRC 단기 +2.1% 상승 → 원가 상승 명분',
      '대만 인프라 투자 확대 → 와이어 수요 견조',
    ],
  },
  'JFE Techno Wire Corporation': {
    strategy_summary:
      '엔저 장기화에도 고강도 와이어의 품질 차별화로 단가 방어. 자동차 부품向 신규 인증 트랙 자료를 활용.',
    recommended_actions: [
      '고강도 와이어 신규 인증 트랙 레코드 제출',
      '엔/달러 분기 가중평균 정산 메커니즘',
      '자동차 부품向 차종별 가격 협상 분리',
    ],
    negotiation_points: [
      '일본 자동차 생산 -4.2% → 기존 단가 동결이 양사 모두에 유리',
      '엔/달러 155엔대 약세 → 일본 수출재 단가 메리트',
      '고강도 와이어(2200MPa 이상) 품질 트랙',
    ],
  },
  동일제강: {
    strategy_summary:
      '전기로 가동률 회복 국면. 스크랩 매입 단가 강세를 부산물 협상에서 활용하고, 전기료 인상 시 추가 단가 조정 조항 신설.',
    recommended_actions: [
      '전기료 인상 시 추가 단가 조정 조항 신설',
      '스크랩 매입 단가 슬라이딩 조항 협상',
      '봉형강 수요 회복기 6개월 장기 계약 갱신',
    ],
    negotiation_points: [
      '국내 전기로 가동률 81% 회복 → 스크랩 수요 견조',
      '일본 H2 수출가 +US$8/톤 → 수입 스크랩 강세',
      '국내 생철 매입가 +2.5%/월 → 단가 인상 명분',
    ],
  },
  세아씨엠: {
    strategy_summary:
      '냉연 약세 국면이나 가전·건자재 수요 양극화. 컬러강판·도금재의 차별화된 가치 제안과 분기 단위 가격 조정 조항으로 단가 방어.',
    recommended_actions: [
      '컬러강판 신규 컬러 라인업 우선 공급 옵션',
      '아연 가격 슬라이딩 조항 신규 도입',
      '가전 OEM 인증 트랙 자료 패키지',
    ],
    negotiation_points: [
      '아연 +3.2% 상승 → 도금 원가 상승 명분',
      '중국 도금재 저가 공세에도 품질 변동성 사례 자료',
      '국내 가전 수요 둔화 → 분기 단위 유연성 필요',
    ],
  },
  'Ningbo Dafeng Machinery Co., Ltd': {
    strategy_summary:
      '조선 호황과 부동산 침체의 양극화 국면. 조선향 후판 강세를 활용한 단가 인상 협상과 STS 304의 분기 슬라이딩 가격 조항 도입.',
    recommended_actions: [
      '조선향 후판 단가 +US$15/톤 인상 협상',
      'STS 304 분기 슬라이딩 가격 조항 도입',
      '인민폐 변동 대응 USD 기준 분기 정산',
    ],
    negotiation_points: [
      'LNG선 발주 +42% → 조선 후판 수요 가시성',
      '중국 후판 mill 운영률 78% → 공급 타이트',
      'LME 니켈 +7.6%/월 → STS 304 원가 상승 명분',
    ],
  },
};

// ─────────────────────────────────────────────
// 추천 질문 (제품별 3개)
// ─────────────────────────────────────────────

export const TODAY_QUESTIONS_BY_PRODUCT: Record<ProductCode, TodayQuestion[]> = {
  'HR(고로밀)': [
    {
      qid: 'q-hr-1',
      text: '중국 철광석 단기 강세가 향후 4주 HRC 가격에 미칠 영향은?',
      trigger_indicators: ['중국 철광석 수입가 - 호주산 62% 분광', '상하이 열연 선물가 (HRC)'],
      related_groups_internal: ['원료가격', '중국수요'],
      score: 0.92,
    },
    {
      qid: 'q-hr-2',
      text: '호주 사이클론 영향이 해소될 경우, 철광석 가격 조정 폭은?',
      trigger_indicators: ['중국 철광석 수입가 - 호주산 62% 분광'],
      related_groups_internal: ['공급차질', '재고수준'],
      score: 0.84,
    },
    {
      qid: 'q-hr-3',
      text: '중국 부동산 약세가 장기화될 경우, HRC 수요에 미칠 누적 영향은?',
      trigger_indicators: ['상하이 열연 선물가 (HRC)'],
      related_groups_internal: ['중국부동산', '글로벌수요'],
      score: 0.78,
    },
  ],
  후판: [
    {
      qid: 'q-pl-1',
      text: '조선 후판 강세와 건설 약세가 동시에 진행될 때 협상 우선순위는?',
      trigger_indicators: ['중국 후판(Plate) 20mm 유통가', '글로벌 신조선 수주량 (CGT)'],
      related_groups_internal: ['조선수요', '건설수요'],
      score: 0.89,
    },
    {
      qid: 'q-pl-2',
      text: '중국 후판 mill 운영률이 추가 하락 시 수입가 인상 폭은?',
      trigger_indicators: ['중국 후판 Mill 운영률'],
      related_groups_internal: ['공급차질', '아시아현물가'],
      score: 0.81,
    },
    {
      qid: 'q-pl-3',
      text: 'LNG선 발주 추세가 6개월 후판 수요에 주는 누적 효과는?',
      trigger_indicators: ['글로벌 신조선 수주량 (CGT)'],
      related_groups_internal: ['LNG수요', '수주잔량'],
      score: 0.76,
    },
  ],
  '냉연(CR)': [
    {
      qid: 'q-cr-1',
      text: '일본 자동차 생산 감소와 중국 저가 수출 증가가 동시에 발생 시 단가 방향은?',
      trigger_indicators: ['일본 냉연 Coil 현물가 - FOB', '일본 자동차 생산량 YoY(월)'],
      related_groups_internal: ['자동차수요', '중국수출'],
      score: 0.88,
    },
    {
      qid: 'q-cr-2',
      text: '엔저 장기화가 한국産 냉연 단가에 미칠 전이 효과는?',
      trigger_indicators: ['일본 냉연 Coil 현물가 - FOB'],
      related_groups_internal: ['환율', '동남아수입'],
      score: 0.79,
    },
    {
      qid: 'q-cr-3',
      text: 'EV 전환 지연이 기존 냉연 수요에 미치는 영향은?',
      trigger_indicators: ['일본 자동차 생산량 YoY(월)'],
      related_groups_internal: ['EV전환', '내연기관'],
      score: 0.71,
    },
  ],
  'STS 304': [
    {
      qid: 'q-st-1',
      text: 'LME 니켈 강세와 페로크롬 동반 상승 시 STS 304 단가 인상 폭은?',
      trigger_indicators: ['LME 니켈 3개월 선물', '중국 페로크롬 58-60% 현물가'],
      related_groups_internal: ['원료가격', '글로벌메이커'],
      score: 0.93,
    },
    {
      qid: 'q-st-2',
      text: '인니 니켈 수출쿼터 강화가 본격화될 경우 단기/중기 가격 시나리오는?',
      trigger_indicators: ['LME 니켈 3개월 선물', '인니 니켈 광석 수출 (월)'],
      related_groups_internal: ['공급정책', '재고수준'],
      score: 0.87,
    },
    {
      qid: 'q-st-3',
      text: '글로벌 메이커들의 5월 가격 인상이 한국 시장에 미칠 시차는?',
      trigger_indicators: ['중국 페로크롬 58-60% 현물가'],
      related_groups_internal: ['수입가격', '국내기준가'],
      score: 0.74,
    },
  ],
  '부산물(철스크랩)': [
    {
      qid: 'q-sc-1',
      text: '전기로 가동률 회복과 동아시아 수입 스크랩 강세가 결합될 때 단가 방향은?',
      trigger_indicators: ['동아시아 철스크랩 수입가 (HMS 1&2)', '국내 생철 매입가 (수도권)'],
      related_groups_internal: ['전기로가동', '수입스크랩'],
      score: 0.86,
    },
    {
      qid: 'q-sc-2',
      text: '일본 H2 수출가 강세가 국내 수입 단가에 미칠 시차는?',
      trigger_indicators: ['동아시아 철스크랩 수입가 (HMS 1&2)'],
      related_groups_internal: ['일본수출', '대만입찰'],
      score: 0.78,
    },
    {
      qid: 'q-sc-3',
      text: '전기료 추가 인상 시 전기로사의 스크랩 매입 의지 변화는?',
      trigger_indicators: ['국내 생철 매입가 (수도권)'],
      related_groups_internal: ['전기료', '봉형강수요'],
      score: 0.72,
    },
  ],
};

// ─────────────────────────────────────────────
// 빌더 (핸들러용)
// ─────────────────────────────────────────────

const FALLBACK_CUSTOMER: CustomerId = '고려제강';
const FALLBACK_PRODUCT: ProductCode = 'HR(고로밀)';

function nowIso(): string {
  return new Date().toISOString();
}

function resolveProductForCustomer(customerId: string): ProductCode {
  const profile = CUSTOMER_PROFILES[customerId];
  const candidate = profile?.product_group[0];
  if (candidate && (PRODUCTS as ReadonlyArray<{ code: string }>).some((p) => p.code === candidate)) {
    return candidate as ProductCode;
  }
  return FALLBACK_PRODUCT;
}

export function buildDashboardPayload(customerId: string): DashboardPayload {
  const resolvedCustomer = CUSTOMER_PROFILES[customerId] ? customerId : FALLBACK_CUSTOMER;
  const product = resolveProductForCustomer(resolvedCustomer);
  const market = PRODUCT_MARKET_DATA[product];
  const strategy = STRATEGY_BY_CUSTOMER[resolvedCustomer] ?? STRATEGY_BY_CUSTOMER[FALLBACK_CUSTOMER]!;

  return {
    customer: resolvedCustomer,
    product,
    generated_at: nowIso(),
    chart1_top_movers: market.top_movers,
    chart2_cause_flow: market.cause_flow,
    interpretation: market.interpretation,
    strategy,
  };
}

export function buildTopMoversPayload(customerId: string): { product: string; top_movers: TopMover[] } {
  const product = resolveProductForCustomer(customerId);
  return {
    product,
    top_movers: PRODUCT_MARKET_DATA[product].top_movers,
  };
}

export function buildTodayQuestionsPayload(productCode: string): TodayQuestionsPayload {
  const product = (PRODUCTS as ReadonlyArray<{ code: string }>).some((p) => p.code === productCode)
    ? (productCode as ProductCode)
    : FALLBACK_PRODUCT;
  return {
    product,
    generated_at: nowIso(),
    questions: TODAY_QUESTIONS_BY_PRODUCT[product],
  };
}

export function buildCustomerProfile(customerId: string): CustomerProfile {
  return CUSTOMER_PROFILES[customerId] ?? CUSTOMER_PROFILES[FALLBACK_CUSTOMER]!;
}

export function buildAnswerForQuestion(args: {
  qid: string;
  text: string;
  product: string;
  trigger_indicators: string[];
}): QuestionAnswer {
  const triggers = args.trigger_indicators.length > 0 ? args.trigger_indicators : [args.product];
  return {
    qid: args.qid,
    briefing: `${args.product} 관련 ${triggers[0]}을(를) 중심으로 분석하면, 최근 4주 변동성이 확대된 가운데 단기 가격 압력은 ±2~4% 범위에서 형성되고 있습니다. 협상 시점은 다음 주 후반이 유리하며, 슬라이딩 가격 조항을 추가하면 양측 리스크가 균형 잡힙니다.`,
    sales_rep_script: `안녕하세요. 이번 주 ${args.product} 시장은 ${triggers[0]} 변동이 주된 흐름입니다. 저희가 제안드리는 핵심은 ① 분기 단위 슬라이딩 조항 신규 도입, ② 다음 4주 가격 동결 옵션, ③ 결품 0% 트랙 자료 공유입니다. 우선 ②부터 검토해 주시면 후속 세부 협의를 진행하겠습니다.`,
    sources: {
      indicators: triggers,
    },
    confidence: 0.82,
  };
}
