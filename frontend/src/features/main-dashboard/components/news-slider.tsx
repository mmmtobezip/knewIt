'use client';

import { useState, useMemo } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ChevronLeft, ChevronRight, Newspaper } from 'lucide-react';
import { CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import { useSelectionStore } from '@/stores/selection-store';
import { useTriggerEvent, useNews } from '@/lib/api/queries/dashboard';
import { formatDate } from '@/shared/utils/format';
import { NEWS_SLIDER } from '@/shared/constants';
import { cn } from '@/shared/utils/cn';
import type { NewsDoc } from '@/types';

/**
 * 뉴스 슬라이더 (AREA-MAIN-07)
 *
 * Q9 결정: 도트 인디케이터 슬라이더 (인플레이스, 새 화면 X)
 * - 한 페이지 5개 (NEWS_SLIDER.ITEMS_PER_PAGE)
 * - 도트 클릭으로 페이지 전환 (transform: translateX 애니메이션)
 * - 좌우 화살표 (호버 시 표시)
 * - 뉴스 아이템 클릭 → 새 탭 외부 이동 (P-07, target="_blank")
 * - 로깅 없음 (Q13)
 */

const NEWS_COLORS: Record<string, string> = {
  Reuters: '#FF8000',
  Bloomberg: '#000000',
  Mysteel: '#C8102E',
  CRU: '#003DA5',
  'Financial Times': '#FFF1E5',
  Nikkei: '#E60012',
  WSJ: '#000000',
};

export function NewsSlider() {
  const { productCode } = useSelectionStore();
  const triggerQuery = useTriggerEvent(productCode, new Date().toISOString().slice(0, 10));
  const newsQuery = useNews(triggerQuery.data?.event_id ?? null);

  const [page, setPage] = useState(0);

  const pages = useMemo(() => {
    if (!newsQuery.data) return [];
    const result: NewsDoc[][] = [];
    for (let i = 0; i < newsQuery.data.length; i += NEWS_SLIDER.ITEMS_PER_PAGE) {
      result.push(newsQuery.data.slice(i, i + NEWS_SLIDER.ITEMS_PER_PAGE));
    }
    return result;
  }, [newsQuery.data]);

  const totalPages = pages.length;
  const canPrev = page > 0;
  const canNext = page < totalPages - 1;

  return (
    <div className="group relative mb-4 flex items-center gap-5 rounded-3xl bg-white px-7 py-5">
      <div className="flex shrink-0 items-center gap-2 text-base font-bold tracking-tighter text-gray-900">
        <Newspaper className="h-5 w-5 text-toss-blue" />
        근거 데이터 <CardSubtitle>(뉴스 출처)</CardSubtitle>
      </div>

      {/* 좌측 화살표 (호버 시 표시) */}
      {canPrev && (
        <button
          onClick={() => setPage((p) => Math.max(0, p - 1))}
          className="absolute left-44 z-10 flex h-8 w-8 items-center justify-center rounded-full bg-white opacity-0 shadow-toss-md transition-opacity hover:bg-gray-50 group-hover:opacity-100"
          aria-label="이전 뉴스"
        >
          <ChevronLeft className="h-4 w-4 text-gray-700" />
        </button>
      )}

      {/* 슬라이더 뷰포트 */}
      <div className="relative flex-1 overflow-hidden">
        {newsQuery.isLoading && (
          <div className="flex gap-2">
            {[0, 1, 2, 3, 4].map((i) => (
              <Skeleton key={i} className="h-12 w-44" />
            ))}
          </div>
        )}

        {!newsQuery.isLoading && pages.length === 0 && (
          <EmptyState icon="📰" title="출처 데이터 일시 미수집" />
        )}

        <AnimatePresence mode="wait">
          {pages[page] && (
            <motion.div
              key={page}
              initial={{ opacity: 0, x: 40 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -40 }}
              transition={{ duration: NEWS_SLIDER.ANIMATION_MS / 1000 }}
              className="flex gap-2"
            >
              {pages[page]?.map((news) => (
                <NewsItem key={news.url + news.published_at} news={news} />
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* 우측 화살표 */}
      {canNext && (
        <button
          onClick={() => setPage((p) => Math.min(totalPages - 1, p + 1))}
          className="absolute right-32 z-10 flex h-8 w-8 items-center justify-center rounded-full bg-white opacity-0 shadow-toss-md transition-opacity hover:bg-gray-50 group-hover:opacity-100"
          aria-label="다음 뉴스"
        >
          <ChevronRight className="h-4 w-4 text-gray-700" />
        </button>
      )}

      {/* 도트 인디케이터 */}
      {totalPages > 1 && (
        <div className="flex shrink-0 items-center gap-2">
          {Array.from({ length: totalPages }).map((_, i) => (
            <button
              key={i}
              onClick={() => setPage(i)}
              className={cn(
                'rounded-full transition-all',
                i === page ? 'h-2.5 w-2.5 bg-toss-blue' : 'h-2 w-2 bg-gray-300',
              )}
              aria-label={`${i + 1}번째 페이지`}
              aria-current={i === page ? 'true' : undefined}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function NewsItem({ news }: { news: NewsDoc }) {
  const color = NEWS_COLORS[news.source] ?? '#3182F6';
  return (
    <a
      href={news.url}
      target="_blank"
      rel="noopener noreferrer"
      className="flex shrink-0 items-center gap-2.5 rounded-lg bg-gray-100 px-3.5 py-2.5 no-underline transition-colors hover:bg-toss-blue-light"
    >
      <div
        className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full text-[11px] font-extrabold text-white"
        style={{ backgroundColor: color, color: news.source === 'Financial Times' ? '#990F3D' : '#fff' }}
        aria-hidden
      >
        {news.source[0]}
      </div>
      <div className="flex flex-col">
        <span className="text-[13px] font-bold tracking-tight text-gray-800">{news.source}</span>
        <span className="text-xs font-medium text-gray-500">{formatDate(news.published_at)}</span>
      </div>
    </a>
  );
}
