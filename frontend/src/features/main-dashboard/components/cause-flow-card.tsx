'use client';

import { motion } from 'framer-motion';
import { Card, CardTitle, CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import { useSelectionStore } from '@/stores/selection-store';
import { useTriggerEvent, useCausalChain } from '@/lib/api/queries/dashboard';

/**
 * 변동 원인 플로우 카드 (AREA-MAIN-06)
 *
 * - FLW-01: 카드 타이틀
 * - FLW-02: 플로우 스텝 (최대 5단계, causal_chain.chain)
 * - FLW-03: 핵심 해석 (Toss Blue 박스)
 *
 * 스텝 카드:
 * - 아이콘(이모지) + 텍스트 + ▼ 화살표
 * - 카드 사이: ▶ (가로 화살표)
 */

const STEP_ICONS = ['🏭', '📉', '🚢', '📊', '⚙️'];

export function CauseFlowCard() {
  const { productCode } = useSelectionStore();
  const triggerQuery = useTriggerEvent(productCode, new Date().toISOString().slice(0, 10));
  const chainQuery = useCausalChain(triggerQuery.data?.event_id ?? null);

  return (
    <Card>
      <CardTitle>
        변동 발생 원인 플로우 <CardSubtitle>(순차 원인 분석)</CardSubtitle>
      </CardTitle>

      {chainQuery.isLoading ? (
        <FlowSkeleton />
      ) : !chainQuery.data ? (
        <EmptyState icon="🔍" title="분석 데이터 준비 중" description="trigger_event 발생 시 표시됩니다." />
      ) : (
        <>
          {/* 플로우 스텝 그리드 */}
          <div
            className="mb-[18px] grid gap-2.5"
            style={{ gridTemplateColumns: `repeat(${Math.min(chainQuery.data.chain.length, 4)}, 1fr)` }}
          >
            {chainQuery.data.chain.slice(0, 4).map((step, idx) => (
              <motion.div
                key={idx}
                initial={{ opacity: 0, x: -8 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: idx * 0.08 }}
                className="relative rounded-xl bg-gray-100 p-4 px-2.5 text-center"
              >
                <div className="mb-2 text-[26px]" aria-hidden>
                  {STEP_ICONS[idx] ?? '📌'}
                </div>
                <div className="mb-1.5 text-xs font-semibold leading-snug tracking-tight text-gray-800">
                  {step}
                </div>
                <div className="text-sm text-danger" aria-hidden>
                  ▼
                </div>
                {idx < Math.min(chainQuery.data.chain.length, 4) - 1 && (
                  <div className="absolute -right-2.5 top-1/2 z-10 -translate-y-1/2 text-xs text-gray-400" aria-hidden>
                    ▶
                  </div>
                )}
              </motion.div>
            ))}
          </div>

          {/* 핵심 해석 */}
          <div className="rounded-xl bg-toss-blue-bg p-4 px-5">
            <div className="mb-1.5 text-sm font-bold text-toss-blue">핵심 해석</div>
            <p className="text-sm font-medium leading-relaxed tracking-tight text-gray-800">
              {chainQuery.data.interpretation}
            </p>
          </div>
        </>
      )}
    </Card>
  );
}

function FlowSkeleton() {
  return (
    <>
      <div className="mb-[18px] grid grid-cols-4 gap-2.5">
        {[0, 1, 2, 3].map((i) => (
          <Skeleton key={i} className="h-[100px]" />
        ))}
      </div>
      <Skeleton className="h-20 w-full" />
    </>
  );
}
