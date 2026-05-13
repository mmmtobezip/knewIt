'use client';

import { cva, type VariantProps } from 'class-variance-authority';
import { Slot } from '@radix-ui/react-slot';
import { forwardRef, type ButtonHTMLAttributes } from 'react';
import { cn } from '@/shared/utils/cn';

/**
 * Toss 스타일 버튼
 *
 * variants:
 * - primary: Toss Blue (주요 액션)
 * - secondary: Gray (보조)
 * - ghost: 투명 배경 호버 시 Gray-100
 * - ai: 그라데이션 (AI 다시 작성 등 강조)
 */
const buttonVariants = cva(
  'inline-flex items-center justify-center gap-1.5 rounded-xl font-bold tracking-tight transition-colors duration-150 disabled:cursor-not-allowed disabled:opacity-60',
  {
    variants: {
      variant: {
        primary: 'bg-toss-blue text-white hover:bg-toss-blue-hover',
        secondary: 'bg-gray-100 text-gray-800 hover:bg-gray-200',
        ghost: 'bg-transparent text-gray-800 hover:bg-gray-100',
        ai: 'bg-gradient-to-br from-toss-blue to-[#1B64DA] text-white hover:opacity-95',
      },
      size: {
        sm: 'h-9 px-3 text-[13px]',
        md: 'h-11 px-4 text-sm',
        lg: 'h-12 px-6 text-[15px]',
      },
    },
    defaultVariants: {
      variant: 'primary',
      size: 'md',
    },
  },
);

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement>, VariantProps<typeof buttonVariants> {
  asChild?: boolean;
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild, ...props }, ref) => {
    const Comp = asChild ? Slot : 'button';
    return <Comp ref={ref} className={cn(buttonVariants({ variant, size }), className)} {...props} />;
  },
);
Button.displayName = 'Button';
