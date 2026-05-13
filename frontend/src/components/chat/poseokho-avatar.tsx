/**
 * 포석호 캐릭터 아바타 (SVG)
 *
 * 흰 곰 + posco 안전모(파란 줄무늬 3개) + 주황 작업복 + 분홍 볼터치
 * AREA-MAIN-04 채팅 패널에서 AI 응답자 표시용
 */
export function PoseokhoAvatar({ size = 52 }: { size?: number }) {
  return (
    <div className="flex flex-col items-center">
      <div
        className="overflow-hidden rounded-full border-2 border-white shadow-md"
        style={{ width: size, height: size, background: '#d6ecff' }}
        aria-label="포석호 AI 어시스턴트"
      >
        <svg viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
          <rect width="80" height="80" fill="#d6ecff" />
          {/* 귀 */}
          <circle cx="20" cy="26" r="8" fill="#ffffff" stroke="#7fb3e0" strokeWidth="1.2" />
          <circle cx="60" cy="26" r="8" fill="#ffffff" stroke="#7fb3e0" strokeWidth="1.2" />
          <circle cx="20" cy="26" r="4" fill="#bfe0ff" />
          <circle cx="60" cy="26" r="4" fill="#bfe0ff" />
          {/* 머리 (통통) */}
          <ellipse cx="40" cy="40" rx="28" ry="24" fill="#ffffff" stroke="#7fb3e0" strokeWidth="1.2" />
          {/* 안전모 */}
          <path d="M 14 28 Q 40 8 66 28 L 66 33 L 14 33 Z" fill="#ffffff" stroke="#7fb3e0" strokeWidth="1.2" />
          <rect x="14" y="31" width="52" height="4" rx="1" fill="#ffffff" stroke="#7fb3e0" strokeWidth="1" />
          {/* 안전모 줄무늬 (3개) */}
          <line x1="36" y1="15" x2="36" y2="24" stroke="#3b82f6" strokeWidth="1.5" strokeLinecap="round" />
          <line x1="40" y1="13" x2="40" y2="24" stroke="#3b82f6" strokeWidth="1.5" strokeLinecap="round" />
          <line x1="44" y1="15" x2="44" y2="24" stroke="#3b82f6" strokeWidth="1.5" strokeLinecap="round" />
          {/* posco 로고 */}
          <text x="40" y="29.5" textAnchor="middle" fontSize="5" fontWeight="700" fill="#1e3a8a" fontFamily="Arial, sans-serif">
            posco
          </text>
          {/* 볼터치 */}
          <ellipse cx="20" cy="46" rx="9" ry="8" fill="#fbbcd0" opacity="0.9" />
          <ellipse cx="60" cy="46" rx="9" ry="8" fill="#fbbcd0" opacity="0.9" />
          {/* 눈 */}
          <circle cx="32" cy="43" r="2.4" fill="#1f2937" />
          <circle cx="48" cy="43" r="2.4" fill="#1f2937" />
          {/* 코, 입 */}
          <ellipse cx="40" cy="48" rx="1.6" ry="1.3" fill="#1f2937" />
          <path d="M 37 51 Q 40 54 43 51" stroke="#1f2937" strokeWidth="1.3" fill="none" strokeLinecap="round" />
          {/* 주황 작업복 */}
          <path d="M 22 60 Q 22 56 26 56 L 54 56 Q 58 56 58 60 L 58 80 L 22 80 Z" fill="#fb923c" stroke="#ea580c" strokeWidth="1" />
          {/* 칼라 */}
          <path d="M 32 56 L 40 62 L 48 56" fill="#ffffff" stroke="#ea580c" strokeWidth="1" />
          {/* 포켓 */}
          <rect x="46" y="64" width="6" height="6" fill="none" stroke="#c2410c" strokeWidth="1" />
          {/* 명찰 */}
          <rect x="28" y="64" width="6" height="3" fill="#fde047" stroke="#a16207" strokeWidth="0.5" />
        </svg>
      </div>
      <div className="mt-0.5 text-[10px] font-bold text-[#1e40af]">포석호</div>
    </div>
  );
}
