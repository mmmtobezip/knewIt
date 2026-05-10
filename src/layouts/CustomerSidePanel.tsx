import { useAppStore } from '@/store/app/useAppStore';
import type { AppStore } from '@/store/app/useAppStore';
import { useSelectedCustomer } from '@/store/app/appStore.selectors';
import SideDrawer from '@/components/drawers/SideDrawer';
import AlertBadge from '@/components/badges/AlertBadge';
import styles from './CustomerSidePanel.module.css';

const selectDrawerOpen = (s: AppStore) => s.drawerOpen;

const CustomerSidePanel = () => {
  const drawerOpen = useAppStore(selectDrawerOpen);
  const customer = useSelectedCustomer();

  return (
    <SideDrawer
      open={drawerOpen}
      onClose={() => useAppStore.getState().closeCustomerDrawer()}
      title={customer?.name ?? '고객사 정보'}
    >
      {customer ? (
        <div className={styles.content}>
          <div className={styles.header}>
            <div className={styles.nameRow}>
              <span className={styles.country}>{customer.country}</span>
              <AlertBadge level={customer.riskLevel} size="sm" />
            </div>
            <div className={styles.scoreRow}>
              <span className={styles.scoreLabel}>리스크 점수</span>
              <span className={styles.scoreValue}>{customer.riskScore}점</span>
            </div>
          </div>

          <section className={styles.section}>
            <h4 className={styles.sectionTitle}>담당자</h4>
            <p className={styles.contactName}>{customer.contactName}</p>
            <a href={`mailto:${customer.contactEmail}`} className={styles.contactEmail}>
              {customer.contactEmail}
            </a>
          </section>

          <section className={styles.section}>
            <h4 className={styles.sectionTitle}>거래 제품</h4>
            <div className={styles.tags}>
              {customer.products.map((p) => (
                <span key={p} className={styles.productTag}>{p}</span>
              ))}
            </div>
          </section>

          <section className={styles.section}>
            <h4 className={styles.sectionTitle}>거래 규모</h4>
            <div className={styles.volumeGrid}>
              <div className={styles.volumeItem}>
                <span className={styles.volumeLabel}>월간</span>
                <span className={styles.volumeValue}>
                  {customer.monthlyVolumeTon.toLocaleString()}t
                </span>
              </div>
              <div className={styles.volumeItem}>
                <span className={styles.volumeLabel}>연간</span>
                <span className={styles.volumeValue}>
                  {customer.annualContractTon.toLocaleString()}t
                </span>
              </div>
            </div>
          </section>

          {customer.notes && (
            <section className={styles.section}>
              <h4 className={styles.sectionTitle}>메모</h4>
              <p className={styles.notes}>{customer.notes}</p>
            </section>
          )}
        </div>
      ) : (
        <div className={styles.empty}>
          <p>고객사를 선택해주세요.</p>
        </div>
      )}
    </SideDrawer>
  );
};

export default CustomerSidePanel;
