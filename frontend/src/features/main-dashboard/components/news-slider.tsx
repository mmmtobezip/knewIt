'use client';

import { useMemo, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { ExternalLink } from 'lucide-react';
import { CardSubtitle } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';
import { EmptyState } from '@/components/ui/empty-state';
import type { CauseFlowStep, FlowEvidence } from '@/types';
import { cn } from '@/shared/utils/cn';

/**
 * 근거 데이터 — 세로 리스트 + 하단 도트 페이징.
 *
 * - cause_flow.evidence 평탄화 + dedupe
 * - 한 화면당 최대 3개, 도트 클릭 시 다음 묶음으로 슬라이드
 * - 행: [출처 배지] + 제목(1줄 truncate) + 날짜 + 외부 링크 아이콘
 */
const ITEMS_PER_PAGE = 3;

const SOURCE_COLORS: Record<string, string> = {
  Reuters: '#FF8000',
  Bloomberg: '#000000',
  Mysteel: '#C8102E',
  CRU: '#003DA5',
  'Financial Times': '#FFF1E5',
  Nikkei: '#E60012',
  WSJ: '#000000',
  Naver: '#03C75A',
  SHFE: '#0F4C81',
  'S&P Global': '#E03C31',
  POSCO: '#003876',
  JAMA: '#1F2937',
  Clarksons: '#1B365D',
  Outokumpu: '#005EB8',
  LME: '#27397A',
  'Steel Daily': '#374151',
  'TEX Report': '#1F2937',
  KOSHIPA: '#0F766E',
  KCA: '#475569',
  Platts: '#E03C31',
};

const DOMAIN_TO_SOURCE: Array<readonly [RegExp, string]> = [
  [/reuters\.com/i, 'Reuters'],
  [/bloomberg\.com/i, 'Bloomberg'],
  [/mysteel/i, 'Mysteel'],
  [/crugroup/i, 'CRU'],
  [/ft\.com/i, 'Financial Times'],
  [/nikkei/i, 'Nikkei'],
  [/wsj\.com/i, 'WSJ'],
  [/naver/i, 'Naver'],
  [/shfe\.com\.cn/i, 'SHFE'],
  [/spglobal\.com/i, 'S&P Global'],
  [/platts/i, 'Platts'],
  [/posco\.co\.kr/i, 'POSCO'],
  [/jama\.or\.jp/i, 'JAMA'],
  [/clarksons/i, 'Clarksons'],
  [/outokumpu/i, 'Outokumpu'],
  [/lme\.com/i, 'LME'],
  [/steeldaily\.co\.kr/i, 'Steel Daily'],
  [/tex-report\.com/i, 'TEX Report'],
  [/kshipbuilders\.or\.kr/i, 'KOSHIPA'],
  [/cement\.or\.kr/i, 'KCA'],
];

function inferSource(ev: FlowEvidence): string {
  const url = ev.url || '';
  for (const [pattern, name] of DOMAIN_TO_SOURCE) {
    if (pattern.test(url)) return name;
  }
  // 알려지지 않은 도메인 → 호스트네임에서 추출 (예: example.com → Example)
  try {
    const host = new URL(url).hostname.replace(/^www\./, '');
    const root = host.split('.')[0] ?? '';
    if (root) return root.charAt(0).toUpperCase() + root.slice(1);
  } catch {
    // URL 파싱 실패 시 fallback
  }
  return '출처 미상';
}

interface NewsSliderProps {
  flow: CauseFlowStep[];
  isLoading?: boolean;
  /** true 면 카드 래퍼 없이 본체만 렌더 (다른 카드 내부 임베드용). */
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
  const safePage = Math.min(page, Math.max(0, totalPages - 1));

  const wrapperClass = embedded
    ? 'flex flex-col gap-3'
    : 'mb-4 flex flex-col gap-3 rounded-3xl bg-white px-7 py-5';

  return (
    <div className={wrapperClass}>
      <div className="flex items-center gap-2 text-[15px] font-bold tracking-tight text-gray-900">
        근거 데이터 <CardSubtitle>(뉴스 출처)</CardSubtitle>
      </div>

      <div className="relative min-h-[156px]">
        {isLoading && (
          <div className="flex flex-col gap-2">
            {[0, 1, 2].map((i) => (
              <Skeleton key={i} className="h-12 w-full" />
            ))}
          </div>
        )}

        {!isLoading && pages.length === 0 && <EmptyState icon="📰" title="출처 데이터 없음" />}

        <AnimatePresence mode="wait">
          {pages[safePage] && (
            <motion.ul
              key={safePage}
              initial={{ opacity: 0, x: 24 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -24 }}
              transition={{ duration: 0.2 }}
              className="flex flex-col gap-2"
            >
              {pages[safePage]!.map((ev) => (
                <NewsRow key={`${ev.news_id}-${ev.title}`} item={ev} />
              ))}
            </motion.ul>
          )}
        </AnimatePresence>
      </div>

      {totalPages > 1 && (
        <div className="flex items-center justify-center gap-2 pt-1">
          {Array.from({ length: totalPages }).map((_, i) => (
            <button
              key={i}
              type="button"
              onClick={() => setPage(i)}
              aria-label={`${i + 1}번째 페이지`}
              aria-current={i === safePage ? 'true' : undefined}
              className={cn(
                'rounded-full transition-all',
                i === safePage ? 'h-2.5 w-2.5 bg-toss-blue' : 'h-2 w-2 bg-gray-300 hover:bg-gray-400',
              )}
            />
          ))}
        </div>
      )}
    </div>
  );
}

interface NewsRowProps {
  item: FlowEvidence & { source: string };
}

function NewsRow({ item }: NewsRowProps) {
  const color = SOURCE_COLORS[item.source] ?? '#3182F6';
  const isFT = item.source === 'Financial Times';
  return (
    <li>
      <a
        href={item.url}
        target="_blank"
        rel="noopener noreferrer"
        title={item.title}
        className="group flex items-center gap-3 rounded-lg bg-gray-100 px-3.5 py-2.5 no-underline transition-colors hover:bg-toss-blue-light"
      >
        <span
          className="inline-flex h-5 shrink-0 items-center rounded-full px-2 text-[10px] font-extrabold tracking-tight"
          style={{ backgroundColor: color, color: isFT ? '#990F3D' : '#fff' }}
        >
          {item.source}
        </span>
        <span className="flex-1 truncate text-[13px] font-semibold tracking-tight text-gray-800">
          {item.title}
        </span>
        <span className="hidden shrink-0 text-[11px] font-medium text-gray-500 sm:inline">
          {item.date}
        </span>
        <ExternalLink className="h-3.5 w-3.5 shrink-0 text-gray-400 group-hover:text-toss-blue" aria-hidden />
      </a>
    </li>
  );
}
