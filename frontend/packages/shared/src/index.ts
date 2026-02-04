// @mdb/shared - Shared code for MDB Copilot
// Types, utilities, and constants for mobile and web apps

// ============================================
// Types
// ============================================
export type {
  // Base types
  BaseEntity,
  SyncableEntity,
  SyncStatus,
  // User types
  User,
  UserRole,
  CreateUserInput,
  UpdateUserInput,
  // Property types
  Property,
  PropertyType,
  SaleUrgency,
  PipelineStatus,
  CreatePropertyInput,
  UpdatePropertyInput,
  // Contact types
  Contact,
  ContactType,
  CreateContactInput,
  UpdateContactInput,
  // API types
  ApiResponse,
  ApiError,
  PaginatedResponse,
  SyncRequest,
  SyncChange,
  SyncResponse,
  SyncConflict,
} from './types';

// ============================================
// Utils
// ============================================
export {
  // UUID
  generateUUID,
  // Formatters
  formatMoney,
  formatDate,
  formatSurface,
  // Validators
  validateEmail,
  validatePhone,
  validateUrl,
  validatePostalCode,
  validateUUID,
  // Date utilities
  parseISODate,
  toISOString,
  nowISO,
  isExpired,
  isWithinDays,
  daysAgo,
  toDateOnly,
  // Money utilities
  eurosToCents,
  centsToEuros,
  centsToEurosString,
  pricePerM2,
  calculateMargin,
  calculatePercentage,
} from './utils';

export type { FormatMoneyOptions, FormatDateOptions } from './utils';

// ============================================
// Constants
// ============================================
export { API_CONFIG, LIGHT_THEME, DARK_THEME, SYNC_CONFIG } from './constants';

// ============================================
// Theme / Design Tokens
// ============================================
export { colors, spacing, borderRadius } from './theme';
export type { ColorMode, Colors, Spacing, BorderRadius } from './theme';

// ============================================
// Test Utils
// ============================================
// NOTE: Test utilities are NOT exported from main index to prevent
// accidental inclusion in production bundles. Import from:
//   import { createMockFetch, ... } from '@mdb/shared/test-utils';
// See: packages/shared/src/test-utils/index.ts
