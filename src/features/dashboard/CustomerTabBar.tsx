import { useAppStore } from '@/store/app/useAppStore';
import AlertBadge from '@/components/badges/AlertBadge';
import type { AppStore } from '@/store/app/useAppStore';
import styles from './CustomerTabBar.module.css';

const selectUserContext = (s: AppStore) => s.userContext;
const selectSelectedCustomerId = (s: AppStore) => s.selectedCustomerId;

const CustomerTabBar = () => {
  const userContext = useAppStore(selectUserContext);
  const customers = userContext?.customers ?? [];
  const selectedCustomerId = useAppStore(selectSelectedCustomerId);

  return (
    <div className={styles.bar}>
      {customers.map((customer) => (
        <button
          key={customer.id}
          className={`${styles.tab} ${selectedCustomerId === customer.id ? styles.tabActive : ''}`}
          onClick={() => useAppStore.getState().openCustomerDrawer(customer.id)}
        >
          <span className={styles.name}>{customer.name}</span>
          <AlertBadge level={customer.riskLevel} size="sm" />
        </button>
      ))}
    </div>
  );
};

export default CustomerTabBar;
