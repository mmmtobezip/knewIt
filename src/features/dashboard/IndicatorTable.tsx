import { useNavigate } from 'react-router-dom';
import { useDashboardStore } from '@/store/dashboard/useDashboardStore';
import type { DashboardStore } from '@/store/dashboard/useDashboardStore';
import DataTable, { type ColumnDef } from '@/components/tables/DataTable';
import AlertBadge from '@/components/badges/AlertBadge';
import type { Indicator } from '@/types/dashboard.types';
import styles from './IndicatorTable.module.css';

const selectIndicators = (s: DashboardStore) => s.indicators;

const columns: ColumnDef<Indicator>[] = [
  {
    key: 'name',
    header: '지표',
    width: '35%',
    render: (row) => <span className={styles.indicatorName}>{row.name}</span>,
  },
  {
    key: 'value',
    header: '현재값',
    width: '25%',
    render: (row) => (
      <span className={styles.value}>
        {row.currentValue}
        {row.unit && <span className={styles.unit}>{row.unit}</span>}
      </span>
    ),
  },
  {
    key: 'change',
    header: '변동',
    width: '20%',
    render: (row) => {
      const isUp = row.changeDirection === 'UP';
      const isFlat = row.changeDirection === 'FLAT';
      const dirClass = isUp ? styles.changeUp : isFlat ? styles.changeFlat : styles.changeDown;
      const arrow = isUp ? '▲' : isFlat ? '—' : '▼';
      return (
        <span className={`${styles.change} ${dirClass}`}>
          {arrow} {isFlat ? '0.0' : Math.abs(row.changePercent).toFixed(1)}%
        </span>
      );
    },
  },
  {
    key: 'alert',
    header: '알림',
    width: '20%',
    render: (row) => <AlertBadge level={row.alertLevel} size="sm" />,
  },
];

const IndicatorTable = () => {
  const indicators = useDashboardStore(selectIndicators);
  const navigate = useNavigate();

  const handleRowClick = (indicator: Indicator) => {
    if (indicator.triggerId) {
      navigate(`/triggers?triggerId=${indicator.triggerId}`);
    }
  };

  return (
    <div className={styles.wrapper}>
      <h3 className={styles.title}>시장 지표</h3>
      <DataTable
        columns={columns}
        rows={indicators}
        rowKey={(row) => row.id}
        onRowClick={handleRowClick}
        emptyMessage="지표 데이터가 없습니다."
      />
    </div>
  );
};

export default IndicatorTable;
