# Story 0.2: Configuration du package shared

Status: done

## Story

As a développeur,
I want configurer le package @mdb/shared avec les types, utilitaires et client API partagés,
so that le code commun entre mobile et web est centralisé et typé.

## Acceptance Criteria

1. **Given** le package `frontend/packages/shared/` initialisé
   **When** le développeur configure le package
   **Then** le `tsconfig.json` est configuré en strict mode

2. **Given** le package shared
   **When** les types de base sont créés
   **Then** le package exporte des types : `User`, `Property`, `Contact`, `ApiResponse`

3. **Given** le package shared
   **When** les utilitaires sont créés
   **Then** le package exporte : `formatMoney()`, `formatDate()`, `validateEmail()`

4. **Given** le package shared
   **When** il est référencé depuis `frontend/apps/mobile/` et `frontend/apps/web/`
   **Then** le package est importable via `@mdb/shared`

5. **Given** les utilitaires
   **When** les tests sont exécutés
   **Then** les tests unitaires passent (`pnpm test`)

## Tasks / Subtasks

- [x] Task 1: Configurer TypeScript strict (AC: #1)
  - [x] Configurer `tsconfig.json` avec `strict: true`
  - [x] Activer `noImplicitAny`, `strictNullChecks`
  - [x] Note: declaration/outDir non nécessaires (package consommé comme source via workspace)

- [x] Task 2: Créer les types de base (AC: #2)
  - [x] `src/types/user.ts` — User, UserRole
  - [x] `src/types/property.ts` — Property, PropertyType, SaleUrgency, PipelineStatus
  - [x] `src/types/contact.ts` — Contact, ContactType
  - [x] `src/types/api.ts` — ApiResponse, ApiError, PaginatedResponse
  - [x] `src/types/index.ts` — export all

- [x] Task 3: Créer les utilitaires (AC: #3)
  - [x] `src/utils/formatters.ts` — formatMoney (centimes → €), formatDate (ISO → locale)
  - [x] `src/utils/validators.ts` — validateEmail, validatePhone, validateUrl
  - [x] `src/utils/dateUtils.ts` — parseISODate, toISOString, isExpired
  - [x] `src/utils/moneyUtils.ts` — eurosToCents, centsToEuros
  - [x] `src/utils/index.ts` — export all

- [x] Task 4: Configurer les exports (AC: #4)
  - [x] `src/index.ts` — barrel export types + utils + constants
  - [x] `package.json` — configurer `main`, `types`, `exports`
  - [x] Vérifier import depuis `apps/mobile/`
  - [x] Vérifier import depuis `apps/web/`

- [x] Task 5: Écrire les tests (AC: #5)
  - [x] Configurer Vitest dans `packages/shared/`
  - [x] Tests pour `formatMoney()`
  - [x] Tests pour `formatDate()`
  - [x] Tests pour `validateEmail()`
  - [x] Tests pour conversions money (centimes ↔ euros)
  - [x] Tests pour `generateUUID()` (ajoutés en code review)
  - [x] `pnpm test` passe (57 tests)

## Dev Notes

### Type Definitions

```typescript
// User types
interface User {
  id: string; // UUID v4
  firstName: string;
  lastName: string;
  email: string;
  role: UserRole;
  createdAt: string; // ISO 8601
  updatedAt: string;
}

type UserRole = 'owner' | 'guest-read' | 'guest-extended';

// Property types
interface Property {
  id: string;
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
  visitDate: string | null;
  createdAt: string;
  updatedAt: string;
  syncStatus: SyncStatus;
}

// Contact types (also has syncStatus for offline sync)
interface Contact {
  // ... fields ...
  syncStatus: SyncStatus;
}

type PropertyType = 'apartment' | 'house' | 'building' | 'land' | 'commercial' | 'other';
type SaleUrgency = 'low' | 'medium' | 'high' | 'unknown';
type PipelineStatus = 'prospection' | 'rdv' | 'visite' | 'analyse' | 'offre' | 'achete' | 'travaux' | 'vente' | 'vendu' | 'no-go';
type SyncStatus = 'pending' | 'synced' | 'conflict' | 'error';
```

### Utility Functions

```typescript
// Money formatting (centimes → display)
formatMoney(150000) // "1 500,00 €"
formatMoney(150000, { locale: 'fr-FR', currency: 'EUR' })

// Date formatting
formatDate('2026-02-03T14:30:00Z') // "3 février 2026"
formatDate('2026-02-03T14:30:00Z', { format: 'short' }) // "03/02/2026"

// Validation
validateEmail('test@example.com') // true
validateEmail('invalid') // false
```

### Project Structure Notes
- Package name: `@mdb/shared`
- Consumed by both mobile and web apps
- Build to ESM format for tree-shaking
- No React dependencies (pure TypeScript)

### References
- [Source: architecture.md#Implementation Patterns]
- [Source: architecture.md#Package Shared Structure]
- [Source: epics.md#Story 0.2]

## Dev Agent Record

### Agent Model Used
Claude Opus 4.5 (claude-opus-4-5-20251101)

### Completion Notes List
- Configured TypeScript strict mode with all recommended flags
- Created comprehensive type definitions for User, Property, Contact, and API types
- Implemented utility functions with French locale support (fr-FR)
- Added extra validators: validatePostalCode (French postal codes with DOM-TOM support), validateUUID (v4)
- Added extra date utils: daysAgo(), isWithinDays(), toDateOnly()
- Added extra money utils: pricePerM2(), calculateMargin(), calculatePercentage()
- Used Vitest instead of Jest (already configured in Story 0.1)
- Fixed postal code validation for DOM-TOM codes (971-976) after initial test failure

**Code Review Fixes (2026-02-04):**
- Restructured monorepo: apps/ et packages/ déplacés dans frontend/
- Added tests for uuid.ts (5 tests)
- Fixed tsconfig.json: removed unused declaration/declarationMap/outDir/rootDir (noEmit makes them ineffective)
- Added syncStatus to Contact type for offline sync consistency
- Improved uuid.ts fallback: added crypto.getRandomValues check + error on unavailable crypto
- Added edge case tests for formatSurface (zero, decimal)
- All 57 tests pass, typecheck passes for all 3 packages

### File List
**Restructuration monorepo:**
- pnpm-workspace.yaml (updated: frontend/apps/*, frontend/packages/*)
- CLAUDE.md (updated: nouvelle structure)

**Package shared (frontend/packages/shared/):**
- tsconfig.json (updated: removed unused options)
- package.json (updated exports)
- src/index.ts (updated)
- src/types/index.ts (created)
- src/types/user.ts (created)
- src/types/property.ts (created)
- src/types/contact.ts (created, updated: +syncStatus)
- src/types/api.ts (created)
- src/utils/index.ts (created)
- src/utils/formatters.ts (created)
- src/utils/validators.ts (created)
- src/utils/dateUtils.ts (created)
- src/utils/moneyUtils.ts (created)
- src/utils/uuid.ts (created, updated: +crypto check)
- src/utils/formatters.test.ts (created, updated: +edge cases)
- src/utils/validators.test.ts (created)
- src/utils/dateUtils.test.ts (created)
- src/utils/moneyUtils.test.ts (created)
- src/utils/uuid.test.ts (created)
- src/utils/index.test.ts (deleted: replaced by individual test files)
