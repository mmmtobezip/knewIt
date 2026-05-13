/**
 * UI 상태 / 사용자 입력 타입 정의
 *
 * 참조: main-ipo.md
 * - § 1-1 사용자 입력 (User Input)
 * - § 3-5 메시지 표준
 * - Q5  MVP 단계는 period 1M 고정
 * - Q9  뉴스 인플레이스 슬라이더
 * - Q14 외부 링크 새 탭
 */

// ─────────────────────────────────────────────────────────
// 차트 기간
// ─────────────────────────────────────────────────────────

/**
 * 차트 기간 옵션
 *
 * ※ MVP 단계: '1M' 고정 (Q5).
 *   Phase 2 에서 나머지 옵션 활성화.
 */
export type ChartPeriod = '1D' | '1W' | '1M' | '3M' | '6M' | '1Y';

export const MVP_DEFAULT_PERIOD: ChartPeriod = '1M';

// ─────────────────────────────────────────────────────────
// 진입 카드 / 화면 이동
// ─────────────────────────────────────────────────────────

/**
 * 진입 카드 (P-08)
 */
export type NavTarget = 'guide' | 'mail';

// ─────────────────────────────────────────────────────────
// 사용자 선택 상태 (localStorage 저장)
// ─────────────────────────────────────────────────────────

/**
 * 직전 선택 상태
 *
 * § 1-2 시스템 입력 (last_selection)
 *
 * 화면 재진입 시 복원
 */
export interface LastSelection {
  customer: string;
  product: string;
}

// ─────────────────────────────────────────────────────────
// 메시지 / 토스트 / 인라인 에러
// ─────────────────────────────────────────────────────────

/**
 * 메시지 종류 (§ 3-5-1)
 *
 * - TST: 토스트 (Toast)
 * - INF: 정보 안내 (Inline Info / Banner)
 * - ERR: 에러 토스트
 * - INL: 입력 인라인 에러
 */
export type MessageId =
  // 성공 토스트
  | 'MSG-TST-01'
  // 에러 토스트
  | 'MSG-ERR-01' | 'MSG-ERR-02' | 'MSG-ERR-03'
  | 'MSG-ERR-04' | 'MSG-ERR-05' | 'MSG-ERR-06' | 'MSG-ERR-07'
  // 정보 안내
  | 'MSG-INF-01' | 'MSG-INF-02' | 'MSG-INF-03' | 'MSG-INF-04'
  // 인라인 에러
  | 'MSG-INL-01' | 'MSG-INL-02';

/**
 * 메시지 카테고리
 */
export type MessageCategory = 'TST' | 'ERR' | 'INF' | 'INL';

/**
 * 토스트 메시지
 */
export interface ToastMessage {
  id: MessageId;
  category: 'TST' | 'ERR';
  text: string;
  /** 노출 시간 (ms) */
  duration_ms: number;
}

// ─────────────────────────────────────────────────────────
// 영역 ID (§ 3-1)
// ─────────────────────────────────────────────────────────

/**
 * 와이어프레임 영역 ID
 */
export type AreaId =
  | 'AREA-MAIN-01'  // 헤더
  | 'AREA-MAIN-02'  // 진입 카드
  | 'AREA-MAIN-03'  // 추천 질문
  | 'AREA-MAIN-04'  // 채팅 패널
  | 'AREA-MAIN-05'  // 가격 차트
  | 'AREA-MAIN-06'  // 변동 원인 플로우
  | 'AREA-MAIN-07'  // 뉴스 슬라이더
  | 'AREA-MAIN-08'  // AI 진단
  | 'AREA-MAIN-09'; // 권장 대응 전략

// ─────────────────────────────────────────────────────────
// 영역별 로딩/에러/빈 상태
// ─────────────────────────────────────────────────────────

/**
 * 비동기 데이터 상태 (각 영역에 사용)
 */
export type AsyncState<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'empty' }
  | { status: 'error'; code: string; message: string };

// ─────────────────────────────────────────────────────────
// 새로고침
// ─────────────────────────────────────────────────────────

/**
 * 새로고침 정책
 */
export const REFRESH_CONSTRAINTS = {
  /** debounce ms (Q12) */
  DEBOUNCE_MS: 5_000,
  /** 토스트 노출 시간 ms */
  TOAST_DURATION_MS: 2_200,
} as const;

// ─────────────────────────────────────────────────────────
// 뉴스 슬라이더
// ─────────────────────────────────────────────────────────

/**
 * 뉴스 슬라이더 설정 (Q9)
 *
 * - 인플레이스 슬라이드 (새 화면 이동 X)
 * - 한 페이지: 5개
 * - 도트 인디케이터로 페이지 표시
 */
export const NEWS_SLIDER_CONFIG = {
  ITEMS_PER_PAGE: 5,
  ANIMATION_MS: 300,
} as const;

// ─────────────────────────────────────────────────────────
// 변동률 표시
// ─────────────────────────────────────────────────────────

/**
 * 변동률 색상 (§ 3-2-4)
 *
 * 한국 금융권 관습:
 * - 상승: 빨강
 * - 하락: 파랑
 * - 보합: 회색
 */
export type ChangeColor = 'red' | 'blue' | 'gray';

/**
 * 변동률 → 색상 결정
 */
export function getChangeColor(rate: number): ChangeColor {
  if (Math.abs(rate) <= 0.1) return 'gray';
  return rate > 0 ? 'red' : 'blue';
}

/**
 * 변동률 → 화살표 결정
 */
export function getChangeArrow(rate: number): '▲' | '▼' | '─' {
  if (Math.abs(rate) <= 0.1) return '─';
  return rate > 0 ? '▲' : '▼';
}

/**
 * 변동률 표시 문자열 (§ 3-2-4)
 *
 * @example
 *   formatChangeRate(-4.2)   // "▼ -4.20%"
 *   formatChangeRate( 3.5)   // "▲ +3.50%"
 *   formatChangeRate( 0.05)  // "─ 0.00%"
 */
export function formatChangeRate(rate: number): string {
  const arrow = getChangeArrow(rate);
  const abs = Math.abs(rate).toFixed(2);
  if (arrow === '─') return `${arrow} 0.00%`;
  const sign = rate > 0 ? '+' : '-';
  return `${arrow} ${sign}${abs}%`;
}
