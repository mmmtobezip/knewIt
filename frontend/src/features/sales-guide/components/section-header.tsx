import { type ReactNode } from 'react';
import { cn } from '@/shared/utils/cn';

/**
 * 섹션 헤더 (kicker + 아이콘 + 헤딩 + 좌측 컬러 바)
 *
 * 가이드값 달성률 / 기회탐지 / 유사 과거 시황 3개 섹션의 시각적 정체성을 통일하기 위한 공용 헤더.
 *
 * 디자인 사양:
 *  - 좌측에 4px 컬러 바 (카드 좌측에서 inset 20px)
 *  - 키커 라벨 (예: "01 · ACHIEVEMENT") — 액센트 컬러 + 굵은 영문
 *  - 아이콘 배지 (38x38, 액센트 컬러 배경, 흰색 SVG)
 *  - 타이틀 (24px, 굵게)
 *  - 서브타이틀 (12px, 회색, 판매사원 친화적 설명문)
 */

export type SectionAccent = 'blue' | 'violet' | 'sky';

const ACCENT_BG: Record<SectionAccent, string> = {
  blue: 'bg-[#3182f6]',
  violet: 'bg-[#7c3aed]',
  sky: 'bg-[#0ea5e9]',
};
const ACCENT_TEXT: Record<SectionAccent, string> = {
  blue: 'text-[#3182f6]',
  violet: 'text-[#7c3aed]',
  sky: 'text-[#0ea5e9]',
};

interface SectionHeaderProps {
  kicker: string;
  title: string;
  subtitle: string;
  icon: ReactNode;
  accent: SectionAccent;
}

export function SectionHeader({ kicker, title, subtitle, icon, accent }: SectionHeaderProps) {
  return (
    <div className="mb-6">
      <div className={cn('mb-2.5 text-[11px] font-extrabold uppercase tracking-[0.14em]', ACCENT_TEXT[accent])}>
        {kicker}
      </div>
      <div className="flex items-center gap-3">
        <div
          className={cn(
            'flex h-[38px] w-[38px] shrink-0 items-center justify-center rounded-[11px] text-white',
            ACCENT_BG[accent],
          )}
        >
          {icon}
        </div>
        <h2 className="text-[24px] font-extrabold tracking-tighter text-gray-900">{title}</h2>
        <span className="text-[12px] font-medium text-gray-400">{subtitle}</span>
      </div>
    </div>
  );
}

/**
 * 섹션 카드 — 좌측 컬러 바 + 카드 컨테이너
 * 카드 padding 안쪽에 위치한 좌측 stripe로 섹션 구분
 */
interface SectionCardProps {
  accent: SectionAccent;
  children: ReactNode;
  id?: string;
  className?: string;
}

export function SectionCard({ accent, children, id, className }: SectionCardProps) {
  return (
    <section
      id={id}
      style={{ scrollMarginTop: '76px' }}
      className={cn(
        'relative rounded-3xl bg-white px-7 pt-7 pb-7 sm:px-8 sm:pt-8 sm:pb-8',
        className,
      )}
    >
      {/* 좌측 컬러 바 (카드 상하 20px inset) */}
      <span
        aria-hidden
        className={cn(
          'pointer-events-none absolute left-0 top-5 bottom-5 w-1 rounded-r',
          ACCENT_BG[accent],
        )}
      />
      {children}
    </section>
  );
}

/* 자주 쓰는 SVG 아이콘 — 18x18, currentColor stroke */
export const SectionIcons = {
  chart: (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
      <path d="M3 3v18h18" />
      <path d="M7 14l4-4 4 4 6-6" />
    </svg>
  ),
  search: (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="11" cy="11" r="8" />
      <path d="m21 21-4.3-4.3" />
    </svg>
  ),
  history: (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
      <path d="M3 12a9 9 0 1 0 9-9 9.7 9.7 0 0 0-6.4 2.6L3 8" />
      <path d="M3 3v5h5" />
      <path d="M12 7v5l4 2" />
    </svg>
  ),
};
