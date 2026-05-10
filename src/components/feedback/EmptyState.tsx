import styles from './EmptyState.module.css';

interface EmptyStateProps {
  message: string;
  icon?: string;
}

const EmptyState = ({ message, icon = '—' }: EmptyStateProps) => (
  <div className={styles.wrapper}>
    <span className={styles.icon}>{icon}</span>
    <span className={styles.message}>{message}</span>
  </div>
);

export default EmptyState;
