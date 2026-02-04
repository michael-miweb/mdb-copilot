# Story 9.3: Cache DVF et consultation offline

Status: ready-for-dev

## Story

As a utilisateur,
I want consulter les donnees DVF meme sans connexion,
so that j'ai acces aux donnees marche lors de mes visites terrain.

## Acceptance Criteria

**Given** des donnees DVF telechargees pour une fiche
**When** l'appareil passe hors connexion
**Then** les donnees DVF en cache restent consultables
**And** la date de derniere mise a jour est affichee

**Given** une requete DVF
**When** le cache contient des donnees recentes (< 24h)
**Then** le cache est utilise sans nouvelle requete reseau

**Given** une requete DVF
**When** l'API DVF est indisponible
**Then** un message informe l'utilisateur "Donnees marche temporairement indisponibles"
**And** les donnees en cache (meme anciennes) restent consultables avec mention de la date
**And** le score est calcule sans la composante marche

## Tasks / Subtasks

### Backend Tasks
- [ ] Ensure DVF cache headers are properly set (Cache-Control, ETag)
- [ ] Add `last_updated_at` timestamp to DVF responses
- [ ] Implement stale-while-revalidate pattern for DVF cache
- [ ] Add graceful degradation when DVF API is down (NFR-R3)

### Frontend Tasks (Mobile - React Native)
- [ ] Implement DVF data persistence in WatermelonDB
  - [ ] Create `dvf_transactions` table schema
  - [ ] Create `dvf_cache_metadata` table for cache timestamps
- [ ] Update `useDvfData` hook to check local cache first
- [ ] Implement cache freshness check (< 24h)
- [ ] Display cache date in DVFComparator component
- [ ] Add "Donnees marche temporairement indisponibles" fallback UI
- [ ] Show stale data indicator when using old cache
- [ ] Write tests for offline DVF access

### Frontend Tasks (Web - React)
- [ ] Implement DVF data persistence in Dexie.js (IndexedDB)
  - [ ] Create `dvfTransactions` store
  - [ ] Create `dvfCacheMetadata` store
- [ ] Update `useDvfData` hook for cache-first strategy
- [ ] Display cache freshness indicator
- [ ] Handle offline/error states gracefully
- [ ] Write tests for offline DVF access

### Shared Package Tasks
- [ ] Add cache metadata types: `DvfCacheEntry`, `CacheStatus`
- [ ] Add cache freshness utility functions
- [ ] Add date formatting for "last updated" display

## Dev Notes

### Architecture Reference
- Mobile: WatermelonDB for DVF offline storage (AR6)
- Web: Dexie.js for DVF offline storage (AR7)
- Cache strategy: cache-first with background refresh
- Stale data is better than no data for field visits

### Cache Strategy
```typescript
const DVF_CACHE_TTL = 24 * 60 * 60 * 1000; // 24 hours in ms

const getDvfData = async (propertyId: string) => {
  const cached = await dvfCache.get(propertyId);
  const isFresh = cached && (Date.now() - cached.fetchedAt < DVF_CACHE_TTL);

  if (isFresh) return { data: cached.data, fromCache: true };

  try {
    const fresh = await api.fetchDvf(propertyId);
    await dvfCache.set(propertyId, fresh);
    return { data: fresh, fromCache: false };
  } catch {
    // Return stale cache if available
    if (cached) return { data: cached.data, fromCache: true, stale: true };
    throw new Error('DVF unavailable');
  }
};
```

### WatermelonDB Schema (Mobile)
```typescript
tableSchema({
  name: 'dvf_transactions',
  columns: [
    { name: 'property_id', type: 'string', isIndexed: true },
    { name: 'transaction_data', type: 'string' }, // JSON
    { name: 'fetched_at', type: 'number' },
  ],
})
```

### References
- [Source: epics.md#Story 9.3]
- [Source: architecture.md#AR6 - WatermelonDB offline]
- [Source: architecture.md#AR7 - Dexie.js offline]
- [Source: prd.md#FR50 - DVF cache offline]
- [Source: architecture.md#NFR-R3 - Graceful DVF fallback]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
