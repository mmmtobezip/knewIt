import { useAppStore } from './useAppStore';
import type { AppStore } from './useAppStore';
import type { Customer } from '@/types/customer.types';

const selectCustomer = (s: AppStore): Customer | null => {
  if (!s.selectedCustomerId || !s.userContext) return null;
  return s.userContext.customers.find((c) => c.id === s.selectedCustomerId) ?? null;
};

export const useSelectedCustomer = (): Customer | null =>
  useAppStore(selectCustomer);
