import type { ReactNode } from 'react';
import { cn } from '@/shared/utils/cn';

interface EmptyStateProps {
  icon?: ReactNode;
  title: string;
  description?: string;
  action?: ReactNode;
  className?: string;
}

/**
 * 빈 상태 / 데이터 없음 표시
 *
 * main-ipo.md § 3-4 빈 상태 출력
 *
 * 케이스:
 * - trigger_event 없음 → "오늘은 주요 변동이 없습니다"
 * - LLM 분석 미생성 → "분석 데이터를 불러오지 못했습니다" + 재시도 버튼
 * - 뉴스 미수집 → "출처 데이터 일시 미수집"
 */
export function EmptyState({ icon, title, description, action, className }: EmptyStateProps) {
  return (
    <div className={cn('flex flex-col items-center justify-center py-10 text-center', className)}>
      {icon && <div className="mb-3 text-2xl text-gray-400">{icon}</div>}
      <p className="text-sm font-semibold text-gray-700">{title}</p>
      {description && <p className="mt-1 text-xs font-medium text-gray-500">{description}</p>}
      {action && <div className="mt-4">{action}</div>}
    </div>
  );
}
