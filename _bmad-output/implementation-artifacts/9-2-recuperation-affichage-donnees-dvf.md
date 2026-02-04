# Story 9.2: Recuperation et affichage des donnees DVF

Status: ready-for-dev

## Story

As a utilisateur,
I want consulter les transactions immobilieres recentes autour d'une annonce,
so that j'evalue objectivement si le prix est coherent avec le marche.

## Acceptance Criteria

**Given** une fiche annonce avec une adresse renseignee
**When** l'utilisateur demande les donnees DVF (ou automatiquement au calcul du score)
**Then** le systeme interroge l'API DVF via le proxy Laravel `/api/dvf`
**And** les transactions recentes dans un rayon pertinent sont recuperees

**Given** les donnees DVF recuperees
**When** l'utilisateur les consulte
**Then** une liste de transactions comparables s'affiche (adresse, surface, prix, date, type)
**And** un comparatif prix/m2 est affiche entre l'annonce et la mediane des transactions
**And** une indication visuelle montre si le prix est au-dessus, dans la moyenne ou en dessous

## Tasks / Subtasks

### Backend Tasks
- [ ] Create `DvfService` in `backend-api/app/Services/`
  - [ ] Implement DVF API client (data.gouv.fr DVF API)
  - [ ] Add geocoding for address to coordinates conversion
  - [ ] Implement radius-based transaction search
  - [ ] Calculate median price per m2
- [ ] Create `DvfController` with endpoints:
  - [ ] `GET /api/dvf/transactions` - fetch transactions by location
  - [ ] `GET /api/properties/{id}/dvf` - get DVF data for a property
- [ ] Implement 24h cache for DVF responses (NFR-I1)
- [ ] Create `DvfTransaction` DTO for API response
- [ ] Add rate limiting to prevent API abuse
- [ ] Write unit tests for DVF service
- [ ] Write feature tests for DVF endpoints

### Frontend Tasks (Mobile - React Native)
- [ ] Create `DVFComparator` component following AR47 specification
  - [ ] Display transaction list with key info
  - [ ] Show price/m2 comparison chart or indicator
  - [ ] Visual indicator for price position (above/below/at market)
- [ ] Create `useDvfData` hook for DVF fetching
- [ ] Create `TransactionCard` component for individual transactions
- [ ] Add "Voir transactions comparables" section to property detail
- [ ] Handle loading, empty, and error states
- [ ] Write component tests

### Frontend Tasks (Web - React)
- [ ] Create `DVFComparator` MUI component
- [ ] Create `TransactionTable` for desktop view
- [ ] Integrate into property detail page
- [ ] Write component tests

### Shared Package Tasks
- [ ] Add DVF types: `DvfTransaction`, `DvfComparison`, `PricePosition`
- [ ] Add price formatting utilities for DVF display
- [ ] Add price position calculation utility

## Dev Notes

### Architecture Reference
- DVF API proxy via Laravel to handle CORS and add caching (NFR-I1)
- Cache TTL: 24 hours for DVF responses
- DVFComparator component (AR47) shows contextualized DVF data
- Search radius: configurable, default 500m for urban, 2km for rural

### DVF API Reference
- Base URL: `https://api.cquest.org/dvf` or `https://app.dvf.etalab.gouv.fr/api`
- Required params: lat, lon, radius (or commune code)
- Response includes: date_mutation, valeur_fonciere, surface_reelle_bati, type_local

### Price Position Indicator
```typescript
type PricePosition = 'below_market' | 'at_market' | 'above_market';
// below_market: price < median - 10%
// at_market: median - 10% <= price <= median + 10%
// above_market: price > median + 10%
```

### References
- [Source: epics.md#Story 9.2]
- [Source: architecture.md#AR47 - DVFComparator component]
- [Source: prd.md#FR48-FR49 - Integration DVF]
- [Source: architecture.md#NFR-I1 - DVF API proxy with 24h cache]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
