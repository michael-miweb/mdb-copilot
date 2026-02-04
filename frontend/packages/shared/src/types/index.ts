// Shared TypeScript types for MDB Copilot

// Base types
/**
 * Sync status for offline-first entities
 */
export type SyncStatus = 'pending' | 'synced' | 'conflict' | 'error';

/**
 * Base entity with UUID and timestamps
 */
export interface BaseEntity {
  id: string; // UUID v4
  createdAt: string; // ISO 8601
  updatedAt: string; // ISO 8601
}

/**
 * Base syncable entity with sync metadata
 */
export interface SyncableEntity extends BaseEntity {
  syncStatus: SyncStatus;
  lastSyncedAt: string | null;
}

// User types
export type { User, UserRole, CreateUserInput, UpdateUserInput } from './user';

// Property types
export type {
  Property,
  PropertyType,
  SaleUrgency,
  PipelineStatus,
  CreatePropertyInput,
  UpdatePropertyInput,
} from './property';

// Contact types
export type {
  Contact,
  ContactType,
  CreateContactInput,
  UpdateContactInput,
} from './contact';

// API types
export type {
  ApiResponse,
  ApiError,
  PaginatedResponse,
  SyncRequest,
  SyncChange,
  SyncResponse,
  SyncConflict,
} from './api';
