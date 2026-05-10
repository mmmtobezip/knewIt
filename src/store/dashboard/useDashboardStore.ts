import { create } from 'zustand';
import type { CoreMessage, Indicator, NewsItem, Question } from '@/types/dashboard.types';
import type { CustomerRisk } from '@/types/customer.types';
import { getDashboardData } from '@/services/dashboard.service';

interface DashboardState {
  coreMessage: CoreMessage | null;
  indicators: Indicator[];
  news: NewsItem[];
  questions: Question[];
  customerRisks: CustomerRisk[];
  loading: boolean;
  error: string | null;
}

interface DashboardActions {
  loadDashboardData: () => Promise<void>;
}

export type DashboardStore = DashboardState & DashboardActions;

export const useDashboardStore = create<DashboardStore>()((set) => ({
  coreMessage: null,
  indicators: [],
  news: [],
  questions: [],
  customerRisks: [],
  loading: false,
  error: null,

  loadDashboardData: async () => {
    set({ loading: true, error: null });
    try {
      const data = await getDashboardData();
      set({
        coreMessage: data.coreMessage,
        indicators: data.indicators,
        news: data.news,
        questions: data.questions,
        customerRisks: data.customerRisks,
        loading: false,
      });
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : '데이터 로드 실패',
        loading: false,
      });
    }
  },
}));
