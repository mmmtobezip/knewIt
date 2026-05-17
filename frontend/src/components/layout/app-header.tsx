'use client';

import Link from 'next/link';
import { User, RefreshCw, X } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { usePathname } from 'next/navigation';
import { useRef, useState, useEffect } from 'react';
import { APP, REFRESH } from '@/shared/constants';
import { Select } from '@/components/ui/select';
import { useSelectionStore } from '@/stores/selection-store';
import { useChatStore } from '@/stores/chat-store';
import { useCustomerProfile, useInvalidateCache } from '@/lib/api/queries/dashboard';
import { useDebouncedCallback } from '@/hooks/use-debounced-callback';
import { toast } from '@/stores/toast-store';
import { formatTime } from '@/shared/utils/format';
import { cn } from '@/shared/utils/cn';
import { PRODUCTS, CUSTOMERS } from '@/lib/msw/mocks/data';

const MOCK_USER = {
  name: '김은지',
  emp_no: 'pc012345',
  email: 'pc012345@posco.com',
  department: '후판마케팅실',
  products: ['후판'],
  customers: ['한화오션', '현대중공업', '삼성중공업', '포스코건설', '포스코인터내셔널'],
};

export function AppHeader({ subtitle }: { subtitle?: string }) {
  const pathname = usePathname();
  const isGuidePage = pathname === '/guide';

  const { customerId, productCode, setCustomer, setProduct } = useSelectionStore();
  const startNewSession = useChatStore((s) => s.startNewSession);
  const invalidate = useInvalidateCache();
  const profileQuery = useCustomerProfile(customerId);
  const [profileOpen, setProfileOpen] = useState(false);
  const profileRef = useRef<HTMLDivElement>(null);

  const allowedProducts = profileQuery.data?.product_group ?? [];
  const productOptions = PRODUCTS.filter(
    (p) => allowedProducts.length === 0 || allowedProducts.includes(p.code),
  ).map((p) => ({ value: p.code, label: p.name }));
  const customerOptions = CUSTOMERS.slice()
    .sort((a, b) => a.name.localeCompare(b.name, 'ko'))
    .map((c) => ({ value: c.id, label: c.name }));

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (profileRef.current && !profileRef.current.contains(e.target as Node)) {
        setProfileOpen(false);
      }
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, []);

  const handleCustomerChange = (newCustomerId: string) => {
    if (newCustomerId === customerId) return;
    setCustomer(newCustomerId);
    startNewSession();
  };

  const handleProductChange = (newProduct: string) => {
    if (newProduct === productCode) return;
    setProduct(newProduct);
    startNewSession();
  };

  const handleRefresh = useDebouncedCallback(() => {
    if (!customerId || !productCode) return;
    invalidate.mutate(
      {
        customer_id: customerId,
        product_code: productCode,
        scope: ['top_movers', 'cause_flow', 'interpretation', 'strategy', 'news'],
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
      <div className="border-l border-gray-200 pl-3.5 text-sm font-medium text-gray-500">
        {subtitle ?? APP.SUBTITLE}
      </div>

      <div className="flex-1" />

      {/* HDR-03 제품 셀렉터 — 판매 가이드 화면에서 숨김 */}
      {!isGuidePage && (
        <Select
          value={productCode}
          onValueChange={handleProductChange}
          options={productOptions}
          placeholder="제품 선택"
          icon="📦"
          ariaLabel="제품 선택"
        />
      )}

      {/* HDR-04 고객사 셀렉터 — 판매 가이드 화면에서 숨김 */}
      {!isGuidePage && (
        <Select
          value={customerId}
          onValueChange={handleCustomerChange}
          options={customerOptions}
          placeholder="고객사 선택"
          icon="🏢"
          ariaLabel="고객사 선택"
        />
      )}

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

      {/* HDR-06 프로필 */}
      <div ref={profileRef} className="relative">
        <button
          onClick={() => setProfileOpen((v) => !v)}
          className={cn(
            'inline-flex h-11 w-11 items-center justify-center rounded-full transition-colors',
            profileOpen ? 'bg-toss-blue text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200',
          )}
          aria-label="프로필"
        >
          <User className="h-4 w-4" />
        </button>

        <AnimatePresence>
          {profileOpen && (
            <motion.div
              initial={{ opacity: 0, y: -8, scale: 0.96 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: -8, scale: 0.96 }}
              transition={{ duration: 0.15 }}
              className="absolute right-0 top-[calc(100%+8px)] z-50 w-72 overflow-hidden rounded-2xl border border-gray-100 bg-white shadow-lg"
            >
              {/* 헤더 */}
              <div className="flex items-center justify-between border-b border-gray-100 px-5 py-4">
                <div className="flex items-center gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-full bg-toss-blue text-[15px] font-extrabold text-white">
                    {MOCK_USER.name[0]}
                  </div>
                  <div>
                    <div className="text-[15px] font-bold text-gray-900">{MOCK_USER.name}</div>
                    <div className="text-[11px] text-gray-400">{MOCK_USER.department}</div>
                  </div>
                </div>
                <button
                  onClick={() => setProfileOpen(false)}
                  className="rounded-lg p-1 text-gray-400 hover:bg-gray-100"
                >
                  <X className="h-3.5 w-3.5" />
                </button>
              </div>

              {/* 상세 정보 */}
              <div className="space-y-0 px-5 py-3">
                <ProfileRow label="직번" value={MOCK_USER.emp_no} />
                <ProfileRow label="이메일" value={MOCK_USER.email} />
                <ProfileRow label="소속실" value={MOCK_USER.department} />
                <ProfileRow
                  label="판매제품"
                  value={MOCK_USER.products.join(', ')}
                />
                <div className="py-2">
                  <div className="mb-1.5 text-[10px] font-semibold uppercase tracking-wide text-gray-400">
                    담당고객사
                  </div>
                  <div className="flex flex-wrap gap-1">
                    {MOCK_USER.customers.map((c) => (
                      <span
                        key={c}
                        className="rounded-md bg-toss-blue-light px-2 py-0.5 text-[10px] font-semibold text-toss-blue"
                      >
                        {c}
                      </span>
                    ))}
                  </div>
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </header>
  );
}

function ProfileRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center gap-2 py-1.5">
      <span className="w-14 shrink-0 text-[10px] font-semibold uppercase tracking-wide text-gray-400">
        {label}
      </span>
      <span className="text-[12px] text-gray-700">{value}</span>
    </div>
  );
}
