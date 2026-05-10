import { usePersonalizationStore } from '@/store/personalization/usePersonalizationStore';
import type { PersonalizationStore } from '@/store/personalization/usePersonalizationStore';
import styles from './AlertPreviewPanel.module.css';

const selectPreview = (s: PersonalizationStore) => s.alertPreview;

const AlertPreviewPanel = () => {
  const preview = usePersonalizationStore(selectPreview);

  return (
    <div className={styles.panel}>
      <div className={styles.header}>
        <h3 className={styles.title}>알림 우선순위 미리보기</h3>
        <span className={styles.subtitle}>현재 가중치 기준 추천 질문 순위</span>
      </div>
      <div className={styles.list}>
        {preview.map((item) => (
          <div key={item.questionId} className={styles.row}>
            <span className={styles.rank}>#{item.rank}</span>
            <div className={styles.content}>
              <p className={styles.question}>{item.questionText}</p>
              <div className={styles.scoreBar}>
                <div
                  className={styles.scoreFill}
                  style={{ width: `${Math.round(item.score * 100)}%` }}
                />
              </div>
            </div>
            <span className={styles.score}>{Math.round(item.score * 100)}점</span>
          </div>
        ))}
      </div>
    </div>
  );
};

export default AlertPreviewPanel;
