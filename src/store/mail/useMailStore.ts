import { create } from 'zustand';
import type { MailBlock, MailContent, MailDraft, MailBlockType } from '@/types/mail.types';
import { mailService } from '@/services/mail.service';

interface MailState {
  availableBlocks: MailBlock[];
  draft: MailDraft | null;
  loading: boolean;
  error: string | null;
}

interface MailActions {
  loadDraft: () => Promise<void>;
  toggleBlock: (type: MailBlockType) => void;
  updateBlockText: (type: MailBlockType, text: string) => void;
  updateField: (field: 'recipient' | 'cc' | 'subject', value: string) => void;
}

export type MailStore = MailState & MailActions;

export const useMailStore = create<MailStore>()((set, get) => ({
  availableBlocks: [],
  draft: null,
  loading: false,
  error: null,

  loadDraft: async () => {
    set({ loading: true, error: null });
    try {
      const [blocks, draft] = await Promise.all([
        mailService.getBlocks(),
        mailService.getDefaultDraft(),
      ]);
      set({ availableBlocks: blocks, draft, loading: false });
    } catch {
      set({ error: '메일 초안을 불러오지 못했습니다.', loading: false });
    }
  },

  toggleBlock: (type) => {
    const { draft, availableBlocks } = get();
    if (!draft) return;
    const exists = draft.blocks.find((b) => b.blockType === type);
    if (exists) {
      set({ draft: { ...draft, blocks: draft.blocks.filter((b) => b.blockType !== type) } });
    } else {
      const block = availableBlocks.find((b) => b.type === type);
      if (!block) return;
      const newBlock: MailContent = { blockType: type, text: block.defaultContent };
      set({ draft: { ...draft, blocks: [...draft.blocks, newBlock] } });
    }
  },

  updateBlockText: (type, text) => {
    const { draft } = get();
    if (!draft) return;
    set({
      draft: {
        ...draft,
        blocks: draft.blocks.map((b) => (b.blockType === type ? { ...b, text } : b)),
      },
    });
  },

  updateField: (field, value) => {
    const { draft } = get();
    if (!draft) return;
    set({ draft: { ...draft, [field]: value } });
  },
}));
