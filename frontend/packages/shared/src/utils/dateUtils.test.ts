import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import {
  parseISODate,
  toISOString,
  nowISO,
  isExpired,
  isWithinDays,
  toDateOnly,
} from './dateUtils';

describe('parseISODate', () => {
  it('should parse valid ISO date string', () => {
    const result = parseISODate('2026-02-03T14:30:00Z');
    expect(result).toBeInstanceOf(Date);
    expect(result?.getFullYear()).toBe(2026);
    expect(result?.getMonth()).toBe(1); // February is 1
    expect(result?.getDate()).toBe(3);
  });

  it('should return null for invalid date', () => {
    expect(parseISODate('invalid')).toBeNull();
    expect(parseISODate('')).toBeNull();
  });

  it('should return null for null/undefined input', () => {
    expect(parseISODate(null as unknown as string)).toBeNull();
    expect(parseISODate(undefined as unknown as string)).toBeNull();
  });
});

describe('toISOString', () => {
  it('should convert Date to ISO string', () => {
    const date = new Date('2026-02-03T14:30:00Z');
    const result = toISOString(date);
    expect(result).toBe('2026-02-03T14:30:00.000Z');
  });
});

describe('nowISO', () => {
  it('should return current time as ISO string', () => {
    const result = nowISO();
    expect(result).toMatch(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/);
  });
});

describe('isExpired', () => {
  beforeEach(() => {
    vi.useFakeTimers();
    vi.setSystemTime(new Date('2026-02-04T12:00:00Z'));
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('should return true for past date', () => {
    expect(isExpired('2026-02-03T12:00:00Z')).toBe(true);
    expect(isExpired('2025-01-01T00:00:00Z')).toBe(true);
  });

  it('should return false for future date', () => {
    expect(isExpired('2026-02-05T12:00:00Z')).toBe(false);
    expect(isExpired('2027-01-01T00:00:00Z')).toBe(false);
  });

  it('should return false for invalid date', () => {
    expect(isExpired('invalid')).toBe(false);
  });
});

describe('isWithinDays', () => {
  beforeEach(() => {
    vi.useFakeTimers();
    vi.setSystemTime(new Date('2026-02-04T12:00:00Z'));
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('should return true for date within range', () => {
    expect(isWithinDays('2026-02-03T12:00:00Z', 7)).toBe(true);
    expect(isWithinDays('2026-02-01T12:00:00Z', 7)).toBe(true);
  });

  it('should return false for date outside range', () => {
    expect(isWithinDays('2026-01-01T12:00:00Z', 7)).toBe(false);
  });
});

describe('toDateOnly', () => {
  it('should extract date part from Date object', () => {
    const date = new Date('2026-02-03T14:30:00Z');
    expect(toDateOnly(date)).toBe('2026-02-03');
  });

  it('should extract date part from ISO string', () => {
    expect(toDateOnly('2026-02-03T14:30:00Z')).toBe('2026-02-03');
  });
});
