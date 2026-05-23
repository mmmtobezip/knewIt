'use client';

import { useMemo, useState } from 'react';
import { Skeleton } from '@/components/ui/skeleton';
import { cn } from '@/shared/utils/cn';
import type {
  CustomerOpportunity,
  FeatureCycle,
  GradeSummary,
  KeyFeature,
  MarketSignal,
  RuleTagType,
} from '@/types';
import { SectionCard, SectionHeader, SectionIcons } from './section-header';
import { CustomerSlider, CustomerSliderCard } from './customer-slider';

/**
 * Module 2 — 기회탐지
 *
 *  - 시황 신호 + A/B/C 등급 (55:15:15:15)
 *  - KEY_FEATURES 변화율 (전체 폭, 주기 탭 + 영향도 막대)
 *  - 고객사별 상세 슬라이더 (3장씩 표시 + 좌/우 버튼)
 */

const PROPOSAL_SCRIPTS: Record<string, string> = {
  '한화오션': `이번 주 내 방문 일정을 확정하고 4분기 추가 물량 견적서를 미리 준비해 두세요. 달성률 88%로 목표 초과 임박 상태이므로 현재 모멘텀을 활용해 추가 물량 선점 제안을 최우선 과제로 설정하십시오. 중국산 대비 후판 인장강도·두께 균일성 데이터를 지참하여 품질 차별화 포인트로 제시하고, 시황 변동성이 낮은 현재가 장기 계약 전환 협상의 적기임을 강조하세요.`,
  '현대중공업': `4Q 발주 공백 방지를 위한 조기 발주 인센티브를 포함한 제안서를 이번 주 안에 발송하세요. LNG선 건조 일정에 연동한 납기 보장 패키지를 핵심 제안으로 내세우고, 선가 상승과 연동한 후판 공급 안정성을 데이터로 제시하십시오. 담당 구매팀에 미팅을 요청하고 최신 시황 보고서를 함께 공유해 신뢰 관계를 강화하세요.`,
  '삼성중공업': `LNG선 건조 재개 일정을 확인한 뒤 즉시 방문하여 사전 물량 확보를 제안하세요. 환율 헤지 연계 후판 구매 패키지를 주요 협상 카드로 활용하고, 경쟁사 대비 납기 단축이 가능한 구간을 구체적인 수치로 제시하십시오. 발주 지연이 이어질 경우를 대비해 소규모 긴급 발주를 선점하여 관계를 유지하는 전략이 이 시점에서 가장 효과적입니다.`,
  '포스코건설': `구매 담당자에게 즉시 연락하여 하반기 예산 집행 계획과 플랜트 신규 수주 일정을 파악하세요. 신규 수주 연계 후판 물량을 사전 협약 형태로 제안하고, 소규모 분할 발주 방식을 통해 초기 진입 장벽을 낮추는 것을 우선 목표로 하십시오. 분양 시장 위축 리스크를 고려하여 계약 조건에 발주 보증 조항 삽입을 반드시 권장합니다.`,
  '포스코인터내셔널': `이번 달 내 임원 레벨 미팅을 요청하고 환율 시나리오별 견적서를 사전에 준비해 두세요. USD/KRW 환율 안정 구간에 대량 발주를 유도하기 위한 인센티브 구조를 제안하고, 내부 승인 프로세스를 단축할 수 있는 조건부 계약 구조를 함께 제시하십시오. 글로벌 수요 회복 신호를 구체적인 수치 데이터로 제시하여 물량 확대 결정을 촉진하세요.`,
};

const CYCLE_TABS: { key: FeatureCycle; label: string }[] = [
  { key: 'DAILY', label: 'DAILY' },
  { key: 'WEEKLY', label: 'WEEKLY' },
  { key: 'MONTHLY', label: 'MONTHLY' },
];

const DIR_ICON: Record<string, string> = { UP: '↑', DOWN: '↓', FLAT: '—' };
const DIR_TEXT: Record<string, string> = {
  UP: 'text-danger',
  DOWN: 'text-toss-blue',
  FLAT: 'text-gray-400',
};
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
  keyFeatures: KeyFeature[];
  gradeSummary: GradeSummary | null;
  opportunities: CustomerOpportunity[];
  isLoading?: boolean;
}

export function OpportunitySection({
  signal,
  keyFeatures,
  gradeSummary,
  opportunities,
  isLoading,
}: OpportunitySectionProps) {
  const [cycle, setCycle] = useState<FeatureCycle>('DAILY');
  const filtered = useMemo(() => keyFeatures.filter((f) => f.cycle === cycle), [keyFeatures, cycle]);

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
          <Skeleton className="h-40" />
          <Skeleton className="h-60" />
        </div>
      ) : (
        <div className="flex flex-col gap-6">
          {/* 시황 신호 + 등급 (55:15:15:15) */}
          <div className="grid grid-cols-[55fr_15fr_15fr_15fr] items-stretch gap-2.5">
            {signal ? (
              <div className="flex items-center justify-between rounded-xl bg-gray-100 px-5 py-4">
                <div>
                  <div className="text-[20px] font-extrabold tracking-tight text-gray-900">{signal.status}</div>
                  <div className="mt-0.5 text-[12px] text-gray-500">{signal.description}</div>
                </div>
                <div className="text-right">
                  <div className="text-[28px] font-extrabold tracking-tightest text-warning">
                    {signal.score >= 0 ? '+' : ''}{signal.score.toFixed(1)}%
                  </div>
                  <div className="text-[10px] text-gray-400">시황 스코어</div>
                </div>
              </div>
            ) : <div />}
            {gradeSummary ? (
              <>
                <GradeBox count={gradeSummary.grade_a} label="A등급" sub="기회" color="text-success" />
                <GradeBox count={gradeSummary.grade_b} label="B등급" sub="관리" color="text-warning" />
                <GradeBox count={gradeSummary.grade_c} label="C등급" sub="리스크" color="text-danger" />
              </>
            ) : <><div /><div /><div /></>}
          </div>

          {/* KEY_FEATURES 변화율 */}
          <div>
            <div className="mb-2.5 text-[11px] font-bold uppercase tracking-wide text-gray-400">
              후판 KEY_FEATURES 변화율
            </div>
            <div className="mb-3 flex gap-1.5">
              {CYCLE_TABS.map((t) => (
                <button
                  key={t.key}
                  type="button"
                  onClick={() => setCycle(t.key)}
                  className={cn(
                    'rounded-full px-3.5 py-1 text-[11px] font-bold transition-colors',
                    cycle === t.key ? 'bg-toss-blue text-white' : 'bg-gray-100 text-gray-500 hover:bg-gray-200',
                  )}
                >
                  {t.label}
                </button>
              ))}
            </div>
            <KeyFeaturesTable features={filtered} />
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
    <div className="flex flex-col items-center justify-center rounded-xl bg-gray-100 px-2 py-4">
      <div className={cn('text-[28px] font-extrabold leading-none', color)}>{count}</div>
      <div className="mt-2 text-center text-[10px] leading-tight text-gray-500">
        {label}
        <br />
        {sub}
      </div>
    </div>
  );
}

function KeyFeaturesTable({ features }: { features: KeyFeature[] }) {
  /* 가중치 막대 채움률: weight ÷ 최대 가중치(20%) × 100% */
  return (
    <table className="w-full table-fixed border-collapse text-[12px]">
      <tbody>
        {features.length === 0 ? (
          <tr>
            <td className="py-4 text-center text-[12px] text-gray-400">해당 주기 데이터 없음</td>
          </tr>
        ) : (
          features.map((f) => {
            const fillPct = Math.min((f.weight / 20) * 100, 100);
            return (
              <tr
                key={`${f.cycle}-${f.rank}`}
                className="border-t border-gray-100 first:border-t-0"
              >
                <td className="w-[32%] py-3 pl-1 pr-3.5">
                  <span className="mr-2 inline-block min-w-[14px] font-semibold text-gray-400">{f.rank}</span>
                  <span className="text-gray-700">{f.name}</span>
                </td>
                <td className="w-[28%] py-3 pr-3.5">
                  <div className="flex items-center gap-2.5">
                    <div className="h-[5px] flex-1 overflow-hidden rounded-full bg-gray-100">
                      <div className="h-full rounded-full bg-toss-blue" style={{ width: `${fillPct}%` }} />
                    </div>
                    <span className="min-w-[32px] text-right text-[11px] font-bold text-gray-700">{f.weight}%</span>
                  </div>
                </td>
                <td className={cn('w-[20%] py-3 pr-3.5 text-right font-bold', DIR_TEXT[f.direction])}>
                  {DIR_ICON[f.direction]}
                </td>
                <td className={cn('w-[20%] py-3 pr-3.5 text-center font-bold', DIR_TEXT[f.direction])}>
                  {f.change}
                </td>
              </tr>
            );
          })
        )}
      </tbody>
    </table>
  );
}

function OpportunityCustomerCard({ opp }: { opp: CustomerOpportunity }) {
  const [proposalState, setProposalState] = useState<'idle' | 'loading' | 'done'>('idle');
  const [proposalText, setProposalText] = useState('');
  const [visible, setVisible] = useState(true);

  const gradeClass = GRADE_CHIP[opp.grade] ?? GRADE_CHIP['B'];
  const ruleClass = RULE_TAG[opp.rule_tag_type];

  const handlePropose = () => {
    if (proposalState !== 'idle') return;
    setProposalState('loading');
    setTimeout(() => {
      setProposalText(PROPOSAL_SCRIPTS[opp.customer_name] ?? '해당 고객사에 대한 제안 스크립트를 준비 중입니다.');
      setProposalState('done');
      setVisible(true);
    }, 1400);
  };

  return (
    <div className="flex h-full flex-col rounded-2xl border-[1.5px] border-gray-100 p-5">
      {/* 헤더 */}
      <div className="mb-3 flex items-start justify-between">
        <div className="flex items-center gap-3">
          <div className={cn('flex h-11 w-11 shrink-0 items-center justify-center rounded-xl text-[15px] font-extrabold', gradeClass)}>
            {opp.grade}
          </div>
          <div>
            <div className="text-[16px] font-extrabold tracking-tight text-gray-900">{opp.customer_name}</div>
            <div className="mt-0.5 text-[12px] text-gray-400">
              {opp.industry} · 달성률 {Math.round(opp.achievement_rate * 100)}%
            </div>
          </div>
        </div>
        <div className="text-right">
          <div className="text-[24px] font-extrabold leading-none tracking-tightest text-gray-900">{opp.score}</div>
          <div className="mt-1 text-[10px] text-gray-400">종합 스코어</div>
        </div>
      </div>

      {/* 스코어 바 */}
      <div className="mb-4 h-[5px] overflow-hidden rounded-full bg-gray-100">
        <div className="h-full rounded-full bg-toss-blue" style={{ width: `${opp.score}%` }} />
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

      {/* 푸터: 제안 시작 / 답변 숨기기 — mt-auto로 항상 카드 하단에 고정 */}
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
    </div>
  );
}

/* ─────────────────────────────────────────────
 * 상태별 메트릭 박스 — 값은 검정, sub만 컬러
 * ───────────────────────────────────────────── */

function parsePercent(value: string): number {
  /* "91점" → 91, "+18%" → 18, "-3%" → -3, "+1.8%" → 1.8 */
  const m = value.match(/-?\d+(?:\.\d+)?/);
  return m ? parseFloat(m[0]) : 0;
}

function SpeedMetricBox({ metric }: { metric?: { label: string; value: string; sub?: string } }) {
  if (!metric) return <div />;
  const score = parsePercent(metric.value);
  const { sub, subColor } =
    score >= 90
      ? { sub: '달성 가속 중', subColor: 'text-toss-blue' }
      : score >= 70
        ? { sub: '달성 속도 정상', subColor: 'text-success' }
        : { sub: '달성 속도 둔화', subColor: 'text-danger' };
  return (
    <MetricBox label="달성 속도" value={metric.value} sub={sub} subColor={subColor} />
  );
}

function YoyMetricBox({ metric }: { metric?: { label: string; value: string; sub?: string } }) {
  if (!metric) return <div />;
  const yoy = parsePercent(metric.value);
  const { sub, subColor } =
    yoy >= 15
      ? { sub: '큰 폭 성장', subColor: 'text-toss-blue' }
      : yoy >= 1
        ? { sub: '성장', subColor: 'text-success' }
        : yoy >= -1
          ? { sub: '동수준', subColor: 'text-gray-700' }
          : { sub: '역성장', subColor: 'text-danger' };
  return (
    <MetricBox label="전년 대비" value={metric.value} sub={sub} subColor={subColor} />
  );
}

function ImpactMetricBox({ metric }: { metric?: { label: string; value: string; sub?: string } }) {
  if (!metric) return <div />;
  const impact = parsePercent(metric.value);
  const { sub, subColor } =
    impact > 1
      ? { sub: '기회', subColor: 'text-toss-blue' }
      : impact >= -1
        ? { sub: '중립', subColor: 'text-gray-700' }
        : { sub: '주의', subColor: 'text-danger' };
  return (
    <MetricBox label="시황 영향" value={metric.value} sub={sub} subColor={subColor} />
  );
}

function MetricBox({
  label,
  value,
  sub,
  subColor,
}: {
  label: string;
  value: string;
  sub: string;
  subColor: string;
}) {
  return (
    <div className="rounded-xl bg-gray-100 px-3.5 py-3">
      <div className="text-[11px] text-gray-400">{label}</div>
      <div className="mt-0.5 text-[16px] font-extrabold tracking-tight text-gray-900">{value}</div>
      <div className={cn('mt-1 text-[10px] font-bold', subColor)}>{sub}</div>
    </div>
  );
}
