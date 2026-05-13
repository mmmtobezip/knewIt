import type { Metadata } from 'next';
import { Providers } from './providers';
import { Toaster } from '@/components/ui/toaster';
import './globals.css';

/**
 * App Router 의 루트 레이아웃
 *
 * - 모든 페이지의 공통 셸: Providers (QueryClient + MSW) + 글로벌 Toaster
 * - max-width 1500px 컨테이너 (wireframe-spec.md § 1-2 Grid 시스템)
 * - lang="ko" 으로 SSR HTML 언어 명시 (스크린리더/검색엔진)
 */
export const metadata: Metadata = {
  title: 'POS-Pricing Navigator',
  description: 'AI 시장 분석 & 협상 전략 - POSCO 영업 협상 지원 도구',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ko">
      <body>
        <Providers>
          {/* 메인 컨테이너 — 1500px 중앙 정렬 + 24px 외부 패딩 */}
          <main className="mx-auto max-w-[1500px] p-6">{children}</main>
          {/* 글로벌 토스트 알림 (성공/에러/정보) */}
          <Toaster />
        </Providers>
      </body>
    </html>
  );
}
