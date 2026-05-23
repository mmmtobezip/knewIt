'use client';

import { useState } from 'react';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/shared/utils/cn';
import type {
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
  C: 'bg-amber-50 text-warning',
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
  isLoading?: boolean;
}

export function OpportunitySection({
  signal,
  gradeSummary,
  opportunities,
  isLoading,
}: OpportunitySectionProps) {
  return (
    <SectionCard id="section-opportunity" accent="violet">
      <SectionHeader
        kicker="02 · OPPORTUNITY"
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
                  <div className="text-[10px] text-gray-400">시황 스코어</div>
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
                <OpportunityCustomerCard opp={opp} />
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


function OpportunityCustomerCard({ opp }: { opp: CustomerOpportunity }) {
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
        <CircularScore score={opp.score} />
      </div>

      {/* 메트릭 3개 — 달성 속도 / 전년 대비 / 시황 영향 */}
      <div className="mb-3 grid grid-cols-3 gap-2">
        <SpeedMetricBox metric={opp.metrics[0]} />
        <YoyMetricBox metric={opp.metrics[1]} />
        <ImpactMetricBox metric={opp.metrics[2]} />
      </div>

      {/* 룰 태그 */}
      <div className={cn('mb-3 rounded-xl px-3.5 py-2.5 text-[12px] font-semibold', ruleClass)}>
        {opp.rule_tag}
      </div>

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

/** 종합 스코어 원형 ring (SVG stroke-dasharray) — Toss App "내 신용 점수" 패턴 */
function CircularScore({ score }: { score: number }) {
  const radius = 24;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference * (1 - Math.max(0, Math.min(100, score)) / 100);
  const { bar } = scoreLevel(score);
  // stroke 컬러를 Tailwind 토큰으로 매핑 (currentColor 활용)
  const strokeClass = bar.replace('bg-', 'text-');
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

function YoyMetricBox({ metric }: { metric?: { label: string; value: string; sub?: string } }) {
  if (!metric) return <div />;
  const yoy = parsePercent(metric.value);
  const sub =
    yoy >= 15 ? '큰 폭 성장'
      : yoy >= 1 ? '성장'
        : yoy >= -1 ? '전년 동수준'
          : '역성장';
  // Linear Clip ±20% → 0~100 정규화 (BE sales_service.normalize_yoy 와 동일)
  const normalizedScore = Math.max(0, Math.min(100, ((yoy + 20) / 40) * 100));
  return <MetricBox label="전년 대비" value={metric.value} sub={sub} normalizedScore={normalizedScore} />;
}

function ImpactMetricBox({ metric }: { metric?: { label: string; value: string; sub?: string } }) {
  if (!metric) return <div />;
  const impact = parsePercent(metric.value);
  const sub = impact > 1 ? '기회' : impact >= -1 ? '중립' : '주의';
  // BE market_impact_score: >+1% 70 / -1~+1% 50 / <-1% 30
  const normalizedScore = impact > 1 ? 70 : impact >= -1 ? 50 : 30;
  return <MetricBox label="시황 영향" value={metric.value} sub={sub} normalizedScore={normalizedScore} />;
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
