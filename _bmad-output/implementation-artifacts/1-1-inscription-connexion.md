# Story 1.1 : Inscription et connexion utilisateur

Status: ready-for-dev

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

- [ ] Task 1 : Backend — Migrations et modèle User (AC: #1)
  - [ ] 1.1 Vérifier migration `users` existante Laravel 12
  - [ ] 1.2 Ajouter le trait `HasApiTokens` au modèle `User` : `use Laravel\Sanctum\HasApiTokens;`
  - [ ] 1.3 Vérifier la configuration Sanctum dans `config/sanctum.php`
  - [ ] 1.4 S'assurer que `api.php` est bien configuré pour Sanctum

- [ ] Task 2 : Backend — AuthController et routes (AC: #1, #2, #3)
  - [ ] 2.1 Créer `app/Http/Controllers/Api/AuthController.php`
  - [ ] 2.2 Implémenter `register(Request $request)` :
    - Valider : name (required, string, max:255), email (required, string, email, unique:users), password (required, string, min:8, confirmed)
    - Hasher le password avec `bcrypt()`
    - Créer l'utilisateur
    - Générer token : `$token = $user->createToken('auth-token', ['owner'])->plainTextToken;`
    - Retourner `{ "user": {...}, "token": "..." }`
  - [ ] 2.3 Implémenter `login(Request $request)` :
    - Valider : email (required, email), password (required)
    - Vérifier credentials : `Auth::attempt(['email' => $request->email, 'password' => $request->password])`
    - Si succès, générer token avec ability `owner`
    - Retourner `{ "user": {...}, "token": "..." }`
    - Si échec, retourner 401 avec `{ "message": "Identifiants incorrects." }`
  - [ ] 2.4 Implémenter `logout(Request $request)` (route protégée) :
    - Révoquer le token actuel : `$request->user()->currentAccessToken()->delete();`
    - Retourner 200 avec `{ "message": "Déconnexion réussie." }`
  - [ ] 2.5 Implémenter `user(Request $request)` (route protégée) :
    - Retourner les infos de l'utilisateur connecté : `return response()->json($request->user());`
  - [ ] 2.6 Créer les routes dans `routes/api.php` :
    ```php
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/auth/logout', [AuthController::class, 'logout']);
        Route::get('/auth/user', [AuthController::class, 'user']);
    });
    ```

- [ ] Task 3 : Backend — Request validation classes (AC: #1, #2)
  - [ ] 3.1 Créer `app/Http/Requests/RegisterRequest.php` :
    - Rules : name, email, password, password_confirmation
    - Messages FR personnalisés
  - [ ] 3.2 Créer `app/Http/Requests/LoginRequest.php` :
    - Rules : email, password
    - Messages FR personnalisés
  - [ ] 3.3 Utiliser ces Request classes dans AuthController

- [ ] Task 4 : Flutter — API client et auth remote source (AC: #1, #2, #3)
  - [ ] 4.1 Créer `lib/core/api/api_client.dart` avec Dio :
    - BaseUrl : `http://localhost:4080/api` (dev flavor)
    - Interceptor pour ajouter le token Bearer : `Authorization: Bearer $token`
    - Interceptor pour logger les erreurs
  - [ ] 4.2 Créer `lib/features/auth/data/models/user_model.dart` :
    - Champs : id, name, email, createdAt
    - `fromJson(Map<String, dynamic>)` et `toJson()`
  - [ ] 4.3 Créer `lib/features/auth/data/auth_remote_source.dart` :
    - `Future<({UserModel user, String token})> register({required String name, required String email, required String password})`
    - `Future<({UserModel user, String token})> login({required String email, required String password})`
    - `Future<void> logout()`
    - `Future<UserModel> getUser()`
  - [ ] 4.4 Implémenter les calls API dans `auth_remote_source.dart` :
    - `POST /auth/register`, `POST /auth/login`, `POST /auth/logout`, `GET /auth/user`
    - Parser les réponses JSON
    - Gérer les erreurs réseau et serveur (throw `AuthException` typée)

- [ ] Task 5 : Flutter — Stockage sécurisé du token (AC: #2, #3)
  - [ ] 5.1 Ajouter dépendance `flutter_secure_storage` dans `pubspec.yaml`
  - [ ] 5.2 Créer `lib/core/api/token_storage.dart` :
    - `Future<void> saveToken(String token)`
    - `Future<String?> getToken()`
    - `Future<void> deleteToken()`
    - Utiliser `FlutterSecureStorage` pour persister le token

- [ ] Task 6 : Flutter — AuthRepository (AC: #1, #2, #3)
  - [ ] 6.1 Créer `lib/features/auth/data/auth_repository.dart` :
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

- [ ] Task 7 : Flutter — AuthCubit et states (AC: #1, #2, #3)
  - [ ] 7.1 Créer `lib/features/auth/presentation/cubit/auth_state.dart` :
    - `AuthInitial`, `AuthLoading`, `AuthAuthenticated(UserModel user)`, `AuthUnauthenticated`, `AuthError(String message)`
  - [ ] 7.2 Créer `lib/features/auth/presentation/cubit/auth_cubit.dart` :
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

- [ ] Task 8 : Flutter — Pages d'inscription et connexion (AC: #1, #2)
  - [ ] 8.1 Créer `lib/features/auth/presentation/pages/login_page.dart` :
    - Formulaire avec email et password
    - Boutons : "Se connecter", "Créer un compte"
    - BlocConsumer : écoute AuthCubit
    - Loading indicator pendant `AuthLoading`
    - Afficher SnackBar erreur si `AuthError`
    - Navigation vers écran d'accueil si `AuthAuthenticated`
  - [ ] 8.2 Créer `lib/features/auth/presentation/pages/register_page.dart` :
    - Formulaire avec name, email, password, password confirmation
    - Validation côté client : email format, password min 8 chars, confirmation match
    - BlocConsumer : écoute AuthCubit
    - Loading indicator pendant `AuthLoading`
    - Afficher SnackBar erreur si `AuthError`
    - Navigation vers écran d'accueil si `AuthAuthenticated`
  - [ ] 8.3 Créer un widget `lib/features/auth/presentation/widgets/auth_text_field.dart` pour réutilisation

- [ ] Task 9 : Flutter — Écran d'accueil temporaire et routing (AC: #1, #2, #3)
  - [ ] 9.1 Créer `lib/features/home/presentation/pages/home_page.dart` :
    - Afficher le nom de l'utilisateur
    - Bouton "Se déconnecter" qui appelle `context.read<AuthCubit>().logout()`
  - [ ] 9.2 Configurer GoRouter dans `lib/app/routes.dart` :
    - Route `/login` → `LoginPage`
    - Route `/register` → `RegisterPage`
    - Route `/home` → `HomePage` (protégée)
    - Redirect : si `AuthUnauthenticated` → `/login`, si `AuthAuthenticated` → `/home`
  - [ ] 9.3 Écouter les changements de `AuthCubit` pour rafraîchir les routes

- [ ] Task 10 : Tests backend (AC: #1, #2, #3)
  - [ ] 10.1 Créer `tests/Feature/Auth/RegisterTest.php` :
    - Test registration successful : POST `/api/auth/register` avec données valides → 201 + token
    - Test registration validation errors : email invalide → 422
    - Test registration duplicate email → 422
  - [ ] 10.2 Créer `tests/Feature/Auth/LoginTest.php` :
    - Test login successful : POST `/api/auth/login` avec credentials valides → 200 + token
    - Test login invalid credentials → 401
    - Test login validation errors → 422
  - [ ] 10.3 Créer `tests/Feature/Auth/LogoutTest.php` :
    - Test logout successful : POST `/api/auth/logout` avec token valide → 200
    - Test logout unauthenticated → 401
  - [ ] 10.4 Créer `tests/Feature/Auth/UserTest.php` :
    - Test get user authenticated → 200 + user data
    - Test get user unauthenticated → 401

- [ ] Task 11 : Tests Flutter (AC: #1, #2, #3)
  - [ ] 11.1 Créer `test/features/auth/data/auth_repository_test.dart` :
    - Mock `AuthRemoteSource` et `TokenStorage`
    - Test register successful
    - Test login successful
    - Test logout successful
    - Test getCurrentUser avec token valide
    - Test getCurrentUser sans token
  - [ ] 11.2 Créer `test/features/auth/presentation/cubit/auth_cubit_test.dart` :
    - Mock `AuthRepository`
    - Test checkAuthStatus avec token valide
    - Test register successful → `AuthAuthenticated`
    - Test register failure → `AuthError`
    - Test login successful → `AuthAuthenticated`
    - Test login failure → `AuthError`
    - Test logout successful → `AuthUnauthenticated`
  - [ ] 11.3 Créer `test/features/auth/presentation/pages/login_page_test.dart` :
    - Test affichage formulaire
    - Test soumission formulaire avec champs valides
    - Test affichage erreurs validation
  - [ ] 11.4 Créer `test/helpers/mock_api_client.dart` pour réutilisation

- [ ] Task 12 : Validation finale (AC: #1, #2, #3)
  - [ ] 12.1 Vérifier le flow complet d'inscription : formulaire → API → token → redirection home
  - [ ] 12.2 Vérifier le flow complet de connexion : formulaire → API → token → redirection home
  - [ ] 12.3 Vérifier le flow complet de déconnexion : bouton → API révocation → suppression token local → redirection login
  - [ ] 12.4 Vérifier que le token est bien inclus dans les headers pour les routes protégées
  - [ ] 12.5 Tester les erreurs réseau : API offline → affichage message d'erreur approprié
  - [ ] 12.6 Exécuter tous les tests : `cd backend-api && ./vendor/bin/sail artisan test`
  - [ ] 12.7 Exécuter tous les tests Flutter : `cd mobile-app && flutter test`
  - [ ] 12.8 Commit : `git add . && git commit -m "feat(auth): inscription et connexion utilisateur avec Sanctum token"`

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

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
