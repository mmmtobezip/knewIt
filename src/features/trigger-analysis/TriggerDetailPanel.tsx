import { useTriggerStore } from '@/store/trigger/useTriggerStore';
import type { TriggerStore } from '@/store/trigger/useTriggerStore';
import AlertBadge from '@/components/badges/AlertBadge';
import CauseFlowChart from './CauseFlowChart';
import AffectedCustomerList from './AffectedCustomerList';
import StrategyCards from './StrategyCards';
import styles from './TriggerDetailPanel.module.css';

const selectSelectedTrigger = (s: TriggerStore) =>
  s.triggers.find((t) => t.id === s.selectedTriggerId) ?? null;

const TriggerDetailPanel = () => {
  const trigger = useTriggerStore(selectSelectedTrigger);

  if (!trigger) {
    return (
      <div className={styles.empty}>
        <p>왼쪽 목록에서 트리거를 선택하세요.</p>
      </div>
    );
  }

  const sign = trigger.changeDirection === 'UP' ? '▲' : '▼';
  const changeClass = trigger.changeDirection === 'UP' ? styles.up : styles.down;

  return (
    <div className={styles.panel}>
      <div className={styles.header}>
        <div className={styles.headerTop}>
          <h2 className={styles.indicatorName}>{trigger.indicatorName}</h2>
          <AlertBadge level={trigger.alertLevel} size="md" />
        </div>
        <div className={styles.headerMeta}>
          <span className={`${styles.change} ${changeClass}`}>
            {sign} {Math.abs(trigger.changePercent)}%
          </span>
          <span className={styles.source}>{trigger.source}</span>
          <span className={styles.detectedAt}>
            감지: {new Date(trigger.detectedAt).toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' })}
          </span>
        </div>
      </div>

      <section className={styles.section}>
        <h3 className={styles.sectionTitle}>원인 분석 흐름</h3>
        <CauseFlowChart steps={trigger.causeFlow} />
      </section>

      <section className={styles.section}>
        <h3 className={styles.sectionTitle}>영향 고객사</h3>
        <AffectedCustomerList customers={trigger.affectedCustomers} />
      </section>

      <section className={styles.section}>
        <h3 className={styles.sectionTitle}>협상 전략 추천</h3>
        <StrategyCards strategies={trigger.strategies} />
      </section>
    </div>
  );
};

export default TriggerDetailPanel;
