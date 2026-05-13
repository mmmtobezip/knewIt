import type { HTMLAttributes } from 'react';
import { cn } from '@/shared/utils/cn';

/**
 * 로딩 Skeleton (Toss 스타일)
 *
 * 사용:
 *   <Skeleton className="h-10 w-40" />
 */
export function Skeleton({ className, ...props }: HTMLAttributes<HTMLDivElement>) {
  return <div className={cn('animate-pulse rounded-lg bg-gray-100', className)} {...props} />;
}
