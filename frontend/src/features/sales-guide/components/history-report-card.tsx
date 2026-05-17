'use client';

import { Card, CardTitle, CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/shared/utils/cn';
import type { MarketSummaryItem, SimilarityPoint, SimilarPeriod } from '@/types';
// MarketFeature is used via SimilarPeriod.market_features

interface HistoryReportCardProps {
  marketSummary: MarketSummaryItem[];
  timeline: SimilarityPoint[];
  similarPeriods: SimilarPeriod[];
  isLoading?: boolean;
}

const DIR_ICON: Record<string, string> = { UP: '↑', DOWN: '↓', FLAT: '—' };
const DIR_CLASS: Record<string, string> = {
  UP: 'text-danger',
  DOWN: 'text-toss-blue',
  FLAT: 'text-gray-400',
};

const RANK_COLORS = ['bg-warning', 'bg-gray-300', 'bg-amber-700'];

export function HistoryReportCard({
  marketSummary,
  timeline,
  similarPeriods,
  isLoading,
}: HistoryReportCardProps) {
  const maxScore = Math.max(...timeline.map((p) => p.score), 1);

  return (
    <Card>
      <CardTitle className="mb-1 text-[15px]">
        과거 시황 학습 리포트
        <CardSubtitle>(월별 코사인 유사도)</CardSubtitle>
      </CardTitle>

      {isLoading ? (
        <div className="space-y-4">
          <Skeleton className="h-20" />
          <Skeleton className="h-32" />
          <Skeleton className="h-48" />
        </div>
      ) : (
        <div className="mt-4 space-y-6">

          {/* 현재 시황 요약 */}
          <div>
            <SectionLabel>현재 후판 시황 (당월 평균)</SectionLabel>
            <div className="grid grid-cols-3 gap-2 sm:grid-cols-6">
              {marketSummary.map((item) => (
                <div key={item.name} className="rounded-xl bg-gray-50 px-3 py-2.5">
                  <div className="mb-1 truncate text-[10px] text-gray-500">{item.name}</div>
                  <div className={cn('text-[13px] font-extrabold', DIR_CLASS[item.direction])}>
                    {DIR_ICON[item.direction]} {item.value}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* 유사도 타임라인 */}
          <div>
            <SectionLabel>과거 시황 유사도 타임라인</SectionLabel>
            <div className="w-full pb-1">
              <div className="flex w-full items-end gap-1" style={{ height: '130px' }}>
                {timeline.map((pt, i) => {
                  const barH = Math.round((pt.score / maxScore) * 100);
                  return (
                    <div key={i} className="flex flex-1 flex-col items-center gap-1">
                      <div
                        className={cn(
                          'w-full rounded-t-[4px] transition-colors',
                          pt.is_current ? 'bg-warning' : pt.highlighted ? 'bg-toss-blue' : 'bg-gray-200',
                        )}
                        style={{ height: `${barH}px`, minHeight: '4px' }}
                      />
                      <span
                        className={cn(
                          'text-[8px] whitespace-nowrap',
                          pt.is_current ? 'font-bold text-warning' : pt.highlighted ? 'font-bold text-toss-blue' : 'text-gray-400',
                        )}
                      >
                        {pt.label}
                      </span>
                    </div>
                  );
                })}
              </div>
            </div>
            {/* 범례 */}
            <div className="mt-2 flex gap-4 text-[10px] text-gray-400">
              {[
                { color: 'bg-toss-blue', label: 'Top 3 유사 시점' },
                { color: 'bg-warning', label: '현재 시점' },
                { color: 'bg-gray-200', label: '일반 구간' },
              ].map((l) => (
                <div key={l.label} className="flex items-center gap-1.5">
                  <div className={cn('h-2.5 w-2.5 rounded-[3px]', l.color)} />
                  <span>{l.label}</span>
                </div>
              ))}
            </div>
          </div>

          {/* TOP 3 */}
          <div>
            <SectionLabel>유사도 TOP 3 — 과거 시황 &amp; 결과</SectionLabel>
            <div className="space-y-3">
              {similarPeriods.map((p) => (
                <SimilarPeriodCard key={p.rank} period={p} rankColor={RANK_COLORS[p.rank - 1] ?? 'bg-gray-300'} />
              ))}
            </div>
          </div>

        </div>
      )}
    </Card>
  );
}

function SectionLabel({ children }: { children: React.ReactNode }) {
  return (
    <div className="mb-2.5 text-[11px] font-bold uppercase tracking-wide text-gray-400">
      {children}
    </div>
  );
}

function SimilarPeriodCard({ period, rankColor }: { period: SimilarPeriod; rankColor: string }) {
  const pct = Math.round(period.achievement_rate * 100);
  const overAchieved = period.achievement_rate >= 1;
  const pairs = chunk(period.market_features ?? [], 2);

  return (
    <div className="rounded-2xl border border-gray-100 p-5">
      {/* 헤더: 순위 + 기간 + 유사도 */}
      <div className="mb-2 flex items-center gap-3">
        <div className={cn('flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-[14px] font-extrabold text-white', rankColor)}>
          {period.rank}
        </div>
        <div className="flex-1">
          <div className="text-[17px] font-bold text-gray-900">{period.period}</div>
          <div className="text-[10px] text-gray-400">유사도</div>
        </div>
        <div className="text-[22px] font-extrabold text-toss-blue">
          {Math.round(period.cosine_similarity * 100)}%
        </div>
      </div>

      {/* 유사도 바 */}
      <div className="mb-4 h-[4px] overflow-hidden rounded-full bg-gray-100">
        <div className="h-full rounded-full bg-toss-blue" style={{ width: `${period.cosine_similarity * 100}%` }} />
      </div>

      {/* 실적 3개 박스 */}
      <div className="mb-4 grid grid-cols-3 gap-2">
        <ResultBox label="당시 판매량 실적값" value={`${period.actual_volume}천톤`} />
        <ResultBox label="당시 제품별 가이드값" value={`${period.guide_volume}천톤`} />
        <ResultBox label="달성률" value={`${pct}%`} valueClass={overAchieved ? 'text-success' : 'text-warning'} />
      </div>

      {/* 당시 시황 */}
      {pairs.length > 0 && (
        <div className="mb-4">
          <div className="mb-1.5 text-[11px] font-semibold text-gray-500">당시 시황 ({period.period} 평균)</div>
          <div className="overflow-hidden rounded-xl border border-gray-100">
            {pairs.map((pair, ri) => (
              <div key={ri} className={cn('grid divide-x divide-gray-100', pair.length === 2 ? 'grid-cols-2' : 'grid-cols-1', ri > 0 && 'border-t border-gray-100')}>
                {pair.map((f, ci) => (
                  <div key={ci} className="flex items-center justify-between px-3 py-2">
                    <span className="text-[11px] text-gray-500">{f.name}</span>
                    <span className="ml-2 shrink-0 text-[12px] font-bold text-gray-900">{f.value}</span>
                  </div>
                ))}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* 집중 고객사 */}
      <div className="flex flex-wrap items-center gap-1.5">
        <span className="text-[11px] text-gray-400">집중 고객사 (중량 순)</span>
        {period.focus_customers.map((c, i) => (
          <span key={c} className="flex items-center gap-1">
            <span className="rounded-md bg-toss-blue-light px-2 py-0.5 text-[10px] font-semibold text-toss-blue">{c}</span>
            {i < period.focus_customers.length - 1 && <span className="text-[10px] text-gray-300">›</span>}
          </span>
        ))}
      </div>
    </div>
  );
}

function ResultBox({ label, value, valueClass = 'text-gray-900' }: { label: string; value: string; valueClass?: string }) {
  return (
    <div className="rounded-xl bg-gray-50 px-3 py-2.5 text-center">
      <div className="mb-0.5 text-[9px] text-gray-400">{label}</div>
      <div className={cn('text-[16px] font-extrabold', valueClass)}>{value}</div>
    </div>
  );
}

function chunk<T>(arr: T[], size: number): T[][] {
  const result: T[][] = [];
  for (let i = 0; i < arr.length; i += size) result.push(arr.slice(i, i + size));
  return result;
}
