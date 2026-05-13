'use client';

import { useEffect } from 'react';
import { useSelectionStore } from '@/stores/selection-store';
import { useChatStore } from '@/stores/chat-store';
import { CUSTOMERS, PRODUCTS } from '@/lib/msw/mocks/data';
import { QuickNav } from '@/components/layout/quick-nav';
import { ChatPanel } from '@/components/chat/chat-panel';
import { QuestionsPanel } from './components/questions-panel';
import { PriceChartCard } from './components/price-chart-card';
import { CauseFlowCard } from './components/cause-flow-card';
import { NewsSlider } from './components/news-slider';
import { AiDiagnosis } from './components/ai-diagnosis';
import { StrategyCard } from './components/strategy-card';

/**
 * 메인 대시보드 (SCR-MAIN-001)
 *
 * 진입 시 처리 (P-01):
 * 1. 직전 선택 복원 또는 기본값 자동 선택
 *    - 고객사: assigned_customers 가나다순 첫 번째
 *    - 제품: PRODUCTS 첫 번째 (열연강판)
 * 2. 채팅 세션 신규 발급
 *
 * 제품/고객사 선택은 완전히 독립적 (index.html 패턴).
 */
export function MainDashboard() {
  const { customerId, productCode, setCustomer, setProduct } = useSelectionStore();
  const startNewSession = useChatStore((s) => s.startNewSession);
  const sessionId = useChatStore((s) => s.sessionId);

  // 기본 고객사 자동 선택 + 유효성 검증 (localStorage stale 방어)
  useEffect(() => {
    const valid = CUSTOMERS.some((c) => c.id === customerId);
    if (!customerId || !valid) {
      const sorted = CUSTOMERS.slice().sort((a, b) => a.name.localeCompare(b.name, 'ko'));
      const first = sorted[0];
      if (first) setCustomer(first.id);
    }
  }, [customerId, setCustomer]);

  // 기본 제품 자동 선택 + 유효성 검증
  useEffect(() => {
    const valid = PRODUCTS.some((p) => p.code === productCode);
    if (!productCode || !valid) {
      const first = PRODUCTS[0];
      if (first) setProduct(first.code);
    }
  }, [productCode, setProduct]);

  // 채팅 세션 신규 발급 (최초 진입)
  useEffect(() => {
    if (!sessionId) startNewSession();
  }, [sessionId, startNewSession]);

  return (
    <>
      {/* AREA-MAIN-02: 판매 가이드/메일 초안 진입 카드 */}
      <QuickNav />

      {/* AREA-MAIN-03/04: 추천 질문 패널 (좌 300px) + 채팅 패널 (우 flex) */}
      <section className="mb-4 grid grid-cols-[300px_1fr] gap-7 rounded-3xl bg-white p-7">
        <QuestionsPanel />
        <ChatPanel />
      </section>

      {/* AREA-MAIN-05/06: 가격 차트 + 변동 원인 플로우 (제품 기반 분석) */}
      <section className="mb-4 grid grid-cols-2 gap-4">
        <PriceChartCard />
        <CauseFlowCard />
      </section>

      {/* AREA-MAIN-07: 근거 데이터 뉴스 슬라이더 (인플레이스, 도트 인디케이터) */}
      <NewsSlider />

      {/* AREA-MAIN-08/09: AI 진단(WHAT/WHY/IMPACT) + 권장 대응 전략(요약/행동/협상) */}
      <section className="grid grid-cols-2 gap-4">
        <AiDiagnosis />
        <StrategyCard />
      </section>
    </>
  );
}
