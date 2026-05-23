import { AppHeader } from '@/components/layout/app-header';
import { SalesGuide } from '@/features/sales-guide/sales-guide';

/**
 * 판매량 가이드 대시보드 (SCR-GUIDE-001).
 *
 * 루트 레이아웃의 main(max-w-[1500px] p-6)을 그대로 사용 →
 * AppHeader, TabNav, 3개 섹션 카드가 모두 동일한 가로 폭으로 정렬됨.
 */
export default function GuidePage() {
  return (
    <>
      <AppHeader subtitle="판매 가이드" />
      <SalesGuide />
    </>
  );
}
