// Formatting utilities for MDB Copilot

export interface FormatMoneyOptions {
  locale?: string;
  currency?: string;
  showSymbol?: boolean;
}

/**
 * Format money from centimes to display string
 * @param centimes Amount in centimes (e.g., 150000 = 1500,00 €)
 * @param options Formatting options
 * @returns Formatted string (e.g., "1 500,00 €")
 */
export function formatMoney(
  centimes: number,
  options: FormatMoneyOptions = {}
): string {
  const { locale = 'fr-FR', currency = 'EUR', showSymbol = true } = options;
  const euros = centimes / 100;

  if (showSymbol) {
    return new Intl.NumberFormat(locale, {
      style: 'currency',
      currency,
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(euros);
  }

  return new Intl.NumberFormat(locale, {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(euros);
}

export interface FormatDateOptions {
  locale?: string;
  format?: 'short' | 'medium' | 'long' | 'full';
  includeTime?: boolean;
}

/**
 * Format ISO date string to localized display
 * @param isoDate ISO 8601 date string (e.g., "2026-02-03T14:30:00Z")
 * @param options Formatting options
 * @returns Formatted string (e.g., "3 février 2026")
 */
export function formatDate(
  isoDate: string,
  options: FormatDateOptions = {}
): string {
  const { locale = 'fr-FR', format = 'long', includeTime = false } = options;
  const date = new Date(isoDate);

  if (isNaN(date.getTime())) {
    return isoDate; // Return original if invalid
  }

  const dateStyleMap: Record<string, Intl.DateTimeFormatOptions['dateStyle']> = {
    short: 'short',
    medium: 'medium',
    long: 'long',
    full: 'full',
  };

  const formatOptions: Intl.DateTimeFormatOptions = {
    dateStyle: dateStyleMap[format],
  };

  if (includeTime) {
    formatOptions.timeStyle = 'short';
  }

  return new Intl.DateTimeFormat(locale, formatOptions).format(date);
}

/**
 * Format surface area in m²
 * @param surface Surface in m²
 * @param locale Locale for number formatting
 * @returns Formatted string (e.g., "150 m²")
 */
export function formatSurface(surface: number, locale = 'fr-FR'): string {
  return `${new Intl.NumberFormat(locale).format(surface)} m²`;
}
