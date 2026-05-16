'use client';

import { useMemo, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ChevronLeft, ChevronRight, Newspaper } from 'lucide-react';
import { CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import type { CauseFlowStep, FlowEvidence } from '@/types';
import { cn } from '@/shared/utils/cn';

/**
 * 근거 데이터 슬라이더 (PRD 0514 + mockup index.html 스타일).
 *
 * - cause_flow.evidence 평탄화 후 dedupe
 * - 5건씩 페이지 슬라이딩 (좌우 화살표 + 도트 인디케이터)
 * - source 별 색상 + 첫 글자 아이콘 (R/B/M/C/F/...)
 */
const ITEMS_PER_PAGE = 5;

const SOURCE_COLORS: Record<string, string> = {
  Reuters: '#FF8000',
  Bloomberg: '#000000',
  Mysteel: '#C8102E',
  CRU: '#003DA5',
  'Financial Times': '#FFF1E5',
  Nikkei: '#E60012',
  WSJ: '#000000',
  Naver: '#03C75A',
};

function inferSource(ev: FlowEvidence): string {
  const url = ev.url || '';
  if (url.includes('reuters.com')) return 'Reuters';
  if (url.includes('bloomberg.com')) return 'Bloomberg';
  if (url.includes('mysteel')) return 'Mysteel';
  if (url.includes('crugroup')) return 'CRU';
  if (url.includes('ft.com')) return 'Financial Times';
  if (url.includes('nikkei')) return 'Nikkei';
  if (url.includes('wsj.com')) return 'WSJ';
  if (url.includes('naver')) return 'Naver';
  return 'News';
}

interface NewsSliderProps {
  flow: CauseFlowStep[];
  isLoading?: boolean;
  /** true 면 카드 래퍼 없이 슬라이더 본체만 렌더 (다른 카드 내부 임베드용). */
  embedded?: boolean;
}

export function NewsSlider({ flow, isLoading, embedded = false }: NewsSliderProps) {
  const items = useMemo(() => {
    const seen = new Set<string>();
    const list: (FlowEvidence & { source: string })[] = [];
    for (const step of flow) {
      for (const ev of step.evidence) {
        const key = ev.url || `${ev.title}-${ev.date}`;
        if (seen.has(key)) continue;
        seen.add(key);
        list.push({ ...ev, source: inferSource(ev) });
      }
    }
    return list;
  }, [flow]);

  const pages = useMemo(() => {
    const out: typeof items[] = [];
    for (let i = 0; i < items.length; i += ITEMS_PER_PAGE) {
      out.push(items.slice(i, i + ITEMS_PER_PAGE));
    }
    return out;
  }, [items]);

  const [page, setPage] = useState(0);
  const totalPages = pages.length;
  const canPrev = page > 0;
  const canNext = page < totalPages - 1;

  const wrapperClass = embedded
    ? 'group relative flex items-center gap-4'
    : 'group relative mb-4 flex items-center gap-5 rounded-3xl bg-white px-7 py-5';

  return (
    <div className={wrapperClass}>
      <div className="flex shrink-0 items-center gap-2 text-sm font-bold tracking-tighter text-gray-900">
        <Newspaper className="h-4 w-4 text-toss-blue" />
        근거 데이터 <CardSubtitle>(뉴스 출처)</CardSubtitle>
      </div>

      {canPrev && (
        <button
          type="button"
          onClick={() => setPage((p) => Math.max(0, p - 1))}
          className="absolute left-44 z-10 flex h-8 w-8 items-center justify-center rounded-full bg-white opacity-0 shadow-toss-md transition-opacity hover:bg-gray-50 group-hover:opacity-100"
          aria-label="이전 뉴스"
        >
          <ChevronLeft className="h-4 w-4 text-gray-700" />
        </button>
      )}

      <div className="relative flex-1 overflow-hidden">
        {isLoading && (
          <div className="flex gap-2">
            {[0, 1, 2, 3, 4].map((i) => (
              <Skeleton key={i} className="h-12 w-44" />
            ))}
          </div>
        )}

        {!isLoading && pages.length === 0 && (
          <EmptyState icon="📰" title="출처 데이터 없음" />
        )}

        <AnimatePresence mode="wait">
          {pages[page] && (
            <motion.div
              key={page}
              initial={{ opacity: 0, x: 40 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -40 }}
              transition={{ duration: 0.2 }}
              className="flex gap-2"
            >
              {pages[page]!.map((ev) => (
                <NewsItem key={`${ev.news_id}-${ev.title}`} item={ev} />
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {canNext && (
        <button
          type="button"
          onClick={() => setPage((p) => Math.min(totalPages - 1, p + 1))}
          className="absolute right-32 z-10 flex h-8 w-8 items-center justify-center rounded-full bg-white opacity-0 shadow-toss-md transition-opacity hover:bg-gray-50 group-hover:opacity-100"
          aria-label="다음 뉴스"
        >
          <ChevronRight className="h-4 w-4 text-gray-700" />
        </button>
      )}

      {totalPages > 1 && (
        <div className="flex shrink-0 items-center gap-2">
          {Array.from({ length: totalPages }).map((_, i) => (
            <button
              key={i}
              onClick={() => setPage(i)}
              aria-label={`${i + 1}번째 페이지`}
              aria-current={i === page ? 'true' : undefined}
              className={cn(
                'rounded-full transition-all',
                i === page ? 'h-2.5 w-2.5 bg-toss-blue' : 'h-2 w-2 bg-gray-300',
              )}
            />
          ))}
        </div>
      )}
    </div>
  );
}

interface NewsItemProps {
  item: FlowEvidence & { source: string };
}

function NewsItem({ item }: NewsItemProps) {
  const color = SOURCE_COLORS[item.source] ?? '#3182F6';
  const isFT = item.source === 'Financial Times';
  return (
    <a
      href={item.url}
      target="_blank"
      rel="noopener noreferrer"
      title={item.title}
      className="flex shrink-0 items-center gap-2.5 rounded-lg bg-gray-100 px-3.5 py-2.5 no-underline transition-colors hover:bg-toss-blue-light"
    >
      <div
        className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full text-[11px] font-extrabold"
        style={{ backgroundColor: color, color: isFT ? '#990F3D' : '#fff' }}
        aria-hidden
      >
        {item.source[0] ?? 'N'}
      </div>
      <div className="flex flex-col">
        <span className="text-[13px] font-bold tracking-tight text-gray-800">{item.source}</span>
        <span className="text-xs font-medium text-gray-500">{item.date}</span>
      </div>
    </a>
  );
}
