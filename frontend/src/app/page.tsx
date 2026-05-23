import { AppHeader } from '@/components/layout/app-header';
import { MainDashboard } from '@/features/main-dashboard/main-dashboard';

/**
 * 루트 페이지 (메인 대시보드)
 *
 * SCR-MAIN-001 진입점.
 * 헤더 + 메인 대시보드 컴포넌트 조합.
 */
export default function Page() {
  return (
    <>
      <AppHeader />
      <MainDashboard />
    </>
  );
}
