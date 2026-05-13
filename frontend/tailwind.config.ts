import type { Config } from 'tailwindcss';

/**
 * Tailwind CSS 설정
 *
 * Toss 디자인 시스템 토큰을 Tailwind에 직접 통합.
 * 토큰 소스: src/styles/tokens.ts 와 src/app/globals.css :root 변수
 *
 * 컬러 네이밍 규칙:
 * - toss-blue: 브랜드 컬러
 * - gray-{50..900}: 9단계 그레이 스케일
 * - red: 가격 상승 표시 (한국 금융권 관습)
 * - blue: 가격 하락 표시
 */
const config: Config = {
  content: ['./src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        'toss-blue': {
          DEFAULT: 'rgb(var(--toss-blue) / <alpha-value>)',
          hover: 'rgb(var(--toss-blue-hover) / <alpha-value>)',
          light: 'rgb(var(--toss-blue-light) / <alpha-value>)',
          bg: 'rgb(var(--toss-blue-bg) / <alpha-value>)',
        },
        gray: {
          50: 'rgb(var(--gray-50) / <alpha-value>)',
          100: 'rgb(var(--gray-100) / <alpha-value>)',
          200: 'rgb(var(--gray-200) / <alpha-value>)',
          300: 'rgb(var(--gray-300) / <alpha-value>)',
          400: 'rgb(var(--gray-400) / <alpha-value>)',
          500: 'rgb(var(--gray-500) / <alpha-value>)',
          600: 'rgb(var(--gray-600) / <alpha-value>)',
          700: 'rgb(var(--gray-700) / <alpha-value>)',
          800: 'rgb(var(--gray-800) / <alpha-value>)',
          900: 'rgb(var(--gray-900) / <alpha-value>)',
        },
        // 변동률 색상 (Q3-2-4: 상승=빨강 / 하락=파랑, 한국 금융권 관습)
        change: {
          up: 'rgb(var(--red) / <alpha-value>)',
          down: 'rgb(var(--toss-blue) / <alpha-value>)',
          flat: 'rgb(var(--gray-500) / <alpha-value>)',
        },
        // Diagnosis 카드 배경 (§ 3-3 AREA-MAIN-08)
        diag: {
          what: 'rgb(var(--diag-what) / <alpha-value>)',
          why: 'rgb(var(--diag-why) / <alpha-value>)',
          impact: 'rgb(var(--diag-impact) / <alpha-value>)',
        },
        success: 'rgb(var(--green) / <alpha-value>)',
        warning: 'rgb(var(--yellow) / <alpha-value>)',
        danger: 'rgb(var(--red) / <alpha-value>)',
      },
      fontFamily: {
        sans: [
          'Pretendard',
          '-apple-system',
          'BlinkMacSystemFont',
          'Apple SD Gothic Neo',
          'Noto Sans KR',
          'sans-serif',
        ],
      },
      letterSpacing: {
        tight: '-0.3px',
        tighter: '-0.4px',
        tightest: '-1px',
      },
      borderRadius: {
        sm: '8px',
        md: '10px',
        lg: '12px',
        xl: '14px',
        '2xl': '16px',
        '3xl': '20px',
      },
      boxShadow: {
        toss: '0 1px 3px rgba(0,0,0,0.08)',
        'toss-md': '0 2px 6px rgba(0,0,0,0.06)',
        'toss-lg': '0 8px 24px rgba(0,0,0,0.08)',
      },
      animation: {
        'fade-in': 'fadeIn 0.3s ease-out',
        'pulse-up': 'pulseUp 0.6s ease-out',
        'spin-slow': 'spin 0.9s linear infinite',
        'slide-up': 'slideUp 0.4s cubic-bezier(0.34, 1.56, 0.64, 1)',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        pulseUp: {
          '0%': { opacity: '0.3', transform: 'translateY(6px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        slideUp: {
          '0%': { opacity: '0', transform: 'translate(-50%, 100px)' },
          '100%': { opacity: '1', transform: 'translate(-50%, 0)' },
        },
      },
    },
  },
  plugins: [],
};

export default config;
