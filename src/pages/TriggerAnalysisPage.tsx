import { useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import { useTriggerStore } from '@/store/trigger/useTriggerStore';
import type { TriggerStore } from '@/store/trigger/useTriggerStore';
import SplitLayout from '@/components/layout/SplitLayout';
import TriggerList from '@/features/trigger-analysis/TriggerList';
import TriggerDetailPanel from '@/features/trigger-analysis/TriggerDetailPanel';
import LoadingSpinner from '@/components/feedback/LoadingSpinner';
import ErrorMessage from '@/components/feedback/ErrorMessage';
import styles from './TriggerAnalysisPage.module.css';

const selectLoading = (s: TriggerStore) => s.loading;
const selectError = (s: TriggerStore) => s.error;

const TriggerAnalysisPage = () => {
  const [searchParams] = useSearchParams();
  const loading = useTriggerStore(selectLoading);
  const error = useTriggerStore(selectError);

  useEffect(() => {
    useTriggerStore.getState().loadTriggers().then(() => {
      const triggerId = searchParams.get('triggerId');
      if (triggerId) {
        useTriggerStore.getState().selectTrigger(triggerId);
      }
    });
  }, [searchParams]);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} onRetry={() => useTriggerStore.getState().loadTriggers()} />;

  return (
    <div className={styles.page}>
      <SplitLayout
        ratio="30/70"
        left={<TriggerList />}
        right={<TriggerDetailPanel />}
      />
    </div>
  );
};

export default TriggerAnalysisPage;
