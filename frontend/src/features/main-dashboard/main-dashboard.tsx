'use client';

import { useEffect } from 'react';
import { useSelectionStore } from '@/stores/selection-store';
import { useCustomerProfile, useDashboard } from '@/lib/api/queries/dashboard';
import { CUSTOMERS, PRODUCTS } from '@/lib/msw/mocks/data';
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

  useEffect(() => {
    const valid = CUSTOMERS.some((c) => c.id === customerId);
    if (!customerId || !valid) {
      const sorted = CUSTOMERS.slice().sort((a, b) => a.name.localeCompare(b.name, 'ko'));
      const first = sorted[0];
      if (first) setCustomer(first.id);
    }
  }, [customerId, setCustomer]);

  // 단일 product 자동 매칭 useEffect:
  //   1순위: customer.product_group[0] (PRD § 4.1)
  //   2순위: PRODUCTS[0] (profile 로딩 전 첫 진입용)
  // target === productCode 일 때는 setState 호출하지 않아 무한 루프 방지
  // (BACKLOG #9: "선재" 같이 PRODUCTS 카탈로그에 없는 product_group 값이 와도 그대로 보존)
  useEffect(() => {
    const fromProfile = profileQuery.data?.product_group?.[0];
    const target = fromProfile ?? PRODUCTS[0]?.code;
    if (target && target !== productCode) {
      setProduct(target);
    }
  }, [profileQuery.data, productCode, setProduct]);

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
