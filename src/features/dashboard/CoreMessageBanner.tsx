import { useNavigate } from 'react-router-dom';
import { useDashboardStore } from '@/store/dashboard/useDashboardStore';
import type { DashboardStore } from '@/store/dashboard/useDashboardStore';
import ActionButton from '@/components/buttons/ActionButton';
import AlertBadge from '@/components/badges/AlertBadge';
import styles from './CoreMessageBanner.module.css';

const selectCoreMessage = (s: DashboardStore) => s.coreMessage;

const CoreMessageBanner = () => {
  const coreMessage = useDashboardStore(selectCoreMessage);
  const navigate = useNavigate();

  if (!coreMessage) return null;

  return (
    <div className={`${styles.banner} ${styles[`level${coreMessage.level}`]}`}>
      <div className={styles.left}>
        <AlertBadge level={coreMessage.level} size="sm" />
        <div className={styles.content}>
          <p className={styles.headline}>{coreMessage.headline}</p>
          <p className={styles.subText}>{coreMessage.subText}</p>
        </div>
      </div>
      <ActionButton
        label={coreMessage.ctaLabel}
        onClick={() => {
          const route = coreMessage.triggerId
            ? `${coreMessage.ctaRoute}?triggerId=${coreMessage.triggerId}`
            : coreMessage.ctaRoute;
          navigate(route);
        }}
        variant="primary"
        size="sm"
      />
    </div>
  );
};

export default CoreMessageBanner;
