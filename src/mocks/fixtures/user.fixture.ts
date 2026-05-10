import type { UserContext } from '@/types/user.types';
import { mockCustomers } from './customers.fixture';

export const mockUserContext: UserContext = {
  id: 'user-001',
  name: '이윤진',
  role: '판매사원',
  products: ['선재', 'HR(고로밀)'],
  customers: mockCustomers,
};
