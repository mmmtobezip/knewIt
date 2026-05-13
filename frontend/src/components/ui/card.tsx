import { forwardRef, type HTMLAttributes } from 'react';
import { cn } from '@/shared/utils/cn';

/**
 * Toss 스타일 카드
 *
 * 모든 대시보드 영역의 기본 컨테이너.
 * - bg-white
 * - rounded-3xl (20px)
 * - p-7 (28px)
 * - 그림자 없음 (Toss 표준)
 */
export const Card = forwardRef<HTMLDivElement, HTMLAttributes<HTMLDivElement>>(({ className, ...props }, ref) => (
  <div ref={ref} className={cn('rounded-3xl bg-white p-7', className)} {...props} />
));
Card.displayName = 'Card';

export function CardTitle({ className, children, ...props }: HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn(
        'mb-5 flex items-center gap-2 text-[17px] font-bold tracking-tighter text-gray-900',
        className,
      )}
      {...props}
    >
      {children}
    </div>
  );
}

export function CardSubtitle({ className, children, ...props }: HTMLAttributes<HTMLSpanElement>) {
  return (
    <span className={cn('text-[13px] font-medium text-gray-500', className)} {...props}>
      {children}
    </span>
  );
}
