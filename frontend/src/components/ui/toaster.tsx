'use client';

import { AnimatePresence, motion } from 'framer-motion';
import { Check, AlertTriangle, Info } from 'lucide-react';
import { useToastStore } from '@/stores/toast-store';
import { cn } from '@/shared/utils/cn';

/**
 * 글로벌 토스트 컨테이너
 *
 * 하단 중앙에서 슬라이드 인 (cubic-bezier).
 * main-ipo.md § 3-5 메시지 표준
 */
export function Toaster() {
  const toasts = useToastStore((s) => s.toasts);
  const dismiss = useToastStore((s) => s.dismiss);

  return (
    <div
      className="pointer-events-none fixed bottom-8 left-1/2 z-[10000] flex -translate-x-1/2 flex-col items-center gap-2"
      aria-live="polite"
      aria-atomic
    >
      <AnimatePresence>
        {toasts.map((t) => (
          <motion.div
            key={t.id}
            initial={{ y: 100, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: 20, opacity: 0 }}
            transition={{ duration: 0.4, ease: [0.34, 1.56, 0.64, 1] }}
            onClick={() => dismiss(t.id)}
            className={cn(
              'pointer-events-auto flex min-w-[280px] cursor-pointer items-center gap-2 rounded-3xl px-6 py-3 text-[13px] font-semibold shadow-toss-lg',
              t.category === 'success' && 'bg-gray-900 text-white',
              t.category === 'error' && 'bg-gray-900 text-white',
              t.category === 'info' && 'bg-gray-900 text-white',
            )}
          >
            {t.category === 'success' && <Check className="h-4 w-4 text-success" />}
            {t.category === 'error' && <AlertTriangle className="h-4 w-4 text-warning" />}
            {t.category === 'info' && <Info className="h-4 w-4 text-toss-blue" />}
            <span>{t.text}</span>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  );
}
