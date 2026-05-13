'use client';

import { MessageSquare, Shield, CheckCheck, Quote } from 'lucide-react';
import { Card, CardTitle, CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import { useSelectionStore } from '@/stores/selection-store';
import { useStrategy } from '@/lib/api/queries/dashboard';

/**
 * 권장 대응 전략 카드 (AREA-MAIN-09)
 *
 * - STR-02 전략 요약: 회색 배경, 🛡️
 * - STR-03 추천 행동: 번호 리스트, ✅
 * - STR-04 협상 포인트 + STR-05 인용 박스 (Toss Blue Bg, ❝❞)
 */
export function StrategyCard() {
  const { customerId } = useSelectionStore();
  const strategyQuery = useStrategy(customerId);

  return (
    <Card>
      <CardTitle>
        <MessageSquare className="h-5 w-5 text-toss-blue" />
        권장 대응 전략 <CardSubtitle>(무엇을 할 것인가?)</CardSubtitle>
      </CardTitle>

      {strategyQuery.isLoading ? (
        <div className="mt-4 grid grid-cols-3 gap-3">
          <Skeleton className="h-44" />
          <Skeleton className="h-44" />
          <Skeleton className="h-44" />
        </div>
      ) : !strategyQuery.data ? (
        <EmptyState icon="💡" title="전략 생성 중" description="trigger_event 발생 시 표시됩니다." />
      ) : (
        <div className="mt-4 grid grid-cols-3 gap-3">
          {/* 전략 요약 */}
          <StratPanel
            icon={<Shield className="h-4 w-4 text-gray-700" />}
            label="전략 요약"
          >
            <p className="whitespace-pre-line text-[13px] font-medium leading-relaxed tracking-tight text-gray-700">
              {strategyQuery.data.summary}
            </p>
          </StratPanel>

          {/* 추천 행동 */}
          <StratPanel
            icon={<CheckCheck className="h-4 w-4 text-success" />}
            label="추천 행동"
          >
            <ol className="ml-5 list-decimal space-y-1.5 text-[13px] font-medium leading-relaxed tracking-tight text-gray-700">
              {strategyQuery.data.actions.map((action, idx) => (
                <li key={idx}>{action}</li>
              ))}
            </ol>
          </StratPanel>

          {/* 협상 포인트 + 인용 */}
          <StratPanel
            icon={<Quote className="h-4 w-4 text-toss-blue" />}
            label="협상 포인트"
          >
            <p className="whitespace-pre-line text-[13px] font-medium leading-relaxed tracking-tight text-gray-700">
              {strategyQuery.data.negotiation_point}
            </p>
            <div className="mt-2.5 rounded-lg bg-toss-blue-light px-3.5 py-3 text-[13px] font-semibold leading-snug tracking-tight text-toss-blue">
              <span aria-hidden>❝ </span>
              {strategyQuery.data.quote}
              <span aria-hidden> ❞</span>
            </div>
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
