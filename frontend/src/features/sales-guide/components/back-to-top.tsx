'use client';

/**
 * 우측 하단 고정 "맨 위로" 버튼
 *
 *  - 항상 표시 (disabled 처리 없음)
 *  - 클릭 시 부드러운 스크롤로 맨 위 이동
 *  - Toss FAB 패턴: 흰 배경 + 옅은 보더 + subtle shadow → 호버 시 검정 invert
 */
export function BackToTopButton() {
  const handleClick = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <button
      type="button"
      onClick={handleClick}
      aria-label="맨 위로"
      className="fixed right-7 bottom-7 z-40 flex h-[52px] w-[52px] flex-col items-center justify-center gap-px rounded-full border border-gray-200 bg-white text-gray-900 shadow-toss-md transition-all hover:-translate-y-0.5 hover:bg-gray-900 hover:text-white hover:shadow-toss-lg"
    >
      <svg
        width="18"
        height="18"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2.4"
        strokeLinecap="round"
        strokeLinejoin="round"
      >
        <polyline points="18 15 12 9 6 15" />
      </svg>
      <span className="text-[9px] font-extrabold tracking-wider">TOP</span>
    </button>
  );
}
