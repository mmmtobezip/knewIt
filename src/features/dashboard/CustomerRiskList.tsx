import AlertBadge from '@/components/badges/AlertBadge';
import type { CustomerRisk } from '@/types/customer.types';
import styles from './CustomerRiskList.module.css';

interface CustomerRiskListProps {
  risks: CustomerRisk[];
  onCustomerClick?: (customerId: string) => void;
}

const CustomerRiskList = ({ risks, onCustomerClick }: CustomerRiskListProps) => {
  return (
    <div className={styles.panel}>
      <h3 className={styles.title}>고객사 리스크</h3>
      <div className={styles.list}>
        {risks.map((risk) => (
          <div
            key={risk.customerId}
            className={`${styles.row} ${onCustomerClick ? styles.rowClickable : ''}`}
            onClick={onCustomerClick ? () => onCustomerClick(risk.customerId) : undefined}
          >
            <div className={styles.left}>
              <div className={styles.nameRow}>
                <span className={styles.name}>{risk.customerName}</span>
                <AlertBadge level={risk.riskLevel} size="sm" />
              </div>
              <p className={styles.reason}>{risk.riskReason}</p>
              <div className={styles.tags}>
                {risk.affectedProducts.map((p) => (
                  <span key={p} className={styles.productTag}>{p}</span>
                ))}
              </div>
            </div>
            <div className={styles.score}>
              <span className={styles.scoreValue}>{risk.riskScore}</span>
              <span className={styles.scoreLabel}>점</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default CustomerRiskList;
