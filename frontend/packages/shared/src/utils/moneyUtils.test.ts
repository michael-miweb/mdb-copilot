import { describe, it, expect } from 'vitest';
import {
  eurosToCents,
  centsToEuros,
  centsToEurosString,
  pricePerM2,
  calculateMargin,
  calculatePercentage,
} from './moneyUtils';

describe('eurosToCents', () => {
  it('should convert euros to centimes', () => {
    expect(eurosToCents(1)).toBe(100);
    expect(eurosToCents(1.5)).toBe(150);
    expect(eurosToCents(12.34)).toBe(1234);
    expect(eurosToCents(1500)).toBe(150000);
  });

  it('should handle zero', () => {
    expect(eurosToCents(0)).toBe(0);
  });

  it('should round floating point errors', () => {
    // 19.99 * 100 = 1998.9999999999998 in JS
    expect(eurosToCents(19.99)).toBe(1999);
  });
});

describe('centsToEuros', () => {
  it('should convert centimes to euros', () => {
    expect(centsToEuros(100)).toBe(1);
    expect(centsToEuros(150)).toBe(1.5);
    expect(centsToEuros(1234)).toBe(12.34);
    expect(centsToEuros(150000)).toBe(1500);
  });

  it('should handle zero', () => {
    expect(centsToEuros(0)).toBe(0);
  });
});

describe('centsToEurosString', () => {
  it('should convert centimes to string with 2 decimals', () => {
    expect(centsToEurosString(100)).toBe('1.00');
    expect(centsToEurosString(150)).toBe('1.50');
    expect(centsToEurosString(1234)).toBe('12.34');
  });
});

describe('pricePerM2', () => {
  it('should calculate price per m²', () => {
    expect(pricePerM2(30000000, 100)).toBe(300000); // 300k€ for 100m² = 3k€/m²
    expect(pricePerM2(15000000, 50)).toBe(300000);
  });

  it('should return 0 for zero surface', () => {
    expect(pricePerM2(30000000, 0)).toBe(0);
  });

  it('should round to integer', () => {
    expect(pricePerM2(10000, 3)).toBe(3333);
  });
});

describe('calculateMargin', () => {
  it('should calculate margin correctly', () => {
    // Sell 300k, buy 200k, costs 20k = 80k margin
    expect(calculateMargin(30000000, 20000000, 2000000)).toBe(8000000);
  });

  it('should work without costs', () => {
    expect(calculateMargin(30000000, 20000000)).toBe(10000000);
  });

  it('should handle negative margin', () => {
    expect(calculateMargin(20000000, 30000000)).toBe(-10000000);
  });
});

describe('calculatePercentage', () => {
  it('should calculate percentage correctly', () => {
    expect(calculatePercentage(50, 100)).toBe(50);
    expect(calculatePercentage(1, 4)).toBe(25);
    expect(calculatePercentage(1, 3)).toBe(33.33);
  });

  it('should return 0 for zero total', () => {
    expect(calculatePercentage(50, 0)).toBe(0);
  });
});
