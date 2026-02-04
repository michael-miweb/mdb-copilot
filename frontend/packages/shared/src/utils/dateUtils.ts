// Date utilities for MDB Copilot

/**
 * Parse ISO 8601 date string to Date object
 * @param isoString ISO date string (e.g., "2026-02-03T14:30:00Z")
 * @returns Date object or null if invalid
 */
export function parseISODate(isoString: string): Date | null {
  if (!isoString || typeof isoString !== 'string') {
    return null;
  }
  const date = new Date(isoString);
  return isNaN(date.getTime()) ? null : date;
}

/**
 * Convert Date to ISO 8601 string
 * @param date Date object
 * @returns ISO string (e.g., "2026-02-03T14:30:00.000Z")
 */
export function toISOString(date: Date): string {
  return date.toISOString();
}

/**
 * Get current date as ISO string
 * @returns Current date/time as ISO string
 */
export function nowISO(): string {
  return new Date().toISOString();
}

/**
 * Check if a date is in the past (expired)
 * @param isoDate ISO date string to check
 * @returns true if date is in the past
 */
export function isExpired(isoDate: string): boolean {
  const date = parseISODate(isoDate);
  if (!date) {
    return false;
  }
  return date.getTime() < Date.now();
}

/**
 * Check if date is within last N days
 * @param isoDate ISO date string
 * @param days Number of days
 * @returns true if date is within last N days
 */
export function isWithinDays(isoDate: string, days: number): boolean {
  const date = parseISODate(isoDate);
  if (!date) {
    return false;
  }
  const cutoff = Date.now() - days * 24 * 60 * 60 * 1000;
  return date.getTime() >= cutoff;
}

/**
 * Get date string for N days ago
 * @param days Number of days ago
 * @returns ISO date string
 */
export function daysAgo(days: number): string {
  const date = new Date();
  date.setDate(date.getDate() - days);
  return date.toISOString();
}

/**
 * Format date to ISO date only (YYYY-MM-DD)
 * @param date Date object or ISO string
 * @returns Date string in YYYY-MM-DD format
 */
export function toDateOnly(date: Date | string): string {
  const d = typeof date === 'string' ? new Date(date) : date;
  return d.toISOString().split('T')[0];
}
