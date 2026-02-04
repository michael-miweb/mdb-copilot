# Story 0.2: Configuration du package shared

Status: ready-for-dev

## Story

As a développeur,
I want configurer le package @mdb/shared avec les types, utilitaires et client API partagés,
so that le code commun entre mobile et web est centralisé et typé.

## Acceptance Criteria

1. **Given** le package `packages/shared/` initialisé
   **When** le développeur configure le package
   **Then** le `tsconfig.json` est configuré en strict mode

2. **Given** le package shared
   **When** les types de base sont créés
   **Then** le package exporte des types : `User`, `Property`, `Contact`, `ApiResponse`

3. **Given** le package shared
   **When** les utilitaires sont créés
   **Then** le package exporte : `formatMoney()`, `formatDate()`, `validateEmail()`

4. **Given** le package shared
   **When** il est référencé depuis `apps/mobile/` et `apps/web/`
   **Then** le package est importable via `@mdb/shared`

5. **Given** les utilitaires
   **When** les tests sont exécutés
   **Then** les tests unitaires passent (`pnpm test`)

## Tasks / Subtasks

- [ ] Task 1: Configurer TypeScript strict (AC: #1)
  - [ ] Configurer `tsconfig.json` avec `strict: true`
  - [ ] Activer `noImplicitAny`, `strictNullChecks`
  - [ ] Configurer `declaration: true` pour générer `.d.ts`
  - [ ] Configurer build output dans `dist/`

- [ ] Task 2: Créer les types de base (AC: #2)
  - [ ] `src/types/user.ts` — User, UserRole
  - [ ] `src/types/property.ts` — Property, PropertyType, SaleUrgency, PipelineStatus
  - [ ] `src/types/contact.ts` — Contact, ContactType
  - [ ] `src/types/api.ts` — ApiResponse, ApiError, PaginatedResponse
  - [ ] `src/types/index.ts` — export all

- [ ] Task 3: Créer les utilitaires (AC: #3)
  - [ ] `src/utils/formatters.ts` — formatMoney (centimes → €), formatDate (ISO → locale)
  - [ ] `src/utils/validators.ts` — validateEmail, validatePhone, validateUrl
  - [ ] `src/utils/dateUtils.ts` — parseISODate, toISOString, isExpired
  - [ ] `src/utils/moneyUtils.ts` — eurosToCents, centsToEuros
  - [ ] `src/utils/index.ts` — export all

- [ ] Task 4: Configurer les exports (AC: #4)
  - [ ] `src/index.ts` — barrel export types + utils + constants
  - [ ] `package.json` — configurer `main`, `types`, `exports`
  - [ ] Vérifier import depuis `apps/mobile/`
  - [ ] Vérifier import depuis `apps/web/`

- [ ] Task 5: Écrire les tests (AC: #5)
  - [ ] Configurer Jest dans `packages/shared/`
  - [ ] Tests pour `formatMoney()`
  - [ ] Tests pour `formatDate()`
  - [ ] Tests pour `validateEmail()`
  - [ ] Tests pour conversions money (centimes ↔ euros)
  - [ ] `pnpm test` passe

## Dev Notes

### Type Definitions

```typescript
// User types
interface User {
  id: string; // UUID v4
  firstName: string;
  lastName: string;
  email: string;
  createdAt: string; // ISO 8601
  updatedAt: string;
}

type UserRole = 'owner' | 'guest-read' | 'guest-extended';

// Property types
interface Property {
  id: string;
  userId: string;
  address: string;
  surface: number; // m²
  price: number; // centimes
  propertyType: PropertyType;
  saleUrgency: SaleUrgency;
  pipelineStatus: PipelineStatus;
  notes: string | null;
  contactId: string | null;
  createdAt: string;
  updatedAt: string;
  syncStatus: SyncStatus;
}

type PropertyType = 'apartment' | 'house' | 'building' | 'land' | 'commercial' | 'other';
type SaleUrgency = 'low' | 'medium' | 'high' | 'unknown';
type PipelineStatus = 'prospection' | 'rdv' | 'visite' | 'analyse' | 'offre' | 'achete' | 'travaux' | 'vente' | 'vendu' | 'no-go';
type SyncStatus = 'synced' | 'pending' | 'error';
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
{{agent_model_name_version}}

### Completion Notes List

### File List
