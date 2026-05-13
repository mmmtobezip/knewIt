'use client';

import { TriangleAlert } from 'lucide-react';
import { Card, CardTitle, CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import { useSelectionStore } from '@/stores/selection-store';
import { useTriggerEvent, useAnalysis } from '@/lib/api/queries/dashboard';
import { Button } from '@/components/ui/button';

/**
 * AI 진단 카드 (AREA-MAIN-08)
 *
 * - DIA-02 WHAT: 빨강 배경 (#FEF1F2), 단문
 * - DIA-03 WHY: 노랑 배경 (#FFF8E5), 불릿 리스트
 * - DIA-04 IMPACT: 초록 배경 (#E8FAF3), 불릿 리스트
 *
 * 데이터 소스: analysis_result (LLM 생성)
 */
export function AiDiagnosis() {
  const { productCode } = useSelectionStore();
  const triggerQuery = useTriggerEvent(productCode, new Date().toISOString().slice(0, 10));
  const analysisQuery = useAnalysis(triggerQuery.data?.event_id ?? null);

  return (
    <Card>
      <CardTitle>
        <TriangleAlert className="h-5 w-5 text-danger" />
        AI 진단 <CardSubtitle>(무슨 일이 일어나고 있는가?)</CardSubtitle>
      </CardTitle>

      {analysisQuery.isLoading ? (
        <div className="mt-4 grid grid-cols-3 gap-3">
          <Skeleton className="h-32" />
          <Skeleton className="h-32" />
          <Skeleton className="h-32" />
        </div>
      ) : analysisQuery.isError ? (
        <EmptyState
          icon="⚠️"
          title="분석 데이터를 불러오지 못했습니다."
          action={
            <Button variant="secondary" size="sm" onClick={() => analysisQuery.refetch()}>
              다시 시도
            </Button>
          }
        />
      ) : !analysisQuery.data ? (
        <EmptyState icon="🤖" title="분석 데이터 없음" description="trigger_event 발생 시 표시됩니다." />
      ) : (
        <div className="mt-4 grid grid-cols-3 gap-3">
          <DiagCard label="WHAT" color="text-danger" bgClass="bg-diag-what">
            <p className="whitespace-pre-line text-[13px] font-medium leading-relaxed tracking-tight text-gray-800">
              {analysisQuery.data.what}
            </p>
          </DiagCard>

          <DiagCard label="WHY" color="text-[#D97706]" bgClass="bg-diag-why">
            <ul className="list-none space-y-1.5">
              {analysisQuery.data.why.map((item, idx) => (
                <li
                  key={idx}
                  className="relative pl-3 text-[13px] font-medium leading-relaxed tracking-tight text-gray-800 before:absolute before:left-0 before:text-gray-500 before:content-['•']"
                >
                  {item}
                </li>
              ))}
            </ul>
          </DiagCard>

          <DiagCard label="IMPACT" color="text-[#00A878]" bgClass="bg-diag-impact">
            <ul className="list-none space-y-1.5">
              {analysisQuery.data.impact.map((item, idx) => (
                <li
                  key={idx}
                  className="relative pl-3 text-[13px] font-medium leading-relaxed tracking-tight text-gray-800 before:absolute before:left-0 before:text-gray-500 before:content-['•']"
                >
                  {item}
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
}

function DiagCard({ label, color, bgClass, children }: DiagCardProps) {
  return (
    <div className={`rounded-2xl p-[18px] ${bgClass}`}>
      <div className={`mb-2.5 text-xs font-extrabold tracking-wide ${color}`}>{label}</div>
      {children}
    </div>
  );
}
