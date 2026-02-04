import { describe, it, expect } from 'vitest';
import {
  validateEmail,
  validatePhone,
  validateUrl,
  validatePostalCode,
  validateUUID,
} from './validators';

describe('validateEmail', () => {
  it('should return true for valid email', () => {
    expect(validateEmail('test@example.com')).toBe(true);
    expect(validateEmail('user.name@domain.co.uk')).toBe(true);
    expect(validateEmail('user+tag@example.org')).toBe(true);
  });

  it('should return false for invalid email', () => {
    expect(validateEmail('invalid')).toBe(false);
    expect(validateEmail('no@domain')).toBe(false);
    expect(validateEmail('@nodomain.com')).toBe(false);
    expect(validateEmail('spaces in@email.com')).toBe(false);
  });

  it('should return false for empty or null input', () => {
    expect(validateEmail('')).toBe(false);
    expect(validateEmail(null as unknown as string)).toBe(false);
    expect(validateEmail(undefined as unknown as string)).toBe(false);
  });
});

describe('validatePhone', () => {
  it('should return true for valid French phone numbers', () => {
    expect(validatePhone('0612345678')).toBe(true);
    expect(validatePhone('06 12 34 56 78')).toBe(true);
    expect(validatePhone('06.12.34.56.78')).toBe(true);
    expect(validatePhone('06-12-34-56-78')).toBe(true);
    expect(validatePhone('+33612345678')).toBe(true);
    expect(validatePhone('0033612345678')).toBe(true);
  });

  it('should return false for invalid phone numbers', () => {
    expect(validatePhone('123456')).toBe(false); // Too short
    expect(validatePhone('00123456789')).toBe(false); // Wrong prefix
    expect(validatePhone('abcdefghij')).toBe(false); // Not numbers
  });

  it('should return false for empty input', () => {
    expect(validatePhone('')).toBe(false);
  });
});

describe('validateUrl', () => {
  it('should return true for valid URLs', () => {
    expect(validateUrl('https://example.com')).toBe(true);
    expect(validateUrl('http://example.com/path')).toBe(true);
    expect(validateUrl('https://sub.domain.com/path?query=value')).toBe(true);
  });

  it('should return false for invalid URLs', () => {
    expect(validateUrl('not-a-url')).toBe(false);
    expect(validateUrl('ftp://example.com')).toBe(false); // Only http/https
    expect(validateUrl('//no-protocol.com')).toBe(false);
  });

  it('should return false for empty input', () => {
    expect(validateUrl('')).toBe(false);
  });
});

describe('validatePostalCode', () => {
  it('should return true for valid French postal codes', () => {
    expect(validatePostalCode('75001')).toBe(true); // Paris
    expect(validatePostalCode('13001')).toBe(true); // Marseille
    expect(validatePostalCode('69001')).toBe(true); // Lyon
    expect(validatePostalCode('97100')).toBe(true); // DOM
  });

  it('should return false for invalid postal codes', () => {
    expect(validatePostalCode('00000')).toBe(false); // Invalid department
    expect(validatePostalCode('99999')).toBe(false); // Invalid department
    expect(validatePostalCode('7500')).toBe(false); // Too short
    expect(validatePostalCode('750011')).toBe(false); // Too long
    expect(validatePostalCode('ABCDE')).toBe(false); // Not numbers
  });
});

describe('validateUUID', () => {
  it('should return true for valid UUID v4', () => {
    expect(validateUUID('550e8400-e29b-41d4-a716-446655440000')).toBe(true);
    expect(validateUUID('6ba7b810-9dad-41d1-80b4-00c04fd430c8')).toBe(true);
  });

  it('should return false for invalid UUIDs', () => {
    expect(validateUUID('not-a-uuid')).toBe(false);
    expect(validateUUID('550e8400-e29b-11d4-a716-446655440000')).toBe(false); // v1, not v4
    expect(validateUUID('550e8400-e29b-41d4-c716-446655440000')).toBe(false); // Wrong variant
  });
});
