'use client';

import { useState } from 'react';
import { CheckCheck, Quote, Copy, Check } from 'lucide-react';
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
    <Card className="flex flex-col">
      <CardTitle>
        권장 대응 전략 <CardSubtitle>(무엇을 할 것인가?)</CardSubtitle>
      </CardTitle>

      {isLoading ? (
        <div className="mt-4 flex flex-1 flex-col gap-3">
          <Skeleton className="h-32" />
          <Skeleton className="flex-1" />
        </div>
      ) : !strategy ? (
        <div className="flex flex-1 items-center">
          <EmptyState icon="💡" title="전략 생성 중" description="대시보드 응답을 받으면 표시됩니다." />
        </div>
      ) : (
        <div className="mt-4 flex flex-1 flex-col gap-3">
          <StratPanel icon={<CheckCheck className="h-4 w-4 text-success" />} label="추천 행동 Top 3">
            <ol className="space-y-2">
              {strategy.recommended_actions.map((action, idx) => (
                <li
                  key={idx}
                  className="flex items-center gap-3 rounded-xl bg-white p-2.5 shadow-toss transition-shadow hover:shadow-toss-md"
                >
                  <div
                    className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-toss-blue text-sm font-extrabold text-white"
                    aria-hidden
                  >
                    {idx + 1}
                  </div>
                  <p className="text-[13.5px] font-semibold leading-snug tracking-tight text-gray-800">
                    {action}
                  </p>
                </li>
              ))}
            </ol>
          </StratPanel>

          <StratPanel
            icon={<Quote className="h-4 w-4 text-toss-blue" />}
            label="협상 시 활용하는 추천 멘트"
            stretch
          >
            <ul className="flex flex-1 flex-col gap-2">
              {strategy.negotiation_points.map((p, idx) => (
                <NegotiationPointCard key={idx} text={p} />
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
  /** true 면 부모 flex-col 안에서 남은 공간을 모두 차지 (마지막 panel 용). */
  stretch?: boolean;
}

function StratPanel({ icon, label, children, stretch }: StratPanelProps) {
  return (
    <div
      className={
        'flex flex-col rounded-2xl bg-gray-100 p-[18px]' + (stretch ? ' flex-1 min-h-0' : '')
      }
    >
      <div className="mb-2 flex items-center gap-1.5 text-[14px] font-semibold tracking-tight text-gray-900">
        {icon}
        {label}
      </div>
      {stretch ? <div className="flex flex-1 flex-col">{children}</div> : children}
    </div>
  );
}

interface NegotiationPointCardProps {
  text: string;
}

function NegotiationPointCard({ text }: NegotiationPointCardProps) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(text);
      setCopied(true);
      setTimeout(() => setCopied(false), 1800);
    } catch {
      // 클립보드 권한 없을 경우 무시
    }
  };

  return (
    <li className="relative rounded-2xl bg-white px-5 py-4 shadow-toss transition-shadow hover:shadow-toss-md">
      <span
        className="absolute left-3 top-1 select-none text-[34px] font-serif leading-none text-toss-blue/30"
        aria-hidden
      >
        ❝
      </span>

      <p className="pl-7 pr-9 text-[14px] font-semibold leading-relaxed tracking-tight text-gray-800">
        {text}
      </p>

      <button
        type="button"
        onClick={handleCopy}
        aria-label={copied ? '복사됨' : '멘트 복사'}
        title={copied ? '복사됨' : '멘트 복사'}
        className="absolute bottom-2 right-2 inline-flex h-7 w-7 items-center justify-center rounded-md text-gray-400 transition-colors hover:bg-gray-100 hover:text-toss-blue"
      >
        {copied ? (
          <Check className="h-3.5 w-3.5 text-success" />
        ) : (
          <Copy className="h-3.5 w-3.5" />
        )}
      </button>
    </li>
  );
}
