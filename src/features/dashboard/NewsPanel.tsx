import { useNavigate } from 'react-router-dom';
import { useDashboardStore } from '@/store/dashboard/useDashboardStore';
import type { DashboardStore } from '@/store/dashboard/useDashboardStore';
import NewsCard from '@/components/cards/NewsCard';
import type { NewsItem } from '@/types/dashboard.types';
import styles from './NewsPanel.module.css';

const selectNews = (s: DashboardStore) => s.news;

const NewsPanel = () => {
  const news = useDashboardStore(selectNews);
  const navigate = useNavigate();

  const handleNewsClick = (item: NewsItem) => {
    if (item.triggerId) {
      navigate(`/triggers?triggerId=${item.triggerId}`);
    }
  };

  return (
    <div className={styles.panel}>
      <h3 className={styles.title}>관련 뉴스</h3>
      <div className={styles.list}>
        {news.map((item) => (
          <NewsCard key={item.id} item={item} onClick={handleNewsClick} />
        ))}
      </div>
    </div>
  );
};

export default NewsPanel;
