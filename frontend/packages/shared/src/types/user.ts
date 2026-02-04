// User types for MDB Copilot

/**
 * User role defining access permissions
 * - owner: Full access to all features
 * - guest-read: Read-only access to shared data
 * - guest-extended: Extended guest access (can submit quotes)
 */
export type UserRole = 'owner' | 'guest-read' | 'guest-extended';

/**
 * User entity
 */
export interface User {
  id: string; // UUID v4
  firstName: string;
  lastName: string;
  email: string;
  role: UserRole;
  createdAt: string; // ISO 8601
  updatedAt: string; // ISO 8601
}

/**
 * User for creation (without id and timestamps)
 */
export interface CreateUserInput {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
}

/**
 * User for update (partial)
 */
export interface UpdateUserInput {
  firstName?: string;
  lastName?: string;
  email?: string;
}
