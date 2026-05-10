import { useState } from 'react';
import { useDashboardStore } from '@/store/dashboard/useDashboardStore';
import type { DashboardStore } from '@/store/dashboard/useDashboardStore';
import type { Question } from '@/types/dashboard.types';
import styles from './QuestionPanel.module.css';

const selectQuestions = (s: DashboardStore) => s.questions;

const ScoreBar = ({ score }: { score: number }) => (
  <div className={styles.scoreBar}>
    <div className={styles.scoreFill} style={{ width: `${score * 100}%` }} />
  </div>
);

const QuestionItem = ({
  question,
  isExpanded,
  onToggle,
}: {
  question: Question;
  isExpanded: boolean;
  onToggle: () => void;
}) => (
  <div className={`${styles.item} ${isExpanded ? styles.itemExpanded : ''}`}>
    <button className={styles.questionBtn} onClick={onToggle}>
      <div className={styles.questionTop}>
        <span className={styles.questionText}>{question.text}</span>
        <span className={styles.chevron}>{isExpanded ? '▲' : '▼'}</span>
      </div>
      <div className={styles.scoreMeta}>
        <ScoreBar score={question.weightedScore} />
        <span className={styles.scoreLabel}>
          관련도 {Math.round(question.weightedScore * 100)}%
        </span>
      </div>
    </button>
    {isExpanded && (
      <div className={styles.answer}>
        <p className={styles.answerText}>{question.answerSummary}</p>
        <div className={styles.answerMeta}>
          <span className={styles.productTag}>{question.product}</span>
        </div>
      </div>
    )}
  </div>
);

const QuestionPanel = () => {
  const questions = useDashboardStore(selectQuestions);
  const [expandedId, setExpandedId] = useState<string | null>(null);

  const handleToggle = (id: string) => {
    setExpandedId((prev) => (prev === id ? null : id));
  };

  return (
    <div className={styles.panel}>
      <h3 className={styles.title}>추천 질문</h3>
      <div className={styles.list}>
        {questions.map((q) => (
          <QuestionItem
            key={q.id}
            question={q}
            isExpanded={expandedId === q.id}
            onToggle={() => handleToggle(q.id)}
          />
        ))}
      </div>
    </div>
  );
};

export default QuestionPanel;
