'use client';

import { BarChart3 } from 'lucide-react';
import { Card, CardTitle } from '@/components/ui/card';
import { PriceChart } from '@/components/chart/price-chart';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import { useSelectionStore } from '@/stores/selection-store';
import { useIndicators, useTriggerEvent } from '@/lib/api/queries/dashboard';
import { formatChangeRate, formatInt, getChangeTextClass } from '@/shared/utils/format';
import { cn } from '@/shared/utils/cn';

/**
 * 가격 차트 카드 (AREA-MAIN-05)
 *
 * 컴포넌트:
 * - CHT-T-01 카드 타이틀
 * - CHT-T-02 가격 라벨
 * - CHT-T-03 가격 값 (40px, 800 weight)
 * - CHT-T-04 변동률 (상승=빨강 / 하락=파랑)
 * - CHT-T-05 기간 탭 (MVP는 1M 고정)
 * - CHT-T-06 차트 영역 (Recharts AreaChart)
 *
 * trigger_event 없음 → "오늘은 주요 변동이 없습니다" placeholder
 */
const PERIODS = ['1D', '1W', '1M', '3M', '6M', '1Y'] as const;

export function PriceChartCard() {
  const { productCode } = useSelectionStore();
  const indicatorsQuery = useIndicators(productCode);
  const triggerQuery = useTriggerEvent(productCode, new Date().toISOString().slice(0, 10));

  return (
    <Card>
      <CardTitle>
        <BarChart3 className="h-5 w-5 text-toss-blue" />
        변동이 크게 발생한 지표 분석 결과
      </CardTitle>

      {indicatorsQuery.isLoading ? (
        <ChartSkeleton />
      ) : !indicatorsQuery.data || !triggerQuery.data ? (
        <EmptyState
          icon="📊"
          title="오늘은 주요 변동이 없습니다."
          description="trigger_event 발생 시 차트가 표시됩니다."
        />
      ) : (
        <>
          {/* 가격 헤더 */}
          <div className="mb-3.5 flex items-start justify-between">
            <div>
              <div className="mb-1.5 text-sm font-medium text-gray-600">
                {indicatorsQuery.data.feature_name} ({indicatorsQuery.data.unit})
              </div>
              <div className="flex items-baseline">
                <span className="text-[40px] font-extrabold leading-none tracking-[-1px] text-gray-900">
                  {formatInt(indicatorsQuery.data.latest.value)}
                </span>
                <span
                  className={cn(
                    'ml-2.5 text-sm font-bold tracking-tight',
                    getChangeTextClass(indicatorsQuery.data.latest.change_rate),
                  )}
                >
                  {formatChangeRate(indicatorsQuery.data.latest.change_rate)} (WoW)
                </span>
              </div>
            </div>

            {/* 기간 탭 (MVP는 1M 고정, Q5) */}
            <div className="flex gap-1 rounded-md bg-gray-100 p-1">
              {PERIODS.map((p) => (
                <button
                  key={p}
                  disabled={p !== '1M'}
                  className={cn(
                    'rounded-md px-3.5 py-1.5 text-[13px] font-semibold transition-all',
                    p === '1M' ? 'bg-white text-gray-900 shadow-toss' : 'text-gray-600',
                    p !== '1M' && 'cursor-not-allowed opacity-40',
                  )}
                  aria-label={`${p} 기간`}
                >
                  {p}
                </button>
              ))}
            </div>
          </div>

          <PriceChart data={indicatorsQuery.data.series} />
        </>
      )}
    </Card>
  );
}

function ChartSkeleton() {
  return (
    <div>
      <div className="mb-3.5 flex items-start justify-between">
        <div>
          <Skeleton className="mb-2 h-4 w-40" />
          <Skeleton className="h-10 w-32" />
        </div>
        <Skeleton className="h-8 w-64" />
      </div>
      <Skeleton className="h-[220px] w-full" />
    </div>
  );
}
