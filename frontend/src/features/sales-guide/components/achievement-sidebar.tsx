'use client';

import { Card, CardTitle, CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/shared/utils/cn';
import type { AchievementKpi, AchievementStatus, CustomerAchievement } from '@/types';

interface AchievementSidebarProps {
  kpi: AchievementKpi | null;
  customers: CustomerAchievement[];
  isLoading?: boolean;
}

const STATUS_COLORS: Record<AchievementStatus, { bar: string; text: string; badge: string }> = {
  normal:  { bar: 'bg-success',  text: 'text-success',  badge: 'bg-emerald-50 text-success' },
  warning: { bar: 'bg-warning',  text: 'text-warning',  badge: 'bg-amber-50 text-warning' },
  danger:  { bar: 'bg-danger',   text: 'text-danger',   badge: 'bg-red-50 text-danger' },
};

const STATUS_LABEL: Record<AchievementStatus, string> = {
  normal: '정상', warning: '주의', danger: '위험',
};

export function AchievementSidebar({ kpi, customers, isLoading }: AchievementSidebarProps) {
  return (
    <Card className="flex h-full flex-col overflow-hidden p-5">
      <CardTitle className="mb-4 shrink-0 text-[15px]">
        가이드값 달성률
        <CardSubtitle>이달 현황</CardSubtitle>
      </CardTitle>

      {isLoading ? (
        <SidebarSkeleton />
      ) : kpi ? (
        <div className="flex min-h-0 flex-1 flex-col">
          {/* KPI 2개 */}
          <div className="mb-4 grid shrink-0 grid-cols-2 gap-2">
            <KpiBox
              label="후판 달성률"
              value={`${Math.round(kpi.achievement_rate * 100)}%`}
              sub="제품별 가이드값 대비"
              valueClass={kpi.achievement_rate >= 0.8 ? 'text-success' : kpi.achievement_rate >= 0.5 ? 'text-warning' : 'text-danger'}
            />
            <KpiBox
              label="전년 대비"
              value={`${kpi.yoy_change >= 0 ? '+' : ''}${Math.round(kpi.yoy_change * 100)}%`}
              sub="전년 동기 대비"
              valueClass={kpi.yoy_change >= 0 ? 'text-success' : 'text-danger'}
            />
          </div>

          {/* 전체 달성률 바 */}
          <div className="mb-4 shrink-0">
            <div className="mb-1.5 flex items-baseline justify-between">
              <span className="text-[12px] font-bold text-gray-800">후판 전체 달성률</span>
              <span className="text-[11px] text-gray-500">
                {kpi.actual_volume} / {kpi.guide_volume} {kpi.volume_unit}
              </span>
            </div>
            <div className="h-2 overflow-hidden rounded-full bg-gray-100">
              <div
                className={cn(
                  'h-full rounded-full transition-all',
                  kpi.achievement_rate >= 0.8 ? 'bg-success' : kpi.achievement_rate >= 0.5 ? 'bg-warning' : 'bg-danger',
                )}
                style={{ width: `${Math.min(kpi.achievement_rate * 100, 100)}%` }}
              />
            </div>
            <div className="mt-1 flex justify-between text-[10px]">
              <span className={kpi.achievement_rate >= 0.8 ? 'font-bold text-success' : kpi.achievement_rate >= 0.5 ? 'font-bold text-warning' : 'font-bold text-danger'}>
                {Math.round(kpi.achievement_rate * 100)}% 달성
              </span>
              <span className={kpi.yoy_change >= 0 ? 'text-success' : 'text-danger'}>
                전년 동기 대비 {kpi.yoy_change >= 0 ? '+' : ''}{Math.round(kpi.yoy_change * 100)}%
              </span>
            </div>
          </div>

          <div className="mb-3 h-px shrink-0 bg-gray-100" />

          {/* 고객사별 실적 — flex-1로 남은 높이 전체 채움 */}
          <div className="flex min-h-0 flex-1 flex-col">
            <div className="mb-2 shrink-0 text-[11px] font-bold text-gray-700">고객사별 실적</div>
            {/* 헤더 */}
            <div className="flex shrink-0 pb-1.5">
              <span className="flex-[3] text-[10px] text-gray-500">고객사</span>
              <span className="flex-[3] text-[10px] text-gray-500">달성률</span>
              <span className="flex-[1.5] text-right text-[10px] text-gray-500">전년</span>
              <span className="flex-[1.5] text-right text-[10px] text-gray-500">상태</span>
            </div>
            {/* 행 목록 — 균등 분배 */}
            <div className="flex flex-1 flex-col">
              {customers.map((c) => {
                const col = STATUS_COLORS[c.status];
                const pct = Math.round(c.achievement_rate * 100);
                return (
                  <div key={c.customer_id} className="flex flex-1 items-center border-t border-gray-50">
                    <div className="flex-[3] pr-1">
                      <div className="text-[12px] font-bold text-gray-900">{c.customer_name}</div>
                      <div className="text-[10px] text-gray-400">
                        {c.actual_volume}/{c.guide_volume}{c.volume_unit}
                      </div>
                    </div>
                    <div className="flex-[3] pr-1">
                      <div className="flex items-center gap-1.5">
                        <div className="h-[5px] w-14 overflow-hidden rounded-full bg-gray-100">
                          <div
                            className={cn('h-full rounded-full', col.bar)}
                            style={{ width: `${pct}%` }}
                          />
                        </div>
                        <span className={cn('text-[11px] font-bold', col.text)}>{pct}%</span>
                      </div>
                    </div>
                    <div className="flex-[1.5] text-right">
                      <span className={cn('text-[11px] font-bold', c.yoy_change >= 0 ? 'text-success' : 'text-danger')}>
                        {c.yoy_change >= 0 ? '+' : ''}{Math.round(c.yoy_change * 100)}%
                      </span>
                    </div>
                    <div className="flex-[1.5] pl-1 text-right">
                      <span className={cn('inline-flex rounded-[6px] px-1.5 py-0.5 text-[10px] font-bold', col.badge)}>
                        {STATUS_LABEL[c.status]}
                      </span>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* 범례 */}
          <div className="mt-3 flex shrink-0 gap-3 border-t border-gray-100 pt-2.5">
            {(['normal', 'warning', 'danger'] as AchievementStatus[]).map((s) => (
              <div key={s} className="flex items-center gap-1.5">
                <div className={cn('h-2 w-2 rounded-full', STATUS_COLORS[s].bar)} />
                <span className="text-[10px] text-gray-500">
                  {s === 'normal' ? '정상 ≥80%' : s === 'warning' ? '주의 50~79%' : '위험 <50%'}
                </span>
              </div>
            ))}
          </div>
        </div>
      ) : null}
    </Card>
  );
}

function KpiBox({ label, value, sub, valueClass }: { label: string; value: string; sub: string; valueClass: string }) {
  return (
    <div className="rounded-xl bg-gray-50 px-3 py-3">
      <div className="mb-1 text-[10px] font-semibold text-gray-500">{label}</div>
      <div className={cn('text-[26px] font-extrabold leading-none tracking-tightest', valueClass)}>{value}</div>
      <div className="mt-1 text-[10px] text-gray-400">{sub}</div>
    </div>
  );
}

function SidebarSkeleton() {
  return (
    <div className="space-y-3">
      <div className="grid grid-cols-2 gap-2">
        <Skeleton className="h-20" />
        <Skeleton className="h-20" />
      </div>
      <Skeleton className="h-10" />
      <Skeleton className="h-40" />
    </div>
  );
}
