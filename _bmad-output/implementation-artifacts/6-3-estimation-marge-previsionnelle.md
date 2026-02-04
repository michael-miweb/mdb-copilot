# Story 6.3: Estimation de marge previsionnelle

Status: ready-for-dev

## Story

As a utilisateur,
I want voir une estimation de marge previsionnelle,
so that j'evalue rapidement la rentabilite potentielle.

## Acceptance Criteria

**Given** une synthese avec les donnees financieres de la fiche (prix annonce)
**When** le systeme calcule la marge previsionnelle
**Then** une estimation est affichee : prix achat estime + travaux estimes (base sur alertes) vs prix de revente estime
**And** la marge est affichee en euros et en pourcentage

**Given** des alertes travaux dans la synthese
**When** l'estimation travaux est calculee
**Then** chaque categorie d'alerte contribue a une fourchette de cout
**And** l'utilisateur peut ajuster manuellement les montants

## Tasks / Subtasks

### Backend API
- [ ] Add work_cost_estimates configuration (config/work-estimates.php)
- [ ] Create MarginEstimateService for calculation logic
- [ ] Add margin estimate fields to visit_summaries table
- [ ] Write tests for margin calculation

### Mobile App (React Native)
- [ ] Create MarginEstimateCard component with visual breakdown
- [ ] Create CostBreakdownSection showing purchase/works/resale
- [ ] Create EditableAmountInput for manual adjustment
- [ ] Create MarginPercentageIndicator (green/orange/red based on %)
- [ ] Implement calculateMarginEstimate service (offline capable)
- [ ] Add work cost estimation based on alerts
- [ ] Store user adjustments in local state
- [ ] Write unit tests for margin calculation
- [ ] Write integration tests for MarginEstimateCard

### Web App (React)
- [ ] Create MarginEstimateCard component
- [ ] Create CostBreakdownSection with editable fields
- [ ] Create EditableAmountInput with validation
- [ ] Create MarginPercentageIndicator
- [ ] Implement calculateMarginEstimate service
- [ ] Add inline editing for amounts
- [ ] Write tests for margin components

### Shared Package
- [ ] Add MarginEstimate type
- [ ] Add WorkCostEstimate type
- [ ] Add calculateMarginEstimate pure function
- [ ] Add estimateWorkCosts utility (based on alerts)
- [ ] Add formatCurrency utility (centimes to euros)

## Dev Notes

### Architecture Reference
- All amounts stored as centimes (int) per conventions
- Margin calculation runs client-side for offline support
- User adjustments override system estimates

### Margin Estimate Structure
```typescript
interface MarginEstimate {
  // Purchase side
  purchasePrice: number; // centimes
  notaryFees: number; // estimated 7-8%
  agencyFees: number; // if applicable

  // Works side
  workEstimates: WorkCostEstimate[];
  totalWorksCost: number; // sum of estimates

  // Resale side
  estimatedResalePrice: number; // user input or market estimate
  resaleAgencyFees: number; // if applicable

  // Result
  totalInvestment: number;
  grossMargin: number; // resale - investment
  marginPercentage: number; // gross / investment * 100

  // Metadata
  isUserAdjusted: boolean;
  adjustedFields: string[];
}

interface WorkCostEstimate {
  category: string;
  alertId?: string;
  description: string;
  lowEstimate: number; // centimes
  highEstimate: number; // centimes
  selectedEstimate: number; // user choice or midpoint
  source: 'alert' | 'manual';
}
```

### Work Cost Estimation by Alert
```typescript
const WORK_COST_BY_ALERT: Record<string, { low: number; high: number }> = {
  'structural_cracks': { low: 1500000, high: 5000000 }, // 15k-50k
  'electrical_obsolete': { low: 800000, high: 2000000 }, // 8k-20k
  'plumbing_issues': { low: 500000, high: 1500000 }, // 5k-15k
  'roof_damage': { low: 1000000, high: 3000000 }, // 10k-30k
  // etc.
};
```

### Margin Indicator Thresholds
```typescript
const MARGIN_THRESHOLDS = {
  good: 20, // >= 20% green
  medium: 10, // 10-19% orange
  low: 0 // < 10% red
};
```

### References
- [Source: epics.md#Story 6.3]
- [Source: prd.md#FR37]
- [Source: CLAUDE.md#montants-en-centimes]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
