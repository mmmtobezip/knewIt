'use client';

import { Skeleton } from '@/components/ui/skeleton';
import type { IndicatorPoint, KeyFeature } from '@/types';
import { SectionCard, SectionHeader, SectionIcons } from './section-header';

interface KeyFeaturesSectionProps {
  product: string;
  keyFeatures: KeyFeature[];
  isLoading?: boolean;
}

export function KeyFeaturesSection({ product, keyFeatures, isLoading }: KeyFeaturesSectionProps) {
  const productLabel = product || '제품';

  return (
    <SectionCard id="section-market" accent="amber">
      <SectionHeader
        kicker="02 · MARKET"
        title={`${productLabel} 관련 시황 한눈에 보기`}
        subtitle="주요 시황 지표의 최근 추이와 변화율을 확인합니다."
        icon={SectionIcons.trend}
        accent="amber"
        action={
          <button
            type="button"
            className="rounded-xl bg-amber-500 px-4 py-2 text-[13px] font-bold text-white transition-colors hover:bg-amber-600"
          >
            지표 바꾸기
          </button>
        }
      />

      {isLoading ? (
        <div className="space-y-2">
          {[...Array(5)].map((_, i) => <Skeleton key={i} className="h-8" />)}
        </div>
      ) : keyFeatures.length === 0 ? null : (
        <>
          {/* 헤더 */}
          <div className="mb-2 flex items-center gap-3 border-b border-gray-200 pb-2">
            <div className="w-4 shrink-0" />
            <div className="flex-1 text-[10px] font-bold text-gray-400">{productLabel} 주요 필수 확인 지표</div>
            <div className="w-40 shrink-0 text-center text-[10px] font-bold text-gray-400">최근 90일 추이</div>
            <div className="w-28 shrink-0 text-right text-[10px] font-bold text-gray-400">현황값 (단위)</div>
            <div className="w-24 shrink-0 text-center text-[10px] font-bold text-gray-400">기준일</div>
            <div className="w-16 shrink-0 text-center text-[10px] font-bold text-gray-400">수집주기</div>
            <div className="w-24 shrink-0 text-center text-[10px] font-bold text-gray-400">변화율 측정 기준</div>
            <div className="w-14 shrink-0 text-right text-[10px] font-bold text-gray-400">변화율</div>
          </div>

          {/* 데이터 행 */}
          <div className="flex flex-col gap-2">
            {keyFeatures.map((f) => (
              <div key={f.rank} className="flex items-center gap-3">
                <span className="w-4 shrink-0 text-[11px] font-bold text-gray-300">{f.rank}</span>
                <span className="flex-1 text-[13px] font-medium text-gray-700">{f.name}</span>
                <Sparkline history={f.history ?? []} change={f.change} />
                <span className="w-28 shrink-0 text-right text-[13px] font-semibold text-gray-600">
                  {f.current_value ?? '—'}
                  {f.unit && <span className="ml-1 text-[10px] font-normal text-gray-400">{f.unit}</span>}
                </span>
                <span className="w-24 shrink-0 text-center text-[11px] text-gray-400">
                  {f.current_date ?? '—'}
                </span>
                <span className="w-16 shrink-0 text-center text-[11px] text-gray-400">
                  {f.cycle === 'DAILY' ? 'Daily' : f.cycle === 'WEEKLY' ? 'Weekly' : f.cycle === 'MONTHLY' ? 'Monthly' : 'Yearly'}
                </span>
                <span className="w-24 shrink-0 text-center text-[11px] text-gray-400">
                  {f.cycle === 'DAILY' ? '5일 평균 대비' : f.cycle === 'WEEKLY' ? '전주 대비' : f.cycle === 'MONTHLY' ? '전월 대비' : '전년 대비'}
                </span>
                <span className={`w-14 shrink-0 text-right text-[13px] font-extrabold ${changeTextColor(f.change)}`}>
                  {f.change}
                </span>
              </div>
            ))}
          </div>
        </>
      )}
    </SectionCard>
  );
}

function isZeroChange(change: string): boolean {
  const num = parseFloat(change.replace(/[^0-9.-]/g, ''));
  return num === 0;
}
function changeTextColor(change: string): string {
  if (isZeroChange(change)) return 'text-gray-400';
  if (change.startsWith('+')) return 'text-red-500';
  if (change.startsWith('-')) return 'text-blue-500';
  return 'text-gray-400';
}
function changeHexColor(change: string): string {
  if (isZeroChange(change)) return '#9ca3af';
  if (change.startsWith('+')) return '#ef4444';
  if (change.startsWith('-')) return '#3b82f6';
  return '#9ca3af';
}

function Sparkline({ history, change }: { history: IndicatorPoint[]; change: string }) {
  if (history.length < 2) return <div className="w-40 shrink-0" />;

  const values = history.map((h) => h.value);
  const min = Math.min(...values);
  const max = Math.max(...values);
  const range = max - min || 1;

  const W = 160;
  const H = 24;
  const pts = values
    .map((v, i) => {
      const x = (i / (values.length - 1)) * W;
      const y = H - ((v - min) / range) * (H - 4) - 2;
      return `${x.toFixed(1)},${y.toFixed(1)}`;
    })
    .join(' ');

  const color = changeHexColor(change);

  return (
    <div className="flex w-40 shrink-0 items-center justify-center">
      <svg width={W} height={H} viewBox={`0 0 ${W} ${H}`} className="overflow-visible">
        <polyline
          points={pts}
          fill="none"
          stroke={color}
          strokeWidth="1.5"
          strokeLinecap="round"
          strokeLinejoin="round"
          opacity={0.8}
        />
      </svg>
    </div>
  );
}
