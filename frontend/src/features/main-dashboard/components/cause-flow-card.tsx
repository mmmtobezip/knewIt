'use client';

import { motion } from 'framer-motion';
import { Card, CardTitle, CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import type { CauseFlowStep } from '@/types';
import { NewsSlider } from './news-slider';

/**
 * 차트2 — 인과 흐름도 (PRD 0514, 최대 5단계) + 근거 데이터 통합.
 *
 * 한 카드 안에:
 *  - 상단: 5단계 인과 사슬
 *  - 하단(구분선 위): NewsSlider (embedded 모드) — 인과 evidence 평탄화 슬라이드
 */
interface CauseFlowCardProps {
  flow: CauseFlowStep[];
  isLoading?: boolean;
}

export function CauseFlowCard({ flow, isLoading }: CauseFlowCardProps) {
  const hasFlow = flow.length > 0;

  return (
    <Card className="flex flex-col">
      <CardTitle>
        변동 발생 원인 플로우 <CardSubtitle>(최대 5단계 인과 사슬)</CardSubtitle>
      </CardTitle>

      {isLoading ? (
        <FlowSkeleton />
      ) : !hasFlow ? (
        <div className="flex flex-1 items-center">
          <EmptyState icon="🔍" title="인과 분석 준비 중" description="LLM 응답을 받으면 표시됩니다." />
        </div>
      ) : (
        <div className="flex flex-1 flex-col">
          <div
            className="grid flex-1 gap-2.5"
            style={{ gridTemplateColumns: `repeat(${Math.min(flow.length, 5)}, 1fr)` }}
          >
            {flow.slice(0, 5).map((step, idx) => (
              <motion.div
                key={step.step}
                initial={{ opacity: 0, x: -8 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: idx * 0.08 }}
                className="flex flex-col items-center"
              >
                <span className="flex w-full shrink-0 items-center justify-center rounded-t-lg bg-toss-blue px-2.5 py-1 text-[11px] font-extrabold tracking-wider text-white">
                  STEP {idx + 1}
                </span>
                <div className="relative flex w-full flex-1 items-center justify-center rounded-b-lg bg-gray-100 px-3 py-4 text-center">
                  <p className="text-[13px] font-semibold leading-snug tracking-tight text-gray-800">
                    {step.node}
                  </p>
                  {idx < Math.min(flow.length, 5) - 1 && (
                    <div
                      className="absolute -right-2.5 top-1/2 z-10 -translate-y-1/2 text-sm font-bold text-toss-blue"
                      aria-hidden
                    >
                      ▶
                    </div>
                  )}
                </div>
              </motion.div>
            ))}
          </div>

          <div className="mt-5 border-t border-gray-100 pt-4">
            <NewsSlider flow={flow} embedded />
          </div>
        </div>
      )}
    </Card>
  );
}

function FlowSkeleton() {
  return (
    <div className="mb-[18px] grid grid-cols-5 gap-2.5">
      {[0, 1, 2, 3, 4].map((i) => (
        <Skeleton key={i} className="h-[100px]" />
      ))}
    </div>
  );
}
