import { describe, it, expect } from 'vitest';
import { formatMoney, formatDate, formatSurface } from './formatters';

describe('formatMoney', () => {
  it('should format centimes to euros with currency symbol', () => {
    const result = formatMoney(150000);
    // French format: 1 500,00 €
    expect(result).toContain('1');
    expect(result).toContain('500');
    expect(result).toContain('€');
  });

  it('should handle zero', () => {
    const result = formatMoney(0);
    expect(result).toContain('0');
    expect(result).toContain('€');
  });

  it('should handle small amounts', () => {
    const result = formatMoney(99); // 0,99 €
    expect(result).toContain('0');
    expect(result).toContain('99');
  });

  it('should format without symbol when showSymbol is false', () => {
    const result = formatMoney(150000, { showSymbol: false });
    expect(result).not.toContain('€');
    expect(result).toContain('1');
    expect(result).toContain('500');
  });

  it('should use custom locale', () => {
    const result = formatMoney(150000, { locale: 'en-US', currency: 'USD' });
    expect(result).toContain('$');
    expect(result).toContain('1,500');
  });
});

describe('formatDate', () => {
  it('should format ISO date to long French format', () => {
    const result = formatDate('2026-02-03T14:30:00Z');
    expect(result).toContain('2026');
    expect(result.toLowerCase()).toContain('février');
  });

  it('should format to short format', () => {
    const result = formatDate('2026-02-03T14:30:00Z', { format: 'short' });
    expect(result).toMatch(/03\/02\/2026|3\/2\/26|02\/03\/2026/);
  });

  it('should return original string for invalid date', () => {
    const result = formatDate('invalid-date');
    expect(result).toBe('invalid-date');
  });

  it('should include time when includeTime is true', () => {
    const result = formatDate('2026-02-03T14:30:00Z', { includeTime: true });
    // Should contain time component
    expect(result.length).toBeGreaterThan(10);
  });
});

describe('formatSurface', () => {
  it('should format surface with m² unit', () => {
    const result = formatSurface(150);
    expect(result).toBe('150 m²');
  });

  it('should format large numbers with thousands separator', () => {
    const result = formatSurface(1500);
    // French format uses space as thousands separator
    expect(result).toMatch(/1\s?500 m²/);
  });

  it('should handle zero surface', () => {
    const result = formatSurface(0);
    expect(result).toBe('0 m²');
  });

  it('should handle decimal surface', () => {
    const result = formatSurface(75.5);
    expect(result).toMatch(/75[,.]5 m²/);
  });
});
