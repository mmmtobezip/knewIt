'use client';

import { useEffect, useMemo } from 'react';
import { useSelectionStore } from '@/stores/selection-store';
import {
  useCatalogCustomers,
  useCustomerProfile,
  useDashboard,
  useUsersMe,
} from '@/lib/api/queries/dashboard';
import { QuickNav } from '@/components/layout/quick-nav';
import { ChatPanel } from '@/components/chat/chat-panel';
import { QuestionsPanel } from './components/questions-panel';
import { PriceChartCard } from './components/price-chart-card';
import { CauseFlowCard } from './components/cause-flow-card';
import { AiDiagnosis } from './components/ai-diagnosis';
import { StrategyCard } from './components/strategy-card';

/**
 * 메인 대시보드 (PRD 0523 MCS-Advisor).
 *
 * 구조:
 *  - 추천 질문 + 채팅 패널
 *  - chart1 (TopMover) | chart2 (Cause Flow)
 *  - AI 진단 | 권장 전략
 *
 * user-aware 자동 매칭 (PRD 0523):
 *  1) /api/users/me  → 현재 사용자 + primary_product_code
 *  2) /api/catalog/customers?product=primary → 사용자 담당 거래처 5개
 *  3) default customer = catalog 첫 번째 (가나다순)
 *  4) default product  = user.primary_product_code (1:1 매핑 절대 고정)
 */
export function MainDashboard() {
  const { customerId, productCode, setCustomer, setProduct } = useSelectionStore();

  const meQuery = useUsersMe();
  const me = meQuery.data;
  const primary = me?.primary_product_code ?? null;
  const myCustomersQuery = useCatalogCustomers(primary);

  const sortedCustomers = useMemo(
    () =>
      (myCustomersQuery.data ?? [])
        .slice()
        .sort((a, b) => a.customer_id.localeCompare(b.customer_id, 'ko')),
    [myCustomersQuery.data],
  );

  // 사용자 변경/첫 진입 시 default customer 자동 매칭.
  // 이전 사용자의 customerId 가 catalog 에 없으면 첫 번째로 강제 변경.
  useEffect(() => {
    if (sortedCustomers.length === 0) return;
    const inList = customerId
      ? sortedCustomers.some((c) => c.customer_id === customerId)
      : false;
    if (!inList) {
      setCustomer(sortedCustomers[0]!.customer_id);
    }
  }, [sortedCustomers, customerId, setCustomer]);

  // product 자동 매칭 (PRD 0523):
  //   1순위: user.primary_product_code (담당자:제품 = 1:1 절대 고정)
  //   2순위: customer.product_group[0]
  const profileQuery = useCustomerProfile(customerId);
  useEffect(() => {
    const fromProfile = profileQuery.data?.product_group?.[0];
    const target = primary ?? fromProfile;
    if (target && target !== productCode) {
      setProduct(target);
    }
  }, [primary, profileQuery.data, productCode, setProduct]);

  const dashboardQuery = useDashboard(customerId);
  const data = dashboardQuery.data;
  const isLoading = dashboardQuery.isLoading;

  return (
    <>
      <QuickNav />

      <section className="mb-4 grid grid-cols-[300px_1fr] gap-7 rounded-3xl bg-white p-7">
        <QuestionsPanel />
        <ChatPanel />
      </section>

      <section className="mb-4 grid grid-cols-2 gap-4">
        <PriceChartCard topMovers={data?.chart1_top_movers ?? []} isLoading={isLoading} />
        <CauseFlowCard flow={data?.chart2_cause_flow ?? []} isLoading={isLoading} />
      </section>

      <section className="grid grid-cols-2 gap-4">
        <AiDiagnosis interpretation={data?.interpretation ?? null} isLoading={isLoading} />
        <StrategyCard strategy={data?.strategy ?? null} isLoading={isLoading} />
      </section>
    </>
  );
}
