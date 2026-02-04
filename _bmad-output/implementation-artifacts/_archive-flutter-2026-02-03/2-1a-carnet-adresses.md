# Story 2.1A : Carnet d'adresses — CRUD contacts professionnels

Status: done

## Story

As a utilisateur,
I want gérer un carnet d'adresses de contacts professionnels (agents immobiliers, artisans, notaires, courtiers, etc.),
So that je centralise mes interlocuteurs et les réutilise facilement dans mes fiches annonces et projets.

## Acceptance Criteria

1. **Given** un utilisateur connecté
   **When** il accède au carnet d'adresses
   **Then** la liste de tous ses contacts est affichée, triée par nom
   **And** un filtre par type de contact est disponible (agent immobilier, artisan, notaire, courtier, autre)

2. **Given** le carnet d'adresses
   **When** l'utilisateur crée un nouveau contact (nom, entreprise/agence, téléphone, email, type de contact, notes)
   **Then** le contact est créé avec un UUID v4
   **And** le contact est stocké localement via Drift et synchronisé au serveur
   **And** le champ "nom" et "type de contact" sont obligatoires, les autres champs sont optionnels

3. **Given** le carnet d'adresses
   **When** l'utilisateur tapote sur un contact
   **Then** l'écran détail affiche toutes les informations du contact
   **And** la liste des fiches annonces associées à ce contact est affichée (si type agent immobilier)

4. **Given** un contact existant
   **When** l'utilisateur modifie ses informations
   **Then** les modifications sont enregistrées localement et synchronisées
   **And** le champ `updated_at` est mis à jour

5. **Given** un contact existant
   **When** l'utilisateur choisit de le supprimer
   **Then** une confirmation est demandée
   **And** si le contact est associé à des fiches annonces, un avertissement indique le nombre de fiches liées
   **And** si confirmé, le contact est soft-deleted (marqué `deleted_at`)
   **And** les fiches annonces liées conservent la référence (le contact_id reste, mais l'affichage indique "contact supprimé")

## Tasks / Subtasks

- [x] Task 1 : Créer le modèle Contact et la migration backend (AC: #2)
  - [x] 1.1 Créer la migration `create_contacts_table.php` avec colonnes : id (UUID), user_id (FK), name, company, phone, email, contact_type (enum: agent_immobilier, artisan, notaire, courtier, autre), notes, sync_status, created_at, updated_at, deleted_at
  - [x] 1.2 Créer le modèle Eloquent `app/Models/Contact.php` avec HasUuids, SoftDeletes
  - [x] 1.3 Créer la migration d'ajout `contact_id` (FK nullable) sur la table `properties` en remplacement des champs `agent_name`, `agent_agency`, `agent_phone`

- [x] Task 2 : Créer le ContactController backend (AC: #1, #2, #4, #5)
  - [x] 2.1 Créer `app/Http/Controllers/Api/ContactController.php` (CRUD complet)
  - [x] 2.2 Créer `app/Http/Requests/StoreContactRequest.php`
  - [x] 2.3 Créer `app/Http/Requests/UpdateContactRequest.php`
  - [x] 2.4 Créer `app/Http/Resources/ContactResource.php`
  - [x] 2.5 Ajouter les routes dans `routes/api.php` : `Route::apiResource('contacts', ContactController::class)`
  - [x] 2.6 Ajouter endpoint filtrage par type : `GET /api/contacts?type=agent_immobilier`

- [x] Task 3 : Créer la table Drift contacts_table (AC: #2)
  - [x] 3.1 Créer `lib/core/db/tables/contacts_table.dart`
  - [x] 3.2 Ajouter la table dans `lib/core/db/app_database.dart`
  - [x] 3.3 Ajouter colonne `contactId` (nullable) dans `properties_table.dart`
  - [x] 3.4 Générer le code Drift

- [x] Task 4 : Créer le modèle Contact Flutter (AC: #2)
  - [x] 4.1 Créer `lib/features/contacts/data/models/contact_model.dart`
  - [x] 4.2 Créer enum `ContactType` (agentImmobilier, artisan, notaire, courtier, autre)

- [x] Task 5 : Créer ContactRepository avec sources local et remote (AC: #1, #2, #4, #5)
  - [x] 5.1 Créer `lib/features/contacts/data/contact_local_source.dart`
  - [x] 5.2 Créer `lib/features/contacts/data/contact_remote_source.dart`
  - [x] 5.3 Créer `lib/features/contacts/data/contact_repository.dart`
  - [x] 5.4 Implémenter `getContactsByType(ContactType type)` pour le filtrage

- [x] Task 6 : Créer ContactCubit et states (AC: #1, #2, #4, #5)
  - [x] 6.1 Créer `lib/features/contacts/presentation/cubit/contact_state.dart`
  - [x] 6.2 Créer `lib/features/contacts/presentation/cubit/contact_cubit.dart`

- [x] Task 7 : Créer les écrans UI du carnet d'adresses (AC: #1, #2, #3, #4, #5)
  - [x] 7.1 Créer `lib/features/contacts/presentation/pages/contacts_list_page.dart` (liste avec filtre par type)
  - [x] 7.2 Créer `lib/features/contacts/presentation/pages/contact_detail_page.dart` (détail + fiches liées)
  - [x] 7.3 Créer `lib/features/contacts/presentation/pages/create_contact_page.dart`
  - [x] 7.4 Créer `lib/features/contacts/presentation/pages/edit_contact_page.dart`
  - [x] 7.5 Créer `lib/features/contacts/presentation/widgets/contact_card.dart`
  - [x] 7.6 Créer `lib/features/contacts/presentation/widgets/contact_form_fields.dart`
  - [x] 7.7 Ajouter les routes dans `lib/app/routes.dart` : `/home/contacts`, `/home/contacts/create`, `/home/contacts/:id`, `/home/contacts/:id/edit`
  - [x] 7.8 Ajouter l'entrée "Contacts" dans la navigation (NavigationBar/NavigationRail)

- [x] Task 8 : Tests unitaires et intégration (AC: #1, #2, #3, #4, #5)
  - [x] 8.1 Créer `test/features/contacts/data/contact_repository_test.dart`
  - [x] 8.2 Créer `test/features/contacts/presentation/cubit/contact_cubit_test.dart`
  - [x] 8.3 Créer `tests/Feature/Contact/ContactControllerTest.php`
  - [x] 8.4 Lint clean: flutter analyze (0 issues), pint (pass), phpstan (0 errors)

- [x] Task 9 : Validation finale (AC: #1, #2, #3, #4, #5)
  - [x] 9.1 Tests automatisés valident CRUD complet Contact
  - [x] 9.2 Tests automatisés valident filtrage par type
  - [x] 9.3 Tests automatisés valident soft delete avec avertissement fiches liées
  - [x] 9.4 Migration backend OK (via RefreshDatabase dans tests)

## Dev Notes

### Architecture & Contraintes

- **UUID v4** : Tous les IDs d'entités utilisent UUID v4 [Source: architecture.md#Implementation Patterns & Consistency Rules]
- **Repository pattern** : Abstraction obligatoire entre Cubit et sources de données (local/remote) [Source: architecture.md#Implementation Patterns & Consistency Rules]
- **Soft deletes** : Utilisation de `deleted_at` pour ne jamais perdre de données [Source: architecture.md#Data Architecture]
- **Sync offline** : Chaque création/modification locale marque `syncStatus: pending` [Source: architecture.md#Process Patterns]
- **RGPD** : Les données de contacts professionnels sont des données personnelles — suppression effective possible [Source: prd.md#Security]

### Conventions de nommage

- **Backend (Laravel)** :
  - Table : `contacts` (snake_case, pluriel)
  - Colonnes : `snake_case` → `contact_type`, `user_id`, `created_at`
  - API JSON fields : `snake_case`
  - Enum DB : `agent_immobilier`, `artisan`, `notaire`, `courtier`, `autre`
- **Flutter (Dart)** :
  - Classe : `ContactModel` (PascalCase)
  - Fichiers : `contact_model.dart` (snake_case)
  - Variables : `camelCase` → `contactType`, `createdAt`
  - Enum : `ContactType.agentImmobilier`, `ContactType.artisan`, etc.
  - Drift table : `ContactsTable` (classe PascalCase), colonnes `camelCase`

### Structure Drift table contacts_table

```dart
class ContactsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get company => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get contactType => text()(); // 'agent_immobilier' | 'artisan' | 'notaire' | 'courtier' | 'autre'
  TextColumn get notes => text().nullable()();
  TextColumn get syncStatus => text()(); // 'pending' | 'synced'
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Migration backend — ajout contact_id sur properties

```php
// Migration: add_contact_id_to_properties_table.php
Schema::table('properties', function (Blueprint $table) {
    $table->foreignUuid('contact_id')->nullable()->constrained('contacts')->nullOnDelete();
    // Les colonnes agent_name, agent_agency, agent_phone sont conservées
    // pour la rétrocompatibilité des données existantes (migration progressive)
});
```

### Routes API Laravel

```php
// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('contacts', ContactController::class);
    Route::apiResource('properties', PropertyController::class);
});

// Généré pour contacts :
// GET    /api/contacts           → index() (supporte ?type=agent_immobilier)
// POST   /api/contacts           → store()
// GET    /api/contacts/{id}      → show()
// PUT    /api/contacts/{id}      → update()
// DELETE /api/contacts/{id}      → destroy()
```

### Validation backend (StoreContactRequest)

```php
public function rules(): array
{
    return [
        'name' => 'required|string|max:255',
        'company' => 'nullable|string|max:255',
        'phone' => 'nullable|string|max:50',
        'email' => 'nullable|email|max:255',
        'contact_type' => 'required|in:agent_immobilier,artisan,notaire,courtier,autre',
        'notes' => 'nullable|string|max:10000',
    ];
}
```

### Relation Eloquent

```php
// app/Models/Contact.php
class Contact extends Model
{
    use HasUuids, SoftDeletes;

    protected $fillable = ['name', 'company', 'phone', 'email', 'contact_type', 'notes', 'user_id'];

    public function properties(): HasMany
    {
        return $this->hasMany(Property::class);
    }
}

// app/Models/Property.php (ajout)
public function contact(): BelongsTo
{
    return $this->belongsTo(Contact::class);
}
```

### Project Structure Notes

```
mdb-copilot/
├── backend-api/
│   ├── app/
│   │   ├── Models/Contact.php
│   │   ├── Http/
│   │   │   ├── Controllers/Api/ContactController.php
│   │   │   ├── Requests/StoreContactRequest.php
│   │   │   ├── Requests/UpdateContactRequest.php
│   │   │   └── Resources/ContactResource.php
│   └── database/migrations/
│       ├── xxxx_create_contacts_table.php
│       └── xxxx_add_contact_id_to_properties_table.php
├── mobile-app/
│   ├── lib/
│   │   ├── core/db/tables/contacts_table.dart
│   │   └── features/contacts/
│   │       ├── data/
│   │       │   ├── models/contact_model.dart
│   │       │   ├── contact_local_source.dart
│   │       │   ├── contact_remote_source.dart
│   │       │   └── contact_repository.dart
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── contact_cubit.dart
│   │           │   └── contact_state.dart
│   │           ├── pages/
│   │           │   ├── contacts_list_page.dart
│   │           │   ├── contact_detail_page.dart
│   │           │   ├── create_contact_page.dart
│   │           │   └── edit_contact_page.dart
│   │           └── widgets/
│   │               ├── contact_card.dart
│   │               └── contact_form_fields.dart
│   └── test/features/contacts/
```

### References

- [Source: architecture.md#Data Architecture] — UUID v4, soft deletes
- [Source: architecture.md#Frontend Architecture] — Repository pattern, Bloc/Cubit
- [Source: architecture.md#Naming Patterns] — snake_case API/DB, camelCase Dart
- [Source: architecture.md#Project Structure & Boundaries] — Structure features Flutter + Laravel
- [Source: prd.md#FR50, FR51, FR52] — Carnet d'adresses, CRUD contacts, sélecteur agent
- **Dépendance** : Story 2.1B, 2.2, 2.3 dépendent de cette story pour l'intégration du sélecteur contact
