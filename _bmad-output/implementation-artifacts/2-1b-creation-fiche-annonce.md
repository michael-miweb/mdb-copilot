# Story 2.1B : Création d'une fiche annonce

Status: review

## Story

As a utilisateur,
I want créer une fiche annonce avec les informations du bien et de l'agent,
So that je centralise toutes les données d'une opportunité immobilière.

## Acceptance Criteria

1. **Given** un utilisateur connecté
   **When** il remplit le formulaire de création (adresse, surface, prix, type de bien)
   **Then** une fiche annonce est créée avec un UUID v4
   **And** la fiche est stockée localement via Drift et synchronisée au serveur

2. **Given** le formulaire de création, section agent immobilier
   **When** l'utilisateur ouvre le sélecteur d'agent
   **Then** une liste déroulante affiche uniquement les contacts de type "agent immobilier" du carnet d'adresses
   **And** un bouton "Créer un nouveau contact" permet d'ajouter un agent directement sans quitter le formulaire
   **And** le champ agent est optionnel

2b. **Given** le formulaire de création
   **When** l'utilisateur sélectionne un agent existant
   **Then** la fiche annonce est liée au contact via `contact_id` (FK)
   **And** les informations de l'agent (nom, agence, téléphone) s'affichent en lecture seule sous le sélecteur

3. **Given** le formulaire de création
   **When** l'utilisateur sélectionne un niveau d'urgence de vente (faible, moyen, élevé)
   **Then** l'urgence est enregistrée dans la fiche
   **And** le champ urgence est optionnel avec valeur par défaut "non renseigné"

4. **Given** le formulaire de création
   **When** l'utilisateur ajoute des notes libres
   **Then** les notes sont enregistrées en texte libre dans la fiche

## Tasks / Subtasks

- [x] Task 1 : Créer le modèle Property et la migration backend (AC: #1, #2, #3, #4)
  - [x] 1.1 Créer la migration `create_properties_table.php`
  - [x] 1.2 Créer le modèle Eloquent `app/Models/Property.php`
  - [x] 1.3 Exécuter la migration (via tests RefreshDatabase)

- [x] Task 2 : Créer le PropertyController backend (AC: #1)
  - [x] 2.1 Créer `app/Http/Controllers/Api/PropertyController.php`
  - [x] 2.2 Créer `app/Http/Requests/StorePropertyRequest.php`
  - [x] 2.3 Créer `app/Http/Resources/PropertyResource.php`
  - [x] 2.4 Ajouter les routes dans `routes/api.php`

- [x] Task 3 : Créer la table Drift properties_table (AC: #1)
  - [x] 3.1 Créer `lib/core/db/tables/properties_table.dart`
  - [x] 3.2 Ajouter la table dans `lib/core/db/app_database.dart`
  - [x] 3.3 Générer le code Drift

- [x] Task 4 : Créer le modèle Property Flutter (AC: #1, #2, #3, #4)
  - [x] 4.1 Créer `lib/features/properties/data/models/property_model.dart`
  - [x] 4.2 Créer enum `PropertyType`
  - [x] 4.3 Créer enum `SaleUrgency`

- [x] Task 5 : Créer PropertyRepository avec sources local et remote (AC: #1)
  - [x] 5.1 Créer `lib/features/properties/data/property_local_source.dart`
  - [x] 5.2 Créer `lib/features/properties/data/property_remote_source.dart`
  - [x] 5.3 Créer `lib/features/properties/data/property_repository.dart`

- [x] Task 6 : Créer PropertyCubit et states (AC: #1)
  - [x] 6.1 Créer `lib/features/properties/presentation/cubit/property_state.dart`
  - [x] 6.2 Créer `lib/features/properties/presentation/cubit/property_cubit.dart`

- [x] Task 7 : Créer l'UI de création de fiche (AC: #1, #2, #3, #4)
  - [x] 7.1 Créer `lib/features/properties/presentation/pages/create_property_page.dart`
  - [x] 7.2 Créer `lib/features/properties/presentation/widgets/property_form_fields.dart`
  - [x] 7.3 Ajouter la route dans `lib/app/routes.dart` : `/home/properties/create`

- [x] Task 8 : Tests unitaires et intégration (AC: #1, #2, #3, #4)
  - [x] 8.1 Créer `test/features/properties/data/property_repository_test.dart` (5 tests)
  - [x] 8.2 Créer `test/features/properties/presentation/cubit/property_cubit_test.dart` (4 tests)
  - [x] 8.3 Créer `tests/Feature/Property/PropertyControllerTest.php` (11 tests, 49 assertions)
  - [x] 8.4 Lint clean: flutter analyze (0 issues), pint (pass), phpstan (0 errors)

- [x] Task 9 : Validation finale (AC: #1, #2, #3, #4)
  - [x] 9.1 Tests automatisés valident stockage Drift via mocks
  - [x] 9.2 Tests automatisés valident syncStatus pending via mocks
  - [x] 9.3 Tests automatisés valident sync remote via mocks
  - [x] 9.4 Migration backend OK (via RefreshDatabase dans tests)
  - [x] 9.5 Ready for commit

## Migration Tasks — Intégration Carnet d'Adresses (Story 2.1A)

Les tâches ci-dessous sont nécessaires après l'implémentation de la Story 2.4 pour migrer le formulaire de création vers le sélecteur de contact :

- [ ] Task 10 : Ajouter `contactId` (FK nullable) dans PropertiesTable Drift et migration backend
  - [ ] 10.1 Ajouter colonne `contactId` dans `properties_table.dart`
  - [ ] 10.2 Créer migration Laravel `add_contact_id_to_properties_table`
  - [ ] 10.3 Mettre à jour `PropertyModel` avec champ `contactId`
  - [ ] 10.4 Conserver les anciens champs `agentName/agentAgency/agentPhone` pour rétrocompatibilité données existantes

- [ ] Task 11 : Remplacer les champs agent par le sélecteur contact dans le formulaire (AC: #2, #2b)
  - [ ] 11.1 Créer widget `lib/features/properties/presentation/widgets/agent_selector_widget.dart`
    - Dropdown filtré : `contactRepository.getContactsByType(ContactType.agentImmobilier)`
    - Affiche nom + agence pour chaque entrée
    - Bouton "Créer un nouveau contact" → ouvre modal/bottom sheet de création rapide
  - [ ] 11.2 Intégrer `AgentSelectorWidget` dans `property_form_fields.dart` en remplacement des 3 champs texte
  - [ ] 11.3 Mettre à jour `PropertyCubit.createProperty()` pour enregistrer `contactId` au lieu des champs dénormalisés

- [ ] Task 12 : Tests migration contact (AC: #2, #2b)
  - [ ] 12.1 Test repository : createProperty avec contactId
  - [ ] 12.2 Test cubit : createProperty lie correctement le contact
  - [ ] 12.3 Test widget : sélecteur affiche uniquement les agents immobiliers
  - [ ] 12.4 Test widget : bouton création inline fonctionne

## Dev Notes

### Architecture & Contraintes

- **UUID v4** : Tous les IDs d'entités utilisent UUID v4 pour éviter les collisions en mode offline [Source: architecture.md#Implementation Patterns & Consistency Rules]
- **Repository pattern** : Abstraction obligatoire entre Cubit et sources de données (local/remote) [Source: architecture.md#Implementation Patterns & Consistency Rules]
- **Montants en centimes** : Le champ `price` est stocké en integer centimes (`150000` = 1500,00 €) côté API et Drift [Source: architecture.md#Implementation Patterns & Consistency Rules]
- **Soft deletes** : Utilisation de `deleted_at` pour ne jamais perdre de données [Source: architecture.md#Data Architecture]
- **Sync offline** : Chaque création/modification locale marque `syncStatus: pending` pour sync ultérieure [Source: architecture.md#Process Patterns]

### Conventions de nommage

- **Backend (Laravel)** :
  - Table : `properties` (snake_case, pluriel)
  - Colonnes : `snake_case` → `sale_urgency`, `agent_name`, `created_at`
  - API JSON fields : `snake_case` (convention Laravel API Resource)
- **Flutter (Dart)** :
  - Classe : `PropertyModel` (PascalCase)
  - Fichiers : `property_model.dart` (snake_case)
  - Variables : `camelCase` → `saleUrgency`, `agentName`, `createdAt`
  - Drift table : `PropertiesTable` (classe PascalCase), colonnes `camelCase`

[Source: architecture.md#Naming Patterns]

### Structure Drift table properties_table

```dart
class PropertiesTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get address => text()();
  IntColumn get surface => integer()();
  IntColumn get price => integer()(); // centimes
  TextColumn get propertyType => text()();
  TextColumn get agentName => text().nullable()();
  TextColumn get agentAgency => text().nullable()();
  TextColumn get agentPhone => text().nullable()();
  TextColumn get saleUrgency => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get syncStatus => text()(); // 'pending' | 'synced'
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Routes API Laravel

```php
// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('properties', PropertyController::class);
});

// Généré :
// GET    /api/properties       → index()
// POST   /api/properties       → store()
// GET    /api/properties/{id}  → show()
// PUT    /api/properties/{id}  → update()
// DELETE /api/properties/{id}  → destroy()
```

### Validation backend (StorePropertyRequest)

```php
public function rules(): array
{
    return [
        'address' => 'required|string|max:500',
        'surface' => 'required|integer|min:1',
        'price' => 'required|integer|min:0',
        'property_type' => 'required|in:appartement,maison,terrain,immeuble,commercial',
        'agent_name' => 'nullable|string|max:255',
        'agent_agency' => 'nullable|string|max:255',
        'agent_phone' => 'nullable|string|max:50',
        'sale_urgency' => 'nullable|in:not_specified,low,medium,high',
        'notes' => 'nullable|string|max:10000',
    ];
}
```

### PropertyModel Flutter

```dart
class PropertyModel {
  final String id;
  final String userId;
  final String address;
  final int surface;
  final int price; // centimes
  final PropertyType propertyType;
  final String? agentName;
  final String? agentAgency;
  final String? agentPhone;
  final SaleUrgency saleUrgency;
  final String? notes;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  // Factory fromJson pour API (snake_case)
  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      address: json['address'] as String,
      // ... snake_case → camelCase
    );
  }

  // Méthode toJson pour API (camelCase → snake_case)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'address': address,
      'sale_urgency': saleUrgency.toSnakeCase(),
      // ...
    };
  }
}
```

### Project Structure Notes

Cette story implémente la feature `properties` dans la structure monorepo :

```
mdb-copilot/
├── backend-api/
│   ├── app/
│   │   ├── Models/Property.php
│   │   ├── Http/
│   │   │   ├── Controllers/Api/PropertyController.php
│   │   │   ├── Requests/StorePropertyRequest.php
│   │   │   └── Resources/PropertyResource.php
│   └── database/migrations/xxxx_create_properties_table.php
├── mobile-app/
│   ├── lib/
│   │   ├── core/db/tables/properties_table.dart
│   │   └── features/properties/
│   │       ├── data/
│   │       │   ├── models/property_model.dart
│   │       │   ├── property_local_source.dart
│   │       │   ├── property_remote_source.dart
│   │       │   └── property_repository.dart
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── property_cubit.dart
│   │           │   └── property_state.dart
│   │           ├── pages/create_property_page.dart
│   │           └── widgets/property_form_fields.dart
│   └── test/features/properties/
```

[Source: architecture.md#Project Structure & Boundaries]

### References

- [Source: architecture.md#Data Architecture] — UUID v4, soft deletes, montants en centimes
- [Source: architecture.md#Frontend Architecture] — Repository pattern, Bloc/Cubit
- [Source: architecture.md#Naming Patterns] — snake_case API/DB, camelCase Dart
- [Source: architecture.md#Project Structure & Boundaries] — Structure features Flutter + Laravel
- [Source: architecture.md#Implementation Patterns & Consistency Rules] — Conventions obligatoires
- [Source: epics.md#Story 2.1] — Acceptance criteria BDD

## Dev Agent Record

### Agent Model Used

Claude Opus 4.5 (claude-opus-4-5-20251101)

### Debug Log References

- PHPStan: 0 errors on all new PHP files
- Flutter analyze: 0 issues
- Laravel Pint: pass on all new PHP files
- Backend tests: 56 pass (11 new), 0 regressions
- Flutter tests: 58 pass (9 new), 0 regressions

### Completion Notes List

- Implemented full backend CRUD API for properties with UUID, soft deletes, validation
- Added Drift (SQLite) support to Flutter app (new dependency)
- Created offline-first repository pattern: local insert → remote sync → update local status
- PropertyModel supports fromJson (API), fromDrift, toJson, toCompanion conversions
- PropertyCubit manages loading, creation, and error states
- Form UI includes all required fields + optional agent info + urgency + notes
- Price stored in centimes (user enters euros, converted to centimes on submit)
- Added uuid package for client-side UUID v4 generation

### Change Log

- 2026-01-29: Story 2.1 implementation complete — full backend + Flutter property creation feature

### File List

**Backend (new files):**
- backend-api/database/migrations/2026_01_29_000001_create_properties_table.php
- backend-api/app/Models/Property.php
- backend-api/app/Http/Controllers/Api/PropertyController.php
- backend-api/app/Http/Requests/StorePropertyRequest.php
- backend-api/app/Http/Requests/UpdatePropertyRequest.php
- backend-api/app/Http/Resources/PropertyResource.php
- backend-api/tests/Feature/Property/PropertyControllerTest.php

**Backend (modified):**
- backend-api/routes/api.php

**Flutter (new files):**
- mobile-app/lib/core/db/tables/properties_table.dart
- mobile-app/lib/core/db/app_database.dart
- mobile-app/lib/core/db/app_database.g.dart (generated)
- mobile-app/lib/features/properties/data/models/property_model.dart
- mobile-app/lib/features/properties/data/property_local_source.dart
- mobile-app/lib/features/properties/data/property_remote_source.dart
- mobile-app/lib/features/properties/data/property_repository.dart
- mobile-app/lib/features/properties/presentation/cubit/property_state.dart
- mobile-app/lib/features/properties/presentation/cubit/property_cubit.dart
- mobile-app/lib/features/properties/presentation/pages/create_property_page.dart
- mobile-app/lib/features/properties/presentation/widgets/property_form_fields.dart
- mobile-app/test/features/properties/data/property_repository_test.dart
- mobile-app/test/features/properties/presentation/cubit/property_cubit_test.dart

**Flutter (modified):**
- mobile-app/pubspec.yaml (added drift, drift_dev, build_runner, uuid, sqlite3_flutter_libs, path, path_provider)
- mobile-app/lib/app/view/app.dart (wired PropertyCubit + AppDatabase)
- mobile-app/lib/app/routes.dart (added /home/properties/create route)
