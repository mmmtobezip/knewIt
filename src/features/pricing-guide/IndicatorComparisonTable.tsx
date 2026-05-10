import type { IndicatorComparison } from '@/types/pricing.types';
import styles from './IndicatorComparisonTable.module.css';

const IndicatorComparisonTable = ({ rows }: { rows: IndicatorComparison[] }) => (
  <div className={styles.table}>
    <div className={styles.thead}>
      <span>지표</span>
      <span>현재</span>
      <span>과거 유사 시점</span>
      <span>변화</span>
    </div>
    {rows.map((row) => {
      const sign = row.changeDirection === 'UP' ? '▲' : row.changeDirection === 'DOWN' ? '▼' : '—';
      const cls = row.changeDirection === 'UP' ? styles.up : row.changeDirection === 'DOWN' ? styles.down : '';
      return (
        <div key={row.indicatorName} className={styles.row}>
          <span className={styles.name}>{row.indicatorName}</span>
          <span className={styles.current}>{row.currentValue}</span>
          <span className={styles.past}>{row.pastValue}</span>
          <span className={`${styles.change} ${cls}`}>
            {sign} {Math.abs(row.changePercent)}%
          </span>
        </div>
      );
    })}
  </div>
);

export default IndicatorComparisonTable;
