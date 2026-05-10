import type { PricingGuideResponse } from '@/types/pricing.types';

export const mockPricingGuideResponse: PricingGuideResponse = {
  priceGuide: {
    customerId: 'KORYEO',
    customerName: '고려제강',
    product: '선재',
    ruleBasePrice: 620000,
    aiAdjustedPrice: 605000,
    negotiationMinPrice: 595000,
    negotiationMaxPrice: 615000,
    negotiationDifficulty: 'MEDIUM',
    currency: 'KRW',
    unit: '톤',
  },
  similarSituation: {
    similarityPercent: 87,
    period: '2023년 8월',
    description:
      '상하이 열연 -3.8% 급락. 고려제강이 가격 재협상을 요청했으나 균형 협상 전략으로 마진을 방어한 케이스.',
    agreedPrice: 612000,
    strategyUsed: '균형 협상',
    marginRetentionRate: 1.5,
    radarData: [
      { subject: '시장 변동', current: 82, past: 75, fullMark: 100 },
      { subject: '고객 리스크', current: 87, past: 70, fullMark: 100 },
      { subject: '원가 압박', current: 74, past: 68, fullMark: 100 },
      { subject: '협상 난이도', current: 65, past: 60, fullMark: 100 },
      { subject: '대체재 위협', current: 70, past: 55, fullMark: 100 },
    ],
  },
  indicatorComparisons: [
    {
      indicatorName: '상하이 열연',
      currentValue: '$480/t',
      pastValue: '$498/t',
      changePercent: -3.8,
      changeDirection: 'DOWN',
    },
    {
      indicatorName: '철광석 62%',
      currentValue: '$102/t',
      pastValue: '$95/t',
      changePercent: 7.4,
      changeDirection: 'UP',
    },
    {
      indicatorName: '원/달러 환율',
      currentValue: '1,342원',
      pastValue: '1,285원',
      changePercent: 4.4,
      changeDirection: 'UP',
    },
  ],
};
