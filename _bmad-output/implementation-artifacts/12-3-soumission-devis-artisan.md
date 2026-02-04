# Story 12.3: Soumission de devis par l'artisan

Status: ready-for-dev

## Story

As a artisan,
I want soumettre une fourchette estimative de devis via le lien partage,
so that je reponds rapidement a la demande sans paperasse.

## Acceptance Criteria

**Given** la vue artisan d'une fiche partagee
**When** l'artisan remplit le formulaire d'estimation (fourchette basse-haute, commentaires, delai estime)
**Then** l'estimation est enregistree et visible par l'utilisateur owner

**Given** une estimation soumise
**When** l'artisan valide
**Then** l'artisan voit une confirmation "Estimation envoyee"
**And** il peut modifier son estimation tant que le lien est valide

## Tasks / Subtasks

### Backend Tasks
- [ ] Create migration for `artisan_estimates` table
  - [ ] id (UUID)
  - [ ] public_share_id (foreign key)
  - [ ] property_id (foreign key)
  - [ ] artisan_name
  - [ ] artisan_email (optional)
  - [ ] artisan_phone (optional)
  - [ ] estimate_low (cents)
  - [ ] estimate_high (cents)
  - [ ] estimated_duration (days)
  - [ ] comments (text)
  - [ ] created_at, updated_at
- [ ] Create `ArtisanEstimate` model
- [ ] Create `ArtisanEstimateController`
  - [ ] `POST /api/public/{token}/estimates` - submit estimate
  - [ ] `PUT /api/public/{token}/estimates/{id}` - update estimate
  - [ ] `GET /api/public/{token}/estimates` - get own estimates (by session/email)
- [ ] Validate share token is still valid
- [ ] Send notification to owner on new estimate (queue job)
- [ ] Write feature tests for estimate submission

### Frontend Tasks (Web - React)
- [ ] Create `EstimateSubmissionForm` component
  - [ ] Artisan name field
  - [ ] Contact info fields (email, phone - optional)
  - [ ] Estimate range slider (low-high)
  - [ ] Duration selector (days/weeks)
  - [ ] Comments textarea
- [ ] Create `EstimateRangeInput` component
  - [ ] Dual-handle slider for min/max
  - [ ] Euro formatting
- [ ] Create `EstimateConfirmation` component
  - [ ] Success message
  - [ ] Summary of submitted estimate
  - [ ] Edit button
- [ ] Add form to `PublicPropertyPage`
- [ ] Implement local storage for artisan identity (for edit capability)
- [ ] Write component tests

### Shared Package Tasks
- [ ] Add types: `ArtisanEstimate`, `EstimateInput`, `EstimateRange`
- [ ] Add estimate formatting utilities
- [ ] Add duration display utilities

## Dev Notes

### Architecture Reference
- Public endpoint, no authentication required
- Estimates linked to share token (not user account)
- Owner receives notification (in-app + optional email)
- All monetary values in cents (CLAUDE.md convention)

### Estimate Form Fields
```typescript
interface EstimateInput {
  artisanName: string;
  artisanEmail?: string;
  artisanPhone?: string;
  estimateLow: number; // cents
  estimateHigh: number; // cents
  estimatedDuration: number; // days
  comments?: string;
}
```

### Edit Capability
- Store artisan identifier in localStorage
- Match by email or session token
- Allow edits only while share link is valid

```typescript
// Store artisan session
const ARTISAN_SESSION_KEY = 'mdb_artisan_session';

const submitEstimate = async (data: EstimateInput) => {
  const sessionId = localStorage.getItem(ARTISAN_SESSION_KEY)
    || crypto.randomUUID();
  localStorage.setItem(ARTISAN_SESSION_KEY, sessionId);

  const response = await api.post(`/public/${token}/estimates`, {
    ...data,
    sessionId,
  });

  return response.data;
};
```

### Estimate Range UX
```typescript
// Predefined ranges for quick selection
const ESTIMATE_PRESETS = [
  { label: '< 5 000 EUR', low: 0, high: 500000 }, // cents
  { label: '5 000 - 10 000 EUR', low: 500000, high: 1000000 },
  { label: '10 000 - 20 000 EUR', low: 1000000, high: 2000000 },
  { label: '20 000 - 50 000 EUR', low: 2000000, high: 5000000 },
  { label: '> 50 000 EUR', low: 5000000, high: 10000000 },
];

// Or free-form slider with MUI Slider
```

### Duration Options
```typescript
const DURATION_OPTIONS = [
  { value: 7, label: '1 semaine' },
  { value: 14, label: '2 semaines' },
  { value: 30, label: '1 mois' },
  { value: 60, label: '2 mois' },
  { value: 90, label: '3 mois' },
  { value: 180, label: '6 mois+' },
];
```

### Success Confirmation
```typescript
const EstimateConfirmation = ({ estimate }: { estimate: ArtisanEstimate }) => (
  <Card sx={{ textAlign: 'center', p: 3 }}>
    <CheckCircleIcon color="success" sx={{ fontSize: 48 }} />
    <Typography variant="h5" gutterBottom>
      Estimation envoyee !
    </Typography>
    <Box sx={{ my: 2 }}>
      <Typography>Fourchette: {formatRange(estimate)}</Typography>
      <Typography>Delai: {formatDuration(estimate.estimatedDuration)}</Typography>
    </Box>
    <Button variant="outlined" onClick={onEdit}>
      Modifier mon estimation
    </Button>
  </Card>
);
```

### References
- [Source: epics.md#Story 12.3]
- [Source: prd.md#FR54 - Soumission devis artisan]
- [Source: CLAUDE.md - Monetary values in cents]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
