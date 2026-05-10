import { useEffect } from 'react';
import { useMailStore } from '@/store/mail/useMailStore';
import type { MailStore } from '@/store/mail/useMailStore';
import SplitLayout from '@/components/layout/SplitLayout';
import MailBlockSelector from '@/features/mail-draft/MailBlockSelector';
import MailEditor from '@/features/mail-draft/MailEditor';
import LoadingSpinner from '@/components/feedback/LoadingSpinner';
import ErrorMessage from '@/components/feedback/ErrorMessage';
import styles from './MailDraftPage.module.css';

const selectLoading = (s: MailStore) => s.loading;
const selectError = (s: MailStore) => s.error;

const MailDraftPage = () => {
  const loading = useMailStore(selectLoading);
  const error = useMailStore(selectError);

  useEffect(() => {
    useMailStore.getState().loadDraft();
  }, []);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} onRetry={() => useMailStore.getState().loadDraft()} />;

  return (
    <div className={styles.page}>
      <SplitLayout
        ratio="30/70"
        left={<MailBlockSelector />}
        right={<MailEditor />}
      />
    </div>
  );
};

export default MailDraftPage;
