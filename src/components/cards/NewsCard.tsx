import type { NewsItem } from '@/types/dashboard.types';
import styles from './NewsCard.module.css';

interface NewsCardProps {
  item: NewsItem;
  onClick: (item: NewsItem) => void;
}

const SENTIMENT_LABEL: Record<NewsItem['sentiment'], string> = {
  POSITIVE: '긍정적',
  NEGATIVE: '부정적',
  NEUTRAL: '중립',
};

const NewsCard = ({ item, onClick }: NewsCardProps) => {
  const sentimentClass =
    styles[`sentiment${item.sentiment}` as keyof typeof styles];

  return (
    <div className={styles.card} onClick={() => onClick(item)}>
      <div className={styles.source}>{item.source} · {item.publishedAt}</div>
      <div className={styles.title}>{item.title}</div>
      <div className={styles.meta}>
        <span className={`${styles.sentimentTag} ${sentimentClass}`}>
          {SENTIMENT_LABEL[item.sentiment]}
        </span>
        <div className={styles.tags}>
          {item.tags.map((tag) => (
            <span key={tag} className={styles.tag}>
              {tag}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
};

export default NewsCard;
