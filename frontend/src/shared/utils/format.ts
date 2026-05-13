/**
 * 표시 포맷 유틸
 *
 * main-ipo.md § 3-2 표시 포맷 표준 기반
 * - 숫자: 천 단위 콤마, 소수 2자리
 * - 변동률: ▲▼ 화살표 + 색상 (상승=빨강, 하락=파랑)
 * - 날짜: YYYY.MM.DD
 */

/** 정수 천 단위 콤마 */
export function formatInt(n: number): string {
  return new Intl.NumberFormat('ko-KR').format(Math.round(n));
}

/** 소수 2자리 + 천 단위 콤마 */
export function formatDecimal(n: number, digits = 2): string {
  return new Intl.NumberFormat('ko-KR', {
    minimumFractionDigits: digits,
    maximumFractionDigits: digits,
  }).format(n);
}

/** USD 가격 ($580 형태) */
export function formatUsd(n: number): string {
  return `$${formatInt(n)}`;
}

/** YYYY.MM.DD */
export function formatDate(iso: string): string {
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return iso;
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}.${m}.${day}`;
}

/** HH:MM (24시간) */
export function formatTime(iso: string | Date = new Date()): string {
  const d = typeof iso === 'string' ? new Date(iso) : iso;
  const h = String(d.getHours()).padStart(2, '0');
  const m = String(d.getMinutes()).padStart(2, '0');
  return `${h}:${m}`;
}

/** 변동률 화살표 */
export function getChangeArrow(rate: number): '▲' | '▼' | '─' {
  if (Math.abs(rate) <= 0.1) return '─';
  return rate > 0 ? '▲' : '▼';
}

/**
 * 변동률 표시 문자열
 *
 * @example
 *   formatChangeRate(-4.2)  // "▼ -4.20%"
 *   formatChangeRate(3.5)   // "▲ +3.50%"
 *   formatChangeRate(0.05)  // "─ 0.00%"
 */
export function formatChangeRate(rate: number): string {
  const arrow = getChangeArrow(rate);
  const abs = Math.abs(rate).toFixed(2);
  if (arrow === '─') return `${arrow} 0.00%`;
  const sign = rate > 0 ? '+' : '-';
  return `${arrow} ${sign}${abs}%`;
}

/** 변동률 색상 토큰 (Tailwind 클래스 또는 hex) */
export type ChangeColor = 'up' | 'down' | 'flat';
export function getChangeColor(rate: number): ChangeColor {
  if (Math.abs(rate) <= 0.1) return 'flat';
  return rate > 0 ? 'up' : 'down';
}

/** Tailwind text color 클래스 */
export function getChangeTextClass(rate: number): string {
  const c = getChangeColor(rate);
  if (c === 'up') return 'text-change-up';
  if (c === 'down') return 'text-change-down';
  return 'text-change-flat';
}
