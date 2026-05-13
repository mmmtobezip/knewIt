/**
 * 디자인 토큰 (JS/TS에서 참조용)
 *
 * Tailwind 클래스로 표현 불가능한 케이스(차트 색상, 인라인 스타일 등)에서만 사용.
 * 일반 UI 스타일링은 Tailwind 우선.
 *
 * wireframe-spec.md § 5 와 동기화
 */

export const TOKENS = {
  color: {
    tossBlue: '#3182F6',
    tossBlueHover: '#1B64DA',
    tossBlueLight: '#E8F3FF',
    tossBlueBg: '#F4F9FF',
    gray: {
      900: '#191F28',
      800: '#333D4B',
      700: '#4E5968',
      600: '#6B7684',
      500: '#8B95A1',
      400: '#B0B8C1',
      300: '#D1D6DB',
      200: '#E5E8EB',
      100: '#F2F4F6',
      50: '#F9FAFB',
    },
    red: '#F04452',
    blue: '#3182F6',
    green: '#00C896',
    yellow: '#FFB020',
    bg: '#F2F4F6',
  },
  /**
   * 변동률 색상 매핑 (한국 금융권 관습)
   * - 상승: 빨강
   * - 하락: 파랑 (Toss Blue 재사용)
   */
  change: {
    up: '#F04452',
    down: '#3182F6',
    flat: '#8B95A1',
  },
  radius: {
    sm: 8,
    md: 10,
    lg: 12,
    xl: 14,
    '2xl': 16,
    '3xl': 20,
  },
  spacing: [4, 8, 10, 12, 14, 16, 18, 20, 24, 28, 32, 40] as const,
} as const;

export type Tokens = typeof TOKENS;
