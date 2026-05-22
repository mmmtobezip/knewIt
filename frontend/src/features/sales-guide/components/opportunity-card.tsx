'use client';

import { useState } from 'react';
import { Card, CardTitle, CardSubtitle } from '@/components/ui/card';
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

const PROPOSAL_SCRIPTS: Record<string, string> = {
  '한화오션': `이번 주 내 방문 일정을 확정하고 4분기 추가 물량 견적서를 미리 준비해 두세요. 달성률 88%로 목표 초과 임박 상태이므로 현재 모멘텀을 활용해 추가 물량 선점 제안을 최우선 과제로 설정하십시오. 중국산 대비 후판 인장강도·두께 균일성 데이터를 지참하여 품질 차별화 포인트로 제시하고, 시황 변동성이 낮은 현재가 장기 계약 전환 협상의 적기임을 강조하세요.`,

  '현대중공업': `4Q 발주 공백 방지를 위한 조기 발주 인센티브를 포함한 제안서를 이번 주 안에 발송하세요. LNG선 건조 일정에 연동한 납기 보장 패키지를 핵심 제안으로 내세우고, 선가 상승과 연동한 후판 공급 안정성을 데이터로 제시하십시오. 담당 구매팀에 미팅을 요청하고 최신 시황 보고서를 함께 공유해 신뢰 관계를 강화하세요.`,

  '삼성중공업': `LNG선 건조 재개 일정을 확인한 뒤 즉시 방문하여 사전 물량 확보를 제안하세요. 환율 헤지 연계 후판 구매 패키지를 주요 협상 카드로 활용하고, 경쟁사 대비 납기 단축이 가능한 구간을 구체적인 수치로 제시하십시오. 발주 지연이 이어질 경우를 대비해 소규모 긴급 발주를 선점하여 관계를 유지하는 전략이 이 시점에서 가장 효과적입니다.`,

  '포스코건설': `구매 담당자에게 즉시 연락하여 하반기 예산 집행 계획과 플랜트 신규 수주 일정을 파악하세요. 신규 수주 연계 후판 물량을 사전 협약 형태로 제안하고, 소규모 분할 발주 방식을 통해 초기 진입 장벽을 낮추는 것을 우선 목표로 하십시오. 분양 시장 위축 리스크를 고려하여 계약 조건에 발주 보증 조항 삽입을 반드시 권장합니다.`,

  '포스코인터내셔널': `이번 달 내 임원 레벨 미팅을 요청하고 환율 시나리오별 견적서를 사전에 준비해 두세요. USD/KRW 환율 안정 구간에 대량 발주를 유도하기 위한 인센티브 구조를 제안하고, 내부 승인 프로세스를 단축할 수 있는 조건부 계약 구조를 함께 제시하십시오. 글로벌 수요 회복 신호를 구체적인 수치 데이터로 제시하여 물량 확대 결정을 촉진하세요.`,
};

interface OpportunityCardProps {
  signal: MarketSignal | null;
  keyFeatures: KeyFeature[];
  gradeSummary: GradeSummary | null;
  opportunities: CustomerOpportunity[];
  isLoading?: boolean;
}

const CYCLE_TABS: { key: FeatureCycle; label: string }[] = [
  { key: 'DAILY', label: 'DAILY' },
  { key: 'WEEKLY', label: 'WEEKLY' },
  { key: 'MONTHLY', label: 'MONTHLY' },
];

const DIRECTION_ICON: Record<string, string> = { UP: '↑', DOWN: '↓', FLAT: '—' };
const DIRECTION_CLASS: Record<string, string> = {
  UP: 'text-danger',
  DOWN: 'text-toss-blue',
  FLAT: 'text-gray-400',
};
const GRADE_CLASS: Record<string, string> = {
  A: 'bg-emerald-50 text-success',
  'A-': 'bg-emerald-50 text-success',
  'B+': 'bg-toss-blue-light text-toss-blue',
  B: 'bg-toss-blue-light text-toss-blue',
  C: 'bg-amber-50 text-warning',
  D: 'bg-red-50 text-danger',
};
const RULE_TAG_CLASS: Record<RuleTagType, string> = {
  info: 'bg-toss-blue-bg text-toss-blue',
  warning: 'bg-amber-50 text-warning',
  danger: 'bg-red-50 text-danger',
};

export function OpportunityCard({
  signal,
  keyFeatures,
  gradeSummary,
  opportunities,
  isLoading,
}: OpportunityCardProps) {
  const [cycle, setCycle] = useState<FeatureCycle>('DAILY');
  const filtered = keyFeatures.filter((f) => f.cycle === cycle);

  return (
    <Card>
      <CardTitle className="mb-1 text-[15px]">
        고객사 현황 &amp; 기회 탐지
        <CardSubtitle>시황 + 실적 통합 분석</CardSubtitle>
      </CardTitle>

      {isLoading ? (
        <div className="space-y-4">
          <Skeleton className="h-20" />
          <Skeleton className="h-40" />
          <Skeleton className="h-60" />
        </div>
      ) : (
        <div className="mt-4 space-y-5">
          {/* ── Row 1: 시황 신호 + 등급 요약 (55 : 15 : 15 : 15) ── */}
          <div className="grid grid-cols-[55fr_15fr_15fr_15fr] items-stretch gap-2">
            {signal ? (
              <div className="flex items-center justify-between rounded-xl bg-gray-50 px-4 py-3">
                <div>
                  <div className="mt-0.5 text-[17px] font-extrabold text-gray-800">{signal.status}</div>
                  <div className="mt-0.5 text-[11px] text-gray-500">{signal.description}</div>
                </div>
                <div className="text-right">
                  <div className="text-[24px] font-extrabold text-warning">
                    {signal.score >= 0 ? '+' : ''}{signal.score.toFixed(1)}%
                  </div>
                  <div className="text-[10px] text-gray-400">시황 스코어</div>
                </div>
              </div>
            ) : <div />}
            {gradeSummary ? (
              <>
                <GradeBox label="A등급 · 기회" count={gradeSummary.grade_a} colorClass="text-toss-blue" />
                <GradeBox label="B등급 · 관리" count={gradeSummary.grade_b} colorClass="text-warning" />
                <GradeBox label="C등급 · 리스크" count={gradeSummary.grade_c} colorClass="text-danger" />
              </>
            ) : <><div /><div /><div /></>}
          </div>

          {/* ── KEY_FEATURES 전체 폭 ── */}
          <div>
            <SectionLabel>후판 KEY_FEATURES 변화율</SectionLabel>
            <div className="mb-2 flex gap-1.5">
              {CYCLE_TABS.map((tab) => (
                <button
                  key={tab.key}
                  type="button"
                  onClick={() => setCycle(tab.key)}
                  className={cn(
                    'rounded-full px-3 py-1 text-[11px] font-bold transition-colors',
                    cycle === tab.key
                      ? 'bg-toss-blue text-white'
                      : 'bg-gray-100 text-gray-500 hover:bg-gray-200',
                  )}
                >
                  {tab.label}
                </button>
              ))}
            </div>
            <table className="w-full border-collapse text-[11px]">
              <tbody>
                {filtered.map((f) => (
                  <tr key={`${f.cycle}-${f.rank}`} className="border-t border-gray-50">
                    <td className="w-5 py-1.5 pr-1 text-gray-400">{f.rank}</td>
                    <td className="py-1.5 pr-2 font-medium text-gray-700">{f.name}</td>
                    <td className="w-10 py-1.5 pr-1 text-gray-400">{f.weight}%</td>
                    <td className={cn('w-5 py-1.5 font-bold', DIRECTION_CLASS[f.direction])}>
                      {DIRECTION_ICON[f.direction]}
                    </td>
                    <td className="py-1.5 text-right">
                      <span className={cn('font-bold', DIRECTION_CLASS[f.direction])}>{f.change}</span>
                    </td>
                  </tr>
                ))}
                {filtered.length === 0 && (
                  <tr>
                    <td colSpan={5} className="py-3 text-center text-[11px] text-gray-400">
                      해당 주기 데이터 없음
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>

          {/* ── 고객사별 상세 ── */}
          <div>
            <SectionLabel>고객사별 상세</SectionLabel>
            <div className="space-y-2.5">
              {opportunities.map((opp) => (
                <CustomerCard key={opp.customer_id} opp={opp} />
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
    <div className="mb-2 text-[11px] font-bold uppercase tracking-wide text-gray-400">
      {children}
    </div>
  );
}

function GradeBox({ label, count, colorClass }: { label: string; count: number; colorClass: string }) {
  return (
    <div className="rounded-xl bg-gray-50 py-3 text-center">
      <div className={cn('text-[28px] font-extrabold leading-none', colorClass)}>{count}</div>
      <div className="mt-1.5 text-[10px] text-gray-500">{label}</div>
    </div>
  );
}

function CustomerCard({ opp }: { opp: CustomerOpportunity }) {
  const [proposalState, setProposalState] = useState<'idle' | 'loading' | 'done'>('idle');
  const [proposalText, setProposalText] = useState('');
  const [visible, setVisible] = useState(true);

  const gradeClass = GRADE_CLASS[opp.grade] ?? GRADE_CLASS['B'];
  const ruleClass = RULE_TAG_CLASS[opp.rule_tag_type];
  const scoreTextClass = (gradeClass ?? '').split(' ')[1];

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
    <div className="rounded-2xl border border-gray-100 p-4">
      {/* 헤더 */}
      <div className="mb-3 flex items-start justify-between">
        <div className="flex items-center gap-3">
          <div className={cn('flex h-10 w-10 shrink-0 items-center justify-center rounded-xl text-[13px] font-extrabold', gradeClass)}>
            {opp.grade}
          </div>
          <div>
            <div className="text-[15px] font-bold text-gray-900">{opp.customer_name}</div>
            <div className="text-[11px] text-gray-400">{opp.industry} · 달성률 {Math.round(opp.achievement_rate * 100)}%</div>
          </div>
        </div>
        <div className="text-right">
          <div className={cn('text-[22px] font-extrabold', scoreTextClass)}>{opp.score}</div>
          <div className="text-[9px] text-gray-400">종합 스코어</div>
        </div>
      </div>

      {/* 스코어 바 */}
      <div className="mb-3 h-[4px] overflow-hidden rounded-full bg-gray-100">
        <div className="h-full rounded-full bg-toss-blue transition-all" style={{ width: `${opp.score}%` }} />
      </div>

      {/* 메트릭 3개 */}
      <div className="mb-3 grid grid-cols-3 gap-2">
        {opp.metrics.map((m, i) => (
          <div key={i} className="rounded-xl bg-gray-50 px-3 py-2">
            <div className="text-[10px] text-gray-400">{m.label}</div>
            <div className="text-[15px] font-extrabold text-gray-900">{m.value}</div>
            {m.sub && <div className="text-[10px] text-gray-400">{m.sub}</div>}
          </div>
        ))}
      </div>

      {/* 룰 태그 */}
      <div className={cn('mb-3 rounded-lg px-3 py-2 text-[12px] font-semibold', ruleClass)}>
        {opp.rule_tag}
      </div>

      {/* 민감 이슈 */}
      {opp.sensitivity_tags.length > 0 && (
        <div className="mb-2">
          <div className="mb-1 text-[10px] text-gray-400">민감 이슈</div>
          <div className="flex flex-wrap gap-1">
            {opp.sensitivity_tags.map((t) => (
              <span key={t} className="rounded-md bg-gray-100 px-2 py-0.5 text-[10px] font-medium text-gray-600">{t}</span>
            ))}
          </div>
        </div>
      )}

      {/* 리스크 요인 */}
      {opp.risk_tags.length > 0 && (
        <div className="mb-3">
          <div className="mb-1 text-[10px] text-gray-400">리스크 요인</div>
          <div className="flex flex-wrap gap-1">
            {opp.risk_tags.map((t) => (
              <span key={t} className="rounded-md bg-red-50 px-2 py-0.5 text-[10px] font-medium text-danger">{t}</span>
            ))}
          </div>
        </div>
      )}

      {/* 구분선 */}
      <div className="mb-3 h-px bg-gray-100" />

      {/* 제안 시작 / 토글 버튼 */}
      <div className="flex items-center gap-3">
        {proposalState === 'idle' && (
          <>
            <button
              type="button"
              onClick={handlePropose}
              className="shrink-0 rounded-xl bg-gray-900 px-4 py-2 text-[13px] font-bold text-white transition-all hover:bg-gray-700"
            >
              제안 시작
            </button>
            <span className="text-[12px] text-gray-400">AI가 행동 지침을 생성합니다</span>
          </>
        )}
        {proposalState === 'loading' && (
          <>
            <button disabled className="shrink-0 cursor-not-allowed rounded-xl bg-gray-200 px-4 py-2 text-[13px] font-bold text-gray-400">
              생성 중...
            </button>
            <span className="animate-pulse text-[12px] text-toss-blue">분석 중입니다…</span>
          </>
        )}
        {proposalState === 'done' && (
          <button
            type="button"
            onClick={() => setVisible((v) => !v)}
            className="shrink-0 rounded-xl border border-gray-200 bg-white px-4 py-2 text-[13px] font-bold text-gray-700 transition-all hover:bg-gray-50"
          >
            {visible ? '답변 숨기기' : '제안 다시 보기'}
          </button>
        )}
      </div>

      {/* AI 응답 */}
      {proposalState === 'done' && visible && (
        <div className="mt-3 rounded-xl border border-toss-blue-light bg-toss-blue-bg px-4 py-3">
          <div className="mb-1.5 text-[10px] font-bold text-toss-blue">AI 행동 지침</div>
          <pre className="whitespace-pre-wrap font-sans text-[12px] leading-relaxed text-gray-700">
            {proposalText}
          </pre>
        </div>
      )}
    </div>
  );
}
