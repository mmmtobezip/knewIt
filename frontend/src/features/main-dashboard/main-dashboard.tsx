'use client';

import { useEffect, useMemo } from 'react';
import { useSelectionStore } from '@/stores/selection-store';
import {
  useCatalogCustomers,
  useCustomerProfile,
  useDashboard,
  useUsersMe,
} from '@/lib/api/queries/dashboard';
import { PRODUCTS } from '@/lib/msw/mocks/data';
import { QuickNav } from '@/components/layout/quick-nav';
import { ChatPanel } from '@/components/chat/chat-panel';
import { QuestionsPanel } from './components/questions-panel';
import { PriceChartCard } from './components/price-chart-card';
import { CauseFlowCard } from './components/cause-flow-card';
import { AiDiagnosis } from './components/ai-diagnosis';
import { StrategyCard } from './components/strategy-card';

/**
 * 메인 대시보드 (PRD 0514 MCS-Advisor).
 *
 * 구조:
 *  - 추천 질문 + 채팅 패널
 *  - chart1 (TopMover) | chart2 (Cause Flow) → 그 밑에 근거 데이터 슬라이더
 *  - AI 진단 | 권장 전략
 *
 * 거래처 변경 시 product_group[0] 으로 product 드롭다운 자동 매칭 (PRD 4.1).
 */
export function MainDashboard() {
  const { customerId, productCode, setCustomer, setProduct } = useSelectionStore();
  const profileQuery = useCustomerProfile(customerId);

  // PRD 0516 — 현재 사용자가 담당하는 거래처 목록 (lv2)
  const meQuery = useUsersMe();
  const myPrimary = meQuery.data?.primary_product_code ?? null;
  const myCustomersQuery = useCatalogCustomers(myPrimary);

  // 사용자 변경 / 첫 진입 시 default customer 자동 선택:
  //   - catalog 응답의 가나다순 첫 번째
  //   - 박지은 → 고려제강 등 / 박현웅 → 삼성중공업 등
  // 현재 customerId 가 catalog 안에 있으면 유지 (사용자가 직접 선택한 것)
  const sortedCustomers = useMemo(
    () =>
      (myCustomersQuery.data ?? []).slice().sort((a, b) =>
        a.customer_id.localeCompare(b.customer_id, 'ko'),
      ),
    [myCustomersQuery.data],
  );
  useEffect(() => {
    if (sortedCustomers.length === 0) return;
    const inList = customerId
      ? sortedCustomers.some((c) => c.customer_id === customerId)
      : false;
    if (!inList) {
      setCustomer(sortedCustomers[0]!.customer_id);
    }
  }, [sortedCustomers, customerId, setCustomer]);

  // product 자동 매칭 우선순위 (PRD 0516):
  //   1순위: user.primary_product_code (1:1 매핑 — 박지은=선재, 박현웅=후판 절대 고정)
  //          고객사를 어떻게 바꿔도 변하지 않음.
  //   2순위: customer.product_group[0]  (primary 없는 사용자 — 이윤진 등)
  //   3순위: PRODUCTS[0]                (profile 도 없는 초기 진입)
  useEffect(() => {
    const primary = meQuery.data?.primary_product_code;
    const fromProfile = profileQuery.data?.product_group?.[0];
    const target = primary ?? fromProfile ?? PRODUCTS[0]?.code;
    if (target && target !== productCode) {
      setProduct(target);
    }
  }, [meQuery.data, profileQuery.data, productCode, setProduct]);

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
