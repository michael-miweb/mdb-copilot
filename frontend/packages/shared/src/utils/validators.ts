// Validation utilities for MDB Copilot

/**
 * Validate email address format
 * @param email Email to validate
 * @returns true if valid email format
 */
export function validateEmail(email: string): boolean {
  if (!email || typeof email !== 'string') {
    return false;
  }
  // RFC 5322 simplified pattern
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email.trim());
}

/**
 * Validate French phone number format
 * @param phone Phone number to validate
 * @returns true if valid French phone format
 */
export function validatePhone(phone: string): boolean {
  if (!phone || typeof phone !== 'string') {
    return false;
  }
  // French phone: 01-09 prefix, 10 digits, with or without spaces/dots/dashes
  const cleaned = phone.replace(/[\s.\-()]/g, '');

  // French mobile/landline: 0X XX XX XX XX or +33 X XX XX XX XX
  const frenchRegex = /^(?:(?:\+33|0033|0)[1-9])(?:\d{8})$/;
  return frenchRegex.test(cleaned);
}

/**
 * Validate URL format
 * @param url URL to validate
 * @returns true if valid URL format
 */
export function validateUrl(url: string): boolean {
  if (!url || typeof url !== 'string') {
    return false;
  }
  try {
    const parsed = new URL(url);
    return ['http:', 'https:'].includes(parsed.protocol);
  } catch {
    return false;
  }
}

/**
 * Validate postal code (French format)
 * @param postalCode Postal code to validate
 * @returns true if valid French postal code
 */
export function validatePostalCode(postalCode: string): boolean {
  if (!postalCode || typeof postalCode !== 'string') {
    return false;
  }
  const trimmed = postalCode.trim();
  // Must be exactly 5 digits
  if (!/^\d{5}$/.test(trimmed)) {
    return false;
  }
  const dept = parseInt(trimmed.substring(0, 2), 10);
  const deptThree = parseInt(trimmed.substring(0, 3), 10);

  // Metropolitan France: 01-95 (20 is Corsica 2A/2B, handled as 20xxx)
  if (dept >= 1 && dept <= 95) {
    return true;
  }
  // DOM-TOM: 971-976 (Guadeloupe, Martinique, Guyane, Réunion, Mayotte)
  if (deptThree >= 971 && deptThree <= 976) {
    return true;
  }
  // Monaco: 980xx
  if (deptThree >= 980 && deptThree <= 989) {
    return true;
  }
  return false;
}

/**
 * Validate UUID v4 format
 * @param uuid UUID to validate
 * @returns true if valid UUID v4 format
 */
export function validateUUID(uuid: string): boolean {
  if (!uuid || typeof uuid !== 'string') {
    return false;
  }
  const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
  return uuidRegex.test(uuid);
}
