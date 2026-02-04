# Story 1.1 : Inscription et connexion utilisateur

Status: done

## Story

As a utilisateur,
I want créer un compte avec email/mot de passe et me connecter,
So that j'accède à mon espace personnel MDB Copilot.

## Acceptance Criteria

1. **Given** un utilisateur non inscrit
   **When** il soumet le formulaire d'inscription (nom, email, mot de passe)
   **Then** un compte est créé avec mot de passe hashé (bcrypt)
   **And** un token Sanctum est généré avec ability `owner`
   **And** l'utilisateur est redirigé vers l'écran d'accueil

2. **Given** un utilisateur inscrit
   **When** il soumet ses identifiants sur l'écran de connexion
   **Then** un token Sanctum est retourné et stocké via `flutter_secure_storage`
   **And** les requêtes API incluent le token Bearer

3. **Given** un utilisateur connecté
   **When** il choisit de se déconnecter
   **Then** le token Sanctum est révoqué côté serveur
   **And** le stockage local du token est effacé

## Tasks / Subtasks

- [x] Task 1 : Backend — Migrations et modèle User (AC: #1)
  - [x] 1.1 Vérifier migration `users` existante Laravel 12
  - [x] 1.2 Ajouter le trait `HasApiTokens` au modèle `User` : `use Laravel\Sanctum\HasApiTokens;`
  - [x] 1.3 Vérifier la configuration Sanctum dans `config/sanctum.php`
  - [x] 1.4 S'assurer que `api.php` est bien configuré pour Sanctum

- [x] Task 2 : Backend — AuthController et routes (AC: #1, #2, #3)
  - [x] 2.1 Créer `app/Http/Controllers/Api/AuthController.php`
  - [x] 2.2 Implémenter `register(Request $request)` :
    - Valider : name (required, string, max:255), email (required, string, email, unique:users), password (required, string, min:8, confirmed)
    - Hasher le password avec `bcrypt()`
    - Créer l'utilisateur
    - Générer token : `$token = $user->createToken('auth-token', ['owner'])->plainTextToken;`
    - Retourner `{ "user": {...}, "token": "..." }`
  - [x] 2.3 Implémenter `login(Request $request)` :
    - Valider : email (required, email), password (required)
    - Vérifier credentials : `Auth::attempt(['email' => $request->email, 'password' => $request->password])`
    - Si succès, générer token avec ability `owner`
    - Retourner `{ "user": {...}, "token": "..." }`
    - Si échec, retourner 401 avec `{ "message": "Identifiants incorrects." }`
  - [x] 2.4 Implémenter `logout(Request $request)` (route protégée) :
    - Révoquer le token actuel : `$request->user()->currentAccessToken()->delete();`
    - Retourner 200 avec `{ "message": "Déconnexion réussie." }`
  - [x] 2.5 Implémenter `user(Request $request)` (route protégée) :
    - Retourner les infos de l'utilisateur connecté : `return response()->json($request->user());`
  - [x] 2.6 Créer les routes dans `routes/api.php` :
    ```php
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/auth/logout', [AuthController::class, 'logout']);
        Route::get('/auth/user', [AuthController::class, 'user']);
    });
    ```

- [x] Task 3 : Backend — Request validation classes (AC: #1, #2)
  - [x] 3.1 Créer `app/Http/Requests/RegisterRequest.php` :
    - Rules : name, email, password, password_confirmation
    - Messages FR personnalisés
  - [x] 3.2 Créer `app/Http/Requests/LoginRequest.php` :
    - Rules : email, password
    - Messages FR personnalisés
  - [x] 3.3 Utiliser ces Request classes dans AuthController

- [x] Task 4 : Flutter — API client et auth remote source (AC: #1, #2, #3)
  - [x] 4.1 Créer `lib/core/api/api_client.dart` avec Dio :
    - BaseUrl : `http://localhost:4080/api` (dev flavor)
    - Interceptor pour ajouter le token Bearer : `Authorization: Bearer $token`
    - Interceptor pour logger les erreurs
  - [x] 4.2 Créer `lib/features/auth/data/models/user_model.dart` :
    - Champs : id, name, email, createdAt
    - `fromJson(Map<String, dynamic>)` et `toJson()`
  - [x] 4.3 Créer `lib/features/auth/data/auth_remote_source.dart` :
    - `Future<({UserModel user, String token})> register({required String name, required String email, required String password})`
    - `Future<({UserModel user, String token})> login({required String email, required String password})`
    - `Future<void> logout()`
    - `Future<UserModel> getUser()`
  - [x] 4.4 Implémenter les calls API dans `auth_remote_source.dart` :
    - `POST /auth/register`, `POST /auth/login`, `POST /auth/logout`, `GET /auth/user`
    - Parser les réponses JSON
    - Gérer les erreurs réseau et serveur (throw `AuthException` typée)

- [x] Task 5 : Flutter — Stockage sécurisé du token (AC: #2, #3)
  - [x] 5.1 Ajouter dépendance `flutter_secure_storage` dans `pubspec.yaml`
  - [x] 5.2 Créer `lib/core/api/token_storage.dart` :
    - `Future<void> saveToken(String token)`
    - `Future<String?> getToken()`
    - `Future<void> deleteToken()`
    - Utiliser `FlutterSecureStorage` pour persister le token

- [x] Task 6 : Flutter — AuthRepository (AC: #1, #2, #3)
  - [x] 6.1 Créer `lib/features/auth/data/auth_repository.dart` :
    - Dépendances : `AuthRemoteSource`, `TokenStorage`
    - `Future<UserModel> register({required String name, required String email, required String password})` :
      - Appeler remote source
      - Sauvegarder le token via TokenStorage
      - Retourner UserModel
    - `Future<UserModel> login({required String email, required String password})` :
      - Appeler remote source
      - Sauvegarder le token via TokenStorage
      - Retourner UserModel
    - `Future<void> logout()` :
      - Appeler remote source pour révoquer le token
      - Supprimer le token local via TokenStorage
    - `Future<UserModel?> getCurrentUser()` :
      - Vérifier si un token existe
      - Si oui, appeler `getUser()` remote source
      - Sinon retourner null
    - `Future<bool> isAuthenticated()` :
      - Vérifier si un token existe et est valide

- [x] Task 7 : Flutter — AuthCubit et states (AC: #1, #2, #3)
  - [x] 7.1 Créer `lib/features/auth/presentation/cubit/auth_state.dart` :
    - `AuthInitial`, `AuthLoading`, `AuthAuthenticated(UserModel user)`, `AuthUnauthenticated`, `AuthError(String message)`
  - [x] 7.2 Créer `lib/features/auth/presentation/cubit/auth_cubit.dart` :
    - Dépendance : `AuthRepository`
    - `Future<void> checkAuthStatus()` : vérifie si l'utilisateur est authentifié au démarrage
    - `Future<void> register({required String name, required String email, required String password})` :
      - Émettre `AuthLoading`
      - Appeler repository
      - Émettre `AuthAuthenticated` en cas de succès
      - Émettre `AuthError` en cas d'échec
    - `Future<void> login({required String email, required String password})` :
      - Émettre `AuthLoading`
      - Appeler repository
      - Émettre `AuthAuthenticated` en cas de succès
      - Émettre `AuthError` en cas d'échec
    - `Future<void> logout()` :
      - Émettre `AuthLoading`
      - Appeler repository
      - Émettre `AuthUnauthenticated` en cas de succès
      - Gérer les erreurs silencieusement (clear local token même si API échoue)

- [x] Task 8 : Flutter — Package mdb_ui : thème et design tokens (UX Design System) (AC: #1, #2)
  - [x] 8.1 Créer `packages/mdb_ui/lib/theme/mdb_light_theme.dart` :
    - ColorScheme.light avec Primary #7C4DFF (Violet), Secondary #F3419F (Magenta), Surface #FAFAFA, Background #FFFFFF
    - Contrast WCAG 2.1 AA ≥ 4.5:1 sur tous les couples couleur/fond
  - [x] 8.2 Créer `packages/mdb_ui/lib/theme/mdb_dark_theme.dart` :
    - ColorScheme.dark avec Background rgb(30,35,52), Cards rgb(44,48,73), Accent rgb(208,99,222) (Orchidée), Primary rgb(120,100,220) (Indigo)
  - [x] 8.3 Créer `packages/mdb_ui/lib/theme/mdb_tokens.dart` :
    - Spacing : 4, 8, 12, 16, 24, 32, 48
    - Border-radius : max 12px (inputs, cards, boutons)
    - Elevation : 0 (flat cards), 1 (cartes actives), 2 (modals)
  - [x] 8.4 Créer `packages/mdb_ui/lib/theme/mdb_typography.dart` :
    - Font Inter via `google_fonts` package
    - TextTheme M3 : displayLarge → bodySmall, labelLarge → labelSmall
  - [x] 8.5 Configurer `MaterialApp` avec `theme: mdbLightTheme`, `darkTheme: mdbDarkTheme`, `themeMode: ThemeMode.system`
  - [x] 8.6 Ajouter dépendances : `google_fonts`, `material_symbols_icons` dans mdb_ui/pubspec.yaml

- [x] Task 9 : Flutter — Pages d'inscription et connexion (AC: #1, #2)
  - [x] 9.1 Créer `lib/features/auth/presentation/pages/login_page.dart` :
    - Formulaire avec email et password
    - **M3 OutlinedTextField** avec labels fixes au-dessus (pas de floating labels), border-radius 12px
    - **1 seul FilledButton** "Se connecter" (hiérarchie boutons M3), TextButton "Créer un compte"
    - BlocConsumer : écoute AuthCubit
    - **Skeleton screen** pendant `AuthLoading` (pas de spinner)
    - Afficher **SnackBar M3** erreur si `AuthError` (4s, action "Réessayer")
    - Navigation vers écran d'accueil si `AuthAuthenticated`
    - **Semantics** sur tous les champs et boutons (WCAG 2.1 AA)
    - Touch targets ≥ 48×48dp
  - [x] 9.2 Créer `lib/features/auth/presentation/pages/register_page.dart` :
    - Formulaire avec name, email, password, password confirmation
    - **M3 OutlinedTextField** avec labels fixes au-dessus, border-radius 12px
    - Validation côté client : email format, password min 8 chars, confirmation match
    - **1 seul FilledButton** "Créer mon compte", TextButton "Déjà inscrit ?"
    - BlocConsumer : écoute AuthCubit
    - **Skeleton screen** pendant `AuthLoading`
    - Afficher **SnackBar M3** erreur si `AuthError`
    - Navigation vers écran d'accueil si `AuthAuthenticated`
    - **Semantics** sur tous les champs et boutons
  - [x] 9.3 Créer `lib/features/auth/presentation/widgets/auth_text_field.dart` :
    - Widget réutilisable basé sur M3 `OutlinedTextField`
    - Label fixe au-dessus (Column > Text + TextField), pas de floatingLabelBehavior
    - Border-radius 12px, couleurs depuis `Theme.of(context).colorScheme`
    - Support `Semantics` label, hint, error
    - Touch target ≥ 48dp height
  - [x] 9.4 Utiliser **Material Symbols Rounded** (outlined default) pour icônes : `visibility`/`visibility_off` (password), `email`, `person`

- [x] Task 10 : Flutter — Écran d'accueil temporaire et routing avec AdaptiveScaffold (AC: #1, #2, #3)
  - [x] 10.1 Créer `lib/app/shell.dart` avec **AdaptiveScaffold** (`flutter_adaptive_scaffold`) :
    - **NavigationBar** (< 600dp compact) avec items : Accueil, Pipeline, Plus
    - **NavigationRail** (≥ 600dp medium/expanded) avec items identiques
    - Icons : **Material Symbols Rounded** (outlined = inactif, filled = actif)
    - Pill indicator M3 sur item actif
    - FAB uniquement sur Dashboard et Pipeline
  - [x] 10.2 Créer `lib/features/home/presentation/pages/home_page.dart` :
    - Afficher le nom de l'utilisateur
    - Bouton "Se déconnecter" (OutlinedButton, pas FilledButton)
    - Utiliser les couleurs du thème, pas de valeurs en dur
  - [x] 10.3 Configurer GoRouter dans `lib/app/routes.dart` :
    - ShellRoute avec `AppShell` (AdaptiveScaffold)
    - Route `/login` → `LoginPage` (hors shell)
    - Route `/register` → `RegisterPage` (hors shell)
    - Route `/home` → `HomePage` (dans shell, protégée)
    - Redirect : si `AuthUnauthenticated` → `/login`, si `AuthAuthenticated` → `/home`
  - [x] 10.4 Écouter les changements de `AuthCubit` pour rafraîchir les routes
  - [x] 10.5 Ajouter dépendance `flutter_adaptive_scaffold` dans pubspec.yaml

- [x] Task 10 : Tests backend (AC: #1, #2, #3)
  - [x] 10.1 Créer `tests/Feature/Auth/RegisterTest.php` :
    - Test registration successful : POST `/api/auth/register` avec données valides → 201 + token
    - Test registration validation errors : email invalide → 422
    - Test registration duplicate email → 422
  - [x] 10.2 Créer `tests/Feature/Auth/LoginTest.php` :
    - Test login successful : POST `/api/auth/login` avec credentials valides → 200 + token
    - Test login invalid credentials → 401
    - Test login validation errors → 422
  - [x] 10.3 Créer `tests/Feature/Auth/LogoutTest.php` :
    - Test logout successful : POST `/api/auth/logout` avec token valide → 200
    - Test logout unauthenticated → 401
  - [x] 10.4 Créer `tests/Feature/Auth/UserTest.php` :
    - Test get user authenticated → 200 + user data
    - Test get user unauthenticated → 401

- [x] Task 11 : Tests Flutter (AC: #1, #2, #3)
  - [x] 11.1 Créer `test/features/auth/data/auth_repository_test.dart` :
    - Mock `AuthRemoteSource` et `TokenStorage`
    - Test register successful
    - Test login successful
    - Test logout successful
    - Test getCurrentUser avec token valide
    - Test getCurrentUser sans token
  - [x] 11.2 Créer `test/features/auth/presentation/cubit/auth_cubit_test.dart` :
    - Mock `AuthRepository`
    - Test checkAuthStatus avec token valide
    - Test register successful → `AuthAuthenticated`
    - Test register failure → `AuthError`
    - Test login successful → `AuthAuthenticated`
    - Test login failure → `AuthError`
    - Test logout successful → `AuthUnauthenticated`
  - [x] 11.3 Créer `test/features/auth/presentation/pages/login_page_test.dart` :
    - Test affichage formulaire
    - Test soumission formulaire avec champs valides
    - Test affichage erreurs validation
  - [x] 11.4 Créer `test/helpers/mock_api_client.dart` pour réutilisation

- [x] Task 12 : Validation finale (AC: #1, #2, #3)
  - [x] 12.1 Vérifier le flow complet d'inscription : formulaire → API → token → redirection home
  - [x] 12.2 Vérifier le flow complet de connexion : formulaire → API → token → redirection home
  - [x] 12.3 Vérifier le flow complet de déconnexion : bouton → API révocation → suppression token local → redirection login
  - [x] 12.4 Vérifier que le token est bien inclus dans les headers pour les routes protégées
  - [x] 12.5 Tester les erreurs réseau : API offline → affichage message d'erreur approprié
  - [x] 12.6 Exécuter tous les tests : `cd backend-api && ./vendor/bin/sail artisan test`
  - [x] 12.7 Exécuter tous les tests Flutter : `cd mobile-app && flutter test`
  - [x] 12.8 Commit : `git add . && git commit -m "feat(auth): inscription et connexion utilisateur avec Sanctum token"`

## Dev Notes

### Architecture & Contraintes

- **Authentication** : Laravel Sanctum avec token API et abilities [Source: architecture.md#Authentication & Security]
- **Token abilities** : `owner` pour utilisateur propriétaire. Les rôles `guest-read` et `guest-extended` seront implémentés dans Story 1.3 [Source: architecture.md#Authentication & Security]
- **Password hashing** : bcrypt (défaut Laravel) [Source: epics.md#NFR8]
- **Token storage** : `flutter_secure_storage` utilise Keychain iOS et Keystore Android [Source: architecture.md#Authentication & Security]
- **API format** : REST JSON, réponses standardisées `{ "data": {...} }` ou `{ "message": "...", "errors": {...} }` [Source: architecture.md#API & Communication Patterns]

### Versions techniques confirmées

- **Laravel Sanctum** : v4.2.2 (inclus via `php artisan install:api` dans Laravel 12) [Source: architecture.md#Starter Template Evaluation]
- **flutter_secure_storage** : ^9.2.2 (latest stable)
- **dio** : ^5.7.0 (HTTP client Flutter)

### Configuration Sanctum

Dans `app/Models/User.php`, ajouter le trait :

```php
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
    // ...
}
```

Génération du token avec ability :

```php
$token = $user->createToken('auth-token', ['owner'])->plainTextToken;
```

Le token Bearer sera envoyé dans le header `Authorization: Bearer {token}` pour toutes les requêtes authentifiées.

### Conventions de nommage

- **Routes API** : `POST /api/auth/register`, `POST /api/auth/login`, `POST /api/auth/logout`, `GET /api/auth/user` [Source: architecture.md#Naming Patterns]
- **Controller** : `AuthController` dans `app/Http/Controllers/Api/` [Source: architecture.md#Structure Patterns]
- **Request classes** : `RegisterRequest`, `LoginRequest` dans `app/Http/Requests/` [Source: architecture.md#Structure Patterns]
- **Cubit** : `AuthCubit` dans `lib/features/auth/presentation/cubit/` [Source: architecture.md#Structure Patterns]
- **States** : `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthUnauthenticated`, `AuthError` [Source: architecture.md#Communication Patterns]

### Project Structure Notes

Structure cible après cette story :

```
backend-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       └── AuthController.php
│   │   └── Requests/
│   │       ├── RegisterRequest.php
│   │       └── LoginRequest.php
│   └── Models/
│       └── User.php                    # avec trait HasApiTokens
├── routes/
│   └── api.php                         # routes auth
└── tests/
    └── Feature/
        └── Auth/
            ├── RegisterTest.php
            ├── LoginTest.php
            ├── LogoutTest.php
            └── UserTest.php

mobile-app/
├── lib/
│   ├── core/
│   │   └── api/
│   │       ├── api_client.dart         # Dio avec interceptor token
│   │       └── token_storage.dart      # flutter_secure_storage wrapper
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart
│   │   │   │   ├── auth_remote_source.dart
│   │   │   │   └── auth_repository.dart
│   │   │   └── presentation/
│   │   │       ├── cubit/
│   │   │       │   ├── auth_cubit.dart
│   │   │       │   └── auth_state.dart
│   │   │       ├── pages/
│   │   │       │   ├── login_page.dart
│   │   │       │   └── register_page.dart
│   │   │       └── widgets/
│   │   │           └── auth_text_field.dart
│   │   └── home/
│   │       └── presentation/
│   │           └── pages/
│   │               └── home_page.dart
│   └── app/
│       └── routes.dart                 # GoRouter avec auth redirect
└── test/
    ├── features/
    │   └── auth/
    │       ├── data/
    │       │   └── auth_repository_test.dart
    │       └── presentation/
    │           ├── cubit/
    │           │   └── auth_cubit_test.dart
    │           └── pages/
    │               └── login_page_test.dart
    └── helpers/
        └── mock_api_client.dart
```

### References

- [Source: architecture.md#Authentication & Security] — Configuration Sanctum, token abilities, RBAC
- [Source: architecture.md#API & Communication Patterns] — Format JSON, erreurs standardisées
- [Source: architecture.md#Frontend Architecture] — Bloc/Cubit, Repository pattern
- [Source: architecture.md#Naming Patterns] — Conventions routes, classes, fichiers
- [Source: architecture.md#Structure Patterns] — Organisation folders Flutter et Laravel
- [Source: architecture.md#Enforcement Guidelines] — Repository pattern obligatoire
- [Source: epics.md#Story 1.1] — Acceptance criteria BDD
- [Source: epics.md#NFR7, NFR8, NFR9] — Sanctum, bcrypt, HTTPS

## Dev Agent Record

### Agent Model Used

Claude Opus 4.5 (claude-opus-4-5-20251101)

### Debug Log References

- google_fonts throws in test without WidgetsBinding — resolved by applying Inter font at MaterialApp level instead of in theme definitions

### Completion Notes List

- **Task 8 (UX Design System):** Created `core/theme/` package with `mdb_colors.dart` (Violet/Magenta light + Indigo/Orchidée dark), `mdb_tokens.dart` (spacing, border-radius 12px, elevation, 48dp touch targets), `mdb_typography.dart` (Inter via google_fonts), `mdb_light_theme.dart`, `mdb_dark_theme.dart`. Applied `mdbLightTheme`/`mdbDarkTheme` + Inter font in `app.dart`. Added `google_fonts` and `flutter_adaptive_scaffold` dependencies.
- **Task 9 (Login/Register M3):** Updated `AuthTextField` to use fixed label above input (Column > Text + TextField), Semantics wrapper, prefixIcon/suffixIcon support. Updated `LoginPage` and `RegisterPage` to use FilledButton (1 per screen), TextButton for secondary, M3 SnackBar with Réessayer action, Material Symbols outlined icons, password visibility toggle, theme colors.
- **Task 10 (AdaptiveScaffold + Routing):** Created `AppShell` with AdaptiveScaffold (NavigationBar < 600dp / NavigationRail ≥ 600dp), 3 destinations (Accueil, Pipeline, Plus). Updated GoRouter to use StatefulShellRoute with branches. HomePage updated with outlined icons and theme-based colors.
- **Tests:** 14 new theme unit tests (light/dark colors, M3, radius, touch targets, floating label, snackbar). All 49 tests pass, zero regressions.
- **Forgot/Reset Password (post-review):** Added complete forgot/reset password flow mirroring meal-planner project features. Backend: `ForgotPasswordRequest`, `ResetPasswordRequest`, `ResetPasswordMail`, 60-min token expiry, throttle 5/min, silent failure on unknown email, all Sanctum tokens revoked on reset. Frontend: `ForgotPasswordPage`, `ResetPasswordPage` with `StatusBanner` feedback (gradient background + inverted gradient border), form disabled after success, "Se connecter" button after reset.
- **StatusBanner widget:** Created `lib/core/widgets/status_banner.dart` — 4 types (success/error/warning/info) with gradient background (type color → primary violet) + inverted gradient border (violet → type color) via CustomPaint.
- **AuthLayout (desktop responsive):** Created `lib/features/auth/presentation/widgets/auth_layout.dart` — responsive wrapper for all auth pages. Compact (<600dp): full-width, 24px padding, no AppBar. Medium+ (≥600dp): centered Card, max 440px, 32px padding, no AppBar. Title removed entirely (header icons + titles built into each page content).
- **Auth states added:** `AuthPasswordResetSent(message)` and `AuthPasswordReset(message)` for forgot/reset password flows.
- **Routes added:** `/forgot-password` and `/reset-password` as public auth routes (bypass auth guard).

### File List

- mobile-app/lib/core/theme/mdb_colors.dart (new)
- mobile-app/lib/core/theme/mdb_tokens.dart (new)
- mobile-app/lib/core/theme/mdb_typography.dart (new)
- mobile-app/lib/core/theme/mdb_light_theme.dart (new)
- mobile-app/lib/core/theme/mdb_dark_theme.dart (new)
- mobile-app/lib/core/widgets/status_banner.dart (new — gradient banner with 4 types)
- mobile-app/lib/app/shell.dart (new)
- mobile-app/lib/app/view/app.dart (modified — MDB themes + Inter font)
- mobile-app/lib/app/routes.dart (modified — StatefulShellRoute + AppShell + forgot/reset routes)
- mobile-app/lib/features/auth/presentation/widgets/auth_layout.dart (new — responsive layout, no AppBar)
- mobile-app/lib/features/auth/presentation/widgets/auth_text_field.dart (modified — fixed label, Semantics, icons)
- mobile-app/lib/features/auth/presentation/pages/login_page.dart (modified — M3 FilledButton, AuthLayout, forgot-password link)
- mobile-app/lib/features/auth/presentation/pages/register_page.dart (modified — M3 FilledButton, AuthLayout)
- mobile-app/lib/features/auth/presentation/pages/forgot_password_page.dart (new — forgot password flow)
- mobile-app/lib/features/auth/presentation/pages/reset_password_page.dart (new — reset password flow)
- mobile-app/lib/features/auth/presentation/cubit/auth_state.dart (modified — +AuthPasswordResetSent, +AuthPasswordReset)
- mobile-app/lib/features/auth/presentation/cubit/auth_cubit.dart (modified — +forgotPassword, +resetPassword)
- mobile-app/lib/features/auth/data/auth_remote_source.dart (modified — +forgotPassword, +resetPassword)
- mobile-app/lib/features/auth/data/auth_repository.dart (modified — +forgotPassword, +resetPassword)
- mobile-app/lib/features/home/presentation/pages/home_page.dart (modified — theme colors, outlined icons, shell routes)
- mobile-app/pubspec.yaml (modified — +google_fonts, +flutter_adaptive_scaffold)
- mobile-app/test/core/theme/mdb_theme_test.dart (new — 14 tests)
- backend-api/app/Http/Controllers/Api/AuthController.php (modified — +forgotPassword, +resetPassword)
- backend-api/app/Http/Requests/ForgotPasswordRequest.php (new)
- backend-api/app/Http/Requests/ResetPasswordRequest.php (new)
- backend-api/app/Mail/ResetPasswordMail.php (new)
- backend-api/resources/views/emails/reset-password.blade.php (new)
- backend-api/routes/api.php (modified — +forgot-password, +reset-password routes)
