# Story 2.5: Consultation et liste des fiches annonces

Status: ready-for-dev

## Story

As a utilisateur,
I want consulter la liste de mes fiches et voir le detail de chacune,
so that j'ai une vue d'ensemble de mes opportunites.

## Acceptance Criteria

**Given** un utilisateur connecte avec des fiches existantes
**When** il accede a l'ecran liste des fiches
**Then** toutes ses fiches sont affichees avec adresse, prix, surface, type et urgence
**And** la liste est triee par date de creation (plus recente en premier)

**Given** la liste des fiches
**When** l'utilisateur selectionne une fiche
**Then** l'ecran detail affiche toutes les informations : bien, agent associe, urgence, notes, photos

**Given** l'ecran detail
**When** l'utilisateur consulte la section agent
**Then** les informations de l'agent (depuis le carnet d'adresses) sont affichees avec lien vers la fiche contact

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Creer `GET /api/properties` endpoint (liste avec pagination)
- [ ] Inclure relation contact (agent) en eager loading
- [ ] Tri par created_at desc par defaut
- [ ] Creer `GET /api/properties/{id}` endpoint (detail)
- [ ] Inclure toutes les relations (contact, photos)

### Mobile (Flutter)
- [ ] Creer `PropertiesListPage` dans `lib/features/properties/presentation/pages/`
- [ ] Implementer `PropertiesListCubit` avec etats: loading, loaded, error
- [ ] Card property avec: adresse, prix formatte, surface, type, badge urgence
- [ ] Tri par date creation (plus recente en premier)
- [ ] Pull-to-refresh pour sync
- [ ] Creer `PropertyDetailPage`
- [ ] Afficher toutes les infos: bien, agent, urgence, notes
- [ ] Galerie photos (si disponibles)
- [ ] Section agent avec lien vers ContactDetailPage

### UX
- [ ] Format prix: "250 000 EUR" (pas centimes)
- [ ] Format surface: "75 m2"
- [ ] Badge urgence colore (rouge=high, orange=medium, gris=low/unknown)
- [ ] Placeholder si pas de photo
- [ ] Empty state si aucune fiche

### Tests
- [ ] Test unitaire backend: liste properties avec pagination
- [ ] Test unitaire backend: detail property avec relations
- [ ] Test widget Flutter: PropertiesListPage
- [ ] Test widget Flutter: PropertyDetailPage
- [ ] Test cubit: load properties flow

## Dev Notes

### Architecture Reference
- Repository pattern pour PropertyRepository
- Eager loading relations pour eviter N+1
- Formatage montants: centimes -> euros cote Flutter

### API Contract
```json
GET /api/properties?page=1&per_page=20
Headers: Authorization: Bearer {token}

Response 200:
{
  "data": [
    {
      "id": "uuid",
      "address": "12 rue de la Paix, 75001 Paris",
      "surface_m2": 75.5,
      "price_cents": 25000000,
      "property_type": "appartement",
      "urgency_level": "medium",
      "pipeline_status": "prospection",
      "contact": {
        "id": "uuid",
        "first_name": "Jean",
        "last_name": "Dupont",
        "company": "Immo Plus"
      },
      "created_at": "2026-02-01T10:00:00Z",
      "updated_at": "2026-02-01T10:00:00Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 20,
    "total": 95
  }
}

GET /api/properties/{id}
Headers: Authorization: Bearer {token}

Response 200:
{
  "id": "uuid",
  "address": "12 rue de la Paix, 75001 Paris",
  "surface_m2": 75.5,
  "price_cents": 25000000,
  "property_type": "appartement",
  "urgency_level": "medium",
  "notes": "Proche metro...",
  "pipeline_status": "prospection",
  "source_url": "https://leboncoin.fr/...",
  "contact": {
    "id": "uuid",
    "first_name": "Jean",
    "last_name": "Dupont",
    "company": "Immo Plus",
    "phone": "+33612345678",
    "email": "jean@immoplus.fr"
  },
  "photos": [
    { "id": "uuid", "url": "https://storage.../photo1.jpg" },
    { "id": "uuid", "url": "https://storage.../photo2.jpg" }
  ],
  "created_at": "2026-02-01T10:00:00Z",
  "updated_at": "2026-02-01T10:00:00Z"
}
```

### Price Formatting
```dart
String formatPrice(int cents) {
  final euros = cents / 100;
  final formatter = NumberFormat('#,###', 'fr_FR');
  return '${formatter.format(euros)} EUR';
}
// 25000000 -> "250 000 EUR"
```

### References
- [Source: epics.md#Story 2.5]
- [Source: prd.md#FR19, FR20]
- [Source: CLAUDE.md#Montants en centimes]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
