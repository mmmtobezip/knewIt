'use client';

import { useSelectionStore } from '@/stores/selection-store';
import { useSalesGuide } from '@/lib/api/queries/sales-guide';
import { AchievementSection } from './components/achievement-section';
import { OpportunitySection } from './components/opportunity-section';
import { HistorySection } from './components/history-section';
import { TabNav } from './components/tab-nav';
import { BackToTopButton } from './components/back-to-top';

/**
 * 판매량 가이드 대시보드 (SCR-GUIDE-001) — Tab-Based Vertical Layout.
 *
 *  - 상단 TabNav (sticky underline 탭)
 *  - 세로 스택: AchievementSection → OpportunitySection → HistorySection
 *  - 우하단 BackToTopButton
 *
 * 각 섹션은 좌측 4px 컬러 바 + kicker + 아이콘 + 헤딩으로 시각 정체성 구분.
 *  - 01 ACHIEVEMENT  → 파랑
 *  - 02 OPPORTUNITY  → 보라
 *  - 03 HISTORY      → 시안
 */
export function SalesGuide() {
  const { customerId } = useSelectionStore();
  const { data, isLoading } = useSalesGuide(customerId);

  return (
    <>
      <TabNav />

      <div className="flex flex-col gap-4 pb-20">
        <AchievementSection
          kpi={data?.achievement_kpi ?? null}
          customers={data?.customer_achievements ?? []}
          isLoading={isLoading}
        />
        <OpportunitySection
          signal={data?.market_signal ?? null}
          keyFeatures={data?.key_features ?? []}
          gradeSummary={data?.grade_summary ?? null}
          opportunities={data?.customer_opportunities ?? []}
          isLoading={isLoading}
        />
        <HistorySection
          marketSummary={data?.market_summary ?? []}
          timeline={data?.similarity_timeline ?? []}
          similarPeriods={data?.similar_periods ?? []}
          isLoading={isLoading}
        />
      </div>

      <BackToTopButton />
    </>
  );
}
