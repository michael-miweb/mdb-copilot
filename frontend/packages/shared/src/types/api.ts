// API types for MDB Copilot

/**
 * Standard API response wrapper
 */
export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
}

/**
 * API error response
 */
export interface ApiError {
  success: false;
  message: string;
  errors?: Record<string, string[]>;
  code?: string;
}

/**
 * Paginated response for list endpoints
 */
export interface PaginatedResponse<T> {
  success: boolean;
  data: T[];
  meta: {
    currentPage: number;
    lastPage: number;
    perPage: number;
    total: number;
  };
  links: {
    first: string | null;
    last: string | null;
    prev: string | null;
    next: string | null;
  };
}

/**
 * Sync request payload
 */
export interface SyncRequest {
  lastSyncedAt: string | null; // ISO 8601
  changes: SyncChange[];
}

/**
 * Individual sync change
 */
export interface SyncChange {
  entity: 'property' | 'contact';
  action: 'create' | 'update' | 'delete';
  id: string;
  data?: Record<string, unknown>;
  updatedAt: string;
}

/**
 * Sync response
 */
export interface SyncResponse {
  success: boolean;
  serverChanges: SyncChange[];
  conflicts: SyncConflict[];
  syncedAt: string; // ISO 8601
}

/**
 * Sync conflict when local and server changes conflict
 */
export interface SyncConflict {
  entity: 'property' | 'contact';
  id: string;
  localData: Record<string, unknown>;
  serverData: Record<string, unknown>;
  resolution: 'server-wins' | 'local-wins' | 'manual';
}
