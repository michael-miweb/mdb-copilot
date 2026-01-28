# Story 8.1 : Consultation des guides et fiches mémo

Status: ready-for-dev

## Story

As a utilisateur débutant MDB,
I want consulter des guides complets et des fiches mémo synthétiques sur les sujets MDB,
So that je me forme progressivement et évite les erreurs coûteuses.

## Acceptance Criteria

1. **Given** un utilisateur connecté
   **When** il accède à la section "Mémos MDB"
   **Then** une liste de guides complets est affichée organisée par thème (fiscalité, juridique, bonnes pratiques, financement)
   **And** chaque guide contient un contenu éducatif structuré

2. **Given** la section Mémos
   **When** l'utilisateur consulte les fiches mémo synthétiques
   **Then** des fiches condensées (1-2 écrans max) résument les points essentiels de chaque sujet
   **And** les fiches sont consultables rapidement comme aide-mémoire

3. **Given** les guides et fiches mémo
   **When** l'appareil est hors connexion
   **Then** tout le contenu éducatif est consultable en mode offline
   **And** le contenu est pré-chargé lors de la première synchronisation

## Tasks / Subtasks

- [ ] Task 1 : Créer le modèle de données Drift pour les fiches mémo (AC: #1, #2, #3)
  - [ ] 1.1 Créer `memo_cards_table.dart` dans `mobile-app/lib/core/db/tables/`
  - [ ] 1.2 Définir les colonnes : `id` (UUID v4), `theme` (string), `title` (string), `content_full` (text), `content_summary` (text), `display_order` (int), `created_at`, `updated_at`
  - [ ] 1.3 Ajouter les thèmes via enum : fiscalité, juridique, bonnes_pratiques, financement
  - [ ] 1.4 Intégrer la table dans `app_database.dart`
  - [ ] 1.5 Générer la migration : `dart run build_runner build`

- [ ] Task 2 : Créer le modèle Laravel et la migration (AC: #1, #2, #3)
  - [ ] 2.1 Créer le modèle : `php artisan make:model MemoCard -m`
  - [ ] 2.2 Définir la migration `memo_cards` : `id` (UUID), `theme`, `title`, `content_full`, `content_summary`, `display_order`, `timestamps`
  - [ ] 2.3 Ajouter les champs `$fillable` dans le modèle `MemoCard.php`
  - [ ] 2.4 Exécuter la migration : `./vendor/bin/sail artisan migrate`

- [ ] Task 3 : Créer le seeder avec le contenu des fiches mémo (AC: #1, #2)
  - [ ] 3.1 Créer le seeder : `php artisan make:seeder MemoCardSeeder`
  - [ ] 3.2 Rédiger les fiches mémo pour le thème "fiscalité" (TVA sur marge, plus-value professionnelle, régimes d'imposition, délais de revente)
  - [ ] 3.3 Rédiger les fiches mémo pour le thème "juridique" (statuts MDB, obligations légales, garanties)
  - [ ] 3.4 Rédiger les fiches mémo pour le thème "bonnes_pratiques" (analyse bien, négociation, gestion chantier)
  - [ ] 3.5 Rédiger les fiches mémo pour le thème "financement" (prêts MDB, apport, partenaires financiers)
  - [ ] 3.6 Insérer les fiches avec UUID v4 et ordre d'affichage dans le seeder
  - [ ] 3.7 Exécuter le seeder : `./vendor/bin/sail artisan db:seed --class=MemoCardSeeder`

- [ ] Task 4 : Créer le controller Laravel et les routes API (AC: #1, #2, #3)
  - [ ] 4.1 Créer le controller : `php artisan make:controller Api/MemoCardController`
  - [ ] 4.2 Implémenter `index()` : retourner toutes les fiches mémo triées par `theme` puis `display_order`
  - [ ] 4.3 Implémenter `show($id)` : retourner une fiche mémo spécifique
  - [ ] 4.4 Créer la ressource API : `php artisan make:resource MemoCardResource`
  - [ ] 4.5 Transformer les données : `id`, `theme`, `title`, `content_full`, `content_summary`, `display_order`
  - [ ] 4.6 Ajouter les routes dans `routes/api.php` : `Route::get('/memo-cards', [MemoCardController::class, 'index'])->middleware('auth:sanctum')` et `Route::get('/memo-cards/{id}', [MemoCardController::class, 'show'])->middleware('auth:sanctum')`

- [ ] Task 5 : Créer le repository Flutter (AC: #1, #2, #3)
  - [ ] 5.1 Créer `mobile-app/lib/features/memo_cards/data/memo_card_repository.dart`
  - [ ] 5.2 Créer `memo_card_local_source.dart` : méthodes `getAllMemoCards()`, `getMemoCardById(String id)`, `getMemoCardsByTheme(String theme)`, `insertMemoCards(List<MemoCard>)`
  - [ ] 5.3 Créer `memo_card_remote_source.dart` : méthodes `fetchMemoCards()`, `fetchMemoCardById(String id)` via API client
  - [ ] 5.4 Créer le modèle `memo_card_model.dart` avec `fromJson()`, `toJson()`, `toTable()` (mapping Drift)
  - [ ] 5.5 Implémenter le repository : `getAllMemoCards()` lit Drift, si vide fetch API puis insère localement
  - [ ] 5.6 Implémenter `getMemoCardsByTheme(String theme)` : filtre par thème depuis Drift

- [ ] Task 6 : Créer le Cubit Flutter (AC: #1, #2)
  - [ ] 6.1 Créer `mobile-app/lib/features/memo_cards/presentation/cubit/memo_cards_cubit.dart`
  - [ ] 6.2 Définir les states : `MemoCardsInitial`, `MemoCardsLoading`, `MemoCardsLoaded`, `MemoCardsError`
  - [ ] 6.3 Implémenter `loadMemoCards()` : appelle le repository, émet `Loading` puis `Loaded` ou `Error`
  - [ ] 6.4 Implémenter `loadMemoCardsByTheme(String theme)` : filtre par thème
  - [ ] 6.5 Implémenter `loadMemoCardById(String id)` : récupère une fiche spécifique

- [ ] Task 7 : Créer l'interface utilisateur Flutter (AC: #1, #2, #3)
  - [ ] 7.1 Créer `mobile-app/lib/features/memo_cards/presentation/pages/memo_cards_list_page.dart`
  - [ ] 7.2 Afficher les thèmes en sections (groupées) : fiscalité, juridique, bonnes_pratiques, financement
  - [ ] 7.3 Pour chaque fiche, afficher `title` + icône thème + badge "Guide complet" / "Mémo"
  - [ ] 7.4 Au tap sur une fiche, naviguer vers `memo_card_detail_page.dart`
  - [ ] 7.5 Créer `memo_card_detail_page.dart` : afficher `title`, `content_summary` (condensé), bouton "Voir le guide complet"
  - [ ] 7.6 Au tap sur "Voir le guide complet", afficher `content_full` dans un écran défilable
  - [ ] 7.7 Ajouter un indicateur visuel offline : icône "Disponible hors ligne" sur chaque fiche

- [ ] Task 8 : Validation finale (AC: #1, #2, #3)
  - [ ] 8.1 Vérifier que la liste des fiches mémo s'affiche organisée par thème
  - [ ] 8.2 Vérifier qu'une fiche condensée affiche `content_summary` sur 1-2 écrans max
  - [ ] 8.3 Vérifier que le guide complet affiche `content_full` structuré
  - [ ] 8.4 Vérifier que toutes les fiches sont consultables en mode offline (désactiver le réseau et naviguer)
  - [ ] 8.5 Vérifier que les fiches sont synchronisées lors du premier login
  - [ ] 8.6 Tester les filtres par thème (fiscalité, juridique, etc.)

## Dev Notes

### Architecture & Contraintes

- **Offline-first** : Les fiches mémo sont pré-chargées lors de la première synchronisation et stockées dans Drift. Aucune requête réseau n'est nécessaire pour la consultation ultérieure. [Source: architecture.md#Data Architecture]
- **Contenu statique** : Le contenu des fiches mémo est géré côté backend via seeder et ne change pas fréquemment. Les mises à jour de contenu sont propagées via sync. [Source: architecture.md#Cross-Cutting Concerns]
- **Repository pattern** : Abstraction local/remote obligatoire. Le Cubit ne doit jamais accéder directement à Drift ou à l'API. [Source: architecture.md#Implementation Patterns & Consistency Rules]
- **Enum thèmes** : Les thèmes sont définis en constantes (fiscalité, juridique, bonnes_pratiques, financement) pour éviter les typos. [Source: epics.md#Story 8.1]

### Modèle de données

**Table Drift `memo_cards_table.dart` :**
```dart
class MemoCards extends Table {
  TextColumn get id => text().withLength(min: 36, max: 36)();
  TextColumn get theme => text()();
  TextColumn get title => text()();
  TextColumn get contentFull => text()();
  TextColumn get contentSummary => text()();
  IntColumn get displayOrder => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Migration Laravel `create_memo_cards_table.php` :**
```php
Schema::create('memo_cards', function (Blueprint $table) {
    $table->uuid('id')->primary();
    $table->string('theme');
    $table->string('title');
    $table->text('content_full');
    $table->text('content_summary');
    $table->integer('display_order');
    $table->timestamps();
});
```

### Structure du contenu des fiches

Chaque fiche mémo doit contenir :
- **Guide complet** (`content_full`) : contenu structuré avec titres, listes, exemples chiffrés (3-5 écrans)
- **Mémo synthétique** (`content_summary`) : résumé condensé (1-2 écrans max) avec points essentiels uniquement

Exemple de thèmes et fiches :
- **Fiscalité** : TVA sur marge, Plus-value professionnelle, Régimes d'imposition, Délais de revente
- **Juridique** : Statuts MDB, Obligations légales, Garanties
- **Bonnes pratiques** : Analyse d'un bien, Négociation, Gestion de chantier
- **Financement** : Prêts MDB, Apport personnel, Partenaires financiers

### Project Structure Notes

Structure cible après cette story :

```
mobile-app/
├── lib/
│   ├── core/
│   │   └── db/
│   │       └── tables/
│   │           └── memo_cards_table.dart
│   └── features/
│       └── memo_cards/
│           ├── data/
│           │   ├── memo_card_repository.dart
│           │   ├── memo_card_local_source.dart
│           │   ├── memo_card_remote_source.dart
│           │   └── models/
│           │       └── memo_card_model.dart
│           └── presentation/
│               ├── cubit/
│               │   ├── memo_cards_cubit.dart
│               │   └── memo_cards_state.dart
│               ├── pages/
│               │   ├── memo_cards_list_page.dart
│               │   └── memo_card_detail_page.dart
│               └── widgets/
│                   ├── memo_card_tile.dart
│                   └── theme_section_header.dart

backend-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       └── MemoCardController.php
│   │   └── Resources/
│   │       └── MemoCardResource.php
│   └── Models/
│       └── MemoCard.php
├── database/
│   ├── migrations/
│   │   └── YYYY_MM_DD_create_memo_cards_table.php
│   └── seeders/
│       └── MemoCardSeeder.php
└── routes/
    └── api.php
```

### References

- [Source: epics.md#Story 8.1] — FR28, FR29, FR30 : Guides complets, fiches mémo synthétiques, offline
- [Source: architecture.md#Data Architecture] — Offline-first, stockage local Drift
- [Source: architecture.md#Frontend Architecture] — Repository pattern, Bloc/Cubit
- [Source: architecture.md#API & Communication Patterns] — Routes `/api/memo-cards`
- [Source: architecture.md#Implementation Patterns & Consistency Rules] — Conventions nommage, UUID v4

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
