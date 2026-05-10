import type { MailBlock, MailDraft } from '@/types/mail.types';

export const mockMailBlocks: MailBlock[] = [
  {
    type: 'GREETING',
    label: '인사말',
    description: '수신자 맞춤 인사',
    defaultContent:
      '안녕하세요, 고려제강 김철수 부장님. 포스코DX 영업팀 이윤진입니다.',
  },
  {
    type: 'MARKET_SUMMARY',
    label: '시장 현황',
    description: '최근 시장 지표 요약',
    defaultContent:
      '최근 상하이 열연 가격이 -4.2% 급락하며 글로벌 철강 시장 변동성이 확대되고 있습니다. 이에 따라 원자재 원가 구조 변화가 예상됩니다.',
  },
  {
    type: 'NEGOTIATION_POSITION',
    label: '협상 입장',
    description: '당사 협상 기조',
    defaultContent:
      '당사는 장기 파트너십을 최우선으로 고려하여 균형적인 협상 기조를 유지하고자 합니다. 상호 이익에 부합하는 합리적인 조건을 제안드릴 예정입니다.',
  },
  {
    type: 'PRICE_PROPOSAL',
    label: '가격 제안',
    description: 'AI 추천 가격 기반 제안',
    defaultContent:
      '시장 상황을 반영하여 선재 납품가를 톤당 605,000원으로 제안드립니다. 협상 가능 범위는 595,000원~615,000원입니다.',
  },
  {
    type: 'QUALITY_STRENGTH',
    label: '품질 강점',
    description: '당사 제품 강점 어필',
    defaultContent:
      '포스코DX 선재는 KS 인증 기준 초과 품질을 보장하며, 납기 준수율 99.2%를 기록하고 있습니다. 중국산 대체재 대비 품질 안정성에서 월등한 경쟁력을 보유합니다.',
  },
  {
    type: 'MEETING_REQUEST',
    label: '미팅 요청',
    description: '대면 협의 제안',
    defaultContent:
      '가능하시다면 이번 주 중 간략한 화상 미팅을 통해 구체적인 협의를 진행하고 싶습니다. 편하신 일정을 알려주시면 맞춰 드리겠습니다.',
  },
  {
    type: 'CLOSING',
    label: '마무리',
    description: '정중한 마무리 인사',
    defaultContent:
      '항상 좋은 파트너십에 감사드리며, 긍정적인 결과를 기대합니다. 검토 부탁드립니다. 감사합니다.',
  },
];

export const mockDefaultDraft: MailDraft = {
  recipient: 'kimcs@koryeo.co.kr',
  cc: '',
  subject: '[포스코DX] 선재 납품 가격 협의 건',
  blocks: mockMailBlocks
    .filter((b) => ['GREETING', 'MARKET_SUMMARY', 'PRICE_PROPOSAL', 'CLOSING'].includes(b.type))
    .map((b) => ({ blockType: b.type, text: b.defaultContent })),
};
