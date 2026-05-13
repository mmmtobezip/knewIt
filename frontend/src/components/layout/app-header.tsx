'use client';

import Link from 'next/link';
import { Bell, User, RefreshCw } from 'lucide-react';
import { motion } from 'framer-motion';
import { APP, REFRESH } from '@/shared/constants';
import { Select } from '@/components/ui/select';
import { useSelectionStore } from '@/stores/selection-store';
import { useChatStore } from '@/stores/chat-store';
import { useInvalidateCache } from '@/lib/api/queries/dashboard';
import { useDebouncedCallback } from '@/hooks/use-debounced-callback';
import { toast } from '@/stores/toast-store';
import { formatTime } from '@/shared/utils/format';
import { cn } from '@/shared/utils/cn';
import { PRODUCTS, CUSTOMERS } from '@/lib/msw/mocks/data';

/**
 * 헤더 (AREA-MAIN-01)
 *
 * 셀렉터 두 종류는 **완전히 독립적** (index.html 패턴):
 * - 제품 셀렉터: 열연강판/냉연강판/아연도금강판/철근 (고정 4종)
 * - 고객사 셀렉터: 현대자동차/기아/삼성중공업/현대중공업 (assigned_customers)
 *
 * 정책:
 * - 고객사 변경 → 채팅 세션 새로 시작 (Q2) / 제품은 유지
 * - 제품 변경 → 채팅 세션 새로 시작 (Q2) / 고객사는 유지
 * - 새로고침 → 분석/뉴스/전략 캐시 무효화 (today_questions 제외)
 */
export function AppHeader() {
  const { customerId, productCode, setCustomer, setProduct } = useSelectionStore();
  const startNewSession = useChatStore((s) => s.startNewSession);
  const invalidate = useInvalidateCache();

  // 셀렉터 옵션 (고정, index.html 매핑)
  const productOptions = PRODUCTS.map((p) => ({ value: p.code, label: p.name }));
  const customerOptions = CUSTOMERS.slice()
    .sort((a, b) => a.name.localeCompare(b.name, 'ko'))
    .map((c) => ({ value: c.id, label: c.name }));

  /** 고객사 변경 (P-02) */
  const handleCustomerChange = (newCustomerId: string) => {
    if (newCustomerId === customerId) return;
    setCustomer(newCustomerId);
    startNewSession();
  };

  /** 제품 변경 (P-03) */
  const handleProductChange = (newProduct: string) => {
    if (newProduct === productCode) return;
    setProduct(newProduct);
    startNewSession();
  };

  /** 새로고침 (P-04) */
  const handleRefresh = useDebouncedCallback(() => {
    if (!customerId || !productCode) return;
    invalidate.mutate(
      {
        customer_id: customerId,
        product_code: productCode,
        scope: ['analysis', 'causal_chain', 'news', 'strategy'],
      },
      {
        onSuccess: () => toast.show('MSG-TST-01', { time: formatTime() }),
      },
    );
  }, REFRESH.DEBOUNCE_MS);

  return (
    <header className="mb-4 flex items-center gap-3 rounded-3xl bg-white px-7 py-5">
      {/* HDR-01 로고 */}
      <Link href="/" className="flex items-center gap-2.5 no-underline">
        <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-toss-blue text-base font-extrabold text-white">
          P
        </div>
        <span className="text-lg font-bold tracking-[-0.5px] text-gray-900">{APP.NAME}</span>
      </Link>

      {/* HDR-02 부제목 */}
      <div className="border-l border-gray-200 pl-3.5 text-sm font-medium text-gray-500">{APP.SUBTITLE}</div>

      <div className="flex-1" />

      {/* HDR-03 제품 셀렉터 */}
      <Select
        value={productCode}
        onValueChange={handleProductChange}
        options={productOptions}
        placeholder="제품 선택"
        icon="📦"
        ariaLabel="제품 선택"
      />

      {/* HDR-04 고객사 셀렉터 */}
      <Select
        value={customerId}
        onValueChange={handleCustomerChange}
        options={customerOptions}
        placeholder="고객사 선택"
        icon="🏢"
        ariaLabel="고객사 선택"
      />

      {/* HDR-05 새로고침 */}
      <motion.button
        whileTap={{ scale: 0.97 }}
        onClick={handleRefresh}
        disabled={invalidate.isPending}
        className={cn(
          'inline-flex h-11 items-center gap-1.5 rounded-lg bg-gray-100 px-4 text-sm font-semibold text-gray-800 transition-colors',
          'hover:bg-gray-200 disabled:opacity-60',
        )}
        aria-label="새로고침"
      >
        <RefreshCw className={cn('h-4 w-4', invalidate.isPending && 'animate-spin-slow')} />
        새로고침
      </motion.button>

      <button
        className="inline-flex h-11 w-11 items-center justify-center rounded-full bg-gray-100 transition-colors hover:bg-gray-200"
        aria-label="알림"
      >
        <Bell className="h-4 w-4 text-gray-700" />
      </button>
      <button
        className="inline-flex h-11 w-11 items-center justify-center rounded-full bg-gray-100 transition-colors hover:bg-gray-200"
        aria-label="프로필"
      >
        <User className="h-4 w-4 text-gray-700" />
      </button>
    </header>
  );
}
