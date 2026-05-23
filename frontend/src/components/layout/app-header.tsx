'use client';

import Link from 'next/link';
import { User, RefreshCw, X, LogOut } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';
import { usePathname, useRouter } from 'next/navigation';
import { useRef, useState, useEffect } from 'react';
import { APP, REFRESH } from '@/shared/constants';
import { Select } from '@/components/ui/select';
import { useSelectionStore } from '@/stores/selection-store';
import { useChatStore } from '@/stores/chat-store';
import {
  useCatalogCustomers,
  useCustomerProfile,
  useInvalidateCache,
  useUsersMe,
} from '@/lib/api/queries/dashboard';
import { useDebouncedCallback } from '@/hooks/use-debounced-callback';
import { toast } from '@/stores/toast-store';
import { formatTime } from '@/shared/utils/format';
import { cn } from '@/shared/utils/cn';
import { PRODUCTS, CUSTOMERS } from '@/lib/msw/mocks/data';
import { useAuthStore } from '@/stores/auth-store';

/** "포스코인터내셔널-후판" → "포스코인터내셔널" 표시명 정리. */
function displayName(customerId: string): string {
  const idx = customerId.lastIndexOf('-');
  if (idx === -1) return customerId;
  const suffix = customerId.slice(idx + 1);
  if (['선재', '후판', 'HR', '냉연', 'STS', '부산물'].includes(suffix)) {
    return customerId.slice(0, idx);
  }
  return customerId;
}

export function AppHeader({ subtitle }: { subtitle?: string }) {
  const pathname = usePathname();
  const router = useRouter();
  const isGuidePage = pathname === '/guide';

  const { customerId, productCode, setCustomer, setProduct } = useSelectionStore();
  const startNewSession = useChatStore((s) => s.startNewSession);
  const invalidate = useInvalidateCache();
  const profileQuery = useCustomerProfile(customerId);
  const meQuery = useUsersMe();
  const me = meQuery.data;
  const myCustomersQuery = useCatalogCustomers(me?.primary_product_code ?? null);

  const [profileOpen, setProfileOpen] = useState(false);
  const profileRef = useRef<HTMLDivElement>(null);
  const setAuthUser = useAuthStore((s) => s.setUser);

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

  const handleLogout = () => {
    if (typeof window === 'undefined') return;
    localStorage.removeItem('auth-token');
    setAuthUser(null as never);
    setProfileOpen(false);
    router.replace('/login');
  };

  // 프로필 표시용 fallback (로딩 중)
  const displayUser = {
    name: me?.name ?? '—',
    initial: (me?.name ?? '?').slice(0, 1),
    employee_no: me?.employee_no ?? '—',
    email: me?.email ?? '—',
    department: me?.department ?? '—',
    product: me?.primary_product_code ?? '—',
    customers: myCustomersQuery.data?.map((c) => displayName(c.customer_id)) ?? [],
  };

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
              className="absolute right-0 top-[calc(100%+8px)] z-50 w-80 overflow-hidden rounded-2xl border border-gray-100 bg-white shadow-lg"
            >
              {/* 헤더 */}
              <div className="flex items-center justify-between border-b border-gray-100 px-5 py-4">
                <div className="flex items-center gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-full bg-toss-blue text-[15px] font-extrabold text-white">
                    {displayUser.initial}
                  </div>
                  <div>
                    <div className="text-[15px] font-bold text-gray-900">{displayUser.name}</div>
                    <div className="text-[11px] text-gray-400">{displayUser.department}</div>
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
                <ProfileRow label="직번" value={displayUser.employee_no} />
                <ProfileRow label="이메일" value={displayUser.email} />
                <ProfileRow label="소속실" value={displayUser.department} />
                <ProfileRow label="판매제품" value={displayUser.product} />
                <div className="py-2">
                  <div className="mb-1.5 text-[10px] font-semibold uppercase tracking-wide text-gray-400">
                    담당고객사
                  </div>
                  {displayUser.customers.length > 0 ? (
                    <div className="flex flex-wrap gap-1">
                      {displayUser.customers.map((c) => (
                        <span
                          key={c}
                          className="rounded-md bg-toss-blue-light px-2 py-0.5 text-[10px] font-semibold text-toss-blue"
                        >
                          {c}
                        </span>
                      ))}
                    </div>
                  ) : (
                    <div className="text-[11px] text-gray-400">로딩 중…</div>
                  )}
                </div>
              </div>

              {/* 로그아웃 */}
              <div className="border-t border-gray-100 px-3 py-2">
                <button
                  type="button"
                  onClick={handleLogout}
                  className="inline-flex w-full items-center justify-center gap-1.5 rounded-lg px-3 py-2 text-[13px] font-semibold text-gray-700 transition-colors hover:bg-gray-100"
                >
                  <LogOut className="h-3.5 w-3.5" />
                  로그아웃
                </button>
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
    <div className="flex items-start gap-2 py-1.5">
      <span className="w-14 shrink-0 text-[10px] font-semibold uppercase tracking-wide text-gray-400">
        {label}
      </span>
      <span className="break-all text-[12px] text-gray-700">{value}</span>
    </div>
  );
}
