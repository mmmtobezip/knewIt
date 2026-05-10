import { useEffect } from 'react';
import { usePersonalizationStore } from '@/store/personalization/usePersonalizationStore';
import type { PersonalizationStore } from '@/store/personalization/usePersonalizationStore';
import SplitLayout from '@/components/layout/SplitLayout';
import ProductWeightPanel from '@/features/personalization/ProductWeightPanel';
import AlertPreviewPanel from '@/features/personalization/AlertPreviewPanel';
import LoadingSpinner from '@/components/feedback/LoadingSpinner';
import ErrorMessage from '@/components/feedback/ErrorMessage';
import styles from './PersonalizationPage.module.css';

const selectLoading = (s: PersonalizationStore) => s.loading;
const selectError = (s: PersonalizationStore) => s.error;

const PersonalizationPage = () => {
  const loading = usePersonalizationStore(selectLoading);
  const error = usePersonalizationStore(selectError);

  useEffect(() => {
    usePersonalizationStore.getState().loadConfigs();
  }, []);

  if (loading) return <LoadingSpinner />;
  if (error)
    return (
      <ErrorMessage
        message={error}
        onRetry={() => usePersonalizationStore.getState().loadConfigs()}
      />
    );

  return (
    <div className={styles.page}>
      <SplitLayout
        ratio="50/50"
        left={<ProductWeightPanel />}
        right={<AlertPreviewPanel />}
      />
    </div>
  );
};

export default PersonalizationPage;
