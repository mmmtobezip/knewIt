import type { DashboardResponse } from '@/types/dashboard.types';
import type { CustomerRisk } from '@/types/customer.types';

const mockCustomerRisks: CustomerRisk[] = [
  {
    customerId: 'KORYEO',
    customerName: '고려제강',
    riskLevel: 'HIGH',
    riskScore: 87,
    affectedProducts: ['선재'],
    riskReason: '상하이 열연 -4.2% 급락으로 원가 경쟁력 하락. 재협상 요구 가능성 높음.',
  },
  {
    customerId: 'BORCELIK',
    customerName: 'Borcelik',
    riskLevel: 'HIGH',
    riskScore: 74,
    affectedProducts: ['HR(고로밀)'],
    riskReason: '철광석 +5.1% 상승으로 원가 압박. 납기 조건 재협상 가능성.',
  },
  {
    customerId: 'DONGIL',
    customerName: '동일제강',
    riskLevel: 'MEDIUM',
    riskScore: 62,
    affectedProducts: ['선재'],
    riskReason: '상하이 열연 간접 영향. 3분기 물량 조정 가능성.',
  },
  {
    customerId: 'SEAH',
    customerName: '세아씨엠',
    riskLevel: 'MEDIUM',
    riskScore: 55,
    affectedProducts: ['냉연AP300'],
    riskReason: '원/달러 환율 변동으로 수출 가격 불확실성 증가.',
  },
];

export const mockDashboardResponse: DashboardResponse = {
  coreMessage: {
    id: 'msg-001',
    headline: '고려제강 — 즉시 대응 필요',
    subText:
      '상하이 열연 -4.2% 급락으로 원가 경쟁력 하락 예상. 가격 재협상 시기 검토 권고.',
    level: 'HIGH',
    ctaLabel: 'AI 분석 보기',
    ctaRoute: '/triggers',
    triggerId: 'trigger-001',
  },

  indicators: [
    {
      id: 'ind-001',
      name: '상하이 열연',
      currentValue: '$480',
      unit: '/t',
      changePercent: -4.2,
      changeDirection: 'DOWN',
      alertLevel: 'HIGH',
      triggerId: 'trigger-001',
    },
    {
      id: 'ind-002',
      name: '철광석 62%',
      currentValue: '$102',
      unit: '/t',
      changePercent: 5.1,
      changeDirection: 'UP',
      alertLevel: 'MEDIUM',
      triggerId: 'trigger-002',
    },
    {
      id: 'ind-003',
      name: 'LME 니켈',
      currentValue: '$16,420',
      unit: '/t',
      changePercent: -2.1,
      changeDirection: 'DOWN',
      alertLevel: 'MEDIUM',
      triggerId: 'trigger-003',
    },
    {
      id: 'ind-004',
      name: '원/달러 환율',
      currentValue: '1,342원',
      unit: '',
      changePercent: 0.8,
      changeDirection: 'UP',
      alertLevel: 'LOW',
    },
    {
      id: 'ind-005',
      name: 'WTI 유가',
      currentValue: '$72.4',
      unit: '/bbl',
      changePercent: -1.3,
      changeDirection: 'DOWN',
      alertLevel: 'LOW',
    },
  ],

  news: [
    {
      id: 'news-001',
      title: '중국 상하이 열연 선물 주간 최저치 경신… 공급 과잉 우려',
      source: 'Reuters',
      publishedAt: '2시간 전',
      sentiment: 'NEGATIVE',
      tags: ['선재', '상하이열연'],
      triggerId: 'trigger-001',
    },
    {
      id: 'news-002',
      title: '철광석 호주산 공급 차질… 가격 반등 가능성',
      source: 'Bloomberg',
      publishedAt: '4시간 전',
      sentiment: 'POSITIVE',
      tags: ['HR(고로밀)', '철광석'],
      triggerId: 'trigger-002',
    },
    {
      id: 'news-003',
      title: 'LME 니켈 재고 축소에도 가격 하락세… 중국 수요 둔화',
      source: '한국경제',
      publishedAt: '6시간 전',
      sentiment: 'NEGATIVE',
      tags: ['STS후판', 'LME니켈'],
      triggerId: 'trigger-003',
    },
    {
      id: 'news-004',
      title: '원/달러 환율 1340원대 안착… 수출 가격 경쟁력 개선',
      source: '연합뉴스',
      publishedAt: '8시간 전',
      sentiment: 'POSITIVE',
      tags: ['환율'],
    },
  ],

  questions: [
    {
      id: 'q-001',
      text: '지금 가격 조정 요청을 하면 수주를 잃을 수 있을까요?',
      weightedScore: 0.81,
      answerSummary:
        '상하이 열연 -4.2% 급락으로 고려제강의 원가 부담이 증가했습니다. 현재 시장 상황에서 가격 인상 요청은 위험합니다. 오히려 현재 가격 유지 또는 소폭 인하를 통해 장기 계약 연장을 유도하는 전략이 유효합니다. 균형적 협상 기조 유지를 권장합니다.',
      customerId: 'KORYEO',
      product: '선재',
    },
    {
      id: 'q-002',
      text: '선재 구매량을 늘릴 의향이 있는 상황인가요?',
      weightedScore: 0.72,
      answerSummary:
        '고려제강은 최근 3분기 연속 구매량이 안정적입니다. 철근 시황 회복세에 따라 Q3 물량 확대 가능성이 있습니다. 단, 상하이 가격 하락으로 중국산 대체재 매력도가 높아진 상황임을 인지해야 합니다.',
      customerId: 'KORYEO',
      product: '선재',
    },
    {
      id: 'q-003',
      text: '납기 조건 조정이 가능한지 확인해봐야 할까요?',
      weightedScore: 0.44,
      answerSummary:
        '현재 고려제강과의 납기 조건은 표준(30일)입니다. 급박한 이슈는 없으나, 하반기 생산 일정 협의 차원에서 확인은 가능합니다.',
      customerId: 'KORYEO',
      product: '선재',
    },
  ],

  customerRisks: mockCustomerRisks,
};
