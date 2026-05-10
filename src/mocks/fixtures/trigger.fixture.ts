import type { TriggerListResponse } from '@/types/trigger.types';

export const mockTriggerListResponse: TriggerListResponse = {
  triggers: [
    {
      id: 'trigger-001',
      indicatorName: '상하이 열연',
      changePercent: -4.2,
      changeDirection: 'DOWN',
      alertLevel: 'HIGH',
      detectedAt: '2026-05-10T09:02:00',
      source: 'CME Group / SGX',
      causeFlow: [
        { id: 'c1', label: '중국 철강 수요 둔화', sublabel: '부동산 경기 침체', type: 'TRIGGER' },
        { id: 'c2', label: '상하이 열연 -4.2%', sublabel: '$480/t → $460/t', type: 'KEY' },
        { id: 'c3', label: '원가 경쟁력 하락', sublabel: '고려제강 원가 압박', type: 'INTERMEDIATE' },
        { id: 'c4', label: '가격 재협상 압박', sublabel: '수주 리스크 HIGH', type: 'OUTCOME' },
      ],
      affectedCustomers: [
        {
          customerId: 'KORYEO',
          customerName: '고려제강',
          product: '선재',
          monthlyVolumeTon: 500,
          riskLevel: 'HIGH',
          riskScore: 87,
        },
        {
          customerId: 'DONGIL',
          customerName: '동일제강',
          product: '선재',
          monthlyVolumeTon: 300,
          riskLevel: 'MEDIUM',
          riskScore: 62,
        },
      ],
      strategies: [
        {
          tone: 'CONSERVATIVE',
          title: '방어적 협상',
          description:
            '현재 가격 유지. 시장 불안정을 인정하되 변동 없음을 강조하며 장기 계약 연장 유도.',
          expectedRisk: '낮음',
          expectedMarginRate: '+0.5%',
        },
        {
          tone: 'BALANCED',
          title: '균형 협상',
          description:
            '소폭 가격 조정(-1~2%) 제안과 물량 확대 연계. 고객 원가 부담 인정하되 마진 방어.',
          expectedRisk: '중간',
          expectedMarginRate: '+1.2%',
        },
        {
          tone: 'AGGRESSIVE',
          title: '적극적 협상',
          description:
            '시장 변동성을 기회로 활용. 중국산 대체재 대비 품질 프리미엄 강조하며 가격 유지.',
          expectedRisk: '높음',
          expectedMarginRate: '+2.8%',
        },
      ],
    },
    {
      id: 'trigger-002',
      indicatorName: '철광석 62%',
      changePercent: 5.1,
      changeDirection: 'UP',
      alertLevel: 'MEDIUM',
      detectedAt: '2026-05-10T08:45:00',
      source: 'Platts / Bloomberg',
      causeFlow: [
        { id: 'c1', label: '호주 공급 차질', sublabel: '기상 이변으로 출하 지연', type: 'TRIGGER' },
        { id: 'c2', label: '철광석 62% +5.1%', sublabel: '$102/t → $107/t', type: 'KEY' },
        { id: 'c3', label: '고로밀 원가 상승', sublabel: 'Borcelik 생산 원가 압박', type: 'INTERMEDIATE' },
        { id: 'c4', label: '납기 조건 재협상', sublabel: '수주 조건 변경 리스크', type: 'OUTCOME' },
      ],
      affectedCustomers: [
        {
          customerId: 'BORCELIK',
          customerName: 'Borcelik',
          product: 'HR(고로밀)',
          monthlyVolumeTon: 1200,
          riskLevel: 'HIGH',
          riskScore: 74,
        },
      ],
      strategies: [
        {
          tone: 'CONSERVATIVE',
          title: '방어적 협상',
          description: '납기 조건 현행 유지. 가격 변동 없음을 명시하고 관계 안정 우선.',
          expectedRisk: '낮음',
          expectedMarginRate: '+0.3%',
        },
        {
          tone: 'BALANCED',
          title: '균형 협상',
          description: '원가 상승분 일부 반영(+2%). 납기 연장 여유를 제공하며 관계 유지.',
          expectedRisk: '중간',
          expectedMarginRate: '+1.5%',
        },
        {
          tone: 'AGGRESSIVE',
          title: '적극적 협상',
          description: '원가 상승 전가(+4%). 조기 계약 갱신 유도로 리스크 헤징.',
          expectedRisk: '높음',
          expectedMarginRate: '+3.1%',
        },
      ],
    },
    {
      id: 'trigger-003',
      indicatorName: 'LME 니켈',
      changePercent: -2.1,
      changeDirection: 'DOWN',
      alertLevel: 'MEDIUM',
      detectedAt: '2026-05-10T07:30:00',
      source: 'LME',
      causeFlow: [
        { id: 'c1', label: '중국 수요 둔화', sublabel: '제조업 PMI 하락', type: 'TRIGGER' },
        { id: 'c2', label: 'LME 니켈 -2.1%', sublabel: '$16,420/t → $16,075/t', type: 'KEY' },
        { id: 'c3', label: 'STS 원가 하락', sublabel: '스테인리스 원가 개선', type: 'INTERMEDIATE' },
        { id: 'c4', label: '가격 인하 압박', sublabel: '납품가 조정 요구 가능성', type: 'OUTCOME' },
      ],
      affectedCustomers: [],
      strategies: [
        {
          tone: 'CONSERVATIVE',
          title: '방어적 협상',
          description: '가격 현행 유지. 니켈 하락이 일시적임을 강조.',
          expectedRisk: '낮음',
          expectedMarginRate: '+0.2%',
        },
        {
          tone: 'BALANCED',
          title: '균형 협상',
          description: '소폭 조정(-1%) 허용. 장기 계약 안정화 우선.',
          expectedRisk: '중간',
          expectedMarginRate: '+0.8%',
        },
        {
          tone: 'AGGRESSIVE',
          title: '적극적 협상',
          description: 'STS 품질 프리미엄 부각으로 현가 유지. 하락 트렌드 일시적임 강조.',
          expectedRisk: '높음',
          expectedMarginRate: '+1.5%',
        },
      ],
    },
  ],
  alertCount: 1,
};
