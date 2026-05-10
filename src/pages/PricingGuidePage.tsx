import { useEffect } from 'react';
import { usePricingStore } from '@/store/pricing/usePricingStore';
import type { PricingStore } from '@/store/pricing/usePricingStore';
import { useAppStore } from '@/store/app/useAppStore';
import type { AppStore } from '@/store/app/useAppStore';
import SplitLayout from '@/components/layout/SplitLayout';
import PriceGuideCard from '@/features/pricing-guide/PriceGuideCard';
import IndicatorComparisonTable from '@/features/pricing-guide/IndicatorComparisonTable';
import SimilarSituationCard from '@/features/pricing-guide/SimilarSituationCard';
import LoadingSpinner from '@/components/feedback/LoadingSpinner';
import ErrorMessage from '@/components/feedback/ErrorMessage';
import styles from './PricingGuidePage.module.css';

const selectCustomerId = (s: AppStore) => s.selectedCustomerId;
const selectPriceGuide = (s: PricingStore) => s.priceGuide;
const selectSimilarSituation = (s: PricingStore) => s.similarSituation;
const selectComparisons = (s: PricingStore) => s.indicatorComparisons;
const selectLoading = (s: PricingStore) => s.loading;
const selectError = (s: PricingStore) => s.error;

const PricingGuidePage = () => {
  const selectedCustomerId = useAppStore(selectCustomerId);
  const priceGuide = usePricingStore(selectPriceGuide);
  const similarSituation = usePricingStore(selectSimilarSituation);
  const comparisons = usePricingStore(selectComparisons);
  const loading = usePricingStore(selectLoading);
  const error = usePricingStore(selectError);

  useEffect(() => {
    const customerId = selectedCustomerId ?? 'KORYEO';
    usePricingStore.getState().loadGuide(customerId);
  }, [selectedCustomerId]);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} onRetry={() => usePricingStore.getState().loadGuide(selectedCustomerId ?? 'KORYEO')} />;
  if (!priceGuide || !similarSituation) return <LoadingSpinner />;

  return (
    <div className={styles.page}>
      <SplitLayout
        ratio="50/50"
        left={
          <div className={styles.leftStack}>
            <PriceGuideCard guide={priceGuide} />
            <div className={styles.section}>
              <h3 className={styles.sectionTitle}>지표 비교</h3>
              <IndicatorComparisonTable rows={comparisons} />
            </div>
          </div>
        }
        right={<SimilarSituationCard situation={similarSituation} />}
      />
    </div>
  );
};

export default PricingGuidePage;
