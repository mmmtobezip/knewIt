'use client';

import * as RadixSelect from '@radix-ui/react-select';
import { Check, ChevronDown } from 'lucide-react';
import { forwardRef, type ReactNode } from 'react';
import { cn } from '@/shared/utils/cn';

/**
 * Toss 스타일 셀렉터 (Radix Select 기반)
 *
 * 헤더의 제품/고객사 드롭다운에 사용.
 * - 키보드 접근성 자동 (Radix)
 * - 아이콘 슬롯 (📦, 🏢 등)
 * - placeholder, ARIA 라벨 지원
 */

export interface SelectOption {
  value: string;
  label: string;
}

interface SelectProps {
  value: string | null;
  onValueChange: (value: string) => void;
  options: SelectOption[];
  placeholder?: string;
  icon?: ReactNode;
  ariaLabel?: string;
  disabled?: boolean;
}

export const Select = forwardRef<HTMLButtonElement, SelectProps>(
  ({ value, onValueChange, options, placeholder, icon, ariaLabel, disabled }, ref) => {
    return (
      <RadixSelect.Root value={value ?? undefined} onValueChange={onValueChange} disabled={disabled}>
        <RadixSelect.Trigger
          ref={ref}
          aria-label={ariaLabel}
          className={cn(
            'inline-flex h-11 min-w-[200px] items-center gap-2 rounded-lg bg-gray-100 px-4 text-sm font-semibold tracking-tight text-gray-900 outline-none transition-colors',
            'hover:bg-gray-200 focus-visible:ring-2 focus-visible:ring-toss-blue',
            'disabled:cursor-not-allowed disabled:opacity-50',
          )}
        >
          {icon && <span className="text-base">{icon}</span>}
          <RadixSelect.Value placeholder={placeholder} />
          <RadixSelect.Icon className="ml-auto">
            <ChevronDown className="h-4 w-4 text-gray-500" strokeWidth={2.5} />
          </RadixSelect.Icon>
        </RadixSelect.Trigger>
        <RadixSelect.Portal>
          <RadixSelect.Content
            position="popper"
            sideOffset={4}
            className={cn(
              'z-50 max-h-80 min-w-[var(--radix-select-trigger-width)] overflow-hidden rounded-xl bg-white p-1 shadow-toss-lg',
              'data-[state=open]:animate-fade-in',
            )}
          >
            <RadixSelect.Viewport>
              {options.map((opt) => (
                <RadixSelect.Item
                  key={opt.value}
                  value={opt.value}
                  className={cn(
                    'relative flex h-10 cursor-pointer select-none items-center rounded-md px-3 pr-8 text-sm font-medium text-gray-800 outline-none',
                    'data-[highlighted]:bg-toss-blue-bg data-[highlighted]:text-gray-900',
                    'data-[state=checked]:font-bold data-[state=checked]:text-toss-blue',
                  )}
                >
                  <RadixSelect.ItemText>{opt.label}</RadixSelect.ItemText>
                  <RadixSelect.ItemIndicator className="absolute right-2 inline-flex items-center">
                    <Check className="h-4 w-4" />
                  </RadixSelect.ItemIndicator>
                </RadixSelect.Item>
              ))}
            </RadixSelect.Viewport>
          </RadixSelect.Content>
        </RadixSelect.Portal>
      </RadixSelect.Root>
    );
  },
);
Select.displayName = 'Select';
