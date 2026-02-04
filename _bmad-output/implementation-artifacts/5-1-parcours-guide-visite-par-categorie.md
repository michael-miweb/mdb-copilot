# Story 5.1: Parcours du guide de visite par categorie

Status: ready-for-dev

## Story

As a utilisateur,
I want parcourir un guide de visite organise par categorie,
so that j'inspecte methodiquement chaque aspect du bien sans rien oublier.

## Acceptance Criteria

**Given** une fiche au statut "Visite" ou superieur
**When** l'utilisateur ouvre le guide de visite
**Then** les categories s'affichent : Structure/Gros oeuvre, Electricite, Plomberie, Toiture, Isolation, Division possible, Exterieurs, Environnement
**And** chaque categorie est accessible via des chips scrollables horizontalement
**And** la progression par categorie est affichee (complete, en cours, vide)

**Given** une categorie du guide
**When** l'utilisateur y accede
**Then** les questions guidees specifiques s'affichent
**And** chaque question a un type de reponse adapte (choix simple, choix multiple, oui/non, texte libre, slider)

## Tasks / Subtasks

### Backend API
- [ ] Create `visit_guides` migration table (id, property_id, status, progress_json, created_at, updated_at)
- [ ] Create `visit_guide_answers` migration table (id, visit_guide_id, category, question_key, answer_json, has_alert, created_at, updated_at)
- [ ] Create VisitGuide and VisitGuideAnswer models with relationships
- [ ] Create VisitGuideController with CRUD endpoints
- [ ] Add visit guide categories and questions configuration file (config/visit-guide.php)
- [ ] Add API routes: GET/POST /api/properties/{id}/visit-guide
- [ ] Write Feature tests for VisitGuideController

### Mobile App (React Native)
- [ ] Create VisitGuideScreen with category chips navigation
- [ ] Create VisitGuideCategoryChip component with progress indicator
- [ ] Create GuidedQuestion component with multiple answer types:
  - [ ] SingleChoice (radio buttons)
  - [ ] MultipleChoice (checkboxes)
  - [ ] YesNo (toggle)
  - [ ] TextInput (free text)
  - [ ] Slider (range selection)
- [ ] Create useVisitGuide hook for state management
- [ ] Create visitGuideService for API calls
- [ ] Implement WatermelonDB schema for visit_guides and answers
- [ ] Add navigation from property detail to visit guide
- [ ] Write unit tests for GuidedQuestion component
- [ ] Write integration tests for VisitGuideScreen

### Web App (React)
- [ ] Create VisitGuidePage with category tabs navigation
- [ ] Create VisitGuideCategoryTab component with progress badge
- [ ] Create GuidedQuestion component (same variants as mobile)
- [ ] Create useVisitGuide hook (shared logic with mobile)
- [ ] Implement Dexie.js schema for visit_guides and answers
- [ ] Add route /properties/:id/visit-guide
- [ ] Write tests for VisitGuidePage

### Shared Package
- [ ] Add VisitGuide and VisitGuideAnswer types to @mdb/shared
- [ ] Add visit guide categories and questions constants
- [ ] Add progress calculation utility

## Dev Notes

### Architecture Reference
- Follow AR44: VisitGuideCategory component (categorie navigable avec badge completion)
- Follow AR45: GuidedQuestion component (question avec reponse rapide par tap)
- Mobile: WatermelonDB for offline storage (AR6)
- Web: Dexie.js for IndexedDB storage (AR7)
- State management: Zustand with persist middleware (AR5)

### Visit Guide Categories
```typescript
const VISIT_GUIDE_CATEGORIES = [
  'structure_gros_oeuvre',
  'electricite',
  'plomberie',
  'toiture',
  'isolation',
  'division_possible',
  'exterieurs',
  'environnement'
];
```

### Question Types
```typescript
type QuestionType = 'single_choice' | 'multiple_choice' | 'yes_no' | 'text' | 'slider';
```

### References
- [Source: epics.md#Story 5.1]
- [Source: architecture.md#AR44, AR45]
- [Source: prd.md#FR30, FR31]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
