'use client';

import { MessageSquare, Shield, CheckCheck, Quote } from 'lucide-react';
import { Card, CardTitle, CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import type { Strategy } from '@/types';

/**
 * 권장 대응 전략 (PRD 0514).
 *  - strategy_summary (톤 명시)
 *  - recommended_actions Top 3 (행동 동사로 시작)
 *  - negotiation_points Top 3 (판매담당자 멘트형)
 */
interface StrategyCardProps {
  strategy: Strategy | null;
  isLoading?: boolean;
}

export function StrategyCard({ strategy, isLoading }: StrategyCardProps) {
  return (
    <Card>
      <CardTitle>
        <MessageSquare className="h-5 w-5 text-toss-blue" />
        권장 대응 전략 <CardSubtitle>(무엇을 할 것인가?)</CardSubtitle>
      </CardTitle>

      {isLoading ? (
        <div className="mt-4 space-y-3">
          <Skeleton className="h-24" />
          <Skeleton className="h-32" />
          <Skeleton className="h-32" />
        </div>
      ) : !strategy ? (
        <EmptyState icon="💡" title="전략 생성 중" description="대시보드 응답을 받으면 표시됩니다." />
      ) : (
        <div className="mt-4 space-y-3">
          <StratPanel icon={<Shield className="h-4 w-4 text-gray-700" />} label="전략 요약">
            <p className="whitespace-pre-line text-[13px] font-medium leading-relaxed tracking-tight text-gray-700">
              {strategy.strategy_summary}
            </p>
          </StratPanel>

          <StratPanel icon={<CheckCheck className="h-4 w-4 text-success" />} label="추천 행동 Top 3">
            <ol className="ml-5 list-decimal space-y-1.5 text-[13px] font-medium leading-relaxed tracking-tight text-gray-700">
              {strategy.recommended_actions.map((action, idx) => (
                <li key={idx}>{action}</li>
              ))}
            </ol>
          </StratPanel>

          <StratPanel icon={<Quote className="h-4 w-4 text-toss-blue" />} label="협상 포인트 Top 3">
            <ul className="space-y-2 text-[13px] font-medium leading-relaxed tracking-tight text-gray-700">
              {strategy.negotiation_points.map((p, idx) => (
                <li
                  key={idx}
                  className="rounded-lg bg-toss-blue-light px-3.5 py-2.5 text-[12.5px] font-semibold leading-snug text-toss-blue"
                >
                  <span aria-hidden>❝ </span>
                  {p}
                  <span aria-hidden> ❞</span>
                </li>
              ))}
            </ul>
          </StratPanel>
        </div>
      )}
    </Card>
  );
}

interface StratPanelProps {
  icon: React.ReactNode;
  label: string;
  children: React.ReactNode;
}

function StratPanel({ icon, label, children }: StratPanelProps) {
  return (
    <div className="rounded-2xl bg-gray-100 p-[18px]">
      <div className="mb-3 flex items-center gap-1.5 text-sm font-bold tracking-tight text-gray-900">
        {icon}
        {label}
      </div>
      {children}
    </div>
  );
}
