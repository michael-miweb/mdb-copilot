import { describe, it, expect } from 'vitest';
import { generateUUID, centsToEuros, eurosToCents, formatDateISO } from './index';

describe('generateUUID', () => {
  it('should generate a valid UUID v4 format', () => {
    const uuid = generateUUID();
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
    expect(uuid).toMatch(uuidRegex);
  });

  it('should generate unique UUIDs', () => {
    const uuid1 = generateUUID();
    const uuid2 = generateUUID();
    expect(uuid1).not.toBe(uuid2);
  });
});

describe('centsToEuros', () => {
  it('should convert cents to euros with 2 decimal places', () => {
    expect(centsToEuros(100)).toBe('1.00');
    expect(centsToEuros(150)).toBe('1.50');
    expect(centsToEuros(1234)).toBe('12.34');
  });

  it('should handle zero', () => {
    expect(centsToEuros(0)).toBe('0.00');
  });

  it('should handle large amounts', () => {
    expect(centsToEuros(1000000)).toBe('10000.00');
  });
});

describe('eurosToCents', () => {
  it('should convert euros to cents', () => {
    expect(eurosToCents(1)).toBe(100);
    expect(eurosToCents(1.5)).toBe(150);
    expect(eurosToCents(12.34)).toBe(1234);
  });

  it('should handle zero', () => {
    expect(eurosToCents(0)).toBe(0);
  });

  it('should round floating point errors', () => {
    // 19.99 * 100 = 1998.9999999999998 in JS, should round to 1999
    expect(eurosToCents(19.99)).toBe(1999);
  });
});

describe('formatDateISO', () => {
  it('should format date to ISO string without time', () => {
    const date = new Date('2026-02-04T15:30:00Z');
    expect(formatDateISO(date)).toBe('2026-02-04');
  });
});
