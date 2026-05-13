import { describe, expect, it } from 'vitest';
import { formatChangeRate, getChangeColor, getChangeArrow, formatInt, formatDecimal, formatDate, formatUsd } from './format';

describe('format utilities', () => {
  describe('formatChangeRate', () => {
    it('하락은 ▼ + 음수 부호 + 소수 2자리', () => {
      expect(formatChangeRate(-4.2)).toBe('▼ -4.20%');
    });
    it('상승은 ▲ + 양수 부호 + 소수 2자리', () => {
      expect(formatChangeRate(3.5)).toBe('▲ +3.50%');
    });
    it('보합(절대값 0.1 이하)은 ─ 0.00%', () => {
      expect(formatChangeRate(0.05)).toBe('─ 0.00%');
      expect(formatChangeRate(-0.1)).toBe('─ 0.00%');
    });
  });

  describe('getChangeColor', () => {
    it('상승은 up (한국 금융권: 빨강)', () => {
      expect(getChangeColor(2.5)).toBe('up');
    });
    it('하락은 down (한국 금융권: 파랑)', () => {
      expect(getChangeColor(-2.5)).toBe('down');
    });
    it('보합은 flat', () => {
      expect(getChangeColor(0)).toBe('flat');
    });
  });

  describe('getChangeArrow', () => {
    it('각 방향별 화살표 반환', () => {
      expect(getChangeArrow(1)).toBe('▲');
      expect(getChangeArrow(-1)).toBe('▼');
      expect(getChangeArrow(0)).toBe('─');
    });
  });

  describe('formatInt / formatDecimal / formatUsd', () => {
    it('천 단위 콤마', () => {
      expect(formatInt(1234)).toBe('1,234');
      expect(formatInt(1234567)).toBe('1,234,567');
    });
    it('소수 2자리 + 콤마', () => {
      expect(formatDecimal(1234.5)).toBe('1,234.50');
      expect(formatDecimal(1234.567)).toBe('1,234.57');
    });
    it('USD 가격 prefix', () => {
      expect(formatUsd(580)).toBe('$580');
    });
  });

  describe('formatDate', () => {
    it('ISO → YYYY.MM.DD', () => {
      expect(formatDate('2026-05-08')).toBe('2026.05.08');
    });
  });
});
