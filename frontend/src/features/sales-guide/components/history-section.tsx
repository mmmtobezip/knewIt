'use client';

import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/shared/utils/cn';
import type { MarketSummaryItem, SimilarityPoint, SimilarPeriod } from '@/types';
import { SectionCard, SectionHeader, SectionIcons } from './section-header';

/**
 * Module 3 — 유사 과거 시황
 *
 *  - 현재 후판 시황 요약 (6-column)
 *  - 과거 시황 유사도 타임라인 (월별 막대)
 *  - 유사도 TOP 3 — 3-column 카드 (실적/시황/집중 고객사)
 */

const DIR_ICON: Record<string, string> = { UP: '↑', DOWN: '↓', FLAT: '—' };
const DIR_TEXT: Record<string, string> = {
  UP: 'text-danger',
  DOWN: 'text-toss-blue',
  FLAT: 'text-gray-400',
};
const RANK_BG = ['bg-warning', 'bg-gray-400', 'bg-amber-700'];

interface HistorySectionProps {
  marketSummary: MarketSummaryItem[];
  timeline: SimilarityPoint[];
  similarPeriods: SimilarPeriod[];
  isLoading?: boolean;
}

export function HistorySection({
  marketSummary,
  timeline,
  similarPeriods,
  isLoading,
}: HistorySectionProps) {
  const maxScore = Math.max(...timeline.map((p) => p.score), 1);

  return (
    <SectionCard id="section-history" accent="sky">
      <SectionHeader
        kicker="03 · HISTORY"
        title="유사 과거 시황"
        subtitle="지금과 가장 닮았던 과거 월 Top 3를 찾아, 그때의 달성 패턴과 집중 고객사를 함께 제안해드립니다."
        icon={SectionIcons.history}
        accent="sky"
      />

      {isLoading ? (
        <div className="space-y-4">
          <Skeleton className="h-20" />
          <Skeleton className="h-32" />
          <Skeleton className="h-60" />
        </div>
      ) : (
        <div className="flex flex-col gap-6">
          {/* 현재 시황 요약 */}
          <div>
            <SectionLabel>현재 후판 시황 (당월 평균)</SectionLabel>
            <div className="grid grid-cols-3 gap-2.5 sm:grid-cols-6">
              {marketSummary.map((item) => (
                <div key={item.name} className="rounded-xl bg-gray-100 px-3.5 py-3">
                  <div className="mb-1.5 truncate text-[11px] text-gray-500">{item.name}</div>
                  <div className={cn('text-[14px] font-extrabold', DIR_TEXT[item.direction])}>
                    {DIR_ICON[item.direction]} {item.value}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* 유사도 타임라인 */}
          <div>
            <SectionLabel>과거 시황 유사도 타임라인</SectionLabel>
            <div className="flex w-full items-end gap-1.5" style={{ height: 120 }}>
              {timeline.map((pt, i) => {
                const h = Math.round((pt.score / maxScore) * 100);
                return (
                  <div key={i} className="flex flex-1 flex-col items-center gap-1.5">
                    <div
                      className={cn(
                        'w-full rounded-t-[5px] transition-colors',
                        pt.is_current ? 'bg-warning' : pt.highlighted ? 'bg-toss-blue' : 'bg-gray-200',
                      )}
                      style={{ height: `${h}px`, minHeight: 4 }}
                    />
                    <span
                      className={cn(
                        'whitespace-nowrap text-[10px]',
                        pt.is_current ? 'font-bold text-warning' : pt.highlighted ? 'font-bold text-toss-blue' : 'text-gray-400',
                      )}
                    >
                      {pt.label}
                    </span>
                  </div>
                );
              })}
            </div>
            <div className="mt-4 flex gap-4 text-[11px] text-gray-500">
              <LegendDot bg="bg-toss-blue" text="Top 3 유사 시점" />
              <LegendDot bg="bg-warning" text="현재 시점" />
              <LegendDot bg="bg-gray-200" text="일반 구간" />
            </div>
          </div>

          {/* TOP 3 — 3-column 그리드 */}
          <div>
            <SectionLabel>유사도 TOP 3 — 과거 시황 &amp; 결과</SectionLabel>
            <div className="grid grid-cols-1 gap-3.5 lg:grid-cols-3">
              {similarPeriods.map((p) => (
                <SimilarPeriodCard key={p.rank} period={p} />
              ))}
            </div>
          </div>
        </div>
      )}
    </SectionCard>
  );
}

function SectionLabel({ children }: { children: React.ReactNode }) {
  return (
    <div className="mb-2.5 text-[11px] font-bold uppercase tracking-wide text-gray-400">{children}</div>
  );
}

function LegendDot({ bg, text }: { bg: string; text: string }) {
  return (
    <span className="inline-flex items-center gap-1.5">
      <span className={cn('h-2.5 w-2.5 rounded-[3px]', bg)} />
      {text}
    </span>
  );
}

function SimilarPeriodCard({ period }: { period: SimilarPeriod }) {
  const pct = Math.round(period.achievement_rate * 100);
  const overAchieved = period.achievement_rate >= 1;
  const rankBg = RANK_BG[period.rank - 1] ?? 'bg-gray-300';

  return (
    <div className="flex h-full flex-col rounded-2xl border-[1.5px] border-gray-100 p-5">
      {/* 헤더 */}
      <div className="mb-3 flex items-center gap-3">
        <div className={cn('flex h-10 w-10 shrink-0 items-center justify-center rounded-full text-[15px] font-extrabold text-white', rankBg)}>
          {period.rank}
        </div>
        <div className="flex-1">
          <div className="text-[16px] font-extrabold tracking-tight text-gray-900">{period.period}</div>
          <div className="text-[10px] text-gray-400">유사도</div>
        </div>
        <div className="text-[22px] font-extrabold tracking-tightest text-toss-blue">
          {Math.round(period.cosine_similarity * 100)}%
        </div>
      </div>

      <div className="mb-4 h-[5px] overflow-hidden rounded-full bg-gray-100">
        <div className="h-full rounded-full bg-toss-blue" style={{ width: `${period.cosine_similarity * 100}%` }} />
      </div>

      {/* 실적 3개 */}
      <div className="mb-4 grid grid-cols-3 gap-2.5">
        <ResultBox label="당시 실적값" value={`${period.actual_volume}천톤`} />
        <ResultBox label="당시 가이드값" value={`${period.guide_volume}천톤`} />
        <ResultBox
          label="달성률"
          value={`${pct}%`}
          valueClass={overAchieved ? 'text-success' : 'text-warning'}
        />
      </div>

      {/* 당시 시황 features 2-col grid (좁은 카드 폭에서도 표시 가능하도록 세로 정렬) */}
      {period.market_features?.length > 0 && (
        <div className="mb-4">
          <div className="mb-2 text-[11px] font-semibold text-gray-500">당시 시황 ({period.period} 평균)</div>
          <div className="overflow-hidden rounded-xl border border-gray-100">
            {chunk(period.market_features, 2).map((pair, ri) => (
              <div
                key={ri}
                className={cn(
                  'grid divide-x divide-gray-100',
                  pair.length === 2 ? 'grid-cols-2' : 'grid-cols-1',
                  ri > 0 && 'border-t border-gray-100',
                )}
              >
                {pair.map((f, ci) => (
                  <div key={ci} className="flex flex-col gap-1 px-3 py-2">
                    <span className="text-[11px] leading-tight text-gray-500">{f.name}</span>
                    <span className="text-[13px] font-bold text-gray-900">{f.value}</span>
                  </div>
                ))}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* 집중 고객사 */}
      <div className="mt-auto flex flex-wrap items-center gap-1.5">
        <span className="mr-1 text-[11px] text-gray-400">집중 고객사 (중량 순)</span>
        {period.focus_customers.map((c, i) => (
          <span key={c} className="flex items-center gap-1">
            <span className="rounded-md bg-toss-blue-light px-2.5 py-0.5 text-[11px] font-semibold text-toss-blue">
              {c}
            </span>
            {i < period.focus_customers.length - 1 && <span className="text-[10px] text-gray-300">›</span>}
          </span>
        ))}
      </div>
    </div>
  );
}

function ResultBox({
  label,
  value,
  valueClass = 'text-gray-900',
}: {
  label: string;
  value: string;
  valueClass?: string;
}) {
  return (
    <div className="rounded-xl bg-gray-100 px-3 py-3 text-center">
      <div className="mb-1.5 text-[10px] text-gray-400">{label}</div>
      <div className={cn('text-[17px] font-extrabold tracking-tighter', valueClass)}>{value}</div>
    </div>
  );
}

function chunk<T>(arr: T[], size: number): T[][] {
  const out: T[][] = [];
  for (let i = 0; i < arr.length; i += size) out.push(arr.slice(i, i + size));
  return out;
}
