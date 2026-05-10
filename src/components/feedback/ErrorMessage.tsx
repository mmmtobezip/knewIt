import styles from './ErrorMessage.module.css';

interface ErrorMessageProps {
  message: string;
  onRetry?: () => void;
}

const ErrorMessage = ({ message, onRetry }: ErrorMessageProps) => (
  <div className={styles.wrapper}>
    <span className={styles.icon}>⚠</span>
    <p className={styles.message}>{message}</p>
    {onRetry && (
      <button className={styles.retry} onClick={onRetry}>
        다시 시도
      </button>
    )}
  </div>
);

export default ErrorMessage;
