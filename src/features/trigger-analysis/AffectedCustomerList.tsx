import type { AffectedCustomer } from '@/types/customer.types';
import AlertBadge from '@/components/badges/AlertBadge';
import styles from './AffectedCustomerList.module.css';

const AffectedCustomerList = ({ customers }: { customers: AffectedCustomer[] }) => {
  if (customers.length === 0) {
    return <p className={styles.empty}>직접 영향 고객사 없음</p>;
  }

  return (
    <div className={styles.list}>
      {customers.map((c) => (
        <div key={c.customerId} className={styles.row}>
          <div className={styles.nameCol}>
            <span className={styles.name}>{c.customerName}</span>
            <span className={styles.product}>{c.product}</span>
          </div>
          <div className={styles.metaCol}>
            <span className={styles.volume}>{c.monthlyVolumeTon.toLocaleString()}t/월</span>
            <AlertBadge level={c.riskLevel} size="sm" />
          </div>
          <div className={styles.scoreCol}>
            <span className={styles.score}>{c.riskScore}점</span>
          </div>
        </div>
      ))}
    </div>
  );
};

export default AffectedCustomerList;
