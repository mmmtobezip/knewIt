'use client';

import { useSelectionStore } from '@/stores/selection-store';
import { useSalesGuide } from '@/lib/api/queries/sales-guide';
// import { AchievementSection } from './components/achievement-section';
import { KeyFeaturesSection } from './components/key-features-section';
import { OpportunitySection } from './components/opportunity-section';
import { HistorySection } from './components/history-section';
import { TabNav } from './components/tab-nav';
import { BackToTopButton } from './components/back-to-top';
import type { AchievementKpi, CustomerAchievement } from '@/types';

export function SalesGuide() {
  const { customerId } = useSelectionStore();
  const { data, isLoading } = useSalesGuide(customerId);

  return (
    <>
      <TabNav product={data?.product ?? ''} />

      <div className="flex flex-col gap-4 pb-20">
        {/* AchievementSection 주석 처리 — 필요 시 복원
        <AchievementSection
          kpi={data?.achievement_kpi ?? null}
          customers={data?.customer_achievements ?? []}
          isLoading={isLoading}
        />
        */}
        <GuideValueSection
          product={data?.product ?? ''}
          kpi={data?.achievement_kpi ?? null}
          customers={data?.customer_achievements ?? []}
          isLoading={isLoading}
        />
        <KeyFeaturesSection
          product={data?.product ?? ''}
          keyFeatures={data?.key_features ?? []}
          isLoading={isLoading}
        />
        <OpportunitySection
          signal={data?.market_signal ?? null}
          gradeSummary={data?.grade_summary ?? null}
          opportunities={data?.customer_opportunities ?? []}
          achievements={data?.customer_achievements ?? []}
          isLoading={isLoading}
        />
        <HistorySection
          timeline={data?.similarity_timeline ?? []}
          similarPeriods={data?.similar_periods ?? []}
          product={data?.product ?? ''}
          isLoading={isLoading}
        />
      </div>

      <BackToTopButton />
    </>
  );
}

// ── 당월 판매량 가이드값 확인 섹션 ───────────────────────────────

interface GuideValueSectionProps {
  product: string;
  kpi: AchievementKpi | null;
  customers: CustomerAchievement[];
  isLoading?: boolean;
}

function GuideValueSection({ product, kpi, customers, isLoading }: GuideValueSectionProps) {
  const unit = kpi?.volume_unit ?? '천톤';
  const productLabel = product || '제품';

  return (
    <div id="section-achievement" className="rounded-2xl border-[1.5px] border-gray-100 p-5">
      <div className="mb-1 text-[11px] font-extrabold uppercase tracking-wide text-gray-400">
        01 · GUIDE
      </div>
      <div className="mb-0.5 text-[20px] font-extrabold tracking-tight text-gray-900">
        당월 판매량 가이드값 확인
      </div>
      <div className="mb-5 text-[13px] text-gray-500">
        그룹 내 {productLabel} 가이드값과 고객사별 배분 현황을 확인합니다.
      </div>

      {isLoading ? (
        <div className="grid grid-cols-4 gap-3">
          {[...Array(5)].map((_, i) => (
            <div key={i} className="h-20 animate-pulse rounded-xl bg-gray-100" />
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-4 gap-3">
          {/* 첫 번째 카드: 그룹 전체 제품 가이드 */}
          <div className="flex flex-col justify-between rounded-xl bg-gray-900 px-4 py-3.5">
            <div className="text-[10px] font-semibold uppercase tracking-wide text-gray-400">
              그룹 내 {productLabel} 가이드
            </div>
            <div>
              <div className="mt-2 text-[22px] font-extrabold leading-none tracking-tight text-white">
                {(kpi?.guide_volume ?? 0).toLocaleString()}
              </div>
              <div className="mt-1 text-[11px] text-gray-500">{unit}</div>
            </div>
          </div>

          {/* 고객사별 카드 */}
          {customers.map((c) => (
            <div key={c.customer_id} className="flex flex-col justify-between rounded-xl bg-gray-50 px-4 py-3.5">
              <div className="text-[10px] font-semibold text-gray-400">
                그룹 내 고객사별 {productLabel} 가이드
              </div>
              <div>
                <div className="mt-2 truncate text-[14px] font-extrabold tracking-tight text-gray-900">
                  {c.customer_name}
                </div>
                <div className="mt-0.5 text-[20px] font-extrabold leading-none tracking-tight text-gray-900">
                  {c.guide_volume.toLocaleString()}
                </div>
                <div className="mt-1 text-[11px] text-gray-400">{unit}</div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
