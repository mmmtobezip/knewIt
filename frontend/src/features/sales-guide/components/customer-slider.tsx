'use client';

import { useRef, type ReactNode } from 'react';
import { cn } from '@/shared/utils/cn';

/**
 * 고객사 카드 가로 슬라이더
 *
 *  - 기본: 한 화면에 3개 카드 표시 (각 카드 flex-basis = (100% - 2*gap)/3)
 *  - 좌/우 버튼: 항상 표시 (disabled 처리 없음), 카드 1장씩 이동
 *  - 가로 스크롤도 자유롭게 가능 (마우스/터치)
 *  - scroll-snap 으로 카드 단위 정렬
 */
const CARD_GAP_PX = 14;

interface CustomerSliderProps {
  children: ReactNode;
  label: ReactNode;
  count: number;
}

export function CustomerSlider({ children, label, count }: CustomerSliderProps) {
  const sliderRef = useRef<HTMLDivElement>(null);

  const getStep = (): number => {
    const slider = sliderRef.current;
    if (!slider) return 334;
    const firstCard = slider.querySelector<HTMLElement>('[data-slider-card]');
    if (!firstCard) return 334;
    return firstCard.getBoundingClientRect().width + CARD_GAP_PX;
  };

  const handlePrev = () => {
    sliderRef.current?.scrollBy({ left: -getStep(), behavior: 'smooth' });
  };
  const handleNext = () => {
    sliderRef.current?.scrollBy({ left: getStep(), behavior: 'smooth' });
  };

  return (
    <div>
      <div className="mb-2.5 flex items-center gap-2">
        <div className="flex-1 text-[11px] font-bold uppercase tracking-wide text-gray-400">
          {label} · <span className="text-gray-600">{count}개</span>
        </div>
        <SliderBtn onClick={handlePrev} aria-label="이전 고객사" direction="prev" />
        <SliderBtn onClick={handleNext} aria-label="다음 고객사" direction="next" />
      </div>
      <div
        ref={sliderRef}
        className="customer-slider -mx-1 flex snap-x snap-mandatory gap-[14px] overflow-x-auto overflow-y-hidden px-1 pb-3.5 pt-1"
        style={{ scrollbarWidth: 'thin' }}
      >
        {children}
      </div>
    </div>
  );
}

function SliderBtn({
  onClick,
  direction,
  ...rest
}: { onClick: () => void; direction: 'prev' | 'next' } & React.ButtonHTMLAttributes<HTMLButtonElement>) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="inline-flex h-[34px] w-[34px] shrink-0 items-center justify-center rounded-full border-[1.5px] border-gray-200 bg-white text-gray-700 transition-colors hover:border-gray-900 hover:bg-gray-900 hover:text-white"
      {...rest}
    >
      <svg
        width="14"
        height="14"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2.5"
        strokeLinecap="round"
        strokeLinejoin="round"
      >
        {direction === 'prev' ? <polyline points="15 18 9 12 15 6" /> : <polyline points="9 18 15 12 9 6" />}
      </svg>
    </button>
  );
}

/**
 * 슬라이더 내부 카드 — flex 0 0 (100% - 2*gap)/3 너비 적용
 */
export function CustomerSliderCard({ children, className }: { children: ReactNode; className?: string }) {
  return (
    <div
      data-slider-card
      className={cn(
        'flex shrink-0 grow-0 snap-start flex-col self-stretch basis-[calc((100%-28px)/3)]',
        className,
      )}
    >
      {children}
    </div>
  );
}
