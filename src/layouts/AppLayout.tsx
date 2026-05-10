import { useEffect } from 'react';
import { Outlet } from 'react-router-dom';
import GNB from './GNB';
import ContextBar from './ContextBar';
import CustomerSidePanel from './CustomerSidePanel';
import { useAppStore } from '@/store/app/useAppStore';
import type { AppStore } from '@/store/app/useAppStore';
import { userService } from '@/services/user.service';
import styles from './AppLayout.module.css';

const selectDrawerOpen = (s: AppStore) => s.drawerOpen;

const AppLayout = () => {
  const drawerOpen = useAppStore(selectDrawerOpen);

  useEffect(() => {
    userService.getCurrentUser().then((ctx) => {
      useAppStore.getState().setUserContext(ctx);
    });
  }, []);

  return (
    <div className={styles.layout}>
      <GNB />
      <div className={styles.topBar}>
        <ContextBar />
      </div>
      <div className={styles.body}>
        <main className={`${styles.main} ${drawerOpen ? styles.mainWithDrawer : ''}`}>
          <Outlet />
        </main>
        <CustomerSidePanel />
      </div>
    </div>
  );
};

export default AppLayout;
