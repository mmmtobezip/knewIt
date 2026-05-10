import type { ReactNode } from 'react';
import styles from './SideDrawer.module.css';

interface SideDrawerProps {
  open: boolean;
  onClose: () => void;
  title?: string;
  children: ReactNode;
}

const SideDrawer = ({ open, onClose, title, children }: SideDrawerProps) => {
  return (
    <aside
      className={`${styles.drawer} ${open ? styles.drawerOpen : ''}`}
      aria-hidden={!open}
    >
      {title && (
        <div className={styles.header}>
          <span className={styles.title}>{title}</span>
          <button className={styles.closeBtn} onClick={onClose} aria-label="닫기">
            ✕
          </button>
        </div>
      )}
      <div className={styles.content}>{children}</div>
    </aside>
  );
};

export default SideDrawer;
