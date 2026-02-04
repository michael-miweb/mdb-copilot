# Story 12.2: Consultation artisan via lien partage

Status: ready-for-dev

## Story

As a artisan,
I want consulter les informations d'un bien via un lien partage,
so that je prepare mon estimation sans creer de compte.

## Acceptance Criteria

**Given** un artisan avec un lien de partage valide
**When** il ouvre le lien
**Then** il voit les informations du bien : photos organisees par zone, description des travaux, contraintes chantier
**And** les donnees financieres du MDB (prix achat, marge, scoring) sont masquees
**And** aucune inscription n'est requise

**Given** un lien de partage expire
**When** l'artisan ouvre le lien
**Then** une page "Lien expire" s'affiche
**And** un message suggere de contacter le proprietaire pour un nouveau lien

## Tasks / Subtasks

### Backend Tasks
- [ ] Create `PublicPropertyController`
  - [ ] `GET /api/public/{token}` - validate and return property data
  - [ ] Filter response based on visible_sections
  - [ ] Remove all financial data from response
- [ ] Create `PublicPropertyResource` (stripped version of PropertyResource)
- [ ] Add token validation middleware
- [ ] Handle expired/revoked tokens with proper error response
- [ ] Log public access for analytics
- [ ] Write feature tests for public access scenarios

### Frontend Tasks (Web - React)
- [ ] Create `PublicPropertyPage` page (no auth required)
  - [ ] Token validation on load
  - [ ] Property display with limited sections
- [ ] Create `PublicPhotoGallery` component
  - [ ] Photos organized by zone/category
  - [ ] Lightbox for full-screen viewing
- [ ] Create `PublicPropertyDetails` component
  - [ ] Works description
  - [ ] Constraints section
  - [ ] Location info (if visible)
- [ ] Create `ExpiredLinkPage` component
  - [ ] Clear message about expiration
  - [ ] Contact owner suggestion
- [ ] Style public pages with MDB branding but no navigation
- [ ] Write component tests

### Frontend Tasks (Mobile - Deep Link Support)
- [ ] Configure deep link handling for share URLs
- [ ] Route to web view or native screen for public shares
- [ ] Handle expired link gracefully

### Shared Package Tasks
- [ ] Add types: `PublicPropertyView`, `ExpiredLinkError`
- [ ] Add public property display utilities

## Dev Notes

### Architecture Reference
- Public pages are unauthenticated
- Financial data always filtered server-side
- Minimal UI without app navigation
- Optimized for quick loading (artisan may be on mobile)

### Data Filtering (Server-side)
```php
// PublicPropertyResource.php
public function toArray($request): array
{
    $visibleSections = $this->share->visible_sections;

    return [
        'id' => $this->id,
        'address' => in_array('location', $visibleSections)
            ? $this->address
            : $this->city_only,
        'photos' => in_array('photos', $visibleSections)
            ? $this->photos->map(fn($p) => [
                'url' => $p->signed_url,
                'zone' => $p->zone,
              ])
            : [],
        'description' => in_array('description', $visibleSections)
            ? $this->description
            : null,
        'works_needed' => in_array('works_needed', $visibleSections)
            ? $this->works_description
            : null,
        'constraints' => in_array('constraints', $visibleSections)
            ? $this->constraints
            : null,
        // NEVER include:
        // - price
        // - opportunity_score
        // - margin_estimate
        // - dvf_data
        // - agent_info
        // - notes
    ];
}
```

### Photo Organization by Zone
```typescript
const PHOTO_ZONES = [
  'facade',
  'interior',
  'kitchen',
  'bathroom',
  'bedroom',
  'living',
  'basement',
  'attic',
  'exterior',
  'other',
];

// Display photos grouped by zone for easy navigation
```

### Expired Link Page
```typescript
const ExpiredLinkPage = () => (
  <Container maxWidth="sm" sx={{ textAlign: 'center', mt: 8 }}>
    <LinkOffIcon sx={{ fontSize: 64, color: 'text.secondary' }} />
    <Typography variant="h4" gutterBottom>
      Ce lien a expire
    </Typography>
    <Typography color="text.secondary">
      Contactez la personne qui vous l'a envoye
      pour obtenir un nouveau lien d'acces.
    </Typography>
  </Container>
);
```

### Public Page Layout
- Simple header with MDB logo
- No navigation menu
- Property content centered
- "Soumettre une estimation" CTA at bottom (links to Story 12.3)
- Footer with minimal legal links

### References
- [Source: epics.md#Story 12.2]
- [Source: prd.md#FR52 - Masquage donnees financieres]
- [Source: prd.md#FR53 - Consultation artisan via lien]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
