import type { PriceGuide } from '@/types/pricing.types';
import styles from './PriceGuideCard.module.css';

const difficultyLabel = { EASY: '낮음', MEDIUM: '중간', HARD: '높음' };
const difficultyClass = { EASY: styles.easy, MEDIUM: styles.medium, HARD: styles.hard };

const fmt = (n: number) => n.toLocaleString('ko-KR');

const PriceGuideCard = ({ guide }: { guide: PriceGuide }) => (
  <div className={styles.card}>
    <div className={styles.header}>
      <span className={styles.customer}>{guide.customerName}</span>
      <span className={styles.product}>{guide.product}</span>
    </div>

    <div className={styles.priceGrid}>
      <div className={styles.priceItem}>
        <span className={styles.priceLabel}>Rule-base 가격</span>
        <span className={styles.priceValue}>{fmt(guide.ruleBasePrice)}원</span>
        <span className={styles.priceUnit}>/{guide.unit}</span>
      </div>
      <div className={`${styles.priceItem} ${styles.aiPrice}`}>
        <span className={styles.priceLabel}>AI 추천 가격</span>
        <span className={styles.priceValue}>{fmt(guide.aiAdjustedPrice)}원</span>
        <span className={styles.priceUnit}>/{guide.unit}</span>
      </div>
    </div>

    <div className={styles.rangeSection}>
      <span className={styles.rangeLabel}>협상 가능 범위</span>
      <div className={styles.rangeBar}>
        <span className={styles.rangeMin}>{fmt(guide.negotiationMinPrice)}원</span>
        <div className={styles.barTrack}>
          <div className={styles.barFill} />
        </div>
        <span className={styles.rangeMax}>{fmt(guide.negotiationMaxPrice)}원</span>
      </div>
    </div>

    <div className={styles.footer}>
      <span className={styles.diffLabel}>협상 난이도</span>
      <span className={`${styles.diffBadge} ${difficultyClass[guide.negotiationDifficulty]}`}>
        {difficultyLabel[guide.negotiationDifficulty]}
      </span>
    </div>
  </div>
);

export default PriceGuideCard;
