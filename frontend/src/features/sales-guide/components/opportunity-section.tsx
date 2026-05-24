'use client';

import { useState } from 'react';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/shared/utils/cn';
import type {
  CustomerAchievement,
  CustomerOpportunity,
  GradeSummary,
  MarketSignal,
  RuleTagType,
} from '@/types';
import { useProposalScript } from '@/lib/api/queries/sales-guide';
import { SectionCard, SectionHeader, SectionIcons } from './section-header';
import { CustomerSlider, CustomerSliderCard } from './customer-slider';

/**
 * Module 2 — 기회탐지
 *
 *  - 시황 신호 + A/B/C 등급 (55:15:15:15)
 *  - 고객사별 상세 슬라이더 (3장씩 표시 + 좌/우 버튼)
 *
 * 제안 시작 (PRD 4.2.7): POST /api/sales-guide/proposal 호출로 4종 컨텍스트
 * (고객사/실적/시황/과거) 기반 3~4줄 자연어 행동 지침을 BE LLM 으로 생성.
 *
 * 시연용 변경:
 *  - "후판 KEY_FEATURES 변화율" 테이블 제거 (영업담당자 시연 시 시각 과부하)
 *  - 카드 헤더의 "달성률 X%" 제거 (Module 1 에 이미 표시되어 중복)
 */

const GRADE_CHIP: Record<string, string> = {
  A: 'bg-emerald-50 text-success',
  'A-': 'bg-emerald-50 text-success',
  'B+': 'bg-toss-blue-light text-toss-blue',
  B: 'bg-toss-blue-light text-toss-blue',
  C: 'bg-red-50 text-danger',
  D: 'bg-red-50 text-danger',
};
const RULE_TAG: Record<RuleTagType, string> = {
  info: 'bg-toss-blue-bg text-toss-blue',
  warning: 'bg-amber-50 text-warning',
  danger: 'bg-red-50 text-danger',
};

interface OpportunitySectionProps {
  signal: MarketSignal | null;
  gradeSummary: GradeSummary | null;
  opportunities: CustomerOpportunity[];
  achievements: CustomerAchievement[];
  isLoading?: boolean;
}

export function OpportunitySection({
  signal,
  gradeSummary,
  opportunities,
  achievements,
  isLoading,
}: OpportunitySectionProps) {
  return (
    <SectionCard id="section-opportunity" accent="violet">
      <SectionHeader
        kicker="03 · OPPORTUNITY"
        title="기회탐지"
        subtitle="시황 신호와 고객사별 스코어를 통합해, 어떤 고객사를 먼저 관리하고 언제 제안해야 할지 알려드립니다."
        icon={SectionIcons.search}
        accent="violet"
      />

      {isLoading ? (
        <div className="space-y-4">
          <Skeleton className="h-20" />
          <Skeleton className="h-60" />
        </div>
      ) : (
        <div className="flex flex-col gap-6">
          {/* 시황 신호 + 등급 (55:15:15:15) — 색 4단계 통일 */}
          <div className="grid grid-cols-[55fr_15fr_15fr_15fr] items-stretch gap-2.5">
            {signal ? (
              <div className="flex items-center justify-between rounded-xl bg-gray-50 px-5 py-4">
                <div>
                  <div className="text-[20px] font-extrabold tracking-tight text-gray-900">{signal.status}</div>
                  <div className="mt-0.5 text-[12px] text-gray-500">{signal.description}</div>
                </div>
                <div className="text-right">
                  <div className={cn(
                    'text-[28px] font-extrabold tracking-tightest',
                    signal.status === '강세' ? 'text-success'
                      : signal.status === '약세' ? 'text-danger' : 'text-toss-blue'
                  )}>
                    {signal.score >= 0 ? '+' : ''}{signal.score.toFixed(1)}%
                  </div>
                  <div className="text-[10px] text-gray-400">시황 스코어: Σ (변화율 × 가중치)</div>
                </div>
              </div>
            ) : <div />}
            {gradeSummary ? (
              <>
                <GradeBox count={gradeSummary.grade_a} label="A등급" sub="기회" color="text-success" />
                <GradeBox count={gradeSummary.grade_b} label="B등급" sub="관리" color="text-toss-blue" />
                <GradeBox count={gradeSummary.grade_c} label="C등급" sub="리스크" color="text-danger" />
              </>
            ) : <><div /><div /><div /></>}
          </div>

          {/* 고객사별 상세 슬라이더 */}
          <CustomerSlider label="고객사별 상세" count={opportunities.length}>
            {opportunities.map((opp) => (
              <CustomerSliderCard key={opp.customer_id}>
                <OpportunityCustomerCard
                  opp={opp}
                  achievement={achievements.find((a) => a.customer_id === opp.customer_id)}
                />
              </CustomerSliderCard>
            ))}
          </CustomerSlider>
        </div>
      )}
    </SectionCard>
  );
}

function GradeBox({
  count,
  label,
  sub,
  color,
}: {
  count: number;
  label: string;
  sub: string;
  color: string;
}) {
  return (
    <div className="flex flex-col items-center justify-center rounded-xl bg-gray-50 px-2 py-4">
      <div className={cn('text-[28px] font-extrabold leading-none', color)}>{count}</div>
      <div className="mt-2 text-center text-[10px] leading-tight text-gray-500">
        {label}
        <br />
        {sub}
      </div>
    </div>
  );
}


function OpportunityCustomerCard({ opp, achievement }: { opp: CustomerOpportunity; achievement?: CustomerAchievement }) {
  // PRD 4.2.7 — 제안 시작: BE /api/sales-guide/proposal 호출 (LLM 3~4줄 행동지침)
  const proposal = useProposalScript();
  const [visible, setVisible] = useState(true);

  const gradeClass = GRADE_CHIP[opp.grade] ?? GRADE_CHIP['B'];
  const ruleClass = RULE_TAG[opp.rule_tag_type];

  const proposalText = proposal.data?.script ?? '';
  const proposalState: 'idle' | 'loading' | 'done' | 'error' = proposal.isError
    ? 'error'
    : proposal.isPending
      ? 'loading'
      : proposal.data
        ? 'done'
        : 'idle';

  const handlePropose = () => {
    if (proposal.isPending) return;
    proposal.mutate(opp.customer_id, {
      onSuccess: () => setVisible(true),
    });
  };

  return (
    <div className="flex h-full flex-col rounded-2xl border-[1.5px] border-gray-100 p-5">
      {/* 헤더 — 등급 chip + 고객사명 / 종합 스코어 원형 ring */}
      <div className="mb-4 flex items-start justify-between">
        <div className="flex items-center gap-3">
          <div className={cn('flex h-11 w-11 shrink-0 items-center justify-center rounded-xl text-[15px] font-extrabold', gradeClass)}>
            {opp.grade}
          </div>
          <div>
            <div className="text-[16px] font-extrabold tracking-tight text-gray-900">{opp.customer_name}</div>
            <div className="mt-0.5 text-[12px] text-gray-400">{opp.industry}</div>
          </div>
        </div>
        <CircularScore score={opp.score} grade={opp.grade} />
      </div>

      {/* 메트릭 3개 — 달성률 / 전년 대비 / 시황 영향 */}
      <div className="mb-3 grid grid-cols-3 gap-2">
        <AchievementRateBox achievement={achievement} />
        <YoyMetricBox achievement={achievement} />
        <ImpactMetricBox metric={opp.metrics[2]} marketDirections={opp.market_directions} customerName={opp.customer_name} />
      </div>

      {/* 룰 태그 */}
      {/* <div className={cn('mb-3 rounded-xl px-3.5 py-2.5 text-[12px] font-semibold', ruleClass)}>
        {opp.rule_tag}
      </div> */}

      {/* 종합 점수 산출 기준 */}
      <ScoreBreakdown score={opp.score} achievement={achievement} impactPct={parsePercent(opp.metrics[2]?.value ?? '0')} />

      {/* 시황 기여 상위 지표 태그 */}
      {(opp.top_market_drivers ?? []).length > 0 && (
        <div className="mb-3">
        <div className="mb-1 text-[11px] text-gray-400">눈여겨볼 지표</div>
        <div className="flex flex-wrap gap-1.5">
          {(opp.top_market_drivers ?? []).slice(0, 2).map((d) => {
            const impactPositive = (d.impact_sign ?? d.direction) > 0;
            const changeSign = (d.impact_sign ?? 0) * d.direction; // sign(change_pct) 역산
            const arrow = changeSign > 0 ? '↑' : '↓';
            return (
              <span
                key={d.name}
                className="rounded-md bg-gray-100 px-2 py-0.5 text-[10px] font-semibold text-gray-600"
              >
                {arrow} {d.name} · {impactPositive ? '현재 긍정 작용' : '현재 부정 작용'}
              </span>
            );
          })}
        </div>
        </div>
      )}

      {/* 민감 이슈 */}
      {opp.sensitivity_tags.length > 0 && (
        <div className="mb-3">
          <div className="mb-1.5 text-[11px] text-gray-400">민감 이슈</div>
          <div className="flex flex-wrap gap-1.5">
            {opp.sensitivity_tags.map((t) => (
              <span key={t} className="rounded-md bg-gray-100 px-2.5 py-0.5 text-[11px] font-medium text-gray-700">
                {t}
              </span>
            ))}
          </div>
        </div>
      )}

      {/* 리스크 요인 */}
      {opp.risk_tags.length > 0 && (
        <div className="mb-3">
          <div className="mb-1.5 text-[11px] text-gray-400">리스크 요인</div>
          <div className="flex flex-wrap gap-1.5">
            {opp.risk_tags.map((t) => (
              <span key={t} className="rounded-md bg-red-50 px-2.5 py-0.5 text-[11px] font-medium text-danger">
                {t}
              </span>
            ))}
          </div>
        </div>
      )}

      {/* 푸터: 제안 시작 / 답변 숨기기 / 재시도 — mt-auto로 항상 카드 하단에 고정 */}
      <div className="mt-auto flex items-center gap-3 border-t border-gray-100 pt-3.5">
        {proposalState === 'idle' && (
          <button
            type="button"
            onClick={handlePropose}
            className="shrink-0 rounded-xl bg-gray-900 px-5 py-2.5 text-[13px] font-bold text-white transition-colors hover:bg-gray-700"
          >
            제안 시작
          </button>
        )}
        {proposalState === 'loading' && (
          <button
            disabled
            className="shrink-0 cursor-not-allowed rounded-xl bg-gray-200 px-5 py-2.5 text-[13px] font-bold text-gray-400"
          >
            생성 중...
          </button>
        )}
        {proposalState === 'done' && (
          <button
            type="button"
            onClick={() => setVisible((v) => !v)}
            className="shrink-0 rounded-xl border-[1.5px] border-gray-200 bg-white px-5 py-2.5 text-[13px] font-bold text-gray-700 transition-colors hover:bg-gray-50"
          >
            {visible ? '답변 숨기기' : '제안 다시 보기'}
          </button>
        )}
        {proposalState === 'error' && (
          <button
            type="button"
            onClick={handlePropose}
            className="shrink-0 rounded-xl border-[1.5px] border-red-200 bg-red-50 px-5 py-2.5 text-[13px] font-bold text-danger transition-colors hover:bg-red-100"
          >
            재시도
          </button>
        )}
      </div>

      {/* AI 응답 박스 */}
      {proposalState === 'done' && visible && (
        <div className="mt-3.5 animate-fade-in rounded-xl border border-toss-blue-light bg-toss-blue-bg px-4 py-3.5">
          <div className="mb-2 text-[11px] font-extrabold uppercase tracking-wide text-toss-blue">
            AI 행동 지침
          </div>
          <pre className="whitespace-pre-wrap font-sans text-[13px] leading-[1.8] text-gray-700">
            {proposalText}
          </pre>
        </div>
      )}

      {/* 에러 메시지 (PRD 4.2.7: 오류 메시지 + 재시도 버튼) */}
      {proposalState === 'error' && (
        <div className="mt-3.5 rounded-xl border border-red-100 bg-red-50 px-4 py-3 text-[12px] text-danger">
          제안 생성 중 오류가 발생했습니다. 다시 시도해주세요.
        </div>
      )}
    </div>
  );
}

/* ─────────────────────────────────────────────
 * 메트릭 박스 — Toss 미니멀 톤
 *   - 큰 숫자 + 한 줄 sub + 얇은 progress bar (h-1)
 *   - 색 4단계 (emerald/toss-blue/amber/red) — pastel pale
 *   - 영업담당자 시각 과부하 회피 (아이콘 최소화, 그라데이션 X)
 * ───────────────────────────────────────────── */

function parsePercent(value: string): number {
  /* "91점" → 91, "+18%" → 18, "-3%" → -3, "+1.8%" → 1.8 */
  const m = value.match(/-?\d+(?:\.\d+)?/);
  return m ? parseFloat(m[0]) : 0;
}

/** 0~100 점수 → 4단계 색 토큰 (POSCO 보수적 톤, 절제된 pastel) */
function scoreLevel(score: number): {
  bar: string;     // progress bar 색
  text: string;    // sub 텍스트 색
} {
  if (score >= 80) return { bar: 'bg-success', text: 'text-success' };
  if (score >= 60) return { bar: 'bg-toss-blue', text: 'text-toss-blue' };
  if (score >= 40) return { bar: 'bg-warning', text: 'text-warning' };
  return { bar: 'bg-danger', text: 'text-danger' };
}

function countWeekdays(year: number, month: number, toDay?: number): number {
  const last = toDay ?? new Date(year, month, 0).getDate();
  let count = 0;
  for (let d = 1; d <= last; d++) {
    const dow = new Date(year, month - 1, d).getDay();
    if (dow !== 0 && dow !== 6) count++;
  }
  return count;
}

/** 종합 스코어 원형 ring (SVG stroke-dasharray) — Toss App "내 신용 점수" 패턴 */
function CircularScore({ score, grade }: { score: number; grade: string }) {
  const radius = 24;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference * (1 - Math.max(0, Math.min(100, score)) / 100);
  const strokeClass =
    grade === 'A' || grade === 'A-' ? 'text-success'
    : grade === 'B+' || grade === 'B' ? 'text-toss-blue'
    : grade === 'C' ? 'text-danger'
    : 'text-danger';
  return (
    <div className="relative shrink-0">
      <svg width="60" height="60" viewBox="0 0 60 60">
        <circle cx="30" cy="30" r={radius} stroke="#f3f4f6" strokeWidth="4" fill="none" />
        <circle
          cx="30"
          cy="30"
          r={radius}
          stroke="currentColor"
          strokeWidth="4"
          fill="none"
          strokeLinecap="round"
          strokeDasharray={circumference}
          strokeDashoffset={offset}
          transform="rotate(-90 30 30)"
          className={cn('transition-all', strokeClass)}
        />
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <span className="text-[16px] font-extrabold leading-none text-gray-900">{score}</span>
        <span className="mt-0.5 text-[8px] font-medium text-gray-400">종합</span>
      </div>
    </div>
  );
}

function ScoreBreakdown({ score, achievement, impactPct }: {
  score: number;
  achievement?: CustomerAchievement;
  impactPct: number;
}) {
  const DEMO_YEAR = 2026, DEMO_MONTH = 5, DEMO_DAY = 15;
  const totalBd = countWeekdays(DEMO_YEAR, DEMO_MONTH);
  const elapsedBd = countWeekdays(DEMO_YEAR, DEMO_MONTH, DEMO_DAY);
  const timeRatio = elapsedBd / totalBd;

  const achievementRate = achievement?.achievement_rate ?? 0;
  const yoyChange = achievement?.yoy_change ?? 0;

  const paceRaw = (achievementRate / timeRatio) * 100;
  const paceScore = Math.min(100, Math.round(paceRaw));
  const isCapped = paceRaw >= 100;

  const yoyScore = Math.round(Math.max(0, Math.min(100, (yoyChange + 0.20) / 0.40 * 100)));
  const yoySub = yoyChange >= 0.15 ? '큰 폭 성장'
    : yoyChange >= 0.01 ? '성장'
    : yoyChange >= -0.01 ? '전년 동수준'
    : '역성장';

  const impactScore = impactPct > 1 ? 70 : impactPct < -1 ? 30 : 50;
  const impactSub = impactPct > 1 ? '기회' : impactPct < -1 ? '주의' : '중립';

  return (
    <div className="mb-3 rounded-xl bg-gray-50 px-3.5 py-3">
      <div className="mb-2 text-[11px] font-bold text-gray-500">종합 점수 산출 기준</div>
      <div className="space-y-2">
        <div>
          <div className="flex items-center justify-between text-[10px]">
            <span className="font-semibold text-gray-600">내 기여도 <span className="font-normal text-gray-400">× 40%</span></span>
            <span className="font-bold text-gray-700">= {(paceScore * 0.4).toFixed(1)}</span>
          </div>
          <div className="mt-0.5 text-[10px] text-gray-400">
            {Math.round(achievementRate * 100)}% ÷ (경과 영업일/전체 영업일) = {Math.round(paceRaw)}% → <span className="font-semibold text-gray-600">{paceScore}점{isCapped ? ' (상한)' : ''}</span>
          </div>
        </div>
        <div>
          <div className="flex items-center justify-between text-[10px]">
            <span className="font-semibold text-gray-600">전년 대비 <span className="font-normal text-gray-400">× 40%</span></span>
            <span className="font-bold text-gray-700">= {(yoyScore * 0.4).toFixed(1)}</span>
          </div>
          <div className="mt-0.5 text-[10px] text-gray-400">
            (올해 기여율 - 작년 기여율) / 작년 기여율 = {yoyChange >= 0 ? '+' : ''}{Math.round(yoyChange * 100)}% → <span className="font-semibold text-gray-600">{yoyScore}점{yoyScore === 100 ? ' (상한)' : ''} ({yoySub})</span>
          </div>
        </div>
        <div>
          <div className="flex items-center justify-between text-[10px]">
            <span className="font-semibold text-gray-600">시황 영향 <span className="font-normal text-gray-400">× 20%</span></span>
            <span className="font-bold text-gray-700">= {(impactScore * 0.2).toFixed(1)}</span>
          </div>
          <div className="mt-0.5 text-[10px] text-gray-400">
            시황 스코어 {impactPct >= 0 ? '+' : ''}{impactPct.toFixed(2)}% → <span className="font-semibold text-gray-600">{impactScore}점 ({impactSub})</span>
          </div>
        </div>
      </div>
    </div>
  );
}

function AchievementRateBox({ achievement }: { achievement?: CustomerAchievement }) {
  if (!achievement) return <div className="rounded-xl bg-gray-50 px-3.5 py-3" />;
  const pct = Math.min(Math.round(achievement.achievement_rate * 100), 100);
  const barColor = pct >= 80 ? 'bg-success' : pct >= 50 ? 'bg-warning' : 'bg-danger';
  const textColor = pct >= 80 ? 'text-success' : pct >= 50 ? 'text-warning' : 'text-danger';
  return (
    <div className="rounded-xl bg-gray-50 px-3.5 py-3">
      <div className="flex items-center gap-1">
        <span className="text-[11px] text-gray-500">내 기여도</span>
        <div className="group relative">
          <span className="cursor-default select-none text-[10px] text-gray-400 hover:text-gray-600">ⓘ</span>
          <div className="invisible absolute left-0 top-full z-50 mt-1 w-44 rounded-xl border border-gray-100 bg-white p-2.5 shadow-lg group-hover:visible">
            <p className="text-[10px] leading-relaxed text-gray-600">
              나의 실적 ÷ 그룹 내 고객사별 제품 가이드
            </p>
          </div>
        </div>
      </div>
      <div className={cn('mt-1 text-[16px] font-extrabold tracking-tight', textColor)}>{pct}%</div>
      <div className="mt-2 h-1 overflow-hidden rounded-full bg-gray-200">
        <div className={cn('h-full rounded-full transition-all', barColor)} style={{ width: `${pct}%` }} />
      </div>
      <div className="mt-1.5 text-[10px] font-bold text-gray-400">
        {achievement.actual_volume} / {achievement.guide_volume} {achievement.volume_unit}
      </div>
    </div>
  );
}

function SpeedMetricBox({ metric }: { metric?: { label: string; value: string; sub?: string } }) {
  if (!metric) return <div />;
  const score = parsePercent(metric.value);
  const sub =
    score >= 90 ? '달성 가속 중'
      : score >= 70 ? '달성 속도 정상'
        : score >= 50 ? '달성 속도 둔화'
          : '달성 속도 저조';
  return <MetricBox label="달성 속도" value={metric.value} sub={sub} normalizedScore={score} />;
}

function YoyMetricBox({ achievement }: { achievement?: CustomerAchievement }) {
  if (!achievement) return <div className="rounded-xl bg-gray-50 px-3.5 py-3" />;
  const prev = Math.round((achievement.prev_achievement_rate ?? 0) * 100);
  const curr = Math.round(achievement.achievement_rate * 100);
  const diff = curr - prev;
  const isUp = diff >= 0;
  return (
    <div className="rounded-xl bg-gray-50 px-3.5 py-3">
      <div className="flex items-center justify-between">
        <span className="text-[11px] text-gray-500">전년 대비 나의 기여율</span>
      </div>
      <div className="mt-1.5 flex items-center gap-1 text-[13px] font-extrabold tracking-tight text-gray-900">
        <span>{prev}%</span>
        <span className="text-gray-300">→</span>
        <span>{curr}%</span>
      </div>
      <div className={cn('mt-1 text-[12px] font-extrabold', isUp ? 'text-success' : 'text-danger')}>
        {isUp ? '▲' : '▼'} {isUp ? '+' : ''}{diff}%p
      </div>
    </div>
  );
}

function ImpactMetricBox({
  metric,
  marketDirections,
  customerName,
}: {
  metric?: { label: string; value: string; sub?: string };
  marketDirections?: Record<string, number>;
  customerName?: string;
}) {
  if (!metric) return <div />;
  const impact = parsePercent(metric.value);
  const sub = impact > 1 ? '기회' : impact >= -1 ? '중립' : '주의';
  const normalizedScore = impact > 1 ? 70 : impact >= -1 ? 50 : 30;
  const { bar, text } = scoreLevel(normalizedScore);

  const positives = Object.entries(marketDirections ?? {}).filter(([, v]) => v === 1).map(([k]) => k);
  const negatives = Object.entries(marketDirections ?? {}).filter(([, v]) => v === -1).map(([k]) => k);
  const hasDirections = positives.length > 0 || negatives.length > 0;
  const cname = customerName ?? '고객사';

  return (
    <div className="rounded-xl bg-gray-50 px-3.5 py-3">
      <div className="flex items-center gap-1">
        <span className="text-[11px] text-gray-500">시황 영향</span>
        {hasDirections && (
          <div className="group relative">
            <span className="cursor-default select-none text-[10px] text-gray-400 hover:text-gray-600">ⓘ</span>
            <div className="invisible absolute left-0 top-full z-50 mt-1 w-60 rounded-xl border border-gray-100 bg-white p-3 shadow-lg group-hover:visible">
              <div className="mb-2.5 rounded-lg bg-gray-50 p-2.5">
                <div className="mb-1 text-[10px] font-bold text-gray-700">시황 영향 산출 방식</div>
                <div className="mb-1.5 text-[10px] leading-relaxed text-gray-500">
                  각 시황 지표의 (변화율 × 가중치 × AI 방향 판단)을 합산한 값입니다.
                </div>
                <div className="text-[10px] text-gray-500">
                  현재 시황 스코어: <span className="font-bold text-gray-700">{metric.value}</span>
                </div>
              </div>
              <div className="mb-2 text-[11px] font-bold text-gray-700">AI 판단 시황 기여 지표</div>
              {positives.length > 0 && (
                <div className="mb-2.5">
                  <div className="mb-1 text-[10px] font-bold text-success">구매 증가 요인</div>
                  <div className="mb-1.5 text-[10px] text-gray-500">
                    이 지표가 <span className="font-semibold text-success">상승</span>하면 {cname}에게 <span className="font-semibold text-success">호재</span>입니다.
                  </div>
                  {positives.map((name) => (
                    <div key={name} className="truncate text-[10px] text-gray-600">· {name}</div>
                  ))}
                </div>
              )}
              {negatives.length > 0 && (
                <div>
                  <div className="mb-1 text-[10px] font-bold text-danger">구매 감소 요인</div>
                  <div className="mb-1.5 text-[10px] text-gray-500">
                    이 지표가 <span className="font-semibold text-success">상승</span>하면 {cname}에게 <span className="font-semibold text-danger">악재</span>입니다.
                  </div>
                  {negatives.map((name) => (
                    <div key={name} className="truncate text-[10px] text-gray-600">· {name}</div>
                  ))}
                </div>
              )}
            </div>
          </div>
        )}
      </div>
      <div className="mt-1 text-[16px] font-extrabold tracking-tight text-gray-900">{metric.value}</div>
      <div className="mt-2 h-1 overflow-hidden rounded-full bg-gray-200">
        <div className={cn('h-full rounded-full transition-all', bar)} style={{ width: `${Math.max(0, Math.min(100, normalizedScore))}%` }} />
      </div>
      <div className={cn('mt-1.5 text-[10px] font-bold', text)}>{sub}</div>
    </div>
  );
}

function MetricBox({
  label,
  value,
  sub,
  normalizedScore,
}: {
  label: string;
  value: string;
  sub: string;
  /** 0~100 — progress bar + color level 결정 */
  normalizedScore: number;
}) {
  const { bar, text } = scoreLevel(normalizedScore);
  return (
    <div className="rounded-xl bg-gray-50 px-3.5 py-3">
      <div className="flex items-baseline justify-between">
        <span className="text-[11px] text-gray-500">{label}</span>
      </div>
      <div className="mt-1 text-[16px] font-extrabold tracking-tight text-gray-900">{value}</div>
      {/* 얇은 progress bar (h-1) — Toss 패턴 */}
      <div className="mt-2 h-1 overflow-hidden rounded-full bg-gray-200">
        <div
          className={cn('h-full rounded-full transition-all', bar)}
          style={{ width: `${Math.max(0, Math.min(100, normalizedScore))}%` }}
        />
      </div>
      <div className={cn('mt-1.5 text-[10px] font-bold', text)}>{sub}</div>
    </div>
  );
}
