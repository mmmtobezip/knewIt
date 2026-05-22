import { AppHeader } from '@/components/layout/app-header';
import { SalesGuide } from '@/features/sales-guide/sales-guide';

/**
 * 판매량 가이드 대시보드 (SCR-GUIDE-001).
 *
 * 메인 대시보드 QuickNav 의 "판매 가이드" 클릭 시 진입.
 * Layout C: 좌 sticky 사이드바(Module 1) + 우 스크롤 컬럼(Module 2 + 3).
 */
export default function GuidePage() {
  return (
    <>
      <AppHeader subtitle="판매 가이드" />
      <main className="mx-auto max-w-[1500px] px-4 pt-3 pb-[114px]">
        <SalesGuide />
      </main>
    </>
  );
}
