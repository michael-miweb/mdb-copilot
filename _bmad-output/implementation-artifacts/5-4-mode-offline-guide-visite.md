# Story 5.4: Mode offline du guide de visite

Status: ready-for-dev

## Story

As a utilisateur sur le terrain,
I want utiliser le guide de visite sans connexion internet,
so that je peux visiter des biens en cave, parking souterrain ou zone blanche.

## Acceptance Criteria

**Given** le guide de visite ouvert
**When** l'appareil perd la connexion internet
**Then** le guide fonctionne integralement sans interruption
**And** toutes les reponses sont stockees localement (WatermelonDB mobile, Dexie web)
**And** les photos sont stockees localement

**Given** des donnees saisies en mode offline
**When** le reseau revient
**Then** les donnees sont synchronisees automatiquement en arriere-plan
**And** les photos sont uploadees dans une queue de priorite basse
**And** aucune action manuelle n'est requise

**Given** une visite terminee en mode offline
**When** l'utilisateur quitte le guide
**Then** un indicateur montre "Donnees en attente de sync"
**And** la synthese post-visite peut etre generee localement

## Tasks / Subtasks

### Backend API
- [ ] Add visit guide data to sync endpoint: POST /api/sync
- [ ] Handle visit_guides, visit_guide_answers, visit_guide_notes in sync payload
- [ ] Add photo upload queue endpoint: POST /api/visit-guides/{id}/photos/batch
- [ ] Implement delta sync for visit guide data (updated_at based)
- [ ] Write tests for sync endpoint with visit guide data

### Mobile App (React Native)
- [ ] Ensure complete WatermelonDB schema for offline visit guide
- [ ] Create OfflineSyncIndicator component showing pending sync status
- [ ] Implement NetInfo listener for connectivity changes
- [ ] Create syncVisitGuide service for background sync
- [ ] Implement photo upload queue with priority management
- [ ] Add local synthesis generation (client-side logic)
- [ ] Handle sync conflicts with last-write-wins strategy
- [ ] Create useOfflineStatus hook
- [ ] Write integration tests for offline mode
- [ ] Write tests for sync on reconnection

### Web App (React)
- [ ] Ensure complete Dexie.js schema for offline visit guide
- [ ] Create OfflineSyncIndicator component
- [ ] Implement navigator.onLine listener for connectivity
- [ ] Create syncVisitGuide service for background sync
- [ ] Implement photo upload queue (IndexedDB Blob storage)
- [ ] Add local synthesis generation
- [ ] Handle sync conflicts with last-write-wins
- [ ] Create useOfflineStatus hook
- [ ] Write tests for offline functionality
- [ ] Write tests for sync process

### Shared Package
- [ ] Add SyncStatus enum (pending, syncing, synced, error)
- [ ] Add sync payload types for visit guide
- [ ] Add offline status utilities
- [ ] Add synthesis generation logic (pure functions)

## Dev Notes

### Architecture Reference
- Mobile offline: WatermelonDB (AR6) with sync primitives (AR32)
- Web offline: Dexie.js (AR7) with custom sync (AR33)
- Connectivity detection: NetInfo mobile (AR34), navigator.onLine web
- Sync endpoint: POST /api/sync (AR31)
- Conflict resolution: Last-write-wins (AR30)

### Offline Sync Flow
```
1. User makes changes offline
2. Changes stored locally with syncStatus: 'pending'
3. NetInfo/navigator.onLine detects reconnection
4. Sync engine collects pending changes
5. POST /api/sync with delta payload
6. Server responds with merged data
7. Local DB updated, syncStatus: 'synced'
8. Photo queue processes uploads in background
```

### Photo Upload Queue
```typescript
interface PhotoUploadQueue {
  add(photo: LocalPhoto): void;
  process(): Promise<void>; // Called when online
  getPending(): LocalPhoto[];
  getProgress(): { uploaded: number; total: number };
}
```

### Offline Indicator States
```typescript
type OfflineIndicatorState =
  | 'online' // Connected, all synced
  | 'offline' // No connection
  | 'syncing' // Connection restored, syncing
  | 'pending' // Online but items pending sync
  | 'error'; // Sync failed after retries
```

### References
- [Source: epics.md#Story 5.4]
- [Source: prd.md#FR34, FR44-FR47]
- [Source: architecture.md#AR6, AR7, AR29-AR34, AR48]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
