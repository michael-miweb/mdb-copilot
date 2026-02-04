// Money utilities for MDB Copilot
// All amounts stored in centimes (integer) to avoid floating point issues

/**
 * Convert euros to centimes (for storage)
 * @param euros Amount in euros (e.g., 1500.50)
 * @returns Amount in centimes (e.g., 150050)
 */
export function eurosToCents(euros: number): number {
  return Math.round(euros * 100);
}

/**
 * Convert centimes to euros (for calculations)
 * @param centimes Amount in centimes
 * @returns Amount in euros
 */
export function centsToEuros(centimes: number): number {
  return centimes / 100;
}

/**
 * Convert centimes to euros string with 2 decimals
 * @param centimes Amount in centimes
 * @returns String with 2 decimal places (e.g., "1500.50")
 */
export function centsToEurosString(centimes: number): string {
  return (centimes / 100).toFixed(2);
}

/**
 * Calculate price per m²
 * @param priceCentimes Price in centimes
 * @param surfaceM2 Surface in m²
 * @returns Price per m² in centimes
 */
export function pricePerM2(priceCentimes: number, surfaceM2: number): number {
  if (surfaceM2 <= 0) {
    return 0;
  }
  return Math.round(priceCentimes / surfaceM2);
}

/**
 * Calculate margin (selling price - buying price - costs)
 * @param sellingPriceCentimes Selling price in centimes
 * @param buyingPriceCentimes Buying price in centimes
 * @param costsCentimes Additional costs in centimes
 * @returns Margin in centimes
 */
export function calculateMargin(
  sellingPriceCentimes: number,
  buyingPriceCentimes: number,
  costsCentimes = 0
): number {
  return sellingPriceCentimes - buyingPriceCentimes - costsCentimes;
}

/**
 * Calculate percentage
 * @param part Part value
 * @param total Total value
 * @returns Percentage (0-100)
 */
export function calculatePercentage(part: number, total: number): number {
  if (total === 0) {
    return 0;
  }
  return Math.round((part / total) * 10000) / 100; // 2 decimal precision
}
