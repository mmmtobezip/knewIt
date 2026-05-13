import Link from 'next/link';
import { ArrowLeft } from 'lucide-react';
import { AppHeader } from '@/components/layout/app-header';
import { Card, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';

/**
 * 판매 가이드 화면 (SCR-GUIDE-001) - Phase 2 placeholder
 *
 * 메인 대시보드에서 NAV-01 클릭 시 진입.
 * MVP 1차에서는 메인 대시보드만 풀 구현, 본 화면은 추후 별도 IPO 정의 후 구현.
 */
export default function GuidePage() {
  return (
    <>
      <AppHeader />
      <Card>
        <CardTitle>📊 판매 가이드</CardTitle>
        <div className="space-y-4">
          <p className="text-sm font-medium text-gray-700">
            고객사별 맞춤 협상 시나리오와 토킹 포인트가 표시될 영역입니다.
          </p>
          <p className="text-xs text-gray-500">
            현재 화면은 Phase 2 구현 예정으로, 별도 IPO 명세서 작성 후 개발됩니다.
          </p>
          <Button asChild variant="ghost" size="sm">
            <Link href="/">
              <ArrowLeft className="mr-1 h-4 w-4" />
              메인 대시보드로 돌아가기
            </Link>
          </Button>
        </div>
      </Card>
    </>
  );
}
