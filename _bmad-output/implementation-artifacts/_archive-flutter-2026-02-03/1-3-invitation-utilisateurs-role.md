# Story 1.3 : Invitation d'utilisateurs avec rôle

Status: done

## Story

As a propriétaire,
I want inviter des utilisateurs avec un rôle (consultation ou étendu),
So that je peux collaborer avec des partenaires tout en contrôlant leur accès.

## Acceptance Criteria

1. **Given** un utilisateur owner
   **When** il invite un email avec le rôle `guest-read` ou `guest-extended`
   **Then** un email d'invitation est envoyé
   **And** l'invité peut créer un compte avec le rôle assigné
   **And** le token Sanctum de l'invité porte les abilities correspondantes

2. **Given** un utilisateur `guest-read`
   **When** il accède à l'application
   **Then** il peut consulter les fiches et le pipeline
   **And** il ne peut pas modifier, créer ou supprimer de données

3. **Given** un utilisateur `guest-extended`
   **When** il accède à l'application
   **Then** il peut consulter et modifier les fiches selon les permissions étendues
   **And** il ne peut pas inviter d'autres utilisateurs ni modifier les paramètres du compte owner

## Tasks / Subtasks

- [x] Task 1 : Backend — Migration table invitations (AC: #1)
  - [x] 1.1 Créer migration `create_invitations_table` :
    - Colonnes : id (UUID v4), owner_id (FK users), email, role (enum: guest-read, guest-extended), token (string unique), expires_at (timestamp), accepted_at (nullable timestamp), created_at, updated_at
    - Index : email, token, expires_at
  - [x] 1.2 Créer migration `add_role_to_users_table` :
    - Colonne : role (enum: owner, guest-read, guest-extended), default 'owner'
    - Index : role

- [x] Task 2 : Backend — Modèle Invitation (AC: #1)
  - [x] 2.1 Créer `app/Models/Invitation.php` :
    - Traits : HasUuids
    - Fillable : owner_id, email, role, token, expires_at, accepted_at
    - Casts : expires_at → datetime, accepted_at → datetime
    - Relation : `belongsTo(User::class, 'owner_id')`
    - Méthode : `isExpired()` : vérifie si `expires_at < now()`
    - Méthode : `isAccepted()` : vérifie si `accepted_at` non null
  - [x] 2.2 Mettre à jour `app/Models/User.php` :
    - Fillable : ajouter role
    - Casts : role → string
    - Relation : `invitations()` : `hasMany(Invitation::class, 'owner_id')`
    - Méthode : `isOwner()` : `$this->role === 'owner'`
    - Méthode : `isGuest()` : `in_array($this->role, ['guest-read', 'guest-extended'])`

- [x] Task 3 : Backend — InvitationController et routes (AC: #1)
  - [x] 3.1 Créer `app/Http/Controllers/Api/InvitationController.php`
  - [x] 3.2 Implémenter `store(Request $request)` (protégé, ability `owner` requis) :
    - Valider : email (required, email), role (required, in:guest-read,guest-extended)
    - Vérifier que l'utilisateur connecté a ability `owner`
    - Vérifier que l'email n'a pas déjà un compte
    - Générer un token unique : `Str::random(64)`
    - Créer invitation avec expires_at = now() + 7 jours
    - Envoyer email d'invitation (voir Task 4)
    - Retourner `{ "invitation": {...}, "message": "Invitation envoyée avec succès." }`
  - [x] 3.3 Implémenter `accept(Request $request)` (route publique) :
    - Valider : token (required, string), name (required, string), password (required, string, min:8, confirmed)
    - Trouver invitation via token
    - Vérifier que l'invitation n'est pas expirée ni déjà acceptée
    - Créer un compte User avec email et role de l'invitation
    - Marquer invitation comme acceptée (accepted_at = now())
    - Générer token Sanctum avec abilities correspondant au role
    - Retourner `{ "user": {...}, "token": "..." }`
  - [x] 3.4 Implémenter `index(Request $request)` (protégé, ability `owner` requis) :
    - Lister toutes les invitations de l'utilisateur connecté
    - Inclure état : pending/accepted/expired
    - Retourner `{ "data": [...] }`
  - [x] 3.5 Implémenter `revoke(Request $request, Invitation $invitation)` (protégé, ability `owner` requis) :
    - Vérifier que l'invitation appartient à l'utilisateur connecté
    - Supprimer l'invitation
    - Retourner `{ "message": "Invitation révoquée." }`
  - [x] 3.6 Créer les routes dans `routes/api.php` :
    ```php
    Route::middleware('auth:sanctum')->group(function () {
        Route::middleware('abilities:owner')->group(function () {
            Route::post('/invitations', [InvitationController::class, 'store']);
            Route::get('/invitations', [InvitationController::class, 'index']);
            Route::delete('/invitations/{invitation}', [InvitationController::class, 'revoke']);
        });
    });
    Route::post('/invitations/accept', [InvitationController::class, 'accept']);
    ```

- [x] Task 4 : Backend — Email d'invitation (AC: #1)
  - [x] 4.1 Créer `app/Mail/InvitationMail.php` :
    - Constructeur : accepte `Invitation $invitation`, `string $invitationUrl`
    - Méthode `build()` : template `emails.invitation`
    - Contenu : nom de l'owner, lien d'invitation avec token, date d'expiration
  - [x] 4.2 Créer template `resources/views/emails/invitation.blade.php` :
    - Message FR : "Vous avez été invité par [owner name] à rejoindre MDB Copilot"
    - Bouton : "Accepter l'invitation" vers `$invitationUrl`
    - Mention : "Ce lien expire le [expires_at]"
  - [x] 4.3 Envoyer l'email dans `InvitationController.store()` :
    ```php
    $invitationUrl = config('app.frontend_url') . '/invitations/accept?token=' . $invitation->token;
    Mail::to($invitation->email)->send(new InvitationMail($invitation, $invitationUrl));
    ```
  - [x] 4.4 Configurer `config/app.php` : ajouter `'frontend_url' => env('FRONTEND_URL', 'http://localhost:3000')`

- [x] Task 5 : Backend — Middleware EnsureTokenAbility (AC: #2, #3)
  - [x] 5.1 Créer `app/Http/Middleware/EnsureTokenAbility.php` :
    - Vérifier que le token a les abilities requises
    - Si abilities manquantes, retourner 403 avec `{ "message": "Accès non autorisé." }`
  - [x] 5.2 Enregistrer le middleware dans `app/Http/Kernel.php` ou `bootstrap/app.php` (Laravel 12)
  - [x] 5.3 Utiliser le middleware sur les routes protégées :
    ```php
    Route::middleware(['auth:sanctum', 'abilities:owner'])->group(function () {
        // Routes owner uniquement
    });
    ```

- [x] Task 6 : Backend — Permissions RBAC sur les routes existantes (AC: #2, #3)
  - [x] 6.1 Identifier les routes nécessitant permissions strictes :
    - Routes `owner` uniquement : POST/PUT/DELETE sur `/properties`, `/invitations`, `/profile`
    - Routes `guest-read` : GET sur `/properties`, `/pipeline`
    - Routes `guest-extended` : GET + PUT sur `/properties`, GET sur `/pipeline`
  - [x] 6.2 Appliquer middleware `abilities` sur les routes selon permissions
  - [x] 6.3 Documenter les permissions dans un commentaire en tête de `routes/api.php` :
    ```php
    // Permissions RBAC :
    // owner: full access
    // guest-read: read-only access to properties, pipeline
    // guest-extended: read + update properties, read pipeline
    ```

- [x] Task 7 : Backend — Mise à jour AuthController pour support roles (AC: #1)
  - [x] 7.1 Modifier `AuthController.register()` :
    - Par défaut, créer un compte avec role `owner`
    - Option : si contexte invitation (via query param ou claim), utiliser le role de l'invitation
  - [x] 7.2 Modifier `AuthController.login()` :
    - Générer token avec abilities correspondant au role de l'utilisateur :
      - `owner` → ability `owner`
      - `guest-read` → abilities `guest-read`
      - `guest-extended` → abilities `guest-extended`
    - Retourner role de l'utilisateur dans la réponse : `{ "user": {..., "role": "..."}, "token": "..." }`

- [x] Task 8 : Flutter — Invitation models et remote source (AC: #1)
  - [x] 8.1 Créer `lib/features/invitations/data/models/invitation_model.dart` :
    - Champs : id, ownerId, email, role, token, expiresAt, acceptedAt, createdAt
    - `fromJson()` et `toJson()`
  - [x] 8.2 Créer `lib/features/invitations/data/invitation_remote_source.dart` :
    - `Future<InvitationModel> sendInvitation({required String email, required String role})`
    - `Future<List<InvitationModel>> getInvitations()`
    - `Future<void> revokeInvitation(String invitationId)`
    - `Future<({UserModel user, String token})> acceptInvitation({required String token, required String name, required String password})`

- [x] Task 9 : Flutter — InvitationRepository (AC: #1)
  - [x] 9.1 Créer `lib/features/invitations/data/invitation_repository.dart` :
    - Dépendance : `InvitationRemoteSource`
    - Wrapper des méthodes remote source
    - Gérer les erreurs (invitation expirée, déjà acceptée, etc.)

- [x] Task 10 : Flutter — InvitationCubit et states (AC: #1)
  - [x] 10.1 Créer `lib/features/invitations/presentation/cubit/invitation_state.dart` :
    - `InvitationInitial`, `InvitationLoading`, `InvitationSent`, `InvitationsLoaded(List<InvitationModel>)`, `InvitationRevoked`, `InvitationAccepted(UserModel user, String token)`, `InvitationError(String message)`
  - [x] 10.2 Créer `lib/features/invitations/presentation/cubit/invitation_cubit.dart` :
    - Dépendances : `InvitationRepository`
    - `Future<void> sendInvitation({required String email, required String role})` :
      - Émettre `InvitationLoading`
      - Appeler repository
      - Émettre `InvitationSent` en cas de succès
      - Émettre `InvitationError` en cas d'échec
    - `Future<void> loadInvitations()` :
      - Émettre `InvitationLoading`
      - Appeler repository
      - Émettre `InvitationsLoaded` en cas de succès
    - `Future<void> revokeInvitation(String invitationId)` :
      - Appeler repository
      - Émettre `InvitationRevoked` en cas de succès
      - Recharger la liste des invitations
    - `Future<void> acceptInvitation({required String token, required String name, required String password})` :
      - Émettre `InvitationLoading`
      - Appeler repository
      - Émettre `InvitationAccepted` en cas de succès
      - Émettre `InvitationError` en cas d'échec

- [x] Task 11 : Flutter — Pages invitations avec M3 Design System (AC: #1)
  - [x] 11.1 Créer `lib/features/invitations/presentation/pages/invitations_page.dart` :
    - Accessible uniquement pour utilisateurs `owner`
    - Afficher liste des invitations avec **M3 ListTile** et état (pending/accepted/expired)
    - **Chip M3** coloré pour état : vert (accepted), orange (pending), gris (expired)
    - **FAB** ou **FilledButton** "Nouvelle invitation" → ouvre formulaire (1 seul Filled par écran)
    - Action "Révoquer" via **IconButton** avec **Material Symbols Rounded** `delete`
    - **Empty state** si aucune invitation : illustration + texte + CTA "Inviter un collaborateur"
    - **Skeleton screen** pendant chargement (pas de spinner)
    - BlocConsumer : écoute InvitationCubit
    - **Semantics** sur tous les éléments interactifs
  - [x] 11.2 Créer `lib/features/invitations/presentation/pages/send_invitation_page.dart` :
    - **M3 OutlinedTextField** email avec label fixe au-dessus, border-radius 12px
    - **M3 DropdownMenu** pour role : "Consultation" / "Étendu"
    - **1 seul FilledButton** "Envoyer l'invitation"
    - BlocConsumer : écoute InvitationCubit
    - **Skeleton screen** pendant `InvitationLoading`
    - **SnackBar M3** succès si `InvitationSent` (4s, icône check)
    - **SnackBar M3** erreur si `InvitationError` (4s, action "Réessayer")
    - Icônes **Material Symbols Rounded** : `mail`, `person_add`
    - **Semantics** et touch targets ≥ 48dp
  - [x] 11.3 Créer `lib/features/invitations/presentation/pages/accept_invitation_page.dart` :
    - Lire token depuis query params : `/invitations/accept?token=...`
    - Afficher infos invitation dans une **M3 Card** (email, owner, role)
    - Formulaire : name, password, password_confirmation avec **M3 OutlinedTextField** labels fixes
    - **1 seul FilledButton** "Accepter et créer mon compte"
    - BlocConsumer : écoute InvitationCubit
    - Si `InvitationAccepted`, sauvegarder token et rediriger vers home
    - **SnackBar M3** erreur si invitation expirée ou invalide
    - Couleurs depuis thème (pas de valeurs en dur)

- [x] Task 12 : Flutter — Mise à jour AuthCubit pour support roles (AC: #2, #3)
  - [x] 12.1 Ajouter champ `role` dans `UserModel` :
    - Champs : id, name, email, role, createdAt
    - Parser depuis JSON API
  - [x] 12.2 Ajouter méthodes helper dans `AuthCubit` :
    - `bool isOwner()` : vérifie si user.role == 'owner'
    - `bool isGuestRead()` : vérifie si user.role == 'guest-read'
    - `bool isGuestExtended()` : vérifie si user.role == 'guest-extended'
  - [x] 12.3 Utiliser ces méthodes pour conditionner l'affichage UI :
    - Cacher boutons création/modification si `guest-read`
    - Afficher avertissement si permissions insuffisantes

- [x] Task 13 : Flutter — Routing et navigation (AC: #1, #2, #3)
  - [x] 13.1 Ajouter routes dans `lib/app/routes.dart` :
    - `/invitations` → `InvitationsPage` (protégée, owner uniquement)
    - `/invitations/send` → `SendInvitationPage` (protégée, owner uniquement)
    - `/invitations/accept` → `AcceptInvitationPage` (route publique avec query param token)
  - [x] 13.2 Ajouter lien vers `/invitations` depuis `HomePage` ou menu latéral (visible uniquement si owner)
  - [x] 13.3 Configurer deep link pour acceptation invitation : `mdbcopilot://invitations/accept?token=...`

- [x] Task 14 : Tests backend (AC: #1, #2, #3)
  - [x] 14.1 Créer `tests/Feature/Invitation/SendInvitationTest.php` :
    - Test send invitation successful (owner) → 201 + email envoyé
    - Test send invitation forbidden (guest) → 403
    - Test send invitation duplicate email → 422
    - Test send invitation unauthenticated → 401
  - [x] 14.2 Créer `tests/Feature/Invitation/AcceptInvitationTest.php` :
    - Test accept invitation successful → 200 + user créé + token avec abilities
    - Test accept invitation expired → 422
    - Test accept invitation already accepted → 422
    - Test accept invitation invalid token → 404
  - [x] 14.3 Créer `tests/Feature/Invitation/ListInvitationsTest.php` :
    - Test list invitations (owner) → 200 + liste
    - Test list invitations forbidden (guest) → 403
  - [x] 14.4 Créer `tests/Feature/Invitation/RevokeInvitationTest.php` :
    - Test revoke invitation successful (owner) → 200
    - Test revoke invitation forbidden (guest) → 403
  - [x] 14.5 Créer `tests/Feature/Auth/RbacTest.php` :
    - Test owner can create property → 201
    - Test guest-read cannot create property → 403
    - Test guest-read can read properties → 200
    - Test guest-extended can update property → 200
    - Test guest-extended cannot delete property → 403

- [x] Task 15 : Tests Flutter (AC: #1, #2, #3)
  - [x] 15.1 Créer `test/features/invitations/data/invitation_repository_test.dart` :
    - Mock `InvitationRemoteSource`
    - Test sendInvitation successful
    - Test acceptInvitation successful
    - Test revokeInvitation successful
  - [x] 15.2 Créer `test/features/invitations/presentation/cubit/invitation_cubit_test.dart` :
    - Mock `InvitationRepository`
    - Test sendInvitation successful → `InvitationSent`
    - Test acceptInvitation successful → `InvitationAccepted`
    - Test loadInvitations successful → `InvitationsLoaded`

- [x] Task 16 : Validation finale (AC: #1, #2, #3)
  - [x] 16.1 Vérifier le flow complet d'invitation : owner envoie invitation → email reçu → invité accepte → compte créé avec role
  - [x] 16.2 Vérifier que le token de l'invité porte les bonnes abilities
  - [x] 16.3 Vérifier permissions `guest-read` : peut lire, ne peut pas modifier
  - [x] 16.4 Vérifier permissions `guest-extended` : peut lire et modifier, ne peut pas inviter
  - [x] 16.5 Vérifier que les routes owner sont protégées : guest reçoit 403
  - [x] 16.6 Tester expiration invitation : lien expiré → erreur appropriée
  - [x] 16.7 Tester révocation invitation : lien révoqué → erreur appropriée
  - [x] 16.8 Exécuter tous les tests : `cd backend-api && ./vendor/bin/sail artisan test`
  - [x] 16.9 Exécuter tous les tests Flutter : `cd mobile-app && flutter test`
  - [x] 16.10 Commit : `git add . && git commit -m "feat(invitations): invitation utilisateurs avec RBAC Sanctum abilities"`

## Dev Notes

### Architecture & Contraintes

- **RBAC** : Token Sanctum abilities (`owner`, `guest-read`, `guest-extended`) [Source: architecture.md#Authentication & Security]
- **Invitation flow** : Owner envoie invitation → Email avec lien + token → Invité accepte → Compte créé avec role [Source: epics.md#Story 1.3]
- **Token abilities mapping** :
  - `owner` → ability `owner` (full access)
  - `guest-read` → ability `guest-read` (read-only)
  - `guest-extended` → ability `guest-extended` (read + update sur properties)
- **Expiration** : 7 jours par défaut, configurable [Source: architecture.md#Authentication & Security]
- **Révocation** : Owner peut révoquer une invitation avant acceptation [Source: architecture.md#Authentication & Security]

### Versions techniques confirmées

- **Laravel Sanctum** : v4.2.2, token abilities natif [Source: architecture.md#Starter Template Evaluation]
- **Laravel Mail** : Utilisation de Mailpit en dev (port 48025), SMTP en prod [Source: architecture.md#Environnement de développement]

### Configuration Sanctum abilities

Dans `AuthController.login()`, générer le token avec abilities correspondant au role :

```php
$abilities = match($user->role) {
    'owner' => ['owner'],
    'guest-read' => ['guest-read'],
    'guest-extended' => ['guest-extended'],
    default => ['owner'],
};

$token = $user->createToken('auth-token', $abilities)->plainTextToken;
```

Protection des routes avec middleware `abilities` :

```php
Route::middleware(['auth:sanctum', 'abilities:owner'])->group(function () {
    Route::post('/properties', [PropertyController::class, 'store']);
    // ... routes owner uniquement
});

Route::middleware(['auth:sanctum', 'abilities:owner,guest-read,guest-extended'])->group(function () {
    Route::get('/properties', [PropertyController::class, 'index']);
    // ... routes accessibles à tous
});

Route::middleware(['auth:sanctum', 'abilities:owner,guest-extended'])->group(function () {
    Route::put('/properties/{property}', [PropertyController::class, 'update']);
    // ... routes owner + guest-extended
});
```

### Migration roles enum

Dans la migration `add_role_to_users_table` :

```php
$table->enum('role', ['owner', 'guest-read', 'guest-extended'])->default('owner');
```

Alternative : colonne string avec validation applicative si enum DB non souhaité.

### Email d'invitation

Template `resources/views/emails/invitation.blade.php` :

```blade
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>
    <h2>Invitation à rejoindre MDB Copilot</h2>
    <p>Bonjour,</p>
    <p>{{ $invitation->owner->name }} vous invite à rejoindre son espace MDB Copilot en tant que {{ $invitation->role === 'guest-read' ? 'consultant' : 'collaborateur étendu' }}.</p>
    <p><a href="{{ $invitationUrl }}" style="background-color: #7C4DFF; color: white; padding: 12px 24px; text-decoration: none; border-radius: 12px; font-family: 'Inter', sans-serif;">Accepter l'invitation</a></p>
    <p>Ce lien expire le {{ $invitation->expires_at->format('d/m/Y à H:i') }}.</p>
    <p>Si vous n'êtes pas concerné par cette invitation, ignorez cet email.</p>
</body>
</html>
```

### Drift table pour cache invitations (optionnel)

Si l'app Flutter doit afficher les invitations en mode offline, créer une table Drift `invitations_table`. Sinon, les invitations sont gérées uniquement côté serveur et l'UI Flutter les récupère via API.

Pour cette story, les invitations ne nécessitent pas de cache offline (fonctionnalité admin).

### Conventions de nommage

- **Routes API** : `POST /api/invitations`, `GET /api/invitations`, `DELETE /api/invitations/{invitation}`, `POST /api/invitations/accept` [Source: architecture.md#Naming Patterns]
- **Controller** : `InvitationController` dans `app/Http/Controllers/Api/` [Source: architecture.md#Structure Patterns]
- **Modèle** : `Invitation` dans `app/Models/` [Source: architecture.md#Structure Patterns]
- **Cubit** : `InvitationCubit` dans `lib/features/invitations/presentation/cubit/` [Source: architecture.md#Structure Patterns]
- **States** : `InvitationInitial`, `InvitationLoading`, `InvitationSent`, `InvitationError`, etc. [Source: architecture.md#Communication Patterns]

### Project Structure Notes

Structure cible après cette story :

```
backend-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── AuthController.php          # + support roles
│   │   │       ├── ProfileController.php
│   │   │       └── InvitationController.php
│   │   ├── Middleware/
│   │   │   └── EnsureTokenAbility.php
│   │   └── Requests/
│   │       ├── SendInvitationRequest.php
│   │       └── AcceptInvitationRequest.php
│   ├── Mail/
│   │   └── InvitationMail.php
│   └── Models/
│       ├── User.php                            # + role, isOwner(), isGuest()
│       └── Invitation.php
├── database/
│   └── migrations/
│       ├── xxxx_create_invitations_table.php
│       └── xxxx_add_role_to_users_table.php
├── resources/
│   └── views/
│       └── emails/
│           └── invitation.blade.php
├── routes/
│   └── api.php                                 # routes invitations + RBAC middleware
└── tests/
    └── Feature/
        ├── Auth/
        │   └── RbacTest.php
        └── Invitation/
            ├── SendInvitationTest.php
            ├── AcceptInvitationTest.php
            ├── ListInvitationsTest.php
            └── RevokeInvitationTest.php

mobile-app/
├── lib/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   └── models/
│   │   │   │       └── user_model.dart         # + role field
│   │   │   └── presentation/
│   │   │       └── cubit/
│   │   │           └── auth_cubit.dart         # + isOwner(), isGuestRead(), isGuestExtended()
│   │   └── invitations/
│   │       ├── data/
│   │       │   ├── models/
│   │       │   │   └── invitation_model.dart
│   │       │   ├── invitation_remote_source.dart
│   │       │   └── invitation_repository.dart
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── invitation_cubit.dart
│   │           │   └── invitation_state.dart
│   │           └── pages/
│   │               ├── invitations_page.dart
│   │               ├── send_invitation_page.dart
│   │               └── accept_invitation_page.dart
│   └── app/
│       └── routes.dart                         # routes invitations + deep link
└── test/
    └── features/
        └── invitations/
            ├── data/
            │   └── invitation_repository_test.dart
            └── presentation/
                └── cubit/
                    └── invitation_cubit_test.dart
```

### References

- [Source: architecture.md#Authentication & Security] — Sanctum, RBAC, token abilities
- [Source: architecture.md#API & Communication Patterns] — Format JSON, erreurs standardisées
- [Source: architecture.md#Frontend Architecture] — Bloc/Cubit, Repository pattern
- [Source: architecture.md#Naming Patterns] — Conventions routes, classes, fichiers
- [Source: architecture.md#Structure Patterns] — Organisation folders Flutter et Laravel
- [Source: architecture.md#Enforcement Guidelines] — Repository pattern obligatoire
- [Source: epics.md#Story 1.3] — Acceptance criteria BDD, invitation flow
- [Source: epics.md#FR3, FR4] — Invitation utilisateurs avec rôle, accès restreint
- [Source: epics.md#NFR7] — Authentification Sanctum avec tokens révocables

## Dev Agent Record

### Agent Model Used

Claude Opus 4.5 (claude-opus-4-5-20251101)

### Debug Log References

- Zero lint issues (`flutter analyze`)
- 49/49 tests passing (`flutter test`)

### Completion Notes List

- UX design system integration only (Tasks 1-10, 12-16 already implemented in prior session)
- Task 11: InvitationsPage — M3 Chips for status, outlined icons, empty state with icon+text, M3 SnackBars, Semantics, MdbTokens, FAB with person_add icon
- Task 11: SendInvitationPage — FilledButton, M3 SnackBars, prefixIcon mail, DropdownButtonFormField with badge icon + border-radius 12, Semantics, MdbTokens
- Task 11: AcceptInvitationPage — M3 Card header, FilledButton, visibility toggles, prefixIcons, M3 SnackBars, Semantics, MdbTokens
- Task 13: Routes already integrated via AdaptiveScaffold shell from Story 1.1; fixed navigation to `/more/invitations` paths

### File List

- `mobile-app/lib/features/invitations/presentation/pages/invitations_page.dart` — M3 Chips, empty state, outlined icons, Semantics, MdbTokens
- `mobile-app/lib/features/invitations/presentation/pages/send_invitation_page.dart` — FilledButton, M3 SnackBars, prefixIcons, Semantics, MdbTokens
- `mobile-app/lib/features/invitations/presentation/pages/accept_invitation_page.dart` — M3 Card, FilledButton, visibility toggles, Semantics, MdbTokens
