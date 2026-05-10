import type { ReactNode } from 'react';
import styles from './ActionButton.module.css';

interface ActionButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'ghost' | 'outline' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  icon?: ReactNode;
  disabled?: boolean;
  type?: 'button' | 'submit';
  fullWidth?: boolean;
}

const ActionButton = ({
  label,
  onClick,
  variant = 'primary',
  size = 'md',
  icon,
  disabled = false,
  type = 'button',
  fullWidth = false,
}: ActionButtonProps) => {
  const variantClass =
    styles[`variant${variant.charAt(0).toUpperCase()}${variant.slice(1)}` as keyof typeof styles];
  const sizeClass =
    styles[`size${size.charAt(0).toUpperCase()}${size.slice(1)}` as keyof typeof styles];

  return (
    <button
      type={type}
      className={`${styles.btn} ${variantClass} ${sizeClass}`}
      onClick={onClick}
      disabled={disabled}
      style={fullWidth ? { width: '100%' } : undefined}
    >
      {icon && <span>{icon}</span>}
      {label}
    </button>
  );
};

export default ActionButton;
