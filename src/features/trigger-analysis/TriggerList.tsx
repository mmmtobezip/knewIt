import { useTriggerStore } from '@/store/trigger/useTriggerStore';
import type { TriggerStore } from '@/store/trigger/useTriggerStore';
import type { Trigger } from '@/types/trigger.types';
import AlertBadge from '@/components/badges/AlertBadge';
import styles from './TriggerList.module.css';

const selectTriggers = (s: TriggerStore) => s.triggers;
const selectSelectedId = (s: TriggerStore) => s.selectedTriggerId;

const TriggerItem = ({
  trigger,
  isSelected,
  onSelect,
}: {
  trigger: Trigger;
  isSelected: boolean;
  onSelect: () => void;
}) => {
  const sign = trigger.changeDirection === 'UP' ? '▲' : '▼';
  const changeClass = trigger.changeDirection === 'UP' ? styles.up : styles.down;

  return (
    <button
      className={`${styles.item} ${isSelected ? styles.itemSelected : ''}`}
      onClick={onSelect}
    >
      <div className={styles.itemTop}>
        <span className={styles.indicatorName}>{trigger.indicatorName}</span>
        <AlertBadge level={trigger.alertLevel} size="sm" />
      </div>
      <div className={styles.itemBottom}>
        <span className={`${styles.change} ${changeClass}`}>
          {sign} {Math.abs(trigger.changePercent)}%
        </span>
        <span className={styles.source}>{trigger.source}</span>
      </div>
    </button>
  );
};

const TriggerList = () => {
  const triggers = useTriggerStore(selectTriggers);
  const selectedId = useTriggerStore(selectSelectedId);

  return (
    <div className={styles.panel}>
      <h3 className={styles.title}>트리거 목록</h3>
      <div className={styles.list}>
        {triggers.map((t) => (
          <TriggerItem
            key={t.id}
            trigger={t}
            isSelected={t.id === selectedId}
            onSelect={() => useTriggerStore.getState().selectTrigger(t.id)}
          />
        ))}
      </div>
    </div>
  );
};

export default TriggerList;
