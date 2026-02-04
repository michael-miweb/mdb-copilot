// Shared utility functions for MDB Copilot

/**
 * Generate a cryptographically secure UUID v4
 * Uses native crypto.randomUUID() for security
 */
export function generateUUID(): string {
  // Use native crypto API (available in modern browsers and Node 19+)
  if (typeof crypto !== 'undefined' && crypto.randomUUID) {
    return crypto.randomUUID();
  }
  // Fallback for older environments using crypto.getRandomValues
  const bytes = new Uint8Array(16);
  crypto.getRandomValues(bytes);
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // Version 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // Variant 1
  const hex = Array.from(bytes, (b) => b.toString(16).padStart(2, '0')).join('');
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
}

/**
 * Convert cents to euros formatted string
 */
export function centsToEuros(cents: number): string {
  return (cents / 100).toFixed(2);
}

/**
 * Convert euros to cents (for storage)
 */
export function eurosToCents(euros: number): number {
  return Math.round(euros * 100);
}

/**
 * Format date to ISO string without timezone
 */
export function formatDateISO(date: Date): string {
  return date.toISOString().split('T')[0];
}
