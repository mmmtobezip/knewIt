import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { STORAGE_KEYS } from '@/shared/constants';

/**
 * 고객사/제품 선택 상태
 *
 * main-ipo.md § 1-2 last_selection 매핑
 * - localStorage 영속 (페이지 재진입 시 복원)
 * - 변경 시 P-02 / P-03 트리거됨
 *
 * 선택 변경은 채팅 세션 무조건 새로 시작 (Q2) — chat-store 에서 reset 호출
 */
interface SelectionState {
  customerId: string | null;
  productCode: string | null;
  setCustomer: (id: string) => void;
  setProduct: (code: string) => void;
  reset: () => void;
}

export const useSelectionStore = create<SelectionState>()(
  persist(
    (set) => ({
      customerId: null,
      productCode: null,
      setCustomer: (id) => set({ customerId: id }),
      setProduct: (code) => set({ productCode: code }),
      reset: () => set({ customerId: null, productCode: null }),
    }),
    {
      name: STORAGE_KEYS.LAST_SELECTION,
      storage: createJSONStorage(() => localStorage),
      // SSR 환경에서 hydration mismatch 방지
      skipHydration: false,
    },
  ),
);
