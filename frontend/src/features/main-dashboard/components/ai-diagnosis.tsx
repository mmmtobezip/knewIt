'use client';

import { Card, CardTitle, CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import type { ImpactItem, Interpretation } from '@/types';
import { cn } from '@/shared/utils/cn';

/**
 * AI 진단 (PRD 0518) — WHAT / WHY / IMPACT 구조화.
 *
 *  - WHAT  : headline 한 줄 + key_metrics 2~3 bullet
 *  - WHY   : 드라이버 3개 (rank, title, consequence)
 *  - IMPACT: direction 별 그룹화 + priority 색상 코드
 */
interface AiDiagnosisProps {
  interpretation: Interpretation | null;
  isLoading?: boolean;
}

const DIRECTION_STYLE: Record<
  ImpactItem['direction'],
  { emoji: string; stripe: string; label: string }
> = {
  증폭: { emoji: '🔴', stripe: 'bg-red-400', label: 'text-red-700' },
  완화: { emoji: '🟢', stripe: 'bg-emerald-400', label: 'text-emerald-700' },
  중립: { emoji: '⚪', stripe: 'bg-gray-300', label: 'text-gray-600' },
};

export function AiDiagnosis({ interpretation, isLoading }: AiDiagnosisProps) {
  return (
    <Card className="flex flex-col">
      <CardTitle>
        AI 진단 <CardSubtitle>(무슨 일이 일어나고 있는가?)</CardSubtitle>
      </CardTitle>

      {isLoading ? (
        <div className="mt-4 flex flex-1 flex-col gap-3">
          <Skeleton className="h-24" />
          <Skeleton className="h-40" />
          <Skeleton className="h-32" />
        </div>
      ) : !interpretation ? (
        <div className="flex flex-1 items-center">
          <EmptyState icon="🤖" title="분석 데이터 없음" description="대시보드 응답을 받으면 표시됩니다." />
        </div>
      ) : (
        <div className="mt-4 flex flex-1 flex-col gap-3">
          <WhatSection what={interpretation.what} />
          <WhySection why={interpretation.why} />
          <ImpactSection impact={interpretation.impact} />
        </div>
      )}
    </Card>
  );
}

// ── WHAT ─────────────────────────────────────────
function WhatSection({ what }: { what: Interpretation['what'] }) {
  return (
    <div className="rounded-2xl bg-diag-what p-[18px]">
      <div className="mb-2 flex items-center gap-1.5">
        <span aria-hidden>📊</span>
        <span className="text-xs font-extrabold tracking-wide text-danger">WHAT</span>
      </div>
      <p className="text-[14px] font-bold leading-snug tracking-tight text-gray-900">
        {what.headline}
      </p>
      {what.key_metrics.length > 0 && (
        <ul className="mt-3 space-y-1.5">
          {what.key_metrics.map((m, idx) => (
            <li
              key={idx}
              className="flex items-start gap-1.5 text-[12.5px] font-medium leading-relaxed tracking-tight text-gray-700"
            >
              <span aria-hidden className="mt-[2px] text-gray-500">•</span>
              <span>{m}</span>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

// ── WHY ──────────────────────────────────────────
function WhySection({ why }: { why: Interpretation['why'] }) {
  const sorted = [...why].sort((a, b) => a.rank - b.rank);
  return (
    <div className="rounded-2xl bg-diag-why p-[18px]">
      <div className="mb-2 flex items-center gap-1.5">
        <span aria-hidden>🔍</span>
        <span className="text-xs font-extrabold tracking-wide text-[#D97706]">WHY</span>
      </div>
      <ol className="space-y-2.5">
        {sorted.map((d) => (
          <li key={d.rank} className="flex items-start gap-2.5">
            <span
              className="mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-[#D97706] text-[11px] font-extrabold text-white"
              aria-hidden
            >
              {d.rank}
            </span>
            <div className="flex-1">
              <div className="text-[13px] font-bold leading-snug tracking-tight text-gray-900">
                {d.title}
              </div>
              <div className="text-[12px] font-medium leading-relaxed tracking-tight text-gray-700">
                {d.consequence}
              </div>
            </div>
          </li>
        ))}
      </ol>
    </div>
  );
}

// ── IMPACT (direction 그룹 — priority 배지 미노출, 단순화) ─────
function ImpactSection({ impact }: { impact: ImpactItem[] }) {
  const groups: Record<ImpactItem['direction'], ImpactItem[]> = {
    증폭: [],
    완화: [],
    중립: [],
  };
  for (const it of impact) groups[it.direction]?.push(it);

  return (
    <div className="flex flex-1 flex-col rounded-2xl bg-diag-impact p-[18px]">
      <div className="mb-2 flex items-center gap-1.5">
        <span aria-hidden>⚠️</span>
        <span className="text-xs font-extrabold tracking-wide text-[#00A878]">IMPACT</span>
      </div>
      <ul className="flex flex-1 flex-col gap-3">
        {(['증폭', '완화', '중립'] as const).flatMap((dir) =>
          groups[dir].map((it, idx) => {
            const s = DIRECTION_STYLE[dir];
            return (
              <li key={`${dir}-${idx}`} className="flex items-stretch gap-3">
                <span
                  aria-hidden
                  className={cn('w-[3px] shrink-0 self-stretch rounded-full', s.stripe)}
                />
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-1.5">
                    <span className={cn('text-[11px] font-extrabold tracking-wide', s.label)}>
                      {dir}
                    </span>
                    <span aria-hidden className="text-gray-300">·</span>
                    <span className="text-[13px] font-bold tracking-tight text-gray-900">
                      {it.risk_factor}
                    </span>
                  </div>
                  <p className="mt-1 text-[12px] font-medium leading-relaxed tracking-tight text-gray-700">
                    {it.reason}
                  </p>
                </div>
              </li>
            );
          }),
        )}
      </ul>
    </div>
  );
}
