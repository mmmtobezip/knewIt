import { create } from 'zustand';
import type { Trigger } from '@/types/trigger.types';
import { triggerService } from '@/services/trigger.service';

interface TriggerState {
  triggers: Trigger[];
  selectedTriggerId: string | null;
  loading: boolean;
  error: string | null;
}

interface TriggerActions {
  loadTriggers: () => Promise<void>;
  selectTrigger: (id: string) => void;
}

export type TriggerStore = TriggerState & TriggerActions;

export const useTriggerStore = create<TriggerStore>()((set) => ({
  triggers: [],
  selectedTriggerId: null,
  loading: false,
  error: null,

  loadTriggers: async () => {
    set({ loading: true, error: null });
    try {
      const { triggers } = await triggerService.getAll();
      set({ triggers, loading: false });
    } catch {
      set({ error: '트리거 데이터를 불러오지 못했습니다.', loading: false });
    }
  },

  selectTrigger: (id) => set({ selectedTriggerId: id }),
}));
