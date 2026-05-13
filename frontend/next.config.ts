import type { NextConfig } from 'next';

/**
 * Next.js 15 설정
 * - React Strict Mode 활성화
 * - 사내 환경에서 외부 이미지 화이트리스트 (뉴스 출처 로고)
 */
const nextConfig: NextConfig = {
  reactStrictMode: true,
  typedRoutes: true,
  images: {
    remotePatterns: [
      { protocol: 'https', hostname: '**' },
    ],
  },
};

export default nextConfig;
