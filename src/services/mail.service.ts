import { fetchMailBlocks, fetchDefaultDraft } from '@/mocks/api/mail.mock-api';
import type { MailBlock, MailDraft } from '@/types/mail.types';

export const mailService = {
  getBlocks: (): Promise<MailBlock[]> => fetchMailBlocks(),
  getDefaultDraft: (): Promise<MailDraft> => fetchDefaultDraft(),
};
