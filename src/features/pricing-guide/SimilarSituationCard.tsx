import type { SimilarSituation } from '@/types/pricing.types';
import RadarChart from '@/components/charts/RadarChart';
import styles from './SimilarSituationCard.module.css';

const SimilarSituationCard = ({ situation }: { situation: SimilarSituation }) => (
  <div className={styles.card}>
    <div className={styles.header}>
      <div className={styles.titleRow}>
        <span className={styles.title}>유사 상황 분석</span>
        <span className={styles.similarity}>{situation.similarityPercent}% 유사</span>
      </div>
      <span className={styles.period}>{situation.period}</span>
    </div>

    <p className={styles.description}>{situation.description}</p>

    <RadarChart
      data={situation.radarData}
      currentLabel="현재"
      pastLabel={situation.period}
    />

    <div className={styles.outcomeGrid}>
      <div className={styles.outcomeItem}>
        <span className={styles.outcomeLabel}>합의 가격</span>
        <span className={styles.outcomeValue}>
          {situation.agreedPrice.toLocaleString('ko-KR')}원/톤
        </span>
      </div>
      <div className={styles.outcomeItem}>
        <span className={styles.outcomeLabel}>사용 전략</span>
        <span className={styles.outcomeValue}>{situation.strategyUsed}</span>
      </div>
      <div className={styles.outcomeItem}>
        <span className={styles.outcomeLabel}>마진 유지율</span>
        <span className={styles.outcomeValue}>+{situation.marginRetentionRate}%</span>
      </div>
    </div>
  </div>
);

export default SimilarSituationCard;
