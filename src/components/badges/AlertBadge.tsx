import type { AlertLevel } from '@/types/common.types';
import styles from './AlertBadge.module.css';

interface AlertBadgeProps {
  level: AlertLevel;
  size?: 'sm' | 'md';
  label?: string;
}

const LEVEL_LABEL: Record<AlertLevel, string> = {
  HIGH: 'HIGH',
  MEDIUM: 'MEDIUM',
  LOW: 'LOW',
};

const AlertBadge = ({ level, size = 'md', label }: AlertBadgeProps) => {
  const sizeClass = size === 'sm' ? styles.sizeSm : styles.sizeMd;
  const levelClass = styles[`level${level}` as keyof typeof styles];

  return (
    <span className={`${styles.badge} ${sizeClass} ${levelClass}`}>
      {label ?? LEVEL_LABEL[level]}
    </span>
  );
};

export default AlertBadge;
