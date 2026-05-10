import styles from './LoadingSpinner.module.css';

interface LoadingSpinnerProps {
  message?: string;
}

const LoadingSpinner = ({ message = '로딩 중...' }: LoadingSpinnerProps) => {
  return (
    <div className={styles.wrapper}>
      <div className={styles.spinner} />
      <span>{message}</span>
    </div>
  );
};

export default LoadingSpinner;
