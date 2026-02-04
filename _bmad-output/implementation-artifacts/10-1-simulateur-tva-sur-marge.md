# Story 10.1: Simulateur TVA sur marge

Status: ready-for-dev

## Story

As a utilisateur,
I want simuler la TVA sur marge pour une operation,
so that je maitrise l'impact fiscal avant de faire une offre.

## Acceptance Criteria

**Given** l'ecran simulateur TVA
**When** l'utilisateur saisit : prix d'achat, montant travaux, frais (notaire, agence)
**Then** le systeme calcule automatiquement la base TVA et la TVA due a la revente
**And** le calcul distingue TVA sur marge vs TVA sur total selon le cas

**Given** les parametres saisis
**When** l'utilisateur modifie le prix de revente
**Then** le calcul se met a jour en temps reel
**And** la marge nette apres TVA est affichee

**Given** le simulateur
**When** l'utilisateur souhaite comparer des scenarios
**Then** il peut sauvegarder un scenario et en creer un nouveau
**And** les scenarios sont comparables cote a cote

## Tasks / Subtasks

### Backend Tasks
- [ ] Create `TvaCalculatorService` in `backend-api/app/Services/`
  - [ ] Implement TVA sur marge calculation
  - [ ] Implement TVA sur total calculation
  - [ ] Determine applicable regime based on inputs
- [ ] Create migration for `tva_scenarios` table
  - [ ] Fields: id (UUID), property_id, name, purchase_price, works_amount, notary_fees, agency_fees, resale_price, created_at, updated_at
- [ ] Create `TvaScenario` model
- [ ] Create `TvaScenarioController` with CRUD endpoints
  - [ ] `POST /api/tva-scenarios` - create scenario
  - [ ] `GET /api/tva-scenarios` - list user scenarios
  - [ ] `PUT /api/tva-scenarios/{id}` - update scenario
  - [ ] `DELETE /api/tva-scenarios/{id}` - delete scenario
- [ ] Add `POST /api/tva/calculate` endpoint for real-time calculation
- [ ] Write unit tests for TVA calculations
- [ ] Write feature tests for scenario endpoints

### Frontend Tasks (Mobile - React Native)
- [ ] Create `TvaSimulatorScreen` screen
- [ ] Create `TvaInputForm` component
  - [ ] Purchase price input (cents, formatted as euros)
  - [ ] Works amount input
  - [ ] Notary fees input (with default % option)
  - [ ] Agency fees input
  - [ ] Resale price input
- [ ] Create `TvaResultCard` component
  - [ ] Display base TVA
  - [ ] Display TVA due
  - [ ] Display net margin
  - [ ] Indicate TVA regime used
- [ ] Implement real-time calculation on input change
- [ ] Create `ScenarioListScreen` for saved scenarios
- [ ] Create `ScenarioComparisonView` for side-by-side comparison
- [ ] Add scenario save/load functionality
- [ ] Add navigation to simulator from property detail
- [ ] Write component tests

### Frontend Tasks (Web - React)
- [ ] Create `TvaSimulatorPage` page
- [ ] Create `TvaInputForm` MUI component
- [ ] Create `TvaResultCard` MUI component
- [ ] Create `ScenarioComparisonTable` for desktop comparison
- [ ] Implement real-time calculation
- [ ] Add scenario management
- [ ] Write component tests

### Shared Package Tasks
- [ ] Add TVA types: `TvaScenario`, `TvaCalculation`, `TvaRegime`
- [ ] Add TVA calculation pure functions for client-side preview
- [ ] Add money formatting utilities

## Dev Notes

### Architecture Reference
- All monetary values stored in cents (int) - CLAUDE.md convention
- TVA calculation can be done client-side for real-time preview
- Server validates and persists scenarios
- Scenarios linked to property_id (optional) for context

### TVA Calculation Logic
```typescript
// TVA sur marge (20% on margin only)
const tvaMargin = (resalePrice - purchasePrice) * 0.20;

// TVA sur total (20% on full resale)
const tvaTotal = resalePrice * 0.20;

// Net margin
const netMargin = resalePrice - purchasePrice - works - fees - tva;
```

### TVA Regime Determination
- TVA sur marge: applicable when purchasing from non-VAT-registered seller
- TVA sur total: applicable for new constructions or renovations > 25% value

### Input Validation
- All amounts must be positive
- Resale price should typically be > purchase price + costs
- Show warning if margin is negative

### References
- [Source: epics.md#Story 10.1]
- [Source: prd.md#FR57-FR59 - Simulateur TVA sur marge]
- [Source: CLAUDE.md - Monetary values in cents]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
