'use client';

import { useEffect, useState } from 'react';
import { cn } from '@/shared/utils/cn';

/**
 * 섹션 네비게이션 — sticky 둥근 카드 + Toss segmented control 스타일
 *
 *  - 카드 형태 (rounded-3xl + shadow-toss) → 다른 카드들과 시각적 통일
 *  - sticky top:8px → 스크롤 시 자연스럽게 상단 고정
 *  - 클릭 시 정확한 위치(스티키 nav 바로 아래)로 부드럽게 이동
 *  - 스크롤 위치에 따라 active 자동 갱신
 */

interface TabItem {
  id: string;
  label: string;
}

const TABS = [
  { id: 'section-achievement', label: '가이드값 달성률' },
  { id: 'section-opportunity', label: '기회탐지' },
  { id: 'section-history', label: '유사 과거 시황' },
] as const satisfies readonly TabItem[];

/* 스크롤 보정값:
 * - sticky top 8px
 * - nav 카드 높이 약 56px (p-2 + 내부 h-10)
 * - 추가 호흡 12px
 * → 합계 약 76px
 */
export const TAB_SCROLL_OFFSET = 76;

export function TabNav() {
  const [activeId, setActiveId] = useState<string>(TABS[0].id);

  /* 스크롤 위치에 따라 active 자동 갱신 */
  useEffect(() => {
    const onScroll = () => {
      const threshold = TAB_SCROLL_OFFSET + 12; // 약간의 여유
      let current: string = TABS[0].id;
      for (const t of TABS) {
        const el = document.getElementById(t.id);
        if (!el) continue;
        const rectTop = el.getBoundingClientRect().top;
        if (rectTop <= threshold) current = t.id;
      }
      setActiveId(current);
    };
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  const handleClick = (id: string) => (e: React.MouseEvent) => {
    e.preventDefault();
    const el = document.getElementById(id);
    if (!el) return;
    const absTop = el.getBoundingClientRect().top + window.scrollY;
    window.scrollTo({ top: absTop - TAB_SCROLL_OFFSET, behavior: 'smooth' });
    setActiveId(id);
  };

  return (
    <nav className="sticky top-2 z-30 mb-4 flex items-center gap-1.5 rounded-3xl bg-white p-2 shadow-toss">
      {TABS.map((t) => {
        const isActive = activeId === t.id;
        return (
          <a
            key={t.id}
            href={`#${t.id}`}
            onClick={handleClick(t.id)}
            className={cn(
              'inline-flex h-10 items-center rounded-2xl px-4 text-[14px] font-semibold tracking-tight transition-colors',
              isActive
                ? 'bg-gray-100 font-extrabold text-gray-900'
                : 'text-gray-500 hover:bg-gray-50 hover:text-gray-700',
            )}
          >
            {t.label}
          </a>
        );
      })}
    </nav>
  );
}
