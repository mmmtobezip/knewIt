'use client';

import { TriangleAlert } from 'lucide-react';
import { Card, CardTitle, CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import type { Interpretation } from '@/types';
import { cn } from '@/shared/utils/cn';

/**
 * AI 진단 (PRD 0514) — WHAT / WHY / IMPACT.
 *
 * impact 는 객체 배열 ({risk_factor, direction, reason}).
 *  - 증폭: 빨강 / 완화: 파랑 / 중립: 회색
 */
interface AiDiagnosisProps {
  interpretation: Interpretation | null;
  isLoading?: boolean;
}

const DIRECTION_COLORS: Record<string, string> = {
  증폭: 'bg-red-50 text-red-700 border-red-200',
  완화: 'bg-blue-50 text-blue-700 border-blue-200',
  중립: 'bg-gray-50 text-gray-700 border-gray-200',
};

export function AiDiagnosis({ interpretation, isLoading }: AiDiagnosisProps) {
  return (
    <Card className="flex flex-col">
      <CardTitle>
        <TriangleAlert className="h-5 w-5 text-danger" />
        AI 진단 <CardSubtitle>(무슨 일이 일어나고 있는가?)</CardSubtitle>
      </CardTitle>

      {isLoading ? (
        <div className="mt-4 flex flex-1 flex-col gap-3">
          <Skeleton className="flex-1" />
          <Skeleton className="flex-1" />
          <Skeleton className="flex-1" />
        </div>
      ) : !interpretation ? (
        <div className="flex flex-1 items-center">
          <EmptyState icon="🤖" title="분석 데이터 없음" description="대시보드 응답을 받으면 표시됩니다." />
        </div>
      ) : (
        <div className="mt-4 flex flex-1 flex-col gap-3">
          <DiagCard label="WHAT" color="text-danger" bgClass="bg-diag-what">
            <p className="text-[13px] font-medium leading-relaxed tracking-tight text-gray-800">
              {interpretation.what}
            </p>
          </DiagCard>

          <DiagCard label="WHY" color="text-[#D97706]" bgClass="bg-diag-why">
            <p className="whitespace-pre-line text-[13px] font-medium leading-relaxed tracking-tight text-gray-800">
              {interpretation.why}
            </p>
          </DiagCard>

          <DiagCard label="IMPACT" color="text-[#00A878]" bgClass="bg-diag-impact" stretch>
            <ul className="space-y-2">
              {interpretation.impact.map((item, idx) => (
                <li key={idx} className="text-[13px] leading-relaxed text-gray-800">
                  <div className="mb-1 flex items-center gap-2">
                    <span className="font-semibold text-gray-900">{item.risk_factor}</span>
                    <span
                      className={cn(
                        'rounded-full border px-2 py-0.5 text-[11px] font-bold',
                        DIRECTION_COLORS[item.direction] ?? DIRECTION_COLORS['중립'],
                      )}
                    >
                      {item.direction}
                    </span>
                  </div>
                  <div className="text-[12px] font-medium text-gray-700">{item.reason}</div>
                </li>
              ))}
            </ul>
          </DiagCard>
        </div>
      )}
    </Card>
  );
}

interface DiagCardProps {
  label: string;
  color: string;
  bgClass: string;
  children: React.ReactNode;
  /** true 면 부모 flex-col 안에서 남는 공간을 모두 차지. */
  stretch?: boolean;
}

function DiagCard({ label, color, bgClass, children, stretch }: DiagCardProps) {
  return (
    <div className={cn('rounded-2xl p-[18px]', bgClass, stretch && 'flex-1')}>
      <div className={`mb-2.5 text-xs font-extrabold tracking-wide ${color}`}>{label}</div>
      {children}
    </div>
  );
}
