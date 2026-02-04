// Contact types for MDB Copilot (carnet d'adresses)

import type { SyncStatus } from './index';

/**
 * Contact type classification
 */
export type ContactType =
  | 'seller' // Vendeur
  | 'agent' // Agent immobilier
  | 'notary' // Notaire
  | 'artisan' // Artisan (plombier, électricien, etc.)
  | 'bank' // Banque / courtier
  | 'partner' // Associé
  | 'other';

/**
 * Contact entity (carnet d'adresses)
 */
export interface Contact {
  id: string; // UUID v4
  userId: string;
  firstName: string;
  lastName: string;
  email: string | null;
  phone: string | null;
  company: string | null;
  contactType: ContactType;
  notes: string | null;
  createdAt: string; // ISO 8601
  updatedAt: string; // ISO 8601
  syncStatus: SyncStatus;
}

/**
 * Contact for creation
 */
export interface CreateContactInput {
  firstName: string;
  lastName: string;
  email?: string | null;
  phone?: string | null;
  company?: string | null;
  contactType: ContactType;
  notes?: string | null;
}

/**
 * Contact for update (partial)
 */
export type UpdateContactInput = Partial<CreateContactInput>;
