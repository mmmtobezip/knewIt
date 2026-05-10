import type { ReactNode } from 'react';
import styles from './PageGrid.module.css';

interface PageGridProps {
  children: ReactNode;
  cols?: 1 | 2 | 3;
  className?: string;
}

const PageGrid = ({ children, cols = 2, className }: PageGridProps) => {
  const colsClass = styles[`cols${cols}` as keyof typeof styles];

  return (
    <div className={`${styles.grid} ${colsClass} ${className ?? ''}`}>
      {children}
    </div>
  );
};

export default PageGrid;
