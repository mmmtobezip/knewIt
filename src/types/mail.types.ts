export type MailBlockType =
  | 'GREETING'
  | 'MARKET_SUMMARY'
  | 'NEGOTIATION_POSITION'
  | 'PRICE_PROPOSAL'
  | 'QUALITY_STRENGTH'
  | 'MEETING_REQUEST'
  | 'CLOSING';

export interface MailBlock {
  type: MailBlockType;
  label: string;
  description: string;
  defaultContent: string;
}

export interface MailContent {
  blockType: MailBlockType;
  text: string;
}

export interface MailDraft {
  recipient: string;
  cc: string;
  subject: string;
  blocks: MailContent[];
}
