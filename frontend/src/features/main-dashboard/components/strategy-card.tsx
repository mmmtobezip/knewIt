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
    <Card>
      <CardTitle>
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
          <StratPanel icon={<CheckCheck className="h-4 w-4 text-success" />} label="추천 행동 Top 3">
            <ol className="space-y-2.5">
              {strategy.recommended_actions.map((action, idx) => (
                <li
                  key={idx}
                  className="flex items-center gap-3 rounded-xl bg-white p-3 shadow-toss transition-shadow hover:shadow-toss-md"
                >
                  <div
                    className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-toss-blue text-base font-extrabold text-white"
                    aria-hidden
                  >
                    {idx + 1}
                  </div>
                  <p className="text-[14px] font-semibold leading-snug tracking-tight text-gray-800">
                    {action}
                  </p>
                </li>
              ))}
            </ol>
          </StratPanel>

          <StratPanel icon={<Quote className="h-4 w-4 text-toss-blue" />} label="협상 시 활용하는 추천 멘트">
            <ul className="space-y-2.5">
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
}

function StratPanel({ icon, label, children }: StratPanelProps) {
  return (
    <div className="rounded-2xl bg-gray-100 p-[18px]">
      <div className="mb-3 flex items-center gap-1.5 text-[14px] font-semibold tracking-tight text-gray-900">
        {icon}
        {label}
      </div>
      {children}
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
