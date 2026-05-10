import type { ReactNode } from 'react';
import styles from './SplitLayout.module.css';

interface SplitLayoutProps {
  left: ReactNode;
  right: ReactNode;
  ratio?: '70/30' | '30/70' | '50/50';
}

const SplitLayout = ({ left, right, ratio = '50/50' }: SplitLayoutProps) => {
  const ratioClass =
    ratio === '70/30'
      ? styles.ratio7030
      : ratio === '30/70'
      ? styles.ratio3070
      : styles.ratio5050;

  return (
    <div className={`${styles.layout} ${ratioClass}`}>
      <div>{left}</div>
      <div>{right}</div>
    </div>
  );
};

export default SplitLayout;
