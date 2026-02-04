# Story 11.1: Consultation et saisie offline

Status: ready-for-dev

## Story

As a utilisateur sur le terrain,
I want consulter et modifier mes données sans connexion internet,
so that je travaille efficacement même dans des zones sans réseau.

## Acceptance Criteria

1. **Given** un utilisateur avec des données synchronisées
   **When** l'appareil perd la connexion internet
   **Then** toutes les fiches annonces restent consultables depuis la DB locale
   **And** l'utilisateur peut créer de nouvelles fiches
   **And** l'utilisateur peut modifier des fiches existantes
   **And** les photos stockées localement restent consultables

2. **Given** des modifications effectuées en mode offline
   **When** l'utilisateur crée ou modifie des données
   **Then** chaque entité modifiée est marquée `syncStatus: pending`
   **And** un indicateur visuel discret montre "Données en attente de sync"

## Tasks / Subtasks

- [ ] Task 1: Configurer WatermelonDB pour offline (Mobile) (AC: #1)
  - [ ] Créer schema WatermelonDB pour Property, Contact, Checklist, VisitGuide
  - [ ] Configurer les modèles avec champs syncStatus
  - [ ] Implémenter les repositories avec accès local
  - [ ] Tester lecture offline

- [ ] Task 2: Configurer Dexie.js pour offline (Web) (AC: #1)
  - [ ] Créer schema Dexie pour les mêmes entités
  - [ ] Configurer useLiveQuery pour réactivité
  - [ ] Implémenter repositories web
  - [ ] Tester lecture offline

- [ ] Task 3: Implémenter création/modification offline (AC: #1, #2)
  - [ ] Ajouter champ syncStatus à tous les modèles
  - [ ] Marquer `pending` sur chaque write local
  - [ ] Stocker timestamp de modification

- [ ] Task 4: Indicateur visuel sync status (AC: #2)
  - [ ] Créer composant OfflineSyncIndicator
  - [ ] Afficher nombre d'entités en attente
  - [ ] Style discret (badge ou icône)

## Dev Notes

### Architecture Reference
- **Mobile DB**: WatermelonDB avec SQLite
- **Web DB**: Dexie.js avec IndexedDB
- **Sync Status**: `synced` | `pending` | `error`

### WatermelonDB Schema Example
```typescript
// apps/mobile/src/core/db/schema.ts
import { appSchema, tableSchema } from '@nozbe/watermelondb';

export const schema = appSchema({
  version: 1,
  tables: [
    tableSchema({
      name: 'properties',
      columns: [
        { name: 'user_id', type: 'string' },
        { name: 'address', type: 'string' },
        { name: 'price', type: 'number' },
        { name: 'sync_status', type: 'string' },
        { name: 'updated_at', type: 'number' },
      ],
    }),
  ],
});
```

### References
- [Source: epics.md#Story 11.1]
- [Source: architecture.md#Data Architecture]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
