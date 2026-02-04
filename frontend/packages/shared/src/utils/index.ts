// Shared utility functions for MDB Copilot

// UUID generation
export { generateUUID } from './uuid';

// Formatters
export { formatMoney, formatDate, formatSurface } from './formatters';
export type { FormatMoneyOptions, FormatDateOptions } from './formatters';

// Validators
export {
  validateEmail,
  validatePhone,
  validateUrl,
  validatePostalCode,
  validateUUID,
} from './validators';

// Date utilities
export {
  parseISODate,
  toISOString,
  nowISO,
  isExpired,
  isWithinDays,
  daysAgo,
  toDateOnly,
} from './dateUtils';

// Money utilities
export {
  eurosToCents,
  centsToEuros,
  centsToEurosString,
  pricePerM2,
  calculateMargin,
  calculatePercentage,
} from './moneyUtils';
