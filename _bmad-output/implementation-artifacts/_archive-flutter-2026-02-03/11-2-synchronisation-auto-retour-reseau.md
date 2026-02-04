# Story 11.2 : Synchronisation automatique au retour réseau

Status: ready-for-dev

## Story

As a utilisateur,
I want que mes données se synchronisent automatiquement quand je retrouve le réseau,
So that je n'ai aucune action manuelle à effectuer.

## Acceptance Criteria

1. **Given** des données en attente de synchronisation
   **When** la connexion internet revient
   **Then** le `SyncEngine` déclenche automatiquement la synchronisation
   **And** les données sont envoyées via `POST /api/sync` (delta incrémental via `updated_at`)
   **And** les conflits sont résolus en last-write-wins

2. **Given** une synchronisation en cours
   **When** le processus se termine
   **Then** les entités synchronisées passent de `syncStatus: pending` à `synced`
   **And** les nouvelles données du serveur sont intégrées localement

3. **Given** un échec de synchronisation (réseau instable)
   **When** la requête échoue
   **Then** le système retry avec backoff exponentiel
   **And** aucune donnée n'est perdue
   **And** l'utilisateur est informé discrètement si la sync échoue après plusieurs tentatives

## Tasks / Subtasks

- [ ] Task 1 : Créer le `ConnectivityMonitor` (AC: #1)
  - [ ] 1.1 Installer package `connectivity_plus`
  - [ ] 1.2 Créer `ConnectivityMonitor` dans `lib/core/sync/connectivity_monitor.dart`
  - [ ] 1.3 Méthode `isConnected()` retourne bool (connexion disponible ou non)
  - [ ] 1.4 Stream `onConnectivityChanged` émet événements changement connexion
  - [ ] 1.5 Tester détection perte/retour connexion

- [ ] Task 2 : Créer le `SyncEngine` (AC: #1, #2, #3)
  - [ ] 2.1 Créer `SyncEngine` dans `lib/core/sync/sync_engine.dart`
  - [ ] 2.2 Écouter stream `ConnectivityMonitor.onConnectivityChanged`
  - [ ] 2.3 Déclencher sync automatiquement au retour réseau
  - [ ] 2.4 Méthode `sync()` orchestre la synchronisation complète
  - [ ] 2.5 Singleton ou injecté via DI au démarrage app

- [ ] Task 3 : Implémenter le delta incrémental (AC: #1)
  - [ ] 3.1 Méthode `collectPendingChanges()` dans SyncEngine
  - [ ] 3.2 Query Drift : `SELECT * WHERE syncStatus = 'pending' ORDER BY updated_at`
  - [ ] 3.3 Grouper par entité (properties, checklists, visit_guides, etc.)
  - [ ] 3.4 Construire payload JSON avec toutes les entités modifiées
  - [ ] 3.5 Inclure `updated_at` pour résolution conflits last-write-wins

- [ ] Task 4 : Créer endpoint backend `POST /api/sync` (AC: #1, #2)
  - [ ] 4.1 Créer `SyncController` dans `app/Http/Controllers/Api/SyncController.php`
  - [ ] 4.2 Créer `SyncService` dans `app/Services/SyncService.php`
  - [ ] 4.3 Méthode `sync(Request $request)` reçoit delta client
  - [ ] 4.4 Parser payload : properties, checklists, visit_guides, photos
  - [ ] 4.5 Pour chaque entité : upsert en DB, résolution last-write-wins via `updated_at`
  - [ ] 4.6 Retourner delta serveur : nouvelles données + entités mises à jour par d'autres clients

- [ ] Task 5 : Implémenter la résolution de conflits (AC: #1)
  - [ ] 5.1 Backend : comparer `updated_at` client vs serveur
  - [ ] 5.2 Si `updated_at` client > serveur : écraser avec données client (last-write-wins)
  - [ ] 5.3 Si `updated_at` serveur > client : ignorer données client, retourner version serveur
  - [ ] 5.4 Client : appliquer delta serveur reçu et mettre à jour Drift
  - [ ] 5.5 Logger conflits pour debug (optionnel)

- [ ] Task 6 : Mettre à jour `syncStatus` après sync (AC: #2)
  - [ ] 6.1 Méthode `markAsSynced(entityId)` dans SyncEngine
  - [ ] 6.2 Update Drift : `SET syncStatus = 'synced' WHERE id = ?`
  - [ ] 6.3 Appeler après confirmation serveur pour chaque entité
  - [ ] 6.4 Si delta serveur inclut nouvelles données : insérer en local avec syncStatus = synced
  - [ ] 6.5 Émettre événement `SyncCompleted` pour UI

- [ ] Task 7 : Implémenter retry avec backoff exponentiel (AC: #3)
  - [ ] 7.1 Créer `RetryPolicy` dans `lib/core/sync/retry_policy.dart`
  - [ ] 7.2 Paramètres : maxRetries = 5, baseDelay = 2s, maxDelay = 60s
  - [ ] 7.3 Formule backoff : `delay = min(baseDelay * 2^attempt, maxDelay)`
  - [ ] 7.4 Wrapper `sync()` avec try/catch et retry logic
  - [ ] 7.5 Après maxRetries, marquer entités `syncStatus = error` et notifier user

- [ ] Task 8 : Upload des photos en queue background (AC: #2, #3)
  - [ ] 8.1 Créer endpoint `POST /api/photos` pour upload
  - [ ] 8.2 Méthode `uploadPendingPhotos()` dans SyncEngine
  - [ ] 8.3 Query photos avec `syncStatus = pending`
  - [ ] 8.4 Upload chaque photo via multipart/form-data
  - [ ] 8.5 Marquer `syncStatus = synced` après upload réussi
  - [ ] 8.6 Retry avec backoff si échec upload

- [ ] Task 9 : Tests et validation (AC: #1, #2, #3)
  - [ ] 9.1 Tester `ConnectivityMonitor` détection changement réseau
  - [ ] 9.2 Tester `SyncEngine.sync()` avec données pending
  - [ ] 9.3 Tester résolution last-write-wins (mock serveur)
  - [ ] 9.4 Tester retry avec backoff exponentiel
  - [ ] 9.5 Tester mise à jour syncStatus après sync réussie
  - [ ] 9.6 Tester upload photos en background
  - [ ] 9.7 Tester notification user après échec maxRetries

## Dev Notes

### Architecture & Contraintes

- **SyncEngine** : Composant central pour synchronisation offline-first [Source: architecture.md#Cross-Cutting Concerns]
- **Delta incrémental** : Seules les entités modifiées (`syncStatus = pending`) sont envoyées [Source: architecture.md#Data Architecture]
- **Last-write-wins** : Résolution de conflits simple via `updated_at` [Source: architecture.md#Data Architecture]
- **Connectivity monitoring** : Package `connectivity_plus` pour détecter changements réseau [Source: architecture.md#Frontend Architecture]
- **Background isolate** : Sync peut tourner en background pour ne pas bloquer UI (optionnel)

### Endpoint `POST /api/sync`

**Request payload :**

```json
{
  "properties": [
    {
      "id": "uuid-v4",
      "address": "...",
      "updated_at": "2026-01-28T10:30:00Z",
      "sync_status": "pending"
    }
  ],
  "checklists": [...],
  "visit_guides": [...],
  "last_sync_at": "2026-01-27T08:00:00Z"
}
```

**Response payload :**

```json
{
  "synced_entities": ["uuid-1", "uuid-2"],
  "server_delta": {
    "properties": [
      {
        "id": "uuid-3",
        "updated_at": "2026-01-28T11:00:00Z",
        "..."
      }
    ]
  },
  "conflicts": []
}
```

### Backoff exponentiel

| Attempt | Delay |
|---------|-------|
| 1 | 2s |
| 2 | 4s |
| 3 | 8s |
| 4 | 16s |
| 5 | 32s |
| 6+ | 60s (max) |

### Versions techniques confirmées

- **connectivity_plus** : 6.x
- **Laravel** : 12.x
- **Drift** : 2.x
- **Flutter** : 3.38.x

### Structure cible

**Flutter :**

```
lib/core/sync/
├── sync_engine.dart
├── sync_status.dart
├── connectivity_monitor.dart
└── retry_policy.dart
```

**Laravel :**

```
app/Http/Controllers/Api/
└── SyncController.php

app/Services/
└── SyncService.php

routes/api.php (ajouter route POST /api/sync)
```

### Project Structure Notes

Cette story complète le système offline-first initié dans Story 11.1. Le `SyncEngine` sera utilisé par toutes les features nécessitant une synchronisation (properties, checklists, visit_guides, photos).

- Dépend de Story 11.1 (tables Drift + colonne syncStatus)
- L'endpoint `/api/sync` est protégé par middleware `auth:sanctum`
- Le SyncEngine est un singleton initialisé au démarrage app

### References

- [Source: epics.md#Story 11.2] — Acceptance criteria BDD
- [Source: architecture.md#Data Architecture] — Delta incrémental, last-write-wins
- [Source: architecture.md#API & Communication Patterns] — Endpoint sync batch
- [Source: architecture.md#Cross-Cutting Concerns] — Sync engine
- [Source: architecture.md#Frontend Architecture] — Repository pattern
- [Source: architecture.md#Project Structure & Boundaries] — Sync boundary

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
