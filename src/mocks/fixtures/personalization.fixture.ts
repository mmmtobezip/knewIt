import type { ProductConfig, AlertPreviewItem } from '@/types/personalization.types';

export const mockProductConfigs: ProductConfig[] = [
  {
    product: '선재',
    indicators: [
      { id: 'shanghai_hr', label: '상하이 열연', defaultWeight: 0.45 },
      { id: 'iron_ore', label: '철광석 62%', defaultWeight: 0.25 },
      { id: 'usd_krw', label: '원/달러 환율', defaultWeight: 0.20 },
      { id: 'wti', label: 'WTI 유가', defaultWeight: 0.10 },
    ],
  },
  {
    product: 'HR(고로밀)',
    indicators: [
      { id: 'iron_ore', label: '철광석 62%', defaultWeight: 0.50 },
      { id: 'shanghai_hr', label: '상하이 열연', defaultWeight: 0.25 },
      { id: 'usd_krw', label: '원/달러 환율', defaultWeight: 0.15 },
      { id: 'wti', label: 'WTI 유가', defaultWeight: 0.10 },
    ],
  },
  {
    product: 'STS후판',
    indicators: [
      { id: 'lme_nickel', label: 'LME 니켈', defaultWeight: 0.55 },
      { id: 'iron_ore', label: '철광석 62%', defaultWeight: 0.20 },
      { id: 'usd_krw', label: '원/달러 환율', defaultWeight: 0.15 },
      { id: 'wti', label: 'WTI 유가', defaultWeight: 0.10 },
    ],
  },
];

export const mockAlertPreview: AlertPreviewItem[] = [
  { questionId: 'q-001', questionText: '지금 가격 조정 요청을 하면 수주를 잃을 수 있을까요?', score: 0.87, rank: 1 },
  { questionId: 'q-002', questionText: '선재 구매량을 늘릴 의향이 있는 상황인가요?', score: 0.74, rank: 2 },
  { questionId: 'q-003', questionText: '납기 조건 조정이 가능한지 확인해봐야 할까요?', score: 0.51, rank: 3 },
];
