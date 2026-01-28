# Story 2.1 : Création d'une fiche annonce

Status: ready-for-dev

## Story

As a utilisateur,
I want créer une fiche annonce avec les informations du bien et de l'agent,
So that je centralise toutes les données d'une opportunité immobilière.

## Acceptance Criteria

1. **Given** un utilisateur connecté
   **When** il remplit le formulaire de création (adresse, surface, prix, type de bien)
   **Then** une fiche annonce est créée avec un UUID v4
   **And** la fiche est stockée localement via Drift et synchronisée au serveur

2. **Given** le formulaire de création
   **When** l'utilisateur renseigne les informations agent (nom, agence, téléphone)
   **Then** ces informations sont enregistrées dans la fiche
   **And** les champs agent sont optionnels

3. **Given** le formulaire de création
   **When** l'utilisateur sélectionne un niveau d'urgence de vente (faible, moyen, élevé)
   **Then** l'urgence est enregistrée dans la fiche
   **And** le champ urgence est optionnel avec valeur par défaut "non renseigné"

4. **Given** le formulaire de création
   **When** l'utilisateur ajoute des notes libres
   **Then** les notes sont enregistrées en texte libre dans la fiche

## Tasks / Subtasks

- [ ] Task 1 : Créer le modèle Property et la migration backend (AC: #1, #2, #3, #4)
  - [ ] 1.1 Créer la migration `create_properties_table.php` avec colonnes :
    - `id` (UUID primary key)
    - `user_id` (foreign key vers users)
    - `address` (string 500)
    - `surface` (integer, m²)
    - `price` (integer, centimes)
    - `property_type` (enum: appartement, maison, terrain, immeuble, commercial)
    - `agent_name` (string 255, nullable)
    - `agent_agency` (string 255, nullable)
    - `agent_phone` (string 50, nullable)
    - `sale_urgency` (enum: not_specified, low, medium, high, default: not_specified)
    - `notes` (text, nullable)
    - `created_at`, `updated_at`, `deleted_at` (soft delete)
  - [ ] 1.2 Créer le modèle Eloquent `app/Models/Property.php` avec :
    - Trait `HasUuids`, `SoftDeletes`
    - Casts : `price` integer, `created_at` datetime, `updated_at` datetime
    - Relation `belongsTo(User::class)`
  - [ ] 1.3 Exécuter la migration : `sail artisan migrate`

- [ ] Task 2 : Créer le PropertyController backend (AC: #1)
  - [ ] 2.1 Créer `app/Http/Controllers/Api/PropertyController.php` avec actions :
    - `index()` : liste des fiches de l'utilisateur authentifié
    - `store(StorePropertyRequest $request)` : création fiche
    - `show(Property $property)` : détail fiche
    - `update(UpdatePropertyRequest $request, Property $property)` : modification (Task 3)
    - `destroy(Property $property)` : soft delete (Task 3)
  - [ ] 2.2 Créer `app/Http/Requests/StorePropertyRequest.php` avec validation :
    - `address` required string max:500
    - `surface` required integer min:1
    - `price` required integer min:0 (centimes)
    - `property_type` required enum
    - `agent_name` nullable string max:255
    - `agent_agency` nullable string max:255
    - `agent_phone` nullable string max:50
    - `sale_urgency` nullable enum (default: not_specified)
    - `notes` nullable string max:10000
  - [ ] 2.3 Créer `app/Http/Resources/PropertyResource.php` pour transformer en JSON snake_case
  - [ ] 2.4 Ajouter les routes dans `routes/api.php` :
    - `Route::middleware('auth:sanctum')->group(function () { Route::apiResource('properties', PropertyController::class); });`

- [ ] Task 3 : Créer la table Drift properties_table (AC: #1)
  - [ ] 3.1 Créer `lib/core/db/tables/properties_table.dart` avec :
    - `id` text primary key (UUID v4)
    - `userId` text
    - `address` text
    - `surface` integer
    - `price` integer (centimes)
    - `propertyType` text
    - `agentName` text nullable
    - `agentAgency` text nullable
    - `agentPhone` text nullable
    - `saleUrgency` text
    - `notes` text nullable
    - `syncStatus` text (pending, synced)
    - `createdAt` datetime
    - `updatedAt` datetime
    - `deletedAt` datetime nullable
  - [ ] 3.2 Ajouter la table dans `lib/core/db/app_database.dart` : `@DriftDatabase(tables: [PropertiesTable, ...])`
  - [ ] 3.3 Générer le code : `dart run build_runner build --delete-conflicting-outputs`

- [ ] Task 4 : Créer le modèle Property Flutter (AC: #1, #2, #3, #4)
  - [ ] 4.1 Créer `lib/features/properties/data/models/property_model.dart` avec :
    - Classe `PropertyModel` avec tous les champs (camelCase)
    - Factory `fromJson(Map<String, dynamic> json)` pour API (snake_case → camelCase)
    - Factory `fromDrift(PropertiesTableData data)` pour Drift
    - Méthode `toJson()` pour API (camelCase → snake_case)
    - Méthode `toCompanion()` pour Drift insert/update
  - [ ] 4.2 Créer enum `PropertyType` : apartment, house, land, building, commercial
  - [ ] 4.3 Créer enum `SaleUrgency` : notSpecified, low, medium, high

- [ ] Task 5 : Créer PropertyRepository avec sources local et remote (AC: #1)
  - [ ] 5.1 Créer `lib/features/properties/data/property_local_source.dart` avec :
    - Injection `AppDatabase` (Drift)
    - `Future<List<PropertyModel>> getAll()`
    - `Future<PropertyModel?> getById(String id)`
    - `Future<void> insert(PropertyModel property)` avec `syncStatus: pending`
    - `Future<void> update(PropertyModel property)` avec `syncStatus: pending`
    - `Future<void> delete(String id)` (soft delete avec `deletedAt`)
  - [ ] 5.2 Créer `lib/features/properties/data/property_remote_source.dart` avec :
    - Injection `ApiClient`
    - `Future<List<PropertyModel>> fetchAll()`
    - `Future<PropertyModel> create(PropertyModel property)`
    - `Future<PropertyModel> update(String id, PropertyModel property)`
    - `Future<void> delete(String id)`
  - [ ] 5.3 Créer `lib/features/properties/data/property_repository.dart` avec :
    - Injection `PropertyLocalSource`, `PropertyRemoteSource`
    - `Future<List<PropertyModel>> getProperties()` : récupère local, tente sync si réseau
    - `Future<PropertyModel> createProperty(PropertyModel property)` : génère UUID v4, insert local, tente sync
    - `Stream<List<PropertyModel>> watchProperties()` : stream Drift pour UI réactive

- [ ] Task 6 : Créer PropertyCubit et states (AC: #1)
  - [ ] 6.1 Créer `lib/features/properties/presentation/cubit/property_state.dart` avec :
    - `PropertyInitial`
    - `PropertyLoading`
    - `PropertyLoaded(List<PropertyModel> properties)`
    - `PropertyError(String message)`
    - `PropertyCreated(PropertyModel property)`
  - [ ] 6.2 Créer `lib/features/properties/presentation/cubit/property_cubit.dart` avec :
    - Injection `PropertyRepository`
    - `loadProperties()` → `PropertyLoaded` ou `PropertyError`
    - `createProperty(PropertyModel property)` → `PropertyCreated` ou `PropertyError`
    - `watchProperties()` : écoute stream repository

- [ ] Task 7 : Créer l'UI de création de fiche (AC: #1, #2, #3, #4)
  - [ ] 7.1 Créer `lib/features/properties/presentation/pages/create_property_page.dart` avec :
    - Form avec TextFormField pour adresse, surface, prix
    - Dropdown pour property_type
    - Sections optionnelles pour agent (nom, agence, téléphone)
    - Dropdown pour sale_urgency (default: not_specified)
    - TextFormField multiligne pour notes
    - Validation champs obligatoires
    - Bouton "Créer" qui appelle `propertyCubit.createProperty(...)`
  - [ ] 7.2 Créer `lib/features/properties/presentation/widgets/property_form_fields.dart` pour réutilisabilité
  - [ ] 7.3 Ajouter la route dans `lib/app/routes.dart` : `/properties/create`

- [ ] Task 8 : Tests unitaires et intégration (AC: #1, #2, #3, #4)
  - [ ] 8.1 Créer `test/features/properties/data/property_repository_test.dart` : mock sources, test createProperty
  - [ ] 8.2 Créer `test/features/properties/presentation/cubit/property_cubit_test.dart` : test createProperty emit PropertyCreated
  - [ ] 8.3 Créer `tests/Feature/Property/PropertyControllerTest.php` backend : test POST /api/properties retourne 201
  - [ ] 8.4 Vérifier lint : `very_good analyze` (Flutter) et `./vendor/bin/sail pint` (Laravel)

- [ ] Task 9 : Validation finale (AC: #1, #2, #3, #4)
  - [ ] 9.1 Test manuel : créer fiche avec tous champs → vérifier stockage Drift
  - [ ] 9.2 Test manuel : créer fiche en mode offline → vérifier syncStatus pending
  - [ ] 9.3 Test manuel : retour réseau → vérifier sync automatique au serveur
  - [ ] 9.4 Vérifier migration backend OK : `sail artisan migrate:status`
  - [ ] 9.5 Commit : `git add . && git commit -m "feat: création fiche annonce (Story 2.1)"`

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

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
