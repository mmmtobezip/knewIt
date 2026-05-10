import type { NegotiationStrategy } from '@/types/trigger.types';
import type { StrategyTone } from '@/types/common.types';
import styles from './StrategyCards.module.css';

const toneLabel: Record<StrategyTone, string> = {
  CONSERVATIVE: '방어적',
  BALANCED: '균형',
  AGGRESSIVE: '적극적',
};

const StrategyCard = ({ strategy }: { strategy: NegotiationStrategy }) => (
  <div className={`${styles.card} ${styles[`tone_${strategy.tone}`]}`}>
    <div className={styles.cardHeader}>
      <span className={styles.tone}>{toneLabel[strategy.tone]}</span>
      <span className={styles.title}>{strategy.title}</span>
    </div>
    <p className={styles.description}>{strategy.description}</p>
    <div className={styles.meta}>
      <div className={styles.metaItem}>
        <span className={styles.metaLabel}>예상 리스크</span>
        <span className={styles.metaValue}>{strategy.expectedRisk}</span>
      </div>
      <div className={styles.metaItem}>
        <span className={styles.metaLabel}>예상 마진</span>
        <span className={styles.metaValue}>{strategy.expectedMarginRate}</span>
      </div>
    </div>
  </div>
);

const StrategyCards = ({ strategies }: { strategies: NegotiationStrategy[] }) => (
  <div className={styles.grid}>
    {strategies.map((s) => (
      <StrategyCard key={s.tone} strategy={s} />
    ))}
  </div>
);

export default StrategyCards;
