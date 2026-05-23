'use client';

import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/shared/utils/cn';
import type { AchievementKpi, AchievementStatus, CustomerAchievement } from '@/types';
import { SectionCard, SectionHeader, SectionIcons } from './section-header';

/**
 * Module 1 — 가이드값 달성률 (전체 폭, 세로 카드)
 *
 *  - 상단: 후판 달성률 KPI / 전년 대비 KPI / 전체 진행 바 (3-column)
 *  - 본문: 5개 고객사 테이블 (고객사 / 달성률 / 전년 대비 / 상태)
 *  - 컬럼 비율: 32% / 28% / 20% / 20% (KEY_FEATURES 테이블과 동일)
 */

interface AchievementSectionProps {
  kpi: AchievementKpi | null;
  customers: CustomerAchievement[];
  isLoading?: boolean;
}

const STATUS_BADGE: Record<AchievementStatus, string> = {
  normal: 'bg-emerald-50 text-success',
  warning: 'bg-amber-50 text-warning',
  danger: 'bg-red-50 text-danger',
};
const STATUS_BAR: Record<AchievementStatus, string> = {
  normal: 'bg-success',
  warning: 'bg-warning',
  danger: 'bg-danger',
};
const STATUS_TEXT: Record<AchievementStatus, string> = {
  normal: 'text-success',
  warning: 'text-warning',
  danger: 'text-danger',
};
const STATUS_LABEL: Record<AchievementStatus, string> = {
  normal: '정상',
  warning: '주의',
  danger: '위험',
};

export function AchievementSection({ kpi, customers, isLoading }: AchievementSectionProps) {
  return (
    <SectionCard id="section-achievement" accent="blue">
      <SectionHeader
        kicker="01 · ACHIEVEMENT"
        title="가이드값 달성률"
        subtitle="담당 제품과 고객사별 가이드값 대비 당월 누적 실적을 한눈에 보여드려, 미달 영역을 즉시 확인할 수 있습니다."
        icon={SectionIcons.chart}
        accent="blue"
      />

      {isLoading || !kpi ? (
        <SectionSkeleton />
      ) : (
        <div className="flex flex-col">
          {/* 상단: KPI 2개 + 전체 진행 바 */}
          <div className="grid grid-cols-[1fr_1fr_2fr] gap-3">
            <KpiBox
              label="내 담당 후판 달성률"
              value={`${Math.round(kpi.achievement_rate * 100)}%`}
              sub="내 책임 거래처 5개 합산"
              valueClass={
                kpi.achievement_rate >= 0.8
                  ? 'text-success'
                  : kpi.achievement_rate >= 0.5
                    ? 'text-warning'
                    : 'text-danger'
              }
            />
            <KpiBox
              label="전년 대비"
              value={`${kpi.yoy_change >= 0 ? '+' : ''}${Math.round(kpi.yoy_change * 100)}%`}
              sub="전년 동기 대비"
              valueClass={kpi.yoy_change >= 0 ? 'text-success' : 'text-danger'}
            />
            <div className="flex flex-col justify-center rounded-xl bg-gray-100 px-5 py-4">
              <div className="mb-2 flex items-baseline justify-between">
                <span className="flex items-center gap-1.5 text-[13px] font-bold text-gray-900">
                  내 책임 거래처 합산 달성률
                  <InfoTip text={`내 책임 5개 거래처 합산 기준\n• ${kpi.actual_volume} / ${kpi.guide_volume} 천톤${kpi.group_total_guide ? `\n• 후판판매그룹 전체 ${kpi.group_total_guide.toLocaleString()} 천톤의 ${((kpi.guide_volume / kpi.group_total_guide) * 100).toFixed(1)}%` : ''}`} />
                </span>
                <span className="text-[12px] text-gray-500">
                  {kpi.actual_volume} / {kpi.guide_volume} {kpi.volume_unit}
                </span>
              </div>
              <div className="mb-2 h-2.5 overflow-hidden rounded-full bg-white">
                <div
                  className={cn(
                    'h-full rounded-full transition-all',
                    kpi.achievement_rate >= 0.8
                      ? 'bg-success'
                      : kpi.achievement_rate >= 0.5
                        ? 'bg-warning'
                        : 'bg-danger',
                  )}
                  style={{ width: `${Math.min(kpi.achievement_rate * 100, 100)}%` }}
                />
              </div>
              <div className="flex justify-between text-[11px] font-bold">
                <span
                  className={
                    kpi.achievement_rate >= 0.8
                      ? 'text-success'
                      : kpi.achievement_rate >= 0.5
                        ? 'text-warning'
                        : 'text-danger'
                  }
                >
                  {Math.round(kpi.achievement_rate * 100)}% 달성
                </span>
                <span className={kpi.yoy_change >= 0 ? 'text-success' : 'text-danger'}>
                  전년 동기 대비 {kpi.yoy_change >= 0 ? '+' : ''}
                  {Math.round(kpi.yoy_change * 100)}%
                </span>
              </div>
            </div>
          </div>

          <div className="my-5 h-px bg-gray-100" />

          {/* 고객사별 실적 */}
          <div className="mb-2.5 text-[11px] font-bold uppercase tracking-wide text-gray-400">
            고객사별 실적
          </div>
          <CustomerTable customers={customers} />

          {/* 범례 */}
          <div className="mt-4 flex gap-4 border-t border-gray-100 pt-3.5 text-[11px] text-gray-500">
            <Legend dotClass="bg-success" text="정상 ≥80%" />
            <Legend dotClass="bg-warning" text="주의 50~79%" />
            <Legend dotClass="bg-danger" text="위험 <50%" />
          </div>
        </div>
      )}
    </SectionCard>
  );
}

function KpiBox({
  label,
  value,
  sub,
  valueClass,
  info,
}: {
  label: string;
  value: string;
  sub: string;
  valueClass: string;
  info?: string;
}) {
  return (
    <div className="rounded-xl bg-gray-100 px-5 py-4">
      <div className="mb-1.5 flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wide text-gray-500">
        <span>{label}</span>
        {info && <InfoTip text={info} />}
      </div>
      <div className={cn('text-[34px] font-extrabold leading-none tracking-tightest', valueClass)}>
        {value}
      </div>
      <div className="mt-1.5 text-[11px] text-gray-400">{sub}</div>
    </div>
  );
}

/** info 아이콘 (i) — hover 시 계산 방법 tooltip popup (POSCO 정중 톤). */
function InfoTip({ text }: { text: string }) {
  return (
    <span className="group relative inline-flex">
      <span
        aria-label="계산 방법"
        className="inline-flex h-3.5 w-3.5 cursor-help items-center justify-center rounded-full border border-gray-300 bg-white text-[9px] font-bold text-gray-400 transition-colors hover:border-toss-blue hover:text-toss-blue"
      >
        i
      </span>
      <span className="invisible absolute left-1/2 top-full z-50 mt-1.5 w-[260px] -translate-x-1/2 whitespace-pre-line rounded-xl border border-gray-100 bg-white p-3 text-left text-[11px] leading-[1.6] font-normal normal-case tracking-normal text-gray-700 opacity-0 shadow-toss-md transition-all group-hover:visible group-hover:opacity-100">
        {text}
      </span>
    </span>
  );
}

function Legend({ dotClass, text }: { dotClass: string; text: string }) {
  return (
    <span className="inline-flex items-center gap-1.5">
      <span className={cn('h-2 w-2 rounded-full', dotClass)} />
      {text}
    </span>
  );
}

function CustomerTable({ customers }: { customers: CustomerAchievement[] }) {
  return (
    <table className="w-full table-fixed border-collapse text-[13px]">
      <thead>
        <tr className="text-[11px] font-semibold text-gray-500">
          <th className="w-[32%] border-b border-gray-100 py-3 pl-1 pr-3.5 text-left">고객사</th>
          <th className="w-[28%] border-b border-gray-100 py-3 pr-3.5 text-left">달성률</th>
          <th className="w-[20%] border-b border-gray-100 py-3 pr-3.5 text-right">전년 대비</th>
          <th className="w-[20%] border-b border-gray-100 py-3 pr-3.5 text-center">상태</th>
        </tr>
      </thead>
      <tbody>
        {customers.map((c) => {
          const pct = Math.round(c.achievement_rate * 100);
          return (
            <tr key={c.customer_id} className="border-b border-gray-50 last:border-b-0">
              <td className="py-3.5 pl-1 pr-3.5">
                <div className="text-[13px] font-bold text-gray-900">{c.customer_name}</div>
              </td>
              <td className="py-3.5 pr-3.5">
                <div className="flex items-center gap-3">
                  <div className="h-[7px] w-[160px] max-w-[220px] flex-1 overflow-hidden rounded-full bg-gray-100">
                    <div className={cn('h-full rounded-full', STATUS_BAR[c.status])} style={{ width: `${pct}%` }} />
                  </div>
                  <span className={cn('min-w-[42px] text-[13px] font-bold', STATUS_TEXT[c.status])}>{pct}%</span>
                </div>
              </td>
              <td className="py-3.5 pr-3.5 text-right">
                <span className={cn('text-[12px] font-bold', c.yoy_change >= 0 ? 'text-success' : 'text-danger')}>
                  {c.yoy_change >= 0 ? '+' : ''}
                  {Math.round(c.yoy_change * 100)}%
                </span>
              </td>
              <td className="py-3.5 pr-3.5 text-center">
                <span
                  className={cn(
                    'inline-flex min-w-[44px] justify-center rounded-md px-2.5 py-0.5 text-[11px] font-bold',
                    STATUS_BADGE[c.status],
                  )}
                >
                  {STATUS_LABEL[c.status]}
                </span>
              </td>
            </tr>
          );
        })}
      </tbody>
    </table>
  );
}

function SectionSkeleton() {
  return (
    <div className="space-y-4">
      <div className="grid grid-cols-[1fr_1fr_2fr] gap-3">
        <Skeleton className="h-24" />
        <Skeleton className="h-24" />
        <Skeleton className="h-24" />
      </div>
      <Skeleton className="h-px" />
      <Skeleton className="h-40" />
    </div>
  );
}
