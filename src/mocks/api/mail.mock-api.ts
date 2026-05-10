import type { MailBlock, MailDraft } from '@/types/mail.types';
import { mockMailBlocks, mockDefaultDraft } from '@/mocks/fixtures/mail.fixture';

export const fetchMailBlocks = (): Promise<MailBlock[]> =>
  new Promise((resolve) => setTimeout(() => resolve(mockMailBlocks), 200));

export const fetchDefaultDraft = (): Promise<MailDraft> =>
  new Promise((resolve) => setTimeout(() => resolve(mockDefaultDraft), 200));
