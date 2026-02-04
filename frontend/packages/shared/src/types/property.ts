// Property types for MDB Copilot

import type { SyncStatus } from './index';

/**
 * Property type classification
 */
export type PropertyType = 'apartment' | 'house' | 'building' | 'land' | 'commercial' | 'other';

/**
 * Sale urgency level
 */
export type SaleUrgency = 'low' | 'medium' | 'high' | 'unknown';

/**
 * Pipeline status for property tracking
 */
export type PipelineStatus =
  | 'prospection'
  | 'rdv'
  | 'visite'
  | 'analyse'
  | 'offre'
  | 'achete'
  | 'travaux'
  | 'vente'
  | 'vendu'
  | 'no-go';

/**
 * Property entity (fiche annonce)
 */
export interface Property {
  id: string; // UUID v4
  userId: string;
  title: string;
  address: string;
  city: string;
  postalCode: string;
  surface: number; // m²
  price: number; // centimes
  propertyType: PropertyType;
  saleUrgency: SaleUrgency;
  pipelineStatus: PipelineStatus;
  description: string | null;
  notes: string | null;
  sourceUrl: string | null;
  contactId: string | null;
  visitDate: string | null; // ISO 8601
  createdAt: string; // ISO 8601
  updatedAt: string; // ISO 8601
  syncStatus: SyncStatus;
}

/**
 * Property for creation
 */
export interface CreatePropertyInput {
  title: string;
  address: string;
  city: string;
  postalCode: string;
  surface: number;
  price: number;
  propertyType: PropertyType;
  saleUrgency?: SaleUrgency;
  pipelineStatus?: PipelineStatus;
  description?: string | null;
  notes?: string | null;
  sourceUrl?: string | null;
  contactId?: string | null;
  visitDate?: string | null;
}

/**
 * Property for update (partial)
 */
export type UpdatePropertyInput = Partial<CreatePropertyInput>;
