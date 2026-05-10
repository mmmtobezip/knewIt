import { useAppStore } from '@/store/app/useAppStore';
import type { AppStore } from '@/store/app/useAppStore';
import styles from './ContextBar.module.css';

const selectUserContext = (s: AppStore) => s.userContext;

const today = new Date().toLocaleDateString('ko-KR', {
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
});

const ContextBar = () => {
  const userContext = useAppStore(selectUserContext);

  return (
    <div className={styles.contextBar}>
      <div className={styles.tag}>
        <span className={styles.tagLabel}>담당:</span>
        <span className={styles.tagValue}>{userContext?.name ?? '—'}</span>
      </div>
      <div className={styles.separator} />
      <div className={styles.tag}>
        <span className={styles.tagLabel}>날짜:</span>
        <span className={styles.tagValue}>{today}</span>
      </div>
      <div className={styles.spacer} />
      <span className={styles.updateTime}>최근 업데이트: 오전 9:02</span>
    </div>
  );
};

export default ContextBar;
