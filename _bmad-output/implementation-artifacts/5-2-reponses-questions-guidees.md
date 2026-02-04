# Story 5.2: Reponses aux questions guidees

Status: ready-for-dev

## Story

As a utilisateur,
I want repondre aux questions guidees pour chaque categorie,
so that je documente systematiquement l'etat du bien.

## Acceptance Criteria

**Given** une question du guide de visite
**When** l'utilisateur repond (tap sur choix, slider, texte)
**Then** la reponse est enregistree immediatement (sauvegarde continue)
**And** la progression de la categorie est mise a jour

**Given** une reponse indiquant un probleme critique (ex: "Fissures structurelles: Oui")
**When** la reponse est enregistree
**Then** un indicateur d'alerte apparait sur la categorie
**And** ce point sera remonte dans la synthese post-visite

**Given** le guide de visite
**When** l'utilisateur navigue entre categories
**Then** les reponses deja saisies sont conservees
**And** il peut revenir modifier une reponse precedente

## Tasks / Subtasks

### Backend API
- [ ] Add alert detection rules to visit guide configuration
- [ ] Create AlertRule model with severity levels (critical, warning, info)
- [ ] Update VisitGuideAnswer model to track has_alert and alert_severity
- [ ] Add endpoint PATCH /api/visit-guides/{id}/answers/{answerId}
- [ ] Add endpoint to calculate category progress: GET /api/visit-guides/{id}/progress
- [ ] Write tests for alert detection logic

### Mobile App (React Native)
- [ ] Implement auto-save on answer change (debounced 500ms)
- [ ] Create AlertIndicator component (red/orange/yellow badges)
- [ ] Update VisitGuideCategoryChip to show alert indicator
- [ ] Implement answer persistence in WatermelonDB
- [ ] Create useAutoSave hook for continuous save
- [ ] Add haptic feedback on answer selection
- [ ] Handle navigation between categories preserving state
- [ ] Write unit tests for auto-save logic
- [ ] Write unit tests for alert detection

### Web App (React)
- [ ] Implement auto-save on answer change (debounced 500ms)
- [ ] Create AlertIndicator component (badges with tooltips)
- [ ] Update VisitGuideCategoryTab to show alert count
- [ ] Implement answer persistence in Dexie.js
- [ ] Create useAutoSave hook (shared with mobile)
- [ ] Add keyboard navigation for question responses
- [ ] Write tests for auto-save and alert detection

### Shared Package
- [ ] Add AlertRule type and severity enum to @mdb/shared
- [ ] Add alert detection utility function
- [ ] Add progress calculation utility (X/Y questions answered)

## Dev Notes

### Architecture Reference
- Continuous save pattern: no "Save" button, auto-persist on change (NFR-R2)
- Alert detection runs client-side for offline support
- Severity levels: critical (red), warning (orange), info (yellow)

### Alert Rules Example
```typescript
const ALERT_RULES: AlertRule[] = [
  {
    category: 'structure_gros_oeuvre',
    questionKey: 'fissures_structurelles',
    triggerValue: 'oui',
    severity: 'critical',
    memoLink: 'fissures-structurelles'
  },
  {
    category: 'electricite',
    questionKey: 'tableau_vetuste',
    triggerValue: 'oui',
    severity: 'warning',
    memoLink: 'renovation-electrique'
  }
];
```

### Auto-Save Implementation
```typescript
const useAutoSave = (saveFunction: () => Promise<void>, delay = 500) => {
  const debouncedSave = useDebouncedCallback(saveFunction, delay);
  // Trigger on every answer change
};
```

### References
- [Source: epics.md#Story 5.2]
- [Source: prd.md#FR31]
- [Source: architecture.md#AR45]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
