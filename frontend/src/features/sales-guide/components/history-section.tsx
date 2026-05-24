'use client';

import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/shared/utils/cn';
import type { SimilarityPoint, SimilarPeriod } from '@/types';
import { SectionCard, SectionHeader, SectionIcons } from './section-header';

/**
 * Module 3 — 유사 과거 시황
 *
 *  - 과거 시황 유사도 타임라인 (월별 막대)
 *  - 유사도 TOP 3 — 3-column 카드 (실적/시황/집중 고객사)
 *
 * 시연용 변경: "현재 후판 시황 (당월 평균)" 컴포넌트 제거 (Module 2 시황 영역과 중복).
 */

const RANK_BG = ['bg-warning', 'bg-gray-400', 'bg-amber-700'];

interface HistorySectionProps {
  timeline: SimilarityPoint[];
  similarPeriods: SimilarPeriod[];
  product?: string;
  isLoading?: boolean;
}

export function HistorySection({
  timeline,
  similarPeriods,
  product = '',
  isLoading,
}: HistorySectionProps) {
  // 현재 시점은 비교 대상이 아닌 *기준* 이므로 타임라인에서 제외 (시연 단순화)
  const pastTimeline = timeline.filter((pt) => !pt.is_current);
  const maxScore = Math.max(...pastTimeline.map((p) => p.score), 1);

  return (
    <SectionCard id="section-history" accent="sky">
      <SectionHeader
        kicker="04 · HISTORY"
        title="유사 과거 시황"
        subtitle="지금과 가장 닮았던 과거 월 Top 3를 찾아, 그때의 달성 패턴과 집중 고객사를 함께 제안해드립니다."
        icon={SectionIcons.history}
        accent="sky"
      />

      {isLoading ? (
        <div className="space-y-4">
          <Skeleton className="h-32" />
          <Skeleton className="h-60" />
        </div>
      ) : (
        <div className="flex flex-col gap-6">
          {/* 유사도 타임라인 — 현재 시점 제외, 과거 11개월 비교 */}
          <div>
            <SectionLabel>과거 시황 유사도 타임라인</SectionLabel>
            <div className="flex w-full items-end gap-1.5" style={{ height: 120 }}>
              {pastTimeline.map((pt, i) => {
                const h = Math.round((pt.score / maxScore) * 100);
                // score 라벨은 Top 3 만 표시 (일반 구간은 시각 노이즈 회피)
                const showScore = pt.highlighted;
                return (
                  <div key={i} className="flex flex-1 flex-col items-center gap-1">
                    {/* 막대 위 cos% 표시 */}
                    <span
                      className={cn(
                        'h-3 text-[9px] font-bold leading-none',
                        showScore ? 'text-toss-blue' : 'text-transparent',
                      )}
                    >
                      {showScore ? `${Math.round(pt.score)}%` : '·'}
                    </span>
                    <div
                      title={`코사인 유사도 ${pt.score.toFixed(1)}%`}
                      className={cn(
                        'w-full rounded-t-[5px] transition-colors',
                        pt.highlighted ? 'bg-toss-blue' : 'bg-gray-200',
                      )}
                      style={{ height: `${h}px`, minHeight: 4 }}
                    />
                    <span
                      className={cn(
                        'whitespace-nowrap text-[10px]',
                        pt.highlighted ? 'font-bold text-toss-blue' : 'text-gray-400',
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
              <LegendDot bg="bg-gray-200" text="일반 구간 (낮은 유사도)" />
            </div>
          </div>

          {/* TOP 3 — 3-column 그리드 */}
          <div>
            <SectionLabel>유사도 TOP 3 — 과거 시황 &amp; 결과</SectionLabel>
            <div className="grid grid-cols-1 gap-3.5 lg:grid-cols-3">
              {similarPeriods.map((p) => (
                <SimilarPeriodCard key={p.rank} period={p} product={product} />
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

function SimilarPeriodCard({ period, product }: { period: SimilarPeriod; product: string }) {
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
        <ResultBox label={<>당시 나의 그룹 내<br />{product} 실적값</>} value={`${period.actual_volume}천톤`} />
        <ResultBox label={<>당시 나의 그룹 내<br />{product} 가이드값</>} value={`${period.guide_volume}천톤`} />
        <ResultBox
          label="당시 달성률"
          value={`${pct}%`}
          tooltip={`당시 나의 그룹 내 ${product} 실적값 ÷ 당시 나의 그룹 내 ${product} 가이드값 × 100`}
        />
      </div>

      {/* 당시 시황 features — 현재 대비 delta chip 으로 비교 가능 */}
      {period.market_features?.length > 0 && (
        <div className="mb-4">
          <div className="mb-2 text-[11px] font-semibold text-gray-500">
            당시 시황 ({period.period} 평균) · <span className="text-gray-400">현재 대비 변화</span>
          </div>
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
                    <div className="flex items-baseline gap-1.5">
                      <span className="text-[13px] font-bold text-gray-900">{f.value}</span>
                      <DeltaChip delta={f.delta_pct ?? null} currentValue={f.current_value ?? null} />
                    </div>
                  </div>
                ))}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* 집중 고객사 */}
      <div className="mb-3 flex flex-wrap items-center gap-1.5">
        <span className="mr-1 text-[11px] text-gray-400">당시 판매량 높은 고객사 순</span>
        {period.focus_customers.map((c, i) => (
          <span key={c} className="flex items-center gap-1">
            <span className="rounded-md bg-toss-blue-light px-2.5 py-0.5 text-[11px] font-semibold text-toss-blue">
              {c}
            </span>
            {i < period.focus_customers.length - 1 && <span className="text-[10px] text-gray-300">›</span>}
          </span>
        ))}
      </div>

      {/* 한 줄 인사이트 (룰 기반, POSCO 정중 톤) — 영업담당자 다음 액션 안내 */}
      {period.insight && (
        <div className="mt-auto rounded-xl border border-toss-blue-light bg-toss-blue-bg px-3.5 py-2.5">
          <div className="mb-0.5 text-[10px] font-extrabold uppercase tracking-wide text-toss-blue">
            추천 액션
          </div>
          <div className="text-[12px] leading-[1.6] text-gray-700">{period.insight}</div>
        </div>
      )}
    </div>
  );
}

/** 현재 대비 변화율 chip — past→current 차이. 절대값 1% 미만은 회색(중립). */
function DeltaChip({
  delta,
  currentValue,
}: {
  delta: number | null;
  currentValue: string | null;
}) {
  if (delta === null || currentValue === null) return null;
  const abs = Math.abs(delta);
  const tone =
    abs < 1 ? 'bg-gray-100 text-gray-500'
      : delta > 0 ? 'bg-red-50 text-danger'      // 현재가 더 큼 (상승) — 후판 가격 상승 시그널
        : 'bg-toss-blue-bg text-toss-blue';       // 현재가 더 작음 (하락)
  const sign = delta > 0 ? '↑' : delta < 0 ? '↓' : '—';
  return (
    <span
      title={`현재 ${currentValue}`}
      className={cn('rounded-md px-1.5 py-0.5 text-[10px] font-bold', tone)}
    >
      {sign} {abs.toFixed(1)}%
    </span>
  );
}

function ResultBox({
  label,
  value,
  valueClass = 'text-gray-900',
  tooltip,
}: {
  label: React.ReactNode;
  value: string;
  valueClass?: string;
  tooltip?: string;
}) {
  return (
    <div className="rounded-xl bg-gray-100 px-3 py-3 text-center">
      <div className="mb-1.5 flex items-center justify-center gap-1 text-[10px] text-gray-400">
        <span className="leading-tight">{label}</span>
        {tooltip && (
          <div className="group relative shrink-0">
            <span className="cursor-default select-none text-[10px] text-gray-400 hover:text-gray-600">ⓘ</span>
            <div className="invisible absolute bottom-full left-1/2 z-50 mb-1.5 w-48 -translate-x-1/2 rounded-xl border border-gray-100 bg-white p-2.5 shadow-lg group-hover:visible">
              <p className="text-[10px] leading-relaxed text-gray-600">{tooltip}</p>
            </div>
          </div>
        )}
      </div>
      <div className={cn('text-[17px] font-extrabold tracking-tighter', valueClass)}>{value}</div>
    </div>
  );
}

function chunk<T>(arr: T[], size: number): T[][] {
  const out: T[][] = [];
  for (let i = 0; i < arr.length; i += size) out.push(arr.slice(i, i + size));
  return out;
}
