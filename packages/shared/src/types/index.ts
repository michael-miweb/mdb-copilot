// Shared TypeScript types for MDB Copilot

/**
 * Base entity with UUID and timestamps
 */
export interface BaseEntity {
  id: string; // UUID v4
  createdAt: Date;
  updatedAt: Date;
}

/**
 * Sync status for offline-first entities
 */
export type SyncStatus = 'pending' | 'synced' | 'conflict';

/**
 * Base syncable entity with sync metadata
 */
export interface SyncableEntity extends BaseEntity {
  syncStatus: SyncStatus;
  lastSyncedAt: Date | null;
}
