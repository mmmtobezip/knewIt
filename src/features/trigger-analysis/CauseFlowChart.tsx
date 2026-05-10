import type { CauseStep } from '@/types/trigger.types';
import styles from './CauseFlowChart.module.css';

const stepTypeLabel: Record<CauseStep['type'], string> = {
  TRIGGER: '원인',
  KEY: '핵심 변화',
  INTERMEDIATE: '영향',
  OUTCOME: '결과',
};

const CauseFlowChart = ({ steps }: { steps: CauseStep[] }) => (
  <div className={styles.chart}>
    {steps.map((step, i) => (
      <div key={step.id} className={styles.stepWrapper}>
        <div className={`${styles.step} ${styles[`type_${step.type}`]}`}>
          <span className={styles.typeLabel}>{stepTypeLabel[step.type]}</span>
          <span className={styles.label}>{step.label}</span>
          <span className={styles.sublabel}>{step.sublabel}</span>
        </div>
        {i < steps.length - 1 && <div className={styles.arrow}>→</div>}
      </div>
    ))}
  </div>
);

export default CauseFlowChart;
