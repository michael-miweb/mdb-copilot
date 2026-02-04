# Story 10.3: Guide fiscalite MDB - Plus-value et regimes

Status: ready-for-dev

## Story

As a utilisateur,
I want consulter les regles de plus-value et les regimes d'imposition,
so that j'anticipe la fiscalite globale de mes operations.

## Acceptance Criteria

**Given** l'ecran Guide Fiscalite
**When** l'utilisateur consulte la section plus-value professionnelle
**Then** les regles de calcul et d'imposition sont detaillees
**And** les abattements et exonerations sont expliques

**Given** l'ecran Guide Fiscalite
**When** l'utilisateur consulte les regimes d'imposition
**Then** les differents regimes applicables sont listes (micro-BIC, reel simplifie, etc.)
**And** les conditions et seuils de chaque regime sont precises

## Tasks / Subtasks

### Content Tasks
- [ ] Write plus-value professionnelle guide content
  - [ ] Calculation method for professional capital gains
  - [ ] Tax rates applicable
  - [ ] Holding period considerations
  - [ ] Allowances and exemptions
- [ ] Write tax regimes comparison content
  - [ ] Micro-BIC: conditions, thresholds, flat-rate deduction
  - [ ] Reel simplifie: conditions, deductible expenses
  - [ ] Reel normal: when applicable
  - [ ] Comparison table of regimes
- [ ] Create decision tree for regime selection
- [ ] Add practical examples for each regime
- [ ] Store content in `packages/shared/src/content/guides/`

### Backend Tasks
- [ ] Add `GET /api/guides/plus-value` endpoint
- [ ] Add `GET /api/guides/regimes` endpoint
- [ ] Seed guide content data

### Frontend Tasks (Mobile - React Native)
- [ ] Create `PlusValueGuideSection` component
  - [ ] Calculation breakdown
  - [ ] Tax rate table
  - [ ] Exemption conditions
- [ ] Create `TaxRegimesSection` component
  - [ ] Regime cards with key info
  - [ ] Threshold indicators
  - [ ] Pros/cons for each
- [ ] Create `RegimeComparisonTable` component
- [ ] Create `RegimeDecisionTree` interactive component
- [ ] Add to FiscalGuideScreen navigation
- [ ] Write component tests

### Frontend Tasks (Web - React)
- [ ] Create `PlusValueGuideSection` MUI component
- [ ] Create `TaxRegimesSection` MUI component
- [ ] Create `RegimeComparisonTable` MUI component (full width)
- [ ] Create interactive regime selector tool
- [ ] Write component tests

### Shared Package Tasks
- [ ] Add types: `TaxRegime`, `PlusValueCalculation`, `RegimeThreshold`
- [ ] Store regime thresholds as constants (updated yearly)
- [ ] Add regime comparison utility functions

## Dev Notes

### Architecture Reference
- Content stored statically for offline access
- Regime thresholds should be easily updatable (constants file)
- Decision tree helps users select appropriate regime
- Links to official government resources where appropriate

### Tax Regimes Overview
```typescript
const TAX_REGIMES = {
  microBic: {
    name: 'Micro-BIC',
    threshold: 77700, // euros (2024)
    flatRateDeduction: 0.50, // 50% for services
    description: 'Simplified regime for small businesses',
  },
  reelSimplifie: {
    name: 'Reel Simplifie',
    threshold: 254000, // euros
    description: 'Actual expenses deductible',
  },
  reelNormal: {
    name: 'Reel Normal',
    threshold: null, // No upper limit
    description: 'Full accounting required',
  },
};
```

### Plus-Value Calculation
```typescript
// Professional capital gain
const plusValue = resalePrice - (purchasePrice + works + fees);
// Subject to income tax + social charges
// Potential exemptions based on holding period, reinvestment, etc.
```

### Content Sections
1. Plus-value professionnelle
   - Definition and calculation
   - Tax treatment
   - Exemptions (reinvestment, retirement, etc.)
2. Tax regimes
   - Micro-BIC advantages/disadvantages
   - Reel simplifie: when to choose
   - Transition between regimes
3. Regime comparison table
4. Decision helper

### References
- [Source: epics.md#Story 10.3]
- [Source: prd.md#FR61 - Regles plus-value professionnelle]
- [Source: prd.md#FR62 - Regimes d'imposition applicables]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
