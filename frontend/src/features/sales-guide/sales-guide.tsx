'use client';

import { useSelectionStore } from '@/stores/selection-store';
import { useSalesGuide } from '@/lib/api/queries/sales-guide';
import { AchievementSidebar } from './components/achievement-sidebar';
import { OpportunityCard } from './components/opportunity-card';
import { HistoryReportCard } from './components/history-report-card';

/**
 * 판매량 가이드 대시보드 (SCR-GUIDE-001).
 *
 * Layout C:
 *  - 좌 340px sticky: Module 1 (가이드값 달성률)
 *  - 우 flex-1 scroll: Module 2 (고객사 현황 & 기회 탐지) + Module 3 (과거 시황 학습 리포트)
 */
export function SalesGuide() {
  const { customerId } = useSelectionStore();
  const { data, isLoading } = useSalesGuide(customerId);

  return (
    <div className="grid grid-cols-[340px_1fr] items-stretch gap-3">
      {/* Module 1 — outer wrapper stretches to right column height; inner div sticks */}
      <div>
        <div className="sticky top-4 h-[calc(100vh-130px)]">
          <AchievementSidebar
            kpi={data?.achievement_kpi ?? null}
            customers={data?.customer_achievements ?? []}
            isLoading={isLoading}
          />
        </div>
      </div>

      {/* Right column */}
      <div className="flex flex-col gap-3">
        <OpportunityCard
          signal={data?.market_signal ?? null}
          keyFeatures={data?.key_features ?? []}
          gradeSummary={data?.grade_summary ?? null}
          opportunities={data?.customer_opportunities ?? []}
          isLoading={isLoading}
        />
        <HistoryReportCard
          marketSummary={data?.market_summary ?? []}
          timeline={data?.similarity_timeline ?? []}
          similarPeriods={data?.similar_periods ?? []}
          isLoading={isLoading}
        />
      </div>
    </div>
  );
}
