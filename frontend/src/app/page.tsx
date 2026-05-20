import { AppHeader } from '@/components/layout/app-header';
import { MainDashboard } from '@/features/main-dashboard/main-dashboard';
import { UserBootstrap } from '@/components/layout/user-bootstrap';
import { SyncAuthFromMe } from '@/components/layout/sync-auth-from-me';

/**
 * 루트 페이지 (메인 대시보드).
 *
 * 시연용 URL 파라미터:
 *   /?user=emp_2026003   → 박지은(선재)
 *   /?user=emp_2026004   → 박현웅(후판)
 *   /?user=emp_2026001   → 이윤진(기존)
 */
export default function Page() {
  return (
    <>
      <UserBootstrap />
      <SyncAuthFromMe />
      <AppHeader />
      <MainDashboard />
    </>
  );
}
