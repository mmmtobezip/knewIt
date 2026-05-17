'use client';

import { useEffect, useMemo, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { Card, CardTitle } from '@/components/ui/card';
import { PriceChart } from '@/components/chart/price-chart';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import type { IndicatorPoint, TopMover } from '@/types';
import { cn } from '@/shared/utils/cn';
import { formatChangeRate, formatInt, getChangeTextClass } from '@/shared/utils/format';

/**
 * 차트1 — 최대 변동 핵심지표 (PRD 0514 § 5.2 + mockup index.html 스타일).
 *
 * - Top 3 mover 좌우 스와이프 (◀▶ + 도트 인디케이터)
 * - 기간 탭: 데이터 양에 따라 자동 활성/비활성
 *   기본은 1M, 데이터가 부족하면 가용 최대 기간으로 자동 fallback
 * - Recharts AreaChart
 */
const CYCLE_LABEL: Record<string, string> = {
  D: 'daily',
  W: 'weekly',
  M: 'monthly',
  Q: 'quarterly',
  Y: 'yearly',
};

function cycleLabel(cycle: string): string {
  return CYCLE_LABEL[cycle.toUpperCase()] ?? cycle.toLowerCase();
}

const PERIODS = ['1D', '1M', '1Y'] as const;
type PeriodKey = (typeof PERIODS)[number];

const PERIOD_DAYS: Record<PeriodKey, number | null> = {
  '1D': 1, '1M': 30, '1Y': 365,
};

function sliceByPeriod(series: IndicatorPoint[], period: PeriodKey): IndicatorPoint[] {
  const days = PERIOD_DAYS[period];
  if (days == null || series.length === 0) return series;
  const lastDate = new Date(series[series.length - 1]?.date ?? Date.now());
  const cutoff = new Date(lastDate.getTime() - days * 86_400_000);
  return series.filter((p) => new Date(p.date) >= cutoff);
}

interface PriceChartCardProps {
  topMovers: TopMover[];
  isLoading?: boolean;
}

export function PriceChartCard({ topMovers, isLoading }: PriceChartCardProps) {
  const [idx, setIdx] = useState(0);
  const [period, setPeriod] = useState<PeriodKey>('1M');

  const active = topMovers[idx];

  // 인덱스 변경 시 활성 지표의 데이터 양에 따라 자동 period 선택.
  // 1M에 5점 이상이면 1M, 부족하면 1Y로 fallback.
  useEffect(() => {
    if (!active) return;
    const order: PeriodKey[] = ['1M', '1Y'];
    for (const p of order) {
      if (sliceByPeriod(active.series, p).length >= 5) {
        setPeriod(p);
        return;
      }
    }
    setPeriod('1Y');
  }, [active]);

  const series = useMemo(() => (active ? sliceByPeriod(active.series, period) : []), [active, period]);

  // 기간 탭 활성/비활성: 해당 기간에 2점 이상 있으면 활성
  const periodEnabled = useMemo(() => {
    const out = {} as Record<PeriodKey, boolean>;
    for (const p of PERIODS) {
      out[p] = !!active && sliceByPeriod(active.series, p).length >= 2;
    }
    return out;
  }, [active]);

  const total = topMovers.length;
  const canPrev = idx > 0;
  const canNext = idx < total - 1;

  return (
    <Card className="flex flex-col">
      <CardTitle>변동이 크게 발생한 지표 분석 결과</CardTitle>

      {isLoading ? (
        <ChartSkeleton />
      ) : !active ? (
        <EmptyState icon="📊" title="지표 데이터 없음" description="시계열 적재 후 표시됩니다." />
      ) : (
        <div className="flex flex-1 flex-col">
          <div className="mt-2 flex items-start justify-between gap-3">
            <div className="min-w-0 flex-1">
              <div className="mb-1.5 flex items-center gap-1.5 text-sm font-medium text-gray-600">
                <span className="truncate">
                  {active.indicator} ({active.unit})
                </span>
                {active.cycle && (
                  <span
                    className="inline-flex shrink-0 items-center rounded-md bg-gray-200 px-2 py-0.5 text-[11px] font-bold lowercase tracking-tight text-gray-700"
                    title={`수집 주기: ${cycleLabel(active.cycle)}`}
                    aria-label={`수집 주기 ${cycleLabel(active.cycle)}`}
                  >
                    {cycleLabel(active.cycle)}
                  </span>
                )}
              </div>
              <div className="flex items-baseline">
                <span className="text-[40px] font-extrabold leading-none tracking-[-1px] text-gray-900">
                  {formatInt(active.value)}
                </span>
                <span
                  className={cn(
                    'ml-2.5 text-sm font-bold tracking-tight',
                    getChangeTextClass(active.change_w1),
                  )}
                >
                  {formatChangeRate(active.change_w1)} (WoW)
                </span>
              </div>
            </div>

            <div className="flex shrink-0 gap-1 rounded-md bg-gray-100 p-1">
              {PERIODS.map((p) => {
                const isActive = p === period;
                const enabled = periodEnabled[p];
                return (
                  <button
                    key={p}
                    type="button"
                    onClick={() => enabled && setPeriod(p)}
                    disabled={!enabled}
                    className={cn(
                      'rounded-md px-2.5 py-1.5 text-[12px] font-semibold transition-all',
                      isActive ? 'bg-white text-gray-900 shadow-toss' : 'text-gray-600',
                      !enabled && 'cursor-not-allowed opacity-30',
                    )}
                  >
                    {p}
                  </button>
                );
              })}
            </div>
          </div>

          <div className="relative mt-3 min-h-[180px] flex-1">
            <AnimatePresence mode="wait">
              <motion.div
                key={`${idx}-${period}`}
                initial={{ opacity: 0, x: 16 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -16 }}
                transition={{ duration: 0.2 }}
                className="h-full"
              >
                <PriceChart data={series} unit={active.unit} className="h-full" />
              </motion.div>
            </AnimatePresence>

            {total > 1 && (
              <>
                <button
                  type="button"
                  onClick={() => setIdx((v) => Math.max(0, v - 1))}
                  disabled={!canPrev}
                  aria-label="이전 지표"
                  className="absolute left-0 top-1/2 z-10 flex h-9 w-9 -translate-y-1/2 items-center justify-center rounded-full bg-white shadow-toss-md transition-opacity hover:bg-gray-50 disabled:opacity-30"
                >
                  <ChevronLeft className="h-4 w-4 text-gray-700" />
                </button>
                <button
                  type="button"
                  onClick={() => setIdx((v) => Math.min(total - 1, v + 1))}
                  disabled={!canNext}
                  aria-label="다음 지표"
                  className="absolute right-0 top-1/2 z-10 flex h-9 w-9 -translate-y-1/2 items-center justify-center rounded-full bg-white shadow-toss-md transition-opacity hover:bg-gray-50 disabled:opacity-30"
                >
                  <ChevronRight className="h-4 w-4 text-gray-700" />
                </button>
              </>
            )}
          </div>

          {total > 1 && (
            <div className="mt-2.5 flex items-center justify-center gap-2">
              {topMovers.map((_, i) => (
                <button
                  key={i}
                  onClick={() => setIdx(i)}
                  aria-label={`${i + 1}번째 지표`}
                  aria-current={i === idx ? 'true' : undefined}
                  className={cn(
                    'rounded-full transition-all',
                    i === idx ? 'h-2.5 w-2.5 bg-toss-blue' : 'h-2 w-2 bg-gray-300',
                  )}
                />
              ))}
            </div>
          )}

          {series.length < 2 && (
            <div className="mt-2 text-center text-xs text-gray-500">
              해당 기간 데이터 포인트가 부족합니다.
            </div>
          )}
        </div>
      )}
    </Card>
  );
}

function ChartSkeleton() {
  return (
    <div className="mt-3">
      <Skeleton className="mb-3 h-10 w-72" />
      <Skeleton className="h-[220px] w-full" />
    </div>
  );
}
