# Story 6.4: Decision Go/No Go et liens memo contextuels

Status: ready-for-dev

## Story

As a utilisateur,
I want marquer ma decision et consulter des fiches memo pertinentes,
so that je prends une decision eclairee et documentee.

## Acceptance Criteria

**Given** la synthese complete consultee
**When** l'utilisateur consulte la section decision
**Then** trois options sont proposees : Go, No Go, A approfondir
**And** l'option selectionnee est enregistree et visible sur la fiche

**Given** des alertes specifiques dans la synthese
**When** la synthese est affichee
**Then** des liens contextuels vers les fiches memo pertinentes apparaissent (ex: "Red flags structurels", "Estimation travaux electricite")
**And** les fiches memo s'ouvrent en bottom sheet sans quitter la synthese

**Given** une decision "Go" selectionnee
**When** l'utilisateur confirme
**Then** la fiche passe automatiquement au statut "Offre" dans le pipeline

## Tasks / Subtasks

### Backend API
- [ ] Add decision field to visit_summaries (enum: go, no_go, to_investigate)
- [ ] Add endpoint PATCH /api/visit-summaries/{id}/decision
- [ ] Implement automatic pipeline status update on "Go" decision
- [ ] Add decision history tracking
- [ ] Write tests for decision endpoint and pipeline update

### Mobile App (React Native)
- [ ] Create DecisionSection component with three button options
- [ ] Create DecisionButton component with distinct styling per option
- [ ] Create MemoSuggestionChips component listing contextual links
- [ ] Create MemoBottomSheet component for inline memo display
- [ ] Implement decision save with pipeline update trigger
- [ ] Add confirmation dialog for "Go" decision (mentions pipeline change)
- [ ] Add decision badge on property card in pipeline
- [ ] Write unit tests for DecisionSection
- [ ] Write integration tests for decision flow

### Web App (React)
- [ ] Create DecisionSection component
- [ ] Create DecisionButton component
- [ ] Create MemoSuggestionChips component
- [ ] Create MemoSideSheet component (slides from right)
- [ ] Implement decision save with pipeline update
- [ ] Add confirmation modal for "Go" decision
- [ ] Add decision indicator on Kanban cards
- [ ] Write tests for decision components

### Shared Package
- [ ] Add Decision enum (go, no_go, to_investigate)
- [ ] Add alert-to-memo mapping utilities
- [ ] Add getMemoSuggestions utility (based on alerts)

## Dev Notes

### Architecture Reference
- Follow AR53: MemoSuggestionChip (chip contextuel fiche memo)
- Bottom sheet pattern for memo display (maintains context)
- Pipeline status auto-update on "Go" decision

### Decision Options
```typescript
type Decision = 'go' | 'no_go' | 'to_investigate';

interface DecisionOption {
  value: Decision;
  label: string;
  description: string;
  color: string;
  icon: string;
}

const DECISION_OPTIONS: DecisionOption[] = [
  {
    value: 'go',
    label: 'Go',
    description: 'Passer a l\'offre',
    color: '#22C55E', // green
    icon: 'check-circle'
  },
  {
    value: 'no_go',
    label: 'No Go',
    description: 'Abandonner ce bien',
    color: '#EF4444', // red
    icon: 'x-circle'
  },
  {
    value: 'to_investigate',
    label: 'A approfondir',
    description: 'Besoin de plus d\'infos',
    color: '#F59E0B', // orange
    icon: 'help-circle'
  }
];
```

### Memo Suggestion Logic
```typescript
const getMemoSuggestions = (alerts: Alert[]): MemoSuggestion[] => {
  const suggestions: MemoSuggestion[] = [];

  // Add suggestions based on alert memoSlug
  alerts.forEach(alert => {
    if (alert.memoSlug) {
      suggestions.push({
        alertId: alert.id,
        memoSlug: alert.memoSlug,
        label: `En savoir plus: ${alert.title}`
      });
    }
  });

  // Deduplicate by memoSlug
  return uniqueBy(suggestions, 'memoSlug');
};
```

### Pipeline Status Auto-Update
```typescript
// On "Go" decision confirmation
const handleGoDecision = async () => {
  await updateVisitSummaryDecision(summaryId, 'go');
  await updatePropertyStatus(propertyId, 'offre'); // Auto-move to "Offre"
};
```

### References
- [Source: epics.md#Story 6.4]
- [Source: prd.md#FR38, FR39]
- [Source: architecture.md#AR53]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
