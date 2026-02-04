# Story 11.2: Synchronisation automatique au retour réseau

Status: ready-for-dev

## Story

As a utilisateur,
I want que mes données se synchronisent automatiquement,
so that je n'ai aucune action manuelle à effectuer.

## Acceptance Criteria

1. **Given** des données en attente de synchronisation
   **When** la connexion internet revient
   **Then** le sync engine déclenche automatiquement la synchronisation
   **And** les données sont envoyées via `POST /api/sync` (delta incrémental via `updated_at`)
   **And** les conflits sont résolus en last-write-wins

2. **Given** une synchronisation en cours
   **When** le processus se termine
   **Then** les entités synchronisées passent de `pending` à `synced`
   **And** les nouvelles données du serveur sont intégrées localement
   **And** un feedback discret confirme "Synchronisation terminée"

3. **Given** un échec de synchronisation (réseau instable)
   **When** la requête échoue
   **Then** le système retry avec backoff exponentiel (1s, 2s, 4s, 8s...)
   **And** aucune donnée n'est perdue
   **And** l'utilisateur est informé discrètement après plusieurs échecs

## Tasks / Subtasks

- [ ] Task 1: Implémenter détection connectivité (AC: #1)
  - [ ] Mobile: utiliser NetInfo pour détecter online/offline
  - [ ] Web: utiliser navigator.onLine + online/offline events
  - [ ] Créer hook useNetworkStatus partageable

- [ ] Task 2: Implémenter Sync Engine Mobile (AC: #1, #2)
  - [ ] Créer syncEngine.ts avec WatermelonDB sync primitives
  - [ ] Collecter entités avec syncStatus: pending
  - [ ] Appeler POST /api/sync avec delta
  - [ ] Appliquer les données serveur en retour

- [ ] Task 3: Implémenter Sync Engine Web (AC: #1, #2)
  - [ ] Créer syncEngine.ts pour Dexie.js
  - [ ] Même logique que mobile
  - [ ] Utiliser Dexie transactions

- [ ] Task 4: Conflict resolution (AC: #1)
  - [ ] Implémenter last-write-wins basé sur updated_at
  - [ ] Documenter la stratégie de résolution

- [ ] Task 5: Retry avec backoff (AC: #3)
  - [ ] Implémenter exponential backoff (1s, 2s, 4s, 8s, max 30s)
  - [ ] Limiter à 5 tentatives
  - [ ] Afficher message après échecs répétés

- [ ] Task 6: Feedback UI (AC: #2, #3)
  - [ ] Toast/Snackbar "Synchronisation terminée"
  - [ ] Indicateur d'erreur si échec

## Dev Notes

### Sync API Contract
```typescript
// POST /api/sync
interface SyncRequest {
  lastSyncAt: string; // ISO 8601
  changes: {
    properties: PropertyChange[];
    contacts: ContactChange[];
    // ...
  };
}

interface SyncResponse {
  serverTime: string;
  changes: {
    properties: Property[];
    contacts: Contact[];
    // ...
  };
}
```

### Network Detection
```typescript
// Mobile (React Native)
import NetInfo from '@react-native-community/netinfo';

// Web
const isOnline = navigator.onLine;
window.addEventListener('online', handleOnline);
window.addEventListener('offline', handleOffline);
```

### References
- [Source: epics.md#Story 11.2]
- [Source: architecture.md#Sync Engine]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
