import { AppHeader } from '@/components/layout/app-header';
import { AuthGuard } from '@/components/layout/auth-guard';
import { MainDashboard } from '@/features/main-dashboard/main-dashboard';

/**
 * 루트 페이지 (메인 대시보드).
 *
 * AuthGuard: 미인증 사용자는 /login 으로 자동 리다이렉트.
 */
export default function Page() {
  return (
    <AuthGuard>
      <AppHeader />
      <MainDashboard />
    </AuthGuard>
  );
}
