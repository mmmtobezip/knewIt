import { useEffect } from 'react';
import { useAppStore } from '@/store/app/useAppStore';
import { useDashboardStore } from '@/store/dashboard/useDashboardStore';
import type { DashboardStore } from '@/store/dashboard/useDashboardStore';
import CustomerTabBar from '@/features/dashboard/CustomerTabBar';
import CoreMessageBanner from '@/features/dashboard/CoreMessageBanner';
import IndicatorTable from '@/features/dashboard/IndicatorTable';
import NewsPanel from '@/features/dashboard/NewsPanel';
import QuestionPanel from '@/features/dashboard/QuestionPanel';
import CustomerRiskList from '@/features/dashboard/CustomerRiskList';
import LoadingSpinner from '@/components/feedback/LoadingSpinner';
import ErrorMessage from '@/components/feedback/ErrorMessage';
import PageGrid from '@/components/layout/PageGrid';
import styles from './DashboardPage.module.css';

const selectLoading = (s: DashboardStore) => s.loading;
const selectError = (s: DashboardStore) => s.error;
const selectCustomerRisks = (s: DashboardStore) => s.customerRisks;

const DashboardPage = () => {
  const loading = useDashboardStore(selectLoading);
  const error = useDashboardStore(selectError);
  const customerRisks = useDashboardStore(selectCustomerRisks);

  useEffect(() => {
    useDashboardStore.getState().loadDashboardData();
  }, []);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} onRetry={() => useDashboardStore.getState().loadDashboardData()} />;

  return (
    <div className={styles.page}>
      <CustomerTabBar />
      <div className={styles.content}>
        <CoreMessageBanner />
        <PageGrid cols={2}>
          <IndicatorTable />
          <NewsPanel />
          <QuestionPanel />
          <CustomerRiskList
            risks={customerRisks}
            onCustomerClick={(id) => useAppStore.getState().openCustomerDrawer(id)}
          />
        </PageGrid>
      </div>
    </div>
  );
};

export default DashboardPage;
