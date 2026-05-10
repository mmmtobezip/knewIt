import type { ProductType } from './common.types';
import type { Customer } from './customer.types';

export interface UserContext {
  id: string;
  name: string;
  role: string;
  products: ProductType[];
  customers: Customer[];
}
