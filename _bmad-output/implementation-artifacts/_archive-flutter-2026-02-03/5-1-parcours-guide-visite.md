# Story 5.1 : Parcours du guide de visite par catégorie

Status: ready-for-dev

## Story

As a utilisateur,
I want parcourir un guide de visite organisé par catégorie et répondre aux questions guidées,
So that j'inspecte méthodiquement chaque aspect du bien sans rien oublier.

## Acceptance Criteria

1. **Given** une fiche au statut "Visite" ou supérieur
   **When** l'utilisateur ouvre le guide de visite
   **Then** les catégories s'affichent : structure, électricité, plomberie, toiture, isolation, division possible, extérieurs, environnement
   **And** chaque catégorie contient des questions guidées spécifiques

2. **Given** une catégorie du guide
   **When** l'utilisateur répond aux questions (choix multiples, oui/non, texte libre)
   **Then** les réponses sont enregistrées localement via Drift
   **And** la progression par catégorie est affichée (X/Y questions répondues)

3. **Given** le guide de visite
   **When** l'appareil est hors connexion
   **Then** le guide fonctionne intégralement en mode offline
   **And** toutes les réponses sont stockées localement

## Tasks / Subtasks

- [ ] Task 1 : Créer les modèles Laravel pour le guide de visite (AC: #1, #2)
  - [ ] 1.1 Créer la migration `create_visit_guides_table` avec : `id` (UUID), `property_id` (UUID FK), `created_at`, `updated_at`, `deleted_at`
  - [ ] 1.2 Créer la migration `create_visit_guide_questions_table` avec : `id` (UUID), `category` (string), `label` (text), `question_type` (enum: multiple_choice, yes_no, free_text), `options` (json nullable), `order` (integer), `created_at`, `updated_at`
  - [ ] 1.3 Créer la migration `create_visit_guide_responses_table` avec : `id` (UUID), `visit_guide_id` (UUID FK), `question_id` (UUID FK), `response_value` (text), `created_at`, `updated_at`
  - [ ] 1.4 Créer le modèle `VisitGuide` avec relations `belongsTo(Property)` et `hasMany(VisitGuideResponse)`
  - [ ] 1.5 Créer le modèle `VisitGuideQuestion` (questions templates, pas de FK visit_guide)
  - [ ] 1.6 Créer le modèle `VisitGuideResponse` avec relations `belongsTo(VisitGuide)` et `belongsTo(VisitGuideQuestion)`

- [ ] Task 2 : Créer le seeder pour les questions du guide (AC: #1)
  - [ ] 2.1 Créer `VisitGuideQuestionSeeder` avec les 8 catégories : structure, électricité, plomberie, toiture, isolation, division, extérieurs, environnement
  - [ ] 2.2 Définir les questions par catégorie avec types appropriés (yes_no, multiple_choice, free_text)
  - [ ] 2.3 Exemples catégorie "structure" : "Présence de fissures ?" (yes_no), "État des murs porteurs ?" (multiple_choice: bon/moyen/mauvais), "Notes complémentaires" (free_text)
  - [ ] 2.4 Exemples catégorie "électricité" : "Installation aux normes ?" (yes_no), "Présence d'un tableau électrique récent ?" (yes_no), "Nombre de prises par pièce" (free_text)
  - [ ] 2.5 Répéter pour les 8 catégories avec ~5-10 questions chacune
  - [ ] 2.6 Assigner un `order` cohérent par catégorie

- [ ] Task 3 : Créer les API endpoints pour le guide de visite (AC: #1, #2)
  - [ ] 3.1 Créer `VisitGuideController` avec méthode `getOrCreateForProperty(Property $property): VisitGuideResource`
  - [ ] 3.2 Si aucun VisitGuide pour la property, créer un avec UUID v4
  - [ ] 3.3 Créer la route `GET /api/properties/{property}/visit-guide` avec middleware `auth:sanctum`
  - [ ] 3.4 Créer la route `GET /api/visit-guide-questions` retournant toutes les questions templates groupées par catégorie
  - [ ] 3.5 Créer `VisitGuideResource` incluant `id`, `property_id`, `responses` (nested VisitGuideResponseResource)
  - [ ] 3.6 Créer `VisitGuideQuestionResource` avec `id`, `category`, `label`, `question_type`, `options`, `order`
  - [ ] 3.7 Créer la route `POST /api/visit-guides/{guide}/responses` pour enregistrer/mettre à jour une réponse

- [ ] Task 4 : Créer les tables Drift pour le guide de visite (AC: #2, #3)
  - [ ] 4.1 Créer `visit_guides_table.dart` avec colonnes : `id` (text, PK), `propertyId` (text), `createdAt` (datetime), `updatedAt` (datetime), `syncStatus` (text)
  - [ ] 4.2 Créer `visit_guide_questions_table.dart` avec colonnes : `id` (text, PK), `category` (text), `label` (text), `questionType` (text), `options` (text nullable, JSON), `order` (integer)
  - [ ] 4.3 Créer `visit_guide_responses_table.dart` avec colonnes : `id` (text, PK), `visitGuideId` (text, FK), `questionId` (text, FK), `responseValue` (text), `createdAt` (datetime), `updatedAt` (datetime), `syncStatus` (text)
  - [ ] 4.4 Ajouter les tables à `AppDatabase`
  - [ ] 4.5 Générer le code Drift : `flutter pub run build_runner build`

- [ ] Task 5 : Implémenter le VisitGuideRepository Flutter (AC: #2, #3)
  - [ ] 5.1 Créer `VisitGuideRepository` dans `lib/features/visit_guide/data/`
  - [ ] 5.2 Méthode `getOrCreateVisitGuide(String propertyId)` : chercher local → si vide, créer UUID local + fetch questions templates → store local
  - [ ] 5.3 Méthode `getAllQuestions()` : retourner toutes les questions depuis Drift (pré-chargées au premier sync)
  - [ ] 5.4 Méthode `saveResponse(String visitGuideId, String questionId, String responseValue)` : insert/update local avec `syncStatus: pending`
  - [ ] 5.5 Méthode `getResponsesForGuide(String visitGuideId)` : retourner toutes les réponses
  - [ ] 5.6 Méthode `syncResponses(String visitGuideId)` : appeler API `POST /api/visit-guides/{guide}/responses` si connecté
  - [ ] 5.7 Gérer le mode offline : stocker localement, sync au retour réseau

- [ ] Task 6 : Créer les modèles Flutter (AC: #1, #2)
  - [ ] 6.1 Créer `VisitGuideModel` dans `lib/features/visit_guide/data/models/` avec `id`, `propertyId`, `responses`
  - [ ] 6.2 Créer `VisitGuideQuestionModel` avec `id`, `category`, `label`, `questionType`, `options`, `order`
  - [ ] 6.3 Créer `VisitGuideResponseModel` avec `id`, `visitGuideId`, `questionId`, `responseValue`
  - [ ] 6.4 Implémenter `fromJson`, `toJson`, `fromDrift`, `toDrift` pour chaque modèle

- [ ] Task 7 : Implémenter le VisitGuideCubit (AC: #1, #2, #3)
  - [ ] 7.1 Créer les states : `VisitGuideInitial`, `VisitGuideLoading`, `VisitGuideLoaded(guide, questions, progressByCategory)`, `VisitGuideError(message)`
  - [ ] 7.2 Méthode `loadVisitGuide(String propertyId)` : appeler Repository → charger guide + questions → calculer progression par catégorie
  - [ ] 7.3 Méthode `saveResponse(String questionId, String responseValue)` : appeler Repository → reload guide → émettre `VisitGuideLoaded` avec progression mise à jour
  - [ ] 7.4 Calculer progression par catégorie : pour chaque catégorie, compter questions répondues / total questions
  - [ ] 7.5 Gérer le mode offline : pas de différence côté Cubit, Repository gère la sync

- [ ] Task 8 : Créer l'UI du guide de visite (AC: #1, #2)
  - [ ] 8.1 Créer `visit_guide_page.dart` avec navigation par onglets (TabBar) pour les 8 catégories
  - [ ] 8.2 Pour chaque catégorie, afficher les questions groupées avec leur progression (X/Y répondues)
  - [ ] 8.3 Créer `question_widget.dart` : composant adaptatif selon `questionType` (yes_no → Switch, multiple_choice → RadioButtons, free_text → TextField)
  - [ ] 8.4 Sur changement réponse, appeler `context.read<VisitGuideCubit>().saveResponse(questionId, value)`
  - [ ] 8.5 Afficher un indicateur visuel (checkmark) sur les questions répondues
  - [ ] 8.6 Afficher la progression globale en haut de la page : "X / Y questions répondues"

- [ ] Task 9 : Pré-charger les questions templates lors du premier sync (AC: #3)
  - [ ] 9.1 Étendre le `SyncEngine` pour télécharger `GET /api/visit-guide-questions` au premier sync
  - [ ] 9.2 Stocker les questions dans Drift (`visit_guide_questions_table`)
  - [ ] 9.3 Ne jamais refetch les questions (templates statiques), sauf si version change (post-MVP)

- [ ] Task 10 : Connecter VisitGuidePage à la navigation (AC: #1)
  - [ ] 10.1 Ajouter un bouton "Guide de visite" dans `PropertyDetailPage` si statut >= "Visite"
  - [ ] 10.2 Créer une route GoRouter `/properties/:propertyId/visit-guide` vers `VisitGuidePage`
  - [ ] 10.3 Passer le `propertyId` en paramètre et déclencher `loadVisitGuide()` dans `initState`

- [ ] Task 11 : Validation finale (AC: #1, #2, #3)
  - [ ] 11.1 Tester backend : seeder questions → vérifier 8 catégories avec questions
  - [ ] 11.2 Tester API : `GET /api/visit-guide-questions` retourne toutes les questions groupées
  - [ ] 11.3 Tester API : `GET /api/properties/{uuid}/visit-guide` crée un guide si inexistant
  - [ ] 11.4 Tester API : `POST /api/visit-guides/{uuid}/responses` enregistre une réponse
  - [ ] 11.5 Tester Flutter online : ouvrir guide → répondre à une question → vérifier enregistrement local + sync API
  - [ ] 11.6 Tester Flutter offline : désactiver réseau → répondre à plusieurs questions → vérifier stockage local
  - [ ] 11.7 Tester sync : revenir online → vérifier synchronisation automatique des réponses
  - [ ] 11.8 Tester progression : répondre à des questions dans différentes catégories → vérifier progression par catégorie
  - [ ] 11.9 Commit : `git add . && git commit -m "feat: parcours guide visite par catégorie avec mode offline

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"`

## Dev Notes

### Architecture & Contraintes

- **Offline-first** : Le guide de visite doit fonctionner intégralement hors ligne. Les questions templates sont pré-chargées, les réponses stockées localement, sync au retour réseau [Source: architecture.md#Core Architectural Decisions]
- **Questions templates** : Les questions sont statiques, définies par seeder backend, téléchargées une fois au premier sync et stockées dans Drift [Source: epics.md#Story 5.1]
- **8 catégories** : structure, électricité, plomberie, toiture, isolation, division, extérieurs, environnement [Source: epics.md#Story 5.1 AC]
- **Types de questions** : yes_no (Switch), multiple_choice (RadioButtons), free_text (TextField multiline) [Source: epics.md#Story 5.1 AC]
- **Repository pattern** : Abstraction local/remote obligatoire [Source: architecture.md#Frontend Architecture]

### Versions techniques confirmées

- **Drift** : Tables `visit_guides_table`, `visit_guide_questions_table`, `visit_guide_responses_table` [Source: architecture.md#DB locale Flutter]
- **UUID v4** : Tous les IDs (visit_guides, questions, responses) [Source: architecture.md#Format Patterns]
- **TabBar Flutter** : Navigation par onglets pour les 8 catégories [Standard Material/Cupertino]
- **JSON options** : Pour les questions `multiple_choice`, stocker les options en JSON : `["bon", "moyen", "mauvais"]`

### Modèle de données — Backend

**Table `visit_guides` :**
```
id (UUID, PK)
property_id (UUID, FK → properties)
created_at
updated_at
deleted_at
```

**Table `visit_guide_questions` (templates statiques) :**
```
id (UUID, PK)
category (string: structure, électricité, etc.)
label (text: "Présence de fissures ?")
question_type (enum: yes_no, multiple_choice, free_text)
options (json nullable: ["bon", "moyen", "mauvais"] pour multiple_choice)
order (integer)
created_at
updated_at
```

**Table `visit_guide_responses` :**
```
id (UUID, PK)
visit_guide_id (UUID, FK → visit_guides)
question_id (UUID, FK → visit_guide_questions)
response_value (text: "oui", "moyen", "Texte libre...")
created_at
updated_at
```

**Relations Eloquent :**
- `VisitGuide belongsTo Property`
- `VisitGuide hasMany VisitGuideResponse`
- `VisitGuideResponse belongsTo VisitGuide`
- `VisitGuideResponse belongsTo VisitGuideQuestion`
- `VisitGuideQuestion` n'a pas de FK (templates globaux)

### Seeder — VisitGuideQuestionSeeder

```php
// database/seeders/VisitGuideQuestionSeeder.php
class VisitGuideQuestionSeeder extends Seeder
{
    public function run(): void
    {
        $questions = [
            // Structure
            ['category' => 'structure', 'label' => 'Présence de fissures visibles ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 1],
            ['category' => 'structure', 'label' => 'État des murs porteurs ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['bon', 'moyen', 'mauvais']), 'order' => 2],
            ['category' => 'structure', 'label' => 'État du plancher/dalle ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['bon', 'moyen', 'mauvais']), 'order' => 3],
            ['category' => 'structure', 'label' => 'Présence d\'humidité ou infiltrations ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 4],
            ['category' => 'structure', 'label' => 'Notes complémentaires structure', 'question_type' => 'free_text', 'options' => null, 'order' => 5],

            // Électricité
            ['category' => 'électricité', 'label' => 'Installation aux normes actuelles ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 1],
            ['category' => 'électricité', 'label' => 'Présence d\'un tableau électrique récent ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 2],
            ['category' => 'électricité', 'label' => 'Nombre de prises par pièce principale ?', 'question_type' => 'free_text', 'options' => null, 'order' => 3],
            ['category' => 'électricité', 'label' => 'État des câbles apparents ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['bon', 'moyen', 'vétuste']), 'order' => 4],
            ['category' => 'électricité', 'label' => 'Notes complémentaires électricité', 'question_type' => 'free_text', 'options' => null, 'order' => 5],

            // Plomberie
            ['category' => 'plomberie', 'label' => 'Type de tuyauterie (cuivre, PVC, plomb) ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['cuivre', 'PVC', 'plomb', 'mixte']), 'order' => 1],
            ['category' => 'plomberie', 'label' => 'Présence de fuites visibles ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 2],
            ['category' => 'plomberie', 'label' => 'État du chauffe-eau ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['récent', 'moyen', 'à remplacer']), 'order' => 3],
            ['category' => 'plomberie', 'label' => 'Pression de l\'eau correcte ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 4],
            ['category' => 'plomberie', 'label' => 'Notes complémentaires plomberie', 'question_type' => 'free_text', 'options' => null, 'order' => 5],

            // Toiture
            ['category' => 'toiture', 'label' => 'Type de toiture (tuiles, ardoises, zinc) ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['tuiles', 'ardoises', 'zinc', 'autre']), 'order' => 1],
            ['category' => 'toiture', 'label' => 'Année de dernière réfection ?', 'question_type' => 'free_text', 'options' => null, 'order' => 2],
            ['category' => 'toiture', 'label' => 'Présence de fuites ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 3],
            ['category' => 'toiture', 'label' => 'État de la charpente visible ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['bon', 'moyen', 'mauvais']), 'order' => 4],
            ['category' => 'toiture', 'label' => 'Notes complémentaires toiture', 'question_type' => 'free_text', 'options' => null, 'order' => 5],

            // Isolation
            ['category' => 'isolation', 'label' => 'Isolation des combles présente ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 1],
            ['category' => 'isolation', 'label' => 'Type d\'isolation combles ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['laine minérale', 'laine de verre', 'aucune', 'autre']), 'order' => 2],
            ['category' => 'isolation', 'label' => 'Isolation des murs extérieurs ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 3],
            ['category' => 'isolation', 'label' => 'Type de vitrage (simple, double, triple) ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['simple', 'double', 'triple', 'mixte']), 'order' => 4],
            ['category' => 'isolation', 'label' => 'Notes complémentaires isolation', 'question_type' => 'free_text', 'options' => null, 'order' => 5],

            // Division
            ['category' => 'division', 'label' => 'Possibilité de division en plusieurs lots ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 1],
            ['category' => 'division', 'label' => 'Nombre de lots envisageables ?', 'question_type' => 'free_text', 'options' => null, 'order' => 2],
            ['category' => 'division', 'label' => 'Accès séparés existants ou créables ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 3],
            ['category' => 'division', 'label' => 'Compteurs séparables (eau, électricité) ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 4],
            ['category' => 'division', 'label' => 'Notes complémentaires division', 'question_type' => 'free_text', 'options' => null, 'order' => 5],

            // Extérieurs
            ['category' => 'extérieurs', 'label' => 'Présence d\'un jardin ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 1],
            ['category' => 'extérieurs', 'label' => 'Surface extérieure estimée (m²) ?', 'question_type' => 'free_text', 'options' => null, 'order' => 2],
            ['category' => 'extérieurs', 'label' => 'État des clôtures et portails ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['bon', 'moyen', 'mauvais', 'inexistant']), 'order' => 3],
            ['category' => 'extérieurs', 'label' => 'Présence de dépendances (garage, abri) ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 4],
            ['category' => 'extérieurs', 'label' => 'Notes complémentaires extérieurs', 'question_type' => 'free_text', 'options' => null, 'order' => 5],

            // Environnement
            ['category' => 'environnement', 'label' => 'Nuisances sonores constatées ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 1],
            ['category' => 'environnement', 'label' => 'Proximité commerces et transports ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['proche', 'moyen', 'éloigné']), 'order' => 2],
            ['category' => 'environnement', 'label' => 'Quartier attractif ?', 'question_type' => 'multiple_choice', 'options' => json_encode(['oui', 'moyen', 'non']), 'order' => 3],
            ['category' => 'environnement', 'label' => 'Stationnement disponible ?', 'question_type' => 'yes_no', 'options' => null, 'order' => 4],
            ['category' => 'environnement', 'label' => 'Notes complémentaires environnement', 'question_type' => 'free_text', 'options' => null, 'order' => 5],
        ];

        foreach ($questions as $question) {
            VisitGuideQuestion::create([
                'id' => Str::uuid(),
                ...$question,
            ]);
        }
    }
}
```

### API Endpoints

**Endpoints :**
```
GET /api/visit-guide-questions
→ Retourne toutes les questions templates groupées par catégorie

GET /api/properties/{property}/visit-guide
→ Retourne ou crée le VisitGuide pour la property

POST /api/visit-guides/{guide}/responses
Body: { "question_id": "uuid", "response_value": "oui" }
→ Enregistre/met à jour une réponse
```

**Controller Laravel :**
```php
// app/Http/Controllers/Api/VisitGuideController.php
class VisitGuideController extends Controller
{
    public function getQuestions(): JsonResponse
    {
        $questions = VisitGuideQuestion::orderBy('category')->orderBy('order')->get();
        $grouped = $questions->groupBy('category');

        return response()->json([
            'data' => $grouped->map(fn($q) => VisitGuideQuestionResource::collection($q)),
        ]);
    }

    public function getOrCreateForProperty(Property $property): JsonResponse
    {
        $guide = VisitGuide::firstOrCreate(
            ['property_id' => $property->id],
            ['id' => Str::uuid()]
        );

        return response()->json(new VisitGuideResource($guide->load('responses')));
    }

    public function saveResponse(VisitGuide $guide, StoreVisitGuideResponseRequest $request): JsonResponse
    {
        $response = VisitGuideResponse::updateOrCreate(
            [
                'visit_guide_id' => $guide->id,
                'question_id' => $request->question_id,
            ],
            [
                'id' => Str::uuid(),
                'response_value' => $request->response_value,
            ]
        );

        return response()->json(new VisitGuideResponseResource($response), 201);
    }
}

// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/visit-guide-questions', [VisitGuideController::class, 'getQuestions']);
    Route::get('/properties/{property}/visit-guide', [VisitGuideController::class, 'getOrCreateForProperty']);
    Route::post('/visit-guides/{guide}/responses', [VisitGuideController::class, 'saveResponse']);
});
```

### Flutter Drift Tables

```dart
// lib/core/db/tables/visit_guides_table.dart
class VisitGuidesTable extends Table {
  TextColumn get id => text()();
  TextColumn get propertyId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// lib/core/db/tables/visit_guide_questions_table.dart
class VisitGuideQuestionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()();
  TextColumn get label => text()();
  TextColumn get questionType => text()(); // yes_no, multiple_choice, free_text
  TextColumn get options => text().nullable()(); // JSON array for multiple_choice
  IntColumn get order => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// lib/core/db/tables/visit_guide_responses_table.dart
class VisitGuideResponsesTable extends Table {
  TextColumn get id => text()();
  TextColumn get visitGuideId => text()();
  TextColumn get questionId => text()();
  TextColumn get responseValue => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Flutter VisitGuideRepository

```dart
class VisitGuideRepository {
  final AppDatabase _database;
  final ApiClient _apiClient;
  final ConnectivityMonitor _connectivityMonitor;

  VisitGuideRepository(this._database, this._apiClient, this._connectivityMonitor);

  Future<VisitGuideModel> getOrCreateVisitGuide(String propertyId) async {
    // Try local first
    var localGuide = await _database.visitGuidesDao.getByPropertyId(propertyId);

    if (localGuide == null) {
      // Create locally
      final guideId = const Uuid().v4();
      localGuide = await _database.visitGuidesDao.insert(VisitGuide(
        id: guideId,
        propertyId: propertyId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: 'pending',
      ));

      // Fetch from API if online
      if (_connectivityMonitor.isConnected) {
        try {
          final response = await _apiClient.get('/properties/$propertyId/visit-guide');
          final remoteGuide = VisitGuideModel.fromJson(response.data);
          await _database.visitGuidesDao.update(remoteGuide.toDrift());
          localGuide = remoteGuide.toDrift();
        } catch (e) {
          // Continue with local guide
        }
      }
    }

    final responses = await _database.visitGuideResponsesDao.getByGuideId(localGuide.id);
    return VisitGuideModel.fromDrift(localGuide, responses);
  }

  Future<List<VisitGuideQuestionModel>> getAllQuestions() async {
    final questions = await _database.visitGuideQuestionsDao.getAll();
    return questions.map(VisitGuideQuestionModel.fromDrift).toList();
  }

  Future<void> saveResponse(String visitGuideId, String questionId, String responseValue) async {
    final responseId = const Uuid().v4();

    await _database.visitGuideResponsesDao.upsert(VisitGuideResponse(
      id: responseId,
      visitGuideId: visitGuideId,
      questionId: questionId,
      responseValue: responseValue,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
    ));

    // Try to sync immediately if online
    if (_connectivityMonitor.isConnected) {
      try {
        await _apiClient.post('/visit-guides/$visitGuideId/responses', data: {
          'question_id': questionId,
          'response_value': responseValue,
        });
        await _database.visitGuideResponsesDao.updateSyncStatus(responseId, 'synced');
      } catch (e) {
        // Leave as pending
      }
    }
  }
}
```

### Flutter UI — VisitGuidePage

```dart
// lib/features/visit_guide/presentation/pages/visit_guide_page.dart
class VisitGuidePage extends StatefulWidget {
  final String propertyId;

  const VisitGuidePage({required this.propertyId, super.key});

  @override
  State<VisitGuidePage> createState() => _VisitGuidePageState();
}

class _VisitGuidePageState extends State<VisitGuidePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final categories = [
    'structure',
    'électricité',
    'plomberie',
    'toiture',
    'isolation',
    'division',
    'extérieurs',
    'environnement',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    context.read<VisitGuideCubit>().loadVisitGuide(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide de visite'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((cat) => Tab(text: cat.capitalize())).toList(),
        ),
      ),
      body: BlocBuilder<VisitGuideCubit, VisitGuideState>(
        builder: (context, state) {
          if (state is VisitGuideLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VisitGuideLoaded) {
            return Column(
              children: [
                _GlobalProgressHeader(state: state),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: categories.map((category) {
                      final questionsForCategory = state.questions
                          .where((q) => q.category == category)
                          .toList();

                      final progress = state.progressByCategory[category] ?? '0 / 0';

                      return _CategoryTab(
                        category: category,
                        questions: questionsForCategory,
                        progress: progress,
                        guide: state.guide,
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Guide non disponible'));
        },
      ),
    );
  }
}

class _GlobalProgressHeader extends StatelessWidget {
  final VisitGuideLoaded state;

  const _GlobalProgressHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final totalQuestions = state.questions.length;
    final answeredQuestions = state.guide.responses.length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          const Icon(Icons.assignment, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            '$answeredQuestions / $totalQuestions questions répondues',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String category;
  final List<VisitGuideQuestionModel> questions;
  final String progress;
  final VisitGuideModel guide;

  const _CategoryTab({
    required this.category,
    required this.questions,
    required this.progress,
    required this.guide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Progression : $progress',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              final existingResponse = guide.responses.firstWhereOrNull(
                (r) => r.questionId == question.id,
              );

              return QuestionWidget(
                question: question,
                initialValue: existingResponse?.responseValue,
                onResponseChanged: (value) {
                  context.read<VisitGuideCubit>().saveResponse(question.id, value);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
```

### Project Structure Notes

Structure cible après cette story :

**Backend (`backend-api/`) :**
```
app/Models/
├── VisitGuide.php (new)
├── VisitGuideQuestion.php (new)
└── VisitGuideResponse.php (new)
app/Http/Controllers/Api/
└── VisitGuideController.php (new)
app/Http/Resources/
├── VisitGuideResource.php (new)
├── VisitGuideQuestionResource.php (new)
└── VisitGuideResponseResource.php (new)
database/migrations/
├── xxxx_create_visit_guides_table.php (new)
├── xxxx_create_visit_guide_questions_table.php (new)
└── xxxx_create_visit_guide_responses_table.php (new)
database/seeders/
└── VisitGuideQuestionSeeder.php (new)
```

**Frontend (`mobile-app/`) :**
```
lib/core/db/tables/
├── visit_guides_table.dart (new)
├── visit_guide_questions_table.dart (new)
└── visit_guide_responses_table.dart (new)
lib/features/visit_guide/
├── data/
│   ├── visit_guide_repository.dart (new)
│   └── models/
│       ├── visit_guide_model.dart (new)
│       ├── visit_guide_question_model.dart (new)
│       └── visit_guide_response_model.dart (new)
└── presentation/
    ├── cubit/
    │   ├── visit_guide_cubit.dart (new)
    │   └── visit_guide_state.dart (new)
    ├── pages/
    │   └── visit_guide_page.dart (new)
    └── widgets/
        └── question_widget.dart (new: adaptatif yes_no/multiple_choice/free_text)
```

### References

- [Source: architecture.md#Frontend Architecture] — Repository pattern, Bloc/Cubit, folder-by-feature
- [Source: architecture.md#Data Architecture] — Drift offline-first, sync engine
- [Source: architecture.md#Format Patterns] — UUID v4, snake_case DB/API, camelCase Dart
- [Source: architecture.md#Core Architectural Decisions] — Offline-first obligatoire
- [Source: epics.md#Story 5.1] — Acceptance criteria, 8 catégories, types de questions, mode offline

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
