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
