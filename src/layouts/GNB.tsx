import { useLocation, useNavigate } from 'react-router-dom';
import { GNB_NAV_ITEMS } from '@/constants/navigation';
import { ROUTES } from '@/constants/routes';
import { useAppStore } from '@/store/app/useAppStore';
import type { AppStore } from '@/store/app/useAppStore';
import { useTriggerStore } from '@/store/trigger/useTriggerStore';
import type { TriggerStore } from '@/store/trigger/useTriggerStore';
import styles from './GNB.module.css';

const selectUserContext = (s: AppStore) => s.userContext;
const selectAlertCount = (s: TriggerStore) => s.triggers.filter((t) => t.alertLevel === 'HIGH').length;

const GNB = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const userContext = useAppStore(selectUserContext);
  const highAlertCount = useTriggerStore(selectAlertCount);

  const userName = userContext?.name ?? '';
  const userInitial = userName ? userName.charAt(0) : '이';

  return (
    <header className={styles.gnb}>
      <button className={styles.logo} onClick={() => navigate(ROUTES.DASHBOARD)}>
        STEEL<span className={styles.logoAccent}>INSIGHT</span>
      </button>

      <nav className={styles.nav}>
        {GNB_NAV_ITEMS.map((item) => {
          const isActive =
            item.path === ROUTES.DASHBOARD
              ? location.pathname === ROUTES.DASHBOARD
              : location.pathname.startsWith(item.path);

          const count = item.badgeKey === 'triggerAlertCount' ? highAlertCount : 0;

          return (
            <button
              key={item.path}
              className={`${styles.navBtn} ${isActive ? styles.navBtnActive : ''}`}
              onClick={() => navigate(item.path)}
            >
              {item.label}
              {count > 0 && <span className={styles.badge}>{count}</span>}
            </button>
          );
        })}
      </nav>

      <div className={styles.right}>
        <div className={styles.userAvatar} title={userName}>
          {userInitial}
        </div>
      </div>
    </header>
  );
};

export default GNB;
