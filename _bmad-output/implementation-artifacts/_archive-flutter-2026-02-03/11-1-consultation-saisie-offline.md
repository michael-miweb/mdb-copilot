# Story 11.1 : Consultation et saisie offline

Status: ready-for-dev

## Story

As a utilisateur sur le terrain,
I want consulter et modifier mes fiches annonces sans connexion internet,
So that je travaille efficacement même dans des zones sans réseau.

## Acceptance Criteria

1. **Given** un utilisateur avec des fiches synchronisées
   **When** l'appareil perd la connexion internet
   **Then** toutes les fiches annonces restent consultables depuis Drift
   **And** l'utilisateur peut créer de nouvelles fiches
   **And** l'utilisateur peut modifier des fiches existantes
   **And** les photos stockées localement restent consultables

2. **Given** des modifications effectuées en mode offline
   **When** l'utilisateur crée ou modifie des données
   **Then** chaque entité modifiée est marquée `syncStatus: pending`
   **And** un indicateur visuel discret montre les données non synchronisées

## Tasks / Subtasks

- [ ] Task 1 : Configurer Drift pour offline-first (AC: #1)
  - [ ] 1.1 Installer dépendances : `drift`, `drift_flutter`, `sqlcipher_flutter_libs`
  - [ ] 1.2 Créer `AppDatabase` dans `lib/core/db/app_database.dart`
  - [ ] 1.3 Configurer SQLCipher pour chiffrement local (RGPD)
  - [ ] 1.4 Générer code Drift : `dart run build_runner build`
  - [ ] 1.5 Initialiser database au démarrage app (DI)

- [ ] Task 2 : Créer les tables Drift principales (AC: #1)
  - [ ] 2.1 Créer `PropertiesTable` dans `lib/core/db/tables/properties_table.dart`
  - [ ] 2.2 Ajouter colonnes : id (UUID), address, surface, price, propertyType, urgency, notes, syncStatus, createdAt, updatedAt, deletedAt
  - [ ] 2.3 Créer `PhotosTable` pour stockage métadonnées photos (path local, propertyId, zone)
  - [ ] 2.4 Créer `ChecklistsTable` et `ChecklistItemsTable`
  - [ ] 2.5 Créer `VisitGuidesTable` et `VisitGuideResponsesTable`
  - [ ] 2.6 Créer `PipelineStagesTable` pour statuts Kanban

- [ ] Task 3 : Implémenter la colonne `syncStatus` (AC: #2)
  - [ ] 3.1 Ajouter enum `SyncStatus` (synced, pending, error) dans `lib/core/sync/sync_status.dart`
  - [ ] 3.2 Ajouter colonne `syncStatus` (TEXT) dans toutes les tables principales
  - [ ] 3.3 Valeur par défaut `pending` pour nouvelles entités
  - [ ] 3.4 Valeur `synced` après sync réussie
  - [ ] 3.5 Valeur `error` après échec sync (après retries)

- [ ] Task 4 : Créer `PropertyRepository` avec source locale (AC: #1)
  - [ ] 4.1 Créer `PropertyLocalSource` dans `lib/features/properties/data/`
  - [ ] 4.2 Méthodes CRUD : `create()`, `getAll()`, `getById()`, `update()`, `delete()` (soft delete)
  - [ ] 4.3 Toutes les méthodes utilisent Drift uniquement (pas d'appel API)
  - [ ] 4.4 Chaque write marque `syncStatus = pending` et met à jour `updatedAt`
  - [ ] 4.5 Créer `PropertyRepository` qui wrap `PropertyLocalSource`

- [ ] Task 5 : Gérer le stockage local des photos (AC: #1)
  - [ ] 5.1 Créer `PhotoLocalSource` dans `lib/features/properties/data/`
  - [ ] 5.2 Méthode `savePhoto(file, propertyId, zone)` compresse et sauvegarde dans app directory
  - [ ] 5.3 Stocker métadonnées (path, propertyId, zone) dans `PhotosTable`
  - [ ] 5.4 Méthode `getPhotos(propertyId)` retourne liste des photos locales
  - [ ] 5.5 Marquer photos avec `syncStatus = pending` jusqu'à upload serveur

- [ ] Task 6 : Créer indicateur visuel sync status (AC: #2)
  - [ ] 6.1 Créer widget `SyncStatusIndicator` dans `lib/core/widgets/`
  - [ ] 6.2 Afficher icône subtile (point orange) si données pending
  - [ ] 6.3 Afficher texte "Sync en attente" si tap sur indicateur
  - [ ] 6.4 Intégrer dans AppBar ou BottomNavigationBar
  - [ ] 6.5 Écouter stream Drift pour compter entités avec `syncStatus = pending`

- [ ] Task 7 : Tester le mode offline complet (AC: #1, #2)
  - [ ] 7.1 Simuler perte connexion (mode avion)
  - [ ] 7.2 Créer nouvelle fiche annonce → vérifier stockage Drift + syncStatus pending
  - [ ] 7.3 Modifier fiche existante → vérifier update + syncStatus pending
  - [ ] 7.4 Consulter liste fiches → vérifier données chargées depuis Drift
  - [ ] 7.5 Consulter photos → vérifier chargement depuis cache local
  - [ ] 7.6 Vérifier indicateur sync status affiche bien les données pending

- [ ] Task 8 : Tests unitaires et validation (AC: #1, #2)
  - [ ] 8.1 Tester `PropertyLocalSource.create()` marque syncStatus pending
  - [ ] 8.2 Tester `PropertyLocalSource.update()` met à jour updatedAt et syncStatus
  - [ ] 8.3 Tester `PhotoLocalSource.savePhoto()` stocke bien en local
  - [ ] 8.4 Tester comptage entités pending pour indicateur
  - [ ] 8.5 Tester chiffrement SQLCipher (vérifier DB chiffrée sur disque)

## Dev Notes

### Architecture & Contraintes

- **Drift (SQLite)** : Base de données locale type-safe, chiffrée via SQLCipher [Source: architecture.md#Data Architecture]
- **Offline-first** : Toutes les opérations CRUD se font d'abord en local, sync en background [Source: architecture.md#NFRs]
- **Repository pattern** : Abstraction local/remote, cette story implémente la partie locale uniquement [Source: architecture.md#Frontend Architecture]
- **UUID v4** : Tous les IDs sont des UUID générés côté client pour éviter les collisions [Source: architecture.md#Format Patterns]
- **Soft deletes** : Colonne `deletedAt` pour marquage suppression, purge programmée [Source: architecture.md#Data Architecture]

### Configuration Drift

**`pubspec.yaml` :**

```yaml
dependencies:
  drift: ^2.x
  drift_flutter: ^0.x
  sqlcipher_flutter_libs: ^0.x
  uuid: ^4.x

dev_dependencies:
  drift_dev: ^2.x
  build_runner: ^2.x
```

**`AppDatabase` :**

```dart
@DriftDatabase(tables: [
  PropertiesTable,
  PhotosTable,
  ChecklistsTable,
  ChecklistItemsTable,
  VisitGuidesTable,
  VisitGuideResponsesTable,
  PipelineStagesTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'mdb_copilot.db'));

    return NativeDatabase.createInBackground(
      file,
      logStatements: true,
      enableCipher: true,
      cipherKey: 'YOUR_ENCRYPTION_KEY', // Stocker dans flutter_secure_storage
    );
  });
}
```

### Versions techniques confirmées

- **Drift** : 2.x
- **SQLCipher** : 4.x (via sqlcipher_flutter_libs)
- **UUID** : 4.x (package uuid)
- **Flutter** : 3.38.x

### Structure cible

```
lib/core/db/
├── app_database.dart
├── app_database.g.dart
└── tables/
    ├── properties_table.dart
    ├── photos_table.dart
    ├── checklists_table.dart
    ├── checklist_items_table.dart
    ├── visit_guides_table.dart
    ├── visit_guide_responses_table.dart
    └── pipeline_stages_table.dart

lib/core/sync/
├── sync_status.dart
└── connectivity_monitor.dart

lib/core/widgets/
└── sync_status_indicator.dart

lib/features/properties/data/
├── property_local_source.dart
├── property_repository.dart
└── photo_local_source.dart
```

### Project Structure Notes

Cette story met en place la couche de persistance locale (Drift) et le mode offline pour toutes les features. Les autres features (checklist, visit_guide, etc.) pourront réutiliser le même pattern Repository + LocalSource.

- Toutes les tables Drift sont créées dans cette story
- Le `SyncEngine` (sync automatique au retour réseau) sera implémenté dans Story 11.2
- L'indicateur `SyncStatusIndicator` sera présent dans toute l'app

### References

- [Source: epics.md#Story 11.1] — Acceptance criteria BDD
- [Source: architecture.md#Data Architecture] — Drift + SQLCipher
- [Source: architecture.md#Frontend Architecture] — Repository pattern
- [Source: architecture.md#Format Patterns] — UUID v4, montants en centimes
- [Source: architecture.md#NFRs] — Offline-first
- [Source: architecture.md#Project Structure & Boundaries] — Structure Drift tables

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
