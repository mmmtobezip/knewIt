import { create } from 'zustand';
import type { UserContext } from '@/types/user.types';

interface AppState {
  userContext: UserContext | null;
  selectedCustomerId: string | null;
  drawerOpen: boolean;
}

interface AppActions {
  setUserContext: (ctx: UserContext) => void;
  openCustomerDrawer: (customerId: string) => void;
  closeCustomerDrawer: () => void;
}

export type AppStore = AppState & AppActions;

export const useAppStore = create<AppStore>()((set) => ({
  userContext: null,
  selectedCustomerId: null,
  drawerOpen: false,

  setUserContext: (ctx) => set({ userContext: ctx }),

  openCustomerDrawer: (customerId) =>
    set({ selectedCustomerId: customerId, drawerOpen: true }),

  closeCustomerDrawer: () =>
    set({ selectedCustomerId: null, drawerOpen: false }),
}));
