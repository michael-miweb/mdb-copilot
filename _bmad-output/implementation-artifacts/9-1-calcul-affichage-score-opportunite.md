# Story 9.1: Calcul et affichage du score d'opportunite

Status: ready-for-dev

## Story

As a utilisateur,
I want que le systeme calcule un score d'opportunite pour chaque annonce,
so that je priorise rapidement les meilleures opportunites.

## Acceptance Criteria

**Given** une fiche annonce avec prix, localisation et urgence renseignes
**When** le systeme calcule le score d'opportunite
**Then** un score (0-100) est genere combinant : ecart prix vs marche (DVF si disponible), urgence de vente, potentiel estime
**And** le score est affiche avec un code couleur (vert >=70, orange 40-69, rouge <40)

**Given** l'ecran detail d'une fiche
**When** l'utilisateur consulte le score
**Then** les composantes du score sont detaillees avec leur contribution
**And** chaque composante est expliquee clairement

**Given** une fiche sans donnees DVF disponibles
**When** le score est calcule
**Then** le score est calcule sans la composante marche
**And** une mention "Donnees marche non disponibles" est affichee

## Tasks / Subtasks

### Backend Tasks
- [ ] Create `OpportunityScoreService` in `backend-api/app/Services/`
  - [ ] Implement score calculation algorithm (0-100)
  - [ ] Define weight for each component (DVF comparison, urgency, potential)
  - [ ] Handle missing DVF data gracefully
- [ ] Add `opportunity_score` and `score_components` JSON fields to properties table
- [ ] Create migration for score fields
- [ ] Add `GET /api/properties/{id}/score` endpoint
- [ ] Add `POST /api/properties/{id}/calculate-score` endpoint
- [ ] Write unit tests for score calculation service
- [ ] Write feature tests for score endpoints

### Frontend Tasks (Mobile - React Native)
- [ ] Create `ScoreCard` component following AR42 specification
  - [ ] Display score 0-100 with color coding (green/orange/red)
  - [ ] Show score breakdown with component contributions
  - [ ] Handle loading and error states
- [ ] Create `useOpportunityScore` hook for score fetching/calculation
- [ ] Integrate `ScoreCard` into property detail screen
- [ ] Add "Donnees marche non disponibles" fallback display
- [ ] Write component tests

### Frontend Tasks (Web - React)
- [ ] Create `ScoreCard` MUI component matching mobile design
- [ ] Create `useOpportunityScore` hook (shared logic via @mdb/shared)
- [ ] Integrate into property detail page
- [ ] Write component tests

### Shared Package Tasks
- [ ] Add score types to `@mdb/shared`: `OpportunityScore`, `ScoreComponent`
- [ ] Add score calculation utilities if needed client-side
- [ ] Add color mapping utility for score ranges

## Dev Notes

### Architecture Reference
- Score calculation happens server-side for consistency
- ScoreCard component (AR42) displays score with semantic colors
- Score components: DVF comparison (40%), urgency (30%), potential (30%)
- When DVF unavailable, redistribute weights to urgency (50%) and potential (50%)

### Score Color Mapping
```typescript
const getScoreColor = (score: number) => {
  if (score >= 70) return 'success'; // Green
  if (score >= 40) return 'warning'; // Orange
  return 'error'; // Red
};
```

### References
- [Source: epics.md#Story 9.1]
- [Source: architecture.md#AR42 - ScoreCard component]
- [Source: prd.md#FR21-FR23 - Score d'opportunite]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
