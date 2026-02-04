# Story 5.2 : Photos contextualisées et notes agent

Status: ready-for-dev

## Story

As a utilisateur,
I want prendre des photos liées à un point du guide et saisir des notes d'échanges avec l'agent,
So that je documente visuellement les constats et conserve les informations verbales.

## Acceptance Criteria

1. **Given** une question du guide de visite
   **When** l'utilisateur prend une photo
   **Then** la photo est liée à la question/catégorie spécifique
   **And** la photo est compressée et stockée localement
   **And** la photo est uploadée au serveur quand le réseau est disponible

2. **Given** le guide de visite
   **When** l'utilisateur accède à la section "Notes agent"
   **Then** il peut saisir du texte libre sur les échanges avec l'agent immobilier
   **And** les notes sont horodatées et liées à la visite

3. **Given** des photos et notes prises en mode offline
   **When** le réseau revient
   **Then** les photos sont uploadées et les notes synchronisées automatiquement

## Tasks / Subtasks

- [ ] Task 1 : Créer les modèles Laravel pour photos et notes (AC: #1, #2)
  - [ ] 1.1 Créer la migration `create_photos_table` avec : `id` (UUID), `visit_guide_id` (UUID FK), `question_id` (UUID FK nullable), `category` (string nullable), `file_path` (string), `file_size` (integer), `mime_type` (string), `created_at`, `updated_at`, `deleted_at`
  - [ ] 1.2 Créer la migration `create_agent_notes_table` avec : `id` (UUID), `visit_guide_id` (UUID FK), `note_text` (text), `created_at`, `updated_at`, `deleted_at`
  - [ ] 1.3 Créer le modèle `Photo` avec relations `belongsTo(VisitGuide)` et `belongsTo(VisitGuideQuestion)` (nullable)
  - [ ] 1.4 Créer le modèle `AgentNote` avec relation `belongsTo(VisitGuide)`
  - [ ] 1.5 Ajouter les relations dans `VisitGuide` : `hasMany(Photo)` et `hasMany(AgentNote)`

- [ ] Task 2 : Implémenter l'API upload photo (AC: #1)
  - [ ] 2.1 Créer `PhotoController` avec méthode `upload(UploadPhotoRequest $request): PhotoResource`
  - [ ] 2.2 Valider le fichier : type image (jpg, png, heic), taille max 10MB
  - [ ] 2.3 Stocker le fichier dans `storage/app/photos/{visit_guide_id}/{uuid}.{ext}`
  - [ ] 2.4 Enregistrer en DB avec `file_path`, `file_size`, `mime_type`
  - [ ] 2.5 Créer la route `POST /api/visit-guides/{guide}/photos` avec middleware `auth:sanctum`
  - [ ] 2.6 Retourner `PhotoResource` avec `id`, `file_path`, `question_id`, `category`, `created_at`

- [ ] Task 3 : Implémenter l'API pour notes agent (AC: #2)
  - [ ] 3.1 Créer `AgentNoteController` avec méthodes `index(VisitGuide $guide)` et `store(VisitGuide $guide, StoreAgentNoteRequest $request)`
  - [ ] 3.2 Valider la note : `note_text` (string required, max 5000 caractères)
  - [ ] 3.3 Créer la route `GET /api/visit-guides/{guide}/agent-notes` pour lister les notes
  - [ ] 3.4 Créer la route `POST /api/visit-guides/{guide}/agent-notes` pour créer une note
  - [ ] 3.5 Retourner `AgentNoteResource` avec `id`, `note_text`, `created_at`
  - [ ] 3.6 Ajouter tests Feature : upload photo, création note, liste notes

- [ ] Task 4 : Créer les tables Drift pour photos et notes (AC: #1, #2, #3)
  - [ ] 4.1 Créer `photos_table.dart` avec colonnes : `id` (text, PK), `visitGuideId` (text, FK), `questionId` (text nullable), `category` (text nullable), `localFilePath` (text), `remoteFilePath` (text nullable), `fileSize` (integer), `mimeType` (text), `uploadStatus` (text: pending/uploaded), `createdAt` (datetime), `updatedAt` (datetime)
  - [ ] 4.2 Créer `agent_notes_table.dart` avec colonnes : `id` (text, PK), `visitGuideId` (text, FK), `noteText` (text), `createdAt` (datetime), `updatedAt` (datetime), `syncStatus` (text)
  - [ ] 4.3 Ajouter les tables à `AppDatabase`
  - [ ] 4.4 Générer le code Drift : `flutter pub run build_runner build`

- [ ] Task 5 : Implémenter la capture et compression photo Flutter (AC: #1)
  - [ ] 5.1 Ajouter les dépendances : `image_picker`, `flutter_image_compress`, `path_provider`
  - [ ] 5.2 Créer `PhotoService` dans `lib/core/services/` avec méthode `captureAndCompressPhoto()`
  - [ ] 5.3 Utiliser `ImagePicker.pickImage(source: ImageSource.camera)`
  - [ ] 5.4 Compresser l'image avec `FlutterImageCompress.compressAndGetFile()` : qualité 80%, max largeur 1920px
  - [ ] 5.5 Stocker localement dans `app_documents/photos/{uuid}.jpg`
  - [ ] 5.6 Retourner le chemin local et les métadonnées (taille, mime type)

- [ ] Task 6 : Implémenter le PhotoRepository Flutter (AC: #1, #3)
  - [ ] 6.1 Créer `PhotoRepository` dans `lib/features/visit_guide/data/`
  - [ ] 6.2 Méthode `addPhoto(String visitGuideId, String? questionId, String? category, File photoFile)` : compresser → stocker local → insert Drift avec `uploadStatus: pending`
  - [ ] 6.3 Méthode `uploadPendingPhotos(String visitGuideId)` : récupérer photos `uploadStatus: pending` → uploader via API multipart → mettre à jour `uploadStatus: uploaded` + `remoteFilePath`
  - [ ] 6.4 Méthode `getPhotosForGuide(String visitGuideId)` : retourner toutes les photos depuis Drift
  - [ ] 6.5 Méthode `getPhotosForQuestion(String questionId)` : retourner les photos liées à une question
  - [ ] 6.6 Intégrer dans `SyncEngine` : appeler `uploadPendingPhotos()` au retour du réseau

- [ ] Task 7 : Implémenter le AgentNoteRepository Flutter (AC: #2, #3)
  - [ ] 7.1 Créer `AgentNoteRepository` dans `lib/features/visit_guide/data/`
  - [ ] 7.2 Méthode `addNote(String visitGuideId, String noteText)` : insert Drift avec `syncStatus: pending`
  - [ ] 7.3 Méthode `syncNotes(String visitGuideId)` : récupérer notes `syncStatus: pending` → poster via API → mettre à jour `syncStatus: synced`
  - [ ] 7.4 Méthode `getNotesForGuide(String visitGuideId)` : retourner toutes les notes depuis Drift
  - [ ] 7.5 Intégrer dans `SyncEngine` : appeler `syncNotes()` au retour du réseau

- [ ] Task 8 : Étendre le VisitGuideCubit pour photos et notes (AC: #1, #2)
  - [ ] 8.1 Ajouter au state `VisitGuideLoaded` : `photos` (liste PhotoModel), `agentNotes` (liste AgentNoteModel)
  - [ ] 8.2 Méthode `addPhotoToQuestion(String questionId, String category)` : appeler PhotoService → appeler PhotoRepository → reload guide → émettre state mis à jour
  - [ ] 8.3 Méthode `addAgentNote(String noteText)` : appeler AgentNoteRepository → reload guide → émettre state mis à jour
  - [ ] 8.4 Charger photos et notes lors du `loadVisitGuide()`

- [ ] Task 9 : Créer l'UI pour capture photo (AC: #1)
  - [ ] 9.1 Ajouter un bouton "Ajouter une photo" dans `QuestionWidget` (icône caméra)
  - [ ] 9.2 Sur tap, déclencher `context.read<VisitGuideCubit>().addPhotoToQuestion(questionId, category)`
  - [ ] 9.3 Afficher les photos miniatures sous chaque question
  - [ ] 9.4 Tap sur miniature → afficher plein écran avec `PhotoViewGallery` (package `photo_view`)
  - [ ] 9.5 Afficher un indicateur si photo en attente d'upload (icône nuage avec horloge)

- [ ] Task 10 : Créer l'UI pour notes agent (AC: #2)
  - [ ] 10.1 Créer un onglet/section "Notes agent" dans `VisitGuidePage` (TabBar ou page séparée)
  - [ ] 10.2 Afficher la liste des notes avec horodatage
  - [ ] 10.3 Ajouter un champ texte multi-ligne (TextField `maxLines: null`) et un bouton "Ajouter note"
  - [ ] 10.4 Sur tap bouton, appeler `context.read<VisitGuideCubit>().addAgentNote(noteText)`
  - [ ] 10.5 Vider le champ texte après ajout
  - [ ] 10.6 Afficher un indicateur si note en attente de sync (icône nuage avec horloge)

- [ ] Task 11 : Gérer la queue d'upload photos (AC: #3)
  - [ ] 11.1 Créer `PhotoUploadQueue` dans `lib/core/sync/` qui écoute la connectivité
  - [ ] 11.2 Quand le réseau revient, déclencher `PhotoRepository.uploadPendingPhotos()` pour tous les guides
  - [ ] 11.3 Uploader les photos une par une avec retry en cas d'échec (backoff exponentiel)
  - [ ] 11.4 Mettre à jour l'UI en temps réel via stream Drift

- [ ] Task 12 : Validation finale (AC: #1, #2, #3)
  - [ ] 12.1 Tester backend : `POST /api/visit-guides/{uuid}/photos` avec multipart file → vérifier stockage `storage/app/photos/`
  - [ ] 12.2 Tester backend : `POST /api/visit-guides/{uuid}/agent-notes` → vérifier insertion DB
  - [ ] 12.3 Tester Flutter online : prendre une photo → vérifier compression + stockage local + upload API
  - [ ] 12.4 Tester Flutter online : ajouter une note → vérifier stockage local + sync API
  - [ ] 12.5 Tester Flutter offline : prendre plusieurs photos → désactiver réseau → vérifier stockage local uniquement
  - [ ] 12.6 Tester Flutter offline : ajouter plusieurs notes → vérifier stockage local avec `syncStatus: pending`
  - [ ] 12.7 Tester sync : revenir online → vérifier upload automatique des photos + sync notes
  - [ ] 12.8 Tester affichage : voir miniatures photos sous questions, voir liste notes horodatées
  - [ ] 12.9 Commit : `git add . && git commit -m "feat: photos contextualisées et notes agent avec upload queue offline

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"`

## Dev Notes

### Architecture & Contraintes

- **Offline-first** : Photos stockées localement, upload en queue au retour réseau. Notes stockées localement, sync batch [Source: architecture.md#Core Architectural Decisions]
- **Compression obligatoire** : Réduire la taille des photos pour économiser stockage et bande passante. Qualité 80%, max 1920px largeur [Source: architecture.md#Frontend Architecture]
- **Upload queue** : Photos uploadées en arrière-plan avec retry, pas de blocage UI [Source: architecture.md#Data Architecture]
- **Contexte photo** : Chaque photo liée à `question_id` + `category` pour traçabilité [Source: epics.md#Story 5.2 AC]
- **Notes horodatées** : `created_at` affiché pour tracer la chronologie des échanges [Source: epics.md#Story 5.2 AC]

### Versions techniques confirmées

- **image_picker** : v1.0.7+ pour capture photo (caméra ou galerie)
- **flutter_image_compress** : v2.1.0+ pour compression JPEG/PNG
- **path_provider** : v2.1.0+ pour accès répertoire app documents
- **photo_view** : v0.14.0+ pour affichage plein écran avec zoom
- **Multipart upload** : `dio` package avec `FormData.fromMap()` pour upload fichier Laravel
- **Laravel Storage** : `Storage::putFileAs()` pour stockage organisé par `visit_guide_id`

### Modèle de données — Backend

**Table `photos` :**
```
id (UUID, PK)
visit_guide_id (UUID, FK → visit_guides)
question_id (UUID, FK → visit_guide_questions, nullable)
category (string, nullable: structure, électricité, etc.)
file_path (string: photos/{visit_guide_id}/{uuid}.jpg)
file_size (integer, bytes)
mime_type (string: image/jpeg, image/png)
created_at
updated_at
deleted_at
```

**Table `agent_notes` :**
```
id (UUID, PK)
visit_guide_id (UUID, FK → visit_guides)
note_text (text)
created_at
updated_at
deleted_at
```

**Relations Eloquent :**
- `Photo belongsTo VisitGuide`
- `Photo belongsTo VisitGuideQuestion` (nullable)
- `AgentNote belongsTo VisitGuide`
- `VisitGuide hasMany Photo`
- `VisitGuide hasMany AgentNote`

### API Endpoints

**Upload photo :**
```
POST /api/visit-guides/{guide}/photos
Headers: Authorization: Bearer {token}
Body (multipart/form-data):
  - photo (file)
  - question_id (string, optional)
  - category (string, optional)
Response 201: PhotoResource
```

**Liste notes :**
```
GET /api/visit-guides/{guide}/agent-notes
Headers: Authorization: Bearer {token}
Response 200: AgentNoteResource[]
```

**Créer note :**
```
POST /api/visit-guides/{guide}/agent-notes
Headers: Authorization: Bearer {token}
Body: { "note_text": "L'agent a mentionné..." }
Response 201: AgentNoteResource
```

**Controller Laravel :**
```php
// app/Http/Controllers/Api/PhotoController.php
class PhotoController extends Controller
{
    public function upload(VisitGuide $guide, UploadPhotoRequest $request): JsonResponse
    {
        $file = $request->file('photo');
        $uuid = Str::uuid();
        $extension = $file->getClientOriginalExtension();
        $fileName = "{$uuid}.{$extension}";

        // Store in storage/app/photos/{visit_guide_id}/
        $filePath = $file->storeAs("photos/{$guide->id}", $fileName);

        $photo = Photo::create([
            'id' => $uuid,
            'visit_guide_id' => $guide->id,
            'question_id' => $request->question_id,
            'category' => $request->category,
            'file_path' => $filePath,
            'file_size' => $file->getSize(),
            'mime_type' => $file->getMimeType(),
        ]);

        return response()->json(new PhotoResource($photo), 201);
    }
}

// app/Http/Controllers/Api/AgentNoteController.php
class AgentNoteController extends Controller
{
    public function index(VisitGuide $guide): JsonResponse
    {
        $notes = $guide->agentNotes()->orderBy('created_at', 'desc')->get();
        return response()->json(AgentNoteResource::collection($notes));
    }

    public function store(VisitGuide $guide, StoreAgentNoteRequest $request): JsonResponse
    {
        $note = AgentNote::create([
            'id' => Str::uuid(),
            'visit_guide_id' => $guide->id,
            'note_text' => $request->note_text,
        ]);

        return response()->json(new AgentNoteResource($note), 201);
    }
}

// routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/visit-guides/{guide}/photos', [PhotoController::class, 'upload']);
    Route::get('/visit-guides/{guide}/agent-notes', [AgentNoteController::class, 'index']);
    Route::post('/visit-guides/{guide}/agent-notes', [AgentNoteController::class, 'store']);
});
```

**Request Validation :**
```php
// app/Http/Requests/UploadPhotoRequest.php
class UploadPhotoRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'photo' => 'required|image|mimes:jpeg,png,jpg,heic|max:10240', // 10MB max
            'question_id' => 'nullable|uuid|exists:visit_guide_questions,id',
            'category' => 'nullable|string|max:255',
        ];
    }
}

// app/Http/Requests/StoreAgentNoteRequest.php
class StoreAgentNoteRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'note_text' => 'required|string|max:5000',
        ];
    }
}
```

### Flutter Drift Tables

```dart
// lib/core/db/tables/photos_table.dart
class PhotosTable extends Table {
  TextColumn get id => text()();
  TextColumn get visitGuideId => text()();
  TextColumn get questionId => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get localFilePath => text()();
  TextColumn get remoteFilePath => text().nullable()();
  IntColumn get fileSize => integer()();
  TextColumn get mimeType => text()();
  TextColumn get uploadStatus => text().withDefault(const Constant('pending'))(); // pending, uploaded
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// lib/core/db/tables/agent_notes_table.dart
class AgentNotesTable extends Table {
  TextColumn get id => text()();
  TextColumn get visitGuideId => text()();
  TextColumn get noteText => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### Flutter PhotoService — Capture & Compression

```dart
// lib/core/services/photo_service.dart
class PhotoService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> captureAndCompressPhoto() async {
    try {
      // Capture photo
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Pre-compression
      );

      if (image == null) return null;

      // Compress further
      final String targetPath = await _getTargetPath();
      final File? compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 80,
        minWidth: 1920,
        minHeight: 1080,
      );

      return compressedFile;
    } catch (e) {
      print('Error capturing photo: $e');
      return null;
    }
  }

  Future<String> _getTargetPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${directory.path}/photos');
    if (!photosDir.existsSync()) {
      photosDir.createSync(recursive: true);
    }
    final uuid = const Uuid().v4();
    return '${photosDir.path}/$uuid.jpg';
  }
}
```

### Flutter PhotoRepository — Upload Queue

```dart
// lib/features/visit_guide/data/photo_repository.dart
class PhotoRepository {
  final AppDatabase _database;
  final ApiClient _apiClient;
  final PhotoService _photoService;

  PhotoRepository(this._database, this._apiClient, this._photoService);

  Future<void> addPhoto({
    required String visitGuideId,
    String? questionId,
    String? category,
  }) async {
    // Capture & compress
    final File? photoFile = await _photoService.captureAndCompressPhoto();
    if (photoFile == null) return;

    // Store locally in Drift
    final photoId = const Uuid().v4();
    await _database.photosDao.insert(Photo(
      id: photoId,
      visitGuideId: visitGuideId,
      questionId: questionId,
      category: category,
      localFilePath: photoFile.path,
      remoteFilePath: null,
      fileSize: await photoFile.length(),
      mimeType: 'image/jpeg',
      uploadStatus: 'pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
  }

  Future<void> uploadPendingPhotos(String visitGuideId) async {
    final pendingPhotos = await _database.photosDao.getPendingByGuideId(visitGuideId);

    for (final photo in pendingPhotos) {
      try {
        final file = File(photo.localFilePath);
        if (!file.existsSync()) continue;

        final formData = FormData.fromMap({
          'photo': await MultipartFile.fromFile(file.path, filename: '${photo.id}.jpg'),
          'question_id': photo.questionId,
          'category': photo.category,
        });

        final response = await _apiClient.post(
          '/visit-guides/$visitGuideId/photos',
          data: formData,
        );

        // Update with remote path
        await _database.photosDao.updateUploadStatus(
          photo.id,
          'uploaded',
          response.data['data']['file_path'],
        );
      } catch (e) {
        print('Failed to upload photo ${photo.id}: $e');
        // Retry later
      }
    }
  }

  Future<List<PhotoModel>> getPhotosForGuide(String visitGuideId) async {
    final photos = await _database.photosDao.getByGuideId(visitGuideId);
    return photos.map(PhotoModel.fromDrift).toList();
  }

  Future<List<PhotoModel>> getPhotosForQuestion(String questionId) async {
    final photos = await _database.photosDao.getByQuestionId(questionId);
    return photos.map(PhotoModel.fromDrift).toList();
  }
}
```

### Flutter AgentNoteRepository

```dart
// lib/features/visit_guide/data/agent_note_repository.dart
class AgentNoteRepository {
  final AppDatabase _database;
  final ApiClient _apiClient;

  AgentNoteRepository(this._database, this._apiClient);

  Future<void> addNote(String visitGuideId, String noteText) async {
    final noteId = const Uuid().v4();

    await _database.agentNotesDao.insert(AgentNote(
      id: noteId,
      visitGuideId: visitGuideId,
      noteText: noteText,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
    ));
  }

  Future<void> syncNotes(String visitGuideId) async {
    final pendingNotes = await _database.agentNotesDao.getPendingByGuideId(visitGuideId);

    for (final note in pendingNotes) {
      try {
        await _apiClient.post('/visit-guides/$visitGuideId/agent-notes', data: {
          'note_text': note.noteText,
        });

        await _database.agentNotesDao.updateSyncStatus(note.id, 'synced');
      } catch (e) {
        print('Failed to sync note ${note.id}: $e');
      }
    }
  }

  Future<List<AgentNoteModel>> getNotesForGuide(String visitGuideId) async {
    final notes = await _database.agentNotesDao.getByGuideId(visitGuideId);
    return notes.map(AgentNoteModel.fromDrift).toList();
  }
}
```

### UI — QuestionWidget avec bouton photo

```dart
// lib/features/visit_guide/presentation/widgets/question_widget.dart (extrait)
class QuestionWidget extends StatelessWidget {
  final VisitGuideQuestionModel question;
  final String? initialValue;
  final Function(String) onResponseChanged;

  const QuestionWidget({
    required this.question,
    this.initialValue,
    required this.onResponseChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    context.read<VisitGuideCubit>().addPhotoToQuestion(
                      question.id,
                      question.category,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInputWidget(context),
            const SizedBox(height: 8),
            _PhotosGrid(questionId: question.id),
          ],
        ),
      ),
    );
  }

  Widget _buildInputWidget(BuildContext context) {
    // yes_no, multiple_choice, free_text handling
    // ... (même logique que Story 5.1)
  }
}

class _PhotosGrid extends StatelessWidget {
  final String questionId;

  const _PhotosGrid({required this.questionId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisitGuideCubit, VisitGuideState>(
      builder: (context, state) {
        if (state is! VisitGuideLoaded) return const SizedBox.shrink();

        final photos = state.photos.where((p) => p.questionId == questionId).toList();

        if (photos.isEmpty) return const SizedBox.shrink();

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: photos.map((photo) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PhotoViewPage(photo: photo),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.file(
                    File(photo.localFilePath),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  if (photo.uploadStatus == 'pending')
                    const Positioned(
                      top: 4,
                      right: 4,
                      child: Icon(Icons.cloud_upload, color: Colors.orange, size: 20),
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
```

### UI — Agent Notes Section

```dart
// lib/features/visit_guide/presentation/pages/agent_notes_page.dart
class AgentNotesPage extends StatefulWidget {
  final String visitGuideId;

  const AgentNotesPage({required this.visitGuideId, super.key});

  @override
  State<AgentNotesPage> createState() => _AgentNotesPageState();
}

class _AgentNotesPageState extends State<AgentNotesPage> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes agent')),
      body: BlocBuilder<VisitGuideCubit, VisitGuideState>(
        builder: (context, state) {
          if (state is! VisitGuideLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = state.agentNotes;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return ListTile(
                      title: Text(note.noteText),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(note.createdAt),
                      ),
                      trailing: note.syncStatus == 'pending'
                          ? const Icon(Icons.cloud_upload, color: Colors.orange)
                          : const Icon(Icons.cloud_done, color: Colors.green),
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Ajouter une note sur les échanges avec l\'agent...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final text = _noteController.text.trim();
                        if (text.isNotEmpty) {
                          context.read<VisitGuideCubit>().addAgentNote(text);
                          _noteController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### SyncEngine — Upload Queue Integration

```dart
// lib/core/sync/sync_engine.dart (extrait)
class SyncEngine {
  final PhotoRepository _photoRepository;
  final AgentNoteRepository _agentNoteRepository;
  // ...

  Future<void> syncVisitGuideData(String visitGuideId) async {
    // Upload photos
    await _photoRepository.uploadPendingPhotos(visitGuideId);

    // Sync notes
    await _agentNoteRepository.syncNotes(visitGuideId);

    // ... autres sync
  }
}
```

### Project Structure Notes

Structure cible après cette story :

**Backend (`backend-api/`) :**
```
app/Models/
├── Photo.php (new)
└── AgentNote.php (new)
app/Http/Controllers/Api/
├── PhotoController.php (new)
└── AgentNoteController.php (new)
app/Http/Resources/
├── PhotoResource.php (new)
└── AgentNoteResource.php (new)
app/Http/Requests/
├── UploadPhotoRequest.php (new)
└── StoreAgentNoteRequest.php (new)
database/migrations/
├── xxxx_create_photos_table.php (new)
└── xxxx_create_agent_notes_table.php (new)
storage/app/
└── photos/ (storage directory)
```

**Frontend (`mobile-app/`) :**
```
lib/core/
├── db/tables/
│   ├── photos_table.dart (new)
│   └── agent_notes_table.dart (new)
├── services/
│   └── photo_service.dart (new: capture + compression)
└── sync/
    └── sync_engine.dart (updated: photo upload queue)
lib/features/visit_guide/
├── data/
│   ├── photo_repository.dart (new)
│   ├── agent_note_repository.dart (new)
│   └── models/
│       ├── photo_model.dart (new)
│       └── agent_note_model.dart (new)
└── presentation/
    ├── cubit/
    │   └── visit_guide_cubit.dart (updated: photos + notes)
    ├── pages/
    │   ├── agent_notes_page.dart (new)
    │   └── photo_view_page.dart (new: plein écran)
    └── widgets/
        └── question_widget.dart (updated: bouton photo + miniatures)
pubspec.yaml (updated: image_picker, flutter_image_compress, photo_view)
```

### References

- [Source: architecture.md#Frontend Architecture] — Repository pattern, photo upload queue
- [Source: architecture.md#Data Architecture] — Offline-first, upload background avec retry
- [Source: architecture.md#Photo Boundary] — Upload via POST, stockage storage/app/photos/
- [Source: architecture.md#Format Patterns] — UUID v4, snake_case API
- [Source: epics.md#Story 5.2] — Acceptance criteria, photos contextualisées, notes horodatées, offline sync

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
