# Story 6.1: Generation automatique de la synthese post-visite

Status: ready-for-dev

## Story

As a utilisateur,
I want que le systeme genere une synthese complete basee sur mes reponses du guide de visite,
so that j'ai un recapitulatif structure sans effort de redaction.

## Acceptance Criteria

**Given** un guide de visite avec des reponses completees
**When** l'utilisateur termine la visite ou demande la synthese
**Then** le systeme genere une synthese recapitulant les constats par categorie
**And** la synthese est generee cote client (logique embarquee, fonctionne offline)
**And** la synthese est stockee et liee a la fiche annonce

**Given** un guide de visite partiellement complete
**When** l'utilisateur demande la synthese
**Then** la synthese est generee avec les donnees disponibles
**And** un avertissement indique les categories non completees

## Tasks / Subtasks

### Backend API
- [ ] Create `visit_summaries` migration table (id, property_id, visit_guide_id, content_json, alerts_json, margin_estimate_json, decision, completed_categories, created_at, updated_at)
- [ ] Create VisitSummary model with relationships
- [ ] Add endpoints: GET/POST /api/properties/{id}/visit-summary
- [ ] Add visit summary to sync payload
- [ ] Write tests for VisitSummary endpoints

### Mobile App (React Native)
- [ ] Create PostVisitSummaryScreen with structured layout
- [ ] Create SummarySection component for category recaps
- [ ] Create IncompleteCategoriesWarning component
- [ ] Implement generateSynthesis service (pure function, offline capable)
- [ ] Create useSynthesis hook for state management
- [ ] Add WatermelonDB schema for visit_summaries
- [ ] Add "Generate Synthesis" button in visit guide
- [ ] Add navigation from visit guide to summary
- [ ] Write unit tests for synthesis generation logic
- [ ] Write integration tests for SummaryScreen

### Web App (React)
- [ ] Create PostVisitSummaryPage with structured layout
- [ ] Create SummarySection component
- [ ] Create IncompleteCategoriesWarning component
- [ ] Implement generateSynthesis service (shared logic)
- [ ] Create useSynthesis hook
- [ ] Add Dexie.js schema for visit_summaries
- [ ] Add route /properties/:id/visit-summary
- [ ] Write tests for synthesis generation

### Shared Package
- [ ] Add VisitSummary type to @mdb/shared
- [ ] Add CategorySummary type
- [ ] Create generateSynthesis pure function
- [ ] Create summarizeCategory utility
- [ ] Add completion percentage calculation

## Dev Notes

### Architecture Reference
- Follow AR46: PostVisitSummary component (synthese automatique avec alertes)
- Synthesis generated client-side for offline support
- Pure functions in shared package for testability

### Synthesis Generation Logic
```typescript
interface CategorySummary {
  category: string;
  status: 'complete' | 'partial' | 'empty';
  answeredCount: number;
  totalCount: number;
  highlights: string[]; // Key findings
  alerts: Alert[];
}

const generateSynthesis = (
  visitGuide: VisitGuide,
  answers: VisitGuideAnswer[]
): VisitSummary => {
  const categorySummaries = CATEGORIES.map(cat =>
    summarizeCategory(cat, answers)
  );
  // Aggregate alerts, compute completion, etc.
};
```

### Summary Content Structure
```typescript
interface VisitSummary {
  id: string;
  propertyId: string;
  visitGuideId: string;
  categorySummaries: CategorySummary[];
  completionPercentage: number;
  incompleteCategories: string[];
  alertsCount: { critical: number; warning: number; info: number };
  marginEstimate?: MarginEstimate;
  decision?: 'go' | 'no_go' | 'to_investigate';
  createdAt: Date;
  updatedAt: Date;
}
```

### References
- [Source: epics.md#Story 6.1]
- [Source: prd.md#FR35]
- [Source: architecture.md#AR46]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
