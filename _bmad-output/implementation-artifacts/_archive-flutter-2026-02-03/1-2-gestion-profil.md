# Story 1.2 : Gestion du profil utilisateur

Status: done

## Story

As a utilisateur,
I want modifier mon nom, email et mot de passe,
So that mes informations personnelles restent à jour.

## Acceptance Criteria

1. **Given** un utilisateur connecté
   **When** il modifie son nom ou email dans l'écran profil
   **Then** les modifications sont enregistrées côté serveur
   **And** l'UI reflète les changements immédiatement

2. **Given** un utilisateur connecté
   **When** il modifie son mot de passe (ancien + nouveau + confirmation)
   **Then** le mot de passe est mis à jour si l'ancien est correct
   **And** une erreur s'affiche si l'ancien mot de passe est incorrect
   **And** une erreur s'affiche si nouveau et confirmation ne correspondent pas

## Tasks / Subtasks

- [x] Task 1 : Backend — ProfileController et routes (AC: #1, #2)
  - [x] 1.1 Créer `app/Http/Controllers/Api/ProfileController.php`
  - [x] 1.2 Implémenter `updateProfile(Request $request)` :
    - Valider : name (sometimes, string, max:255), email (sometimes, string, email, unique:users,email,{userId})
    - Mettre à jour les champs modifiés : `$request->user()->update($validated);`
    - Retourner `{ "user": {...}, "message": "Profil mis à jour avec succès." }`
  - [x] 1.3 Implémenter `updatePassword(Request $request)` :
    - Valider : current_password (required, string), password (required, string, min:8, confirmed)
    - Vérifier ancien mot de passe : `if (!Hash::check($request->current_password, $request->user()->password)) { ... }`
    - Si incorrect, retourner 422 avec `{ "errors": { "current_password": ["Mot de passe actuel incorrect."] } }`
    - Si correct, mettre à jour : `$request->user()->update(['password' => bcrypt($request->password)]);`
    - Retourner `{ "message": "Mot de passe mis à jour avec succès." }`
  - [x] 1.4 Créer les routes protégées dans `routes/api.php` :
    ```php
    Route::middleware('auth:sanctum')->group(function () {
        Route::put('/profile', [ProfileController::class, 'updateProfile']);
        Route::put('/profile/password', [ProfileController::class, 'updatePassword']);
    });
    ```

- [x] Task 2 : Backend — Request validation classes (AC: #1, #2)
  - [x] 2.1 Créer `app/Http/Requests/UpdateProfileRequest.php` :
    - Rules : name, email avec unique exception pour l'utilisateur courant
    - Messages FR personnalisés
  - [x] 2.2 Créer `app/Http/Requests/UpdatePasswordRequest.php` :
    - Rules : current_password, password, password_confirmation
    - Messages FR personnalisés
    - Validation custom pour vérifier current_password
  - [x] 2.3 Utiliser ces Request classes dans ProfileController

- [x] Task 3 : Backend — UserResource pour réponses API (AC: #1)
  - [x] 3.1 Créer `app/Http/Resources/UserResource.php` :
    - Transformer le modèle User en JSON : id, name, email, created_at
    - Exclure les champs sensibles (password, tokens)
  - [x] 3.2 Utiliser `UserResource` dans AuthController et ProfileController pour standardiser les réponses

- [x] Task 4 : Flutter — Profile remote source (AC: #1, #2)
  - [x] 4.1 Créer `lib/features/profile/data/profile_remote_source.dart` :
    - `Future<UserModel> updateProfile({String? name, String? email})` :
      - `PUT /profile` avec body JSON
      - Parser la réponse
      - Retourner UserModel mis à jour
    - `Future<void> updatePassword({required String currentPassword, required String newPassword, required String confirmPassword})` :
      - `PUT /profile/password` avec body JSON
      - Gérer les erreurs 422 (current_password incorrect)
      - Retourner void si succès, throw exception si échec

- [x] Task 5 : Flutter — ProfileRepository (AC: #1, #2)
  - [x] 5.1 Créer `lib/features/profile/data/profile_repository.dart` :
    - Dépendances : `ProfileRemoteSource`, `AuthRepository` (pour mettre à jour le user local)
    - `Future<UserModel> updateProfile({String? name, String? email})` :
      - Appeler remote source
      - Mettre à jour le user dans AuthCubit via callback ou event bus
      - Retourner UserModel mis à jour
    - `Future<void> updatePassword({required String currentPassword, required String newPassword, required String confirmPassword})` :
      - Valider côté client que newPassword == confirmPassword
      - Appeler remote source
      - Gérer les erreurs (current_password incorrect, validation)

- [x] Task 6 : Flutter — ProfileCubit et states (AC: #1, #2)
  - [x] 6.1 Créer `lib/features/profile/presentation/cubit/profile_state.dart` :
    - `ProfileInitial`, `ProfileLoading`, `ProfileUpdated(UserModel user)`, `ProfileError(String message)`
  - [x] 6.2 Créer `lib/features/profile/presentation/cubit/profile_cubit.dart` :
    - Dépendances : `ProfileRepository`, `AuthCubit` (pour mettre à jour l'état auth)
    - `Future<void> updateProfile({String? name, String? email})` :
      - Émettre `ProfileLoading`
      - Appeler repository
      - Émettre `ProfileUpdated` en cas de succès
      - Mettre à jour `AuthCubit` avec le nouveau user
      - Émettre `ProfileError` en cas d'échec
    - `Future<void> updatePassword({required String currentPassword, required String newPassword, required String confirmPassword})` :
      - Émettre `ProfileLoading`
      - Appeler repository
      - Émettre `ProfileUpdated` en cas de succès (avec user actuel non modifié)
      - Émettre `ProfileError` en cas d'échec (message spécifique si current_password incorrect)

- [x] Task 7 : Flutter — Page de profil avec M3 Design System (AC: #1, #2)
  - [x] 7.1 Créer `lib/features/profile/presentation/pages/profile_page.dart` :
    - Afficher les informations actuelles de l'utilisateur (nom, email)
    - Section "Modifier le profil" :
      - **M3 OutlinedTextField** avec labels fixes au-dessus, border-radius 12px
      - Champs : name, email (pré-remplis avec valeurs actuelles)
      - **1 seul FilledButton** "Enregistrer" par section
      - BlocListener : écoute ProfileCubit
      - **Skeleton screen** pendant `ProfileLoading`
      - **SnackBar M3** succès si `ProfileUpdated` (4s, vert, icône check)
      - **SnackBar M3** erreur si `ProfileError` (4s, rouge, action "Réessayer")
    - Section "Modifier le mot de passe" :
      - **M3 OutlinedTextField** avec labels fixes, border-radius 12px, obscured
      - Champs : current_password, new_password, confirm_password
      - **OutlinedButton** "Changer le mot de passe" (pas FilledButton, 1 seul Filled par écran)
      - BlocListener : écoute ProfileCubit
      - **SnackBar M3** feedback succès/erreur
    - **Auto-save** optionnel sur les champs profil (formulaire long → save par section)
    - **Semantics** sur tous les champs et boutons (WCAG 2.1 AA)
    - Touch targets ≥ 48×48dp
    - Couleurs depuis `Theme.of(context).colorScheme` (pas de valeurs en dur)
    - Icônes **Material Symbols Rounded** : `person`, `email`, `lock`, `visibility`/`visibility_off`
  - [x] 7.2 Créer `lib/features/profile/presentation/widgets/profile_form.dart` :
    - Réutiliser `auth_text_field.dart` de Story 1.1 (M3 OutlinedTextField avec label fixe)
  - [x] 7.3 Créer `lib/features/profile/presentation/widgets/password_form.dart` :
    - Réutiliser `auth_text_field.dart`, obscureText, suffixIcon visibility toggle

- [x] Task 8 : Flutter — Routing et navigation (AC: #1, #2)
  - [x] 8.1 Ajouter route `/profile` dans `lib/app/routes.dart` :
    - Route protégée dans le ShellRoute (AdaptiveScaffold)
    - Navigation : depuis l'icône profil dans NavigationBar/Rail ou AppBar
  - [x] 8.2 Ajouter accès profil depuis le **NavigationBar/Rail** ou **AppBar** action icon

- [x] Task 9 : Flutter — Mise à jour de AuthCubit après modification profil (AC: #1)
  - [x] 9.1 Ajouter méthode `updateUser(UserModel user)` dans `AuthCubit` :
    - Mettre à jour le state `AuthAuthenticated` avec le nouveau user
    - Notifier les listeners pour rafraîchir l'UI
  - [x] 9.2 Appeler cette méthode depuis `ProfileCubit.updateProfile()` après succès

- [x] Task 10 : Tests backend (AC: #1, #2)
  - [x] 10.1 Créer `tests/Feature/Profile/UpdateProfileTest.php` :
    - Test update profile successful : PUT `/api/profile` avec token valide + données valides → 200 + user mis à jour
    - Test update profile validation errors : email invalide → 422
    - Test update profile duplicate email (autre utilisateur) → 422
    - Test update profile unauthenticated → 401
  - [x] 10.2 Créer `tests/Feature/Profile/UpdatePasswordTest.php` :
    - Test update password successful : PUT `/api/profile/password` avec current_password correct → 200
    - Test update password incorrect current_password → 422
    - Test update password validation errors : password trop court → 422
    - Test update password confirmation mismatch → 422
    - Test update password unauthenticated → 401

- [x] Task 11 : Tests Flutter (AC: #1, #2)
  - [x] 11.1 Créer `test/features/profile/data/profile_repository_test.dart` :
    - Mock `ProfileRemoteSource`
    - Test updateProfile successful
    - Test updateProfile failure
    - Test updatePassword successful
    - Test updatePassword incorrect current_password
  - [x] 11.2 Créer `test/features/profile/presentation/cubit/profile_cubit_test.dart` :
    - Mock `ProfileRepository` et `AuthCubit`
    - Test updateProfile successful → `ProfileUpdated` + AuthCubit.updateUser appelé
    - Test updateProfile failure → `ProfileError`
    - Test updatePassword successful → `ProfileUpdated`
    - Test updatePassword failure → `ProfileError`
  - [x] 11.3 Créer `test/features/profile/presentation/pages/profile_page_test.dart` :
    - Test affichage formulaires
    - Test soumission formulaire profil avec champs valides
    - Test soumission formulaire password avec champs valides
    - Test affichage erreurs validation

- [x] Task 12 : Validation finale (AC: #1, #2)
  - [x] 12.1 Vérifier le flow complet de modification profil : formulaire → API → mise à jour → refresh UI
  - [x] 12.2 Vérifier le flow complet de modification mot de passe : formulaire → validation current_password → mise à jour
  - [x] 12.3 Vérifier les erreurs : ancien mot de passe incorrect, email déjà utilisé, validation
  - [x] 12.4 Vérifier que l'UI reflète immédiatement les changements après modification profil
  - [x] 12.5 Exécuter tous les tests : `cd backend-api && ./vendor/bin/sail artisan test`
  - [x] 12.6 Exécuter tous les tests Flutter : `cd mobile-app && flutter test`
  - [x] 12.7 Commit : `git add . && git commit -m "feat(profile): gestion du profil utilisateur avec modification nom/email/password"`

## Dev Notes

### Architecture & Contraintes

- **Dépendance** : Cette story dépend de Story 1.1 (authentification et AuthCubit) [Source: epics.md#Story 1.2]
- **Repository pattern** : Utilisation obligatoire pour accès données [Source: architecture.md#Enforcement Guidelines]
- **API format** : Réponses standardisées JSON [Source: architecture.md#API & Communication Patterns]
- **Password hashing** : bcrypt (défaut Laravel) [Source: epics.md#NFR8]
- **Validation** : Côté serveur (Request classes) et côté client (formulaires Flutter) [Source: architecture.md#Implementation Patterns & Consistency Rules]

### Conventions de nommage

- **Routes API** : `PUT /api/profile`, `PUT /api/profile/password` [Source: architecture.md#Naming Patterns]
- **Controller** : `ProfileController` dans `app/Http/Controllers/Api/` [Source: architecture.md#Structure Patterns]
- **Request classes** : `UpdateProfileRequest`, `UpdatePasswordRequest` dans `app/Http/Requests/` [Source: architecture.md#Structure Patterns]
- **Resource** : `UserResource` dans `app/Http/Resources/` pour transformer le modèle User en JSON [Source: architecture.md#Structure Patterns]
- **Cubit** : `ProfileCubit` dans `lib/features/profile/presentation/cubit/` [Source: architecture.md#Structure Patterns]
- **States** : `ProfileInitial`, `ProfileLoading`, `ProfileUpdated`, `ProfileError` [Source: architecture.md#Communication Patterns]

### Validation unique email avec exception

Dans `UpdateProfileRequest`, règle de validation email avec exclusion de l'utilisateur courant :

```php
'email' => ['sometimes', 'string', 'email', Rule::unique('users')->ignore($this->user()->id)],
```

Cela permet à l'utilisateur de garder son email actuel sans erreur "email déjà utilisé".

### Vérification ancien mot de passe

Dans `ProfileController.updatePassword()` :

```php
if (!Hash::check($request->current_password, $request->user()->password)) {
    return response()->json([
        'message' => 'Le mot de passe actuel est incorrect.',
        'errors' => [
            'current_password' => ['Le mot de passe actuel est incorrect.']
        ]
    ], 422);
}
```

Côté Flutter, gérer cette erreur 422 spécifiquement pour afficher un message approprié.

### Mise à jour AuthCubit après modification profil

Après modification réussie du profil, `ProfileCubit` doit mettre à jour `AuthCubit` pour que l'UI globale (par exemple nom affiché dans HomePage) soit rafraîchie automatiquement. Deux approches possibles :

1. **Injection AuthCubit dans ProfileCubit** (recommandé) :
   ```dart
   await authCubit.updateUser(updatedUser);
   ```

2. **Event bus ou callback** : si couplage direct non souhaité

Cette story utilise l'approche 1 pour simplicité.

### Project Structure Notes

Structure cible après cette story :

```
backend-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── AuthController.php
│   │   │       └── ProfileController.php
│   │   ├── Requests/
│   │   │   ├── RegisterRequest.php
│   │   │   ├── LoginRequest.php
│   │   │   ├── UpdateProfileRequest.php
│   │   │   └── UpdatePasswordRequest.php
│   │   └── Resources/
│   │       └── UserResource.php
│   └── Models/
│       └── User.php
├── routes/
│   └── api.php
└── tests/
    └── Feature/
        ├── Auth/
        └── Profile/
            ├── UpdateProfileTest.php
            └── UpdatePasswordTest.php

mobile-app/
├── lib/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   └── presentation/
│   │   │       └── cubit/
│   │   │           ├── auth_cubit.dart      # + méthode updateUser()
│   │   │           └── auth_state.dart
│   │   └── profile/
│   │       ├── data/
│   │       │   ├── profile_remote_source.dart
│   │       │   └── profile_repository.dart
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── profile_cubit.dart
│   │           │   └── profile_state.dart
│   │           ├── pages/
│   │           │   └── profile_page.dart
│   │           └── widgets/
│   │               ├── profile_form.dart
│   │               └── password_form.dart
│   └── app/
│       └── routes.dart
└── test/
    └── features/
        ├── auth/
        └── profile/
            ├── data/
            │   └── profile_repository_test.dart
            └── presentation/
                ├── cubit/
                │   └── profile_cubit_test.dart
                └── pages/
                    └── profile_page_test.dart
```

### References

- [Source: architecture.md#API & Communication Patterns] — Format JSON, erreurs standardisées
- [Source: architecture.md#Frontend Architecture] — Bloc/Cubit, Repository pattern
- [Source: architecture.md#Naming Patterns] — Conventions routes, classes, fichiers
- [Source: architecture.md#Structure Patterns] — Organisation folders Flutter et Laravel
- [Source: architecture.md#Enforcement Guidelines] — Repository pattern obligatoire
- [Source: epics.md#Story 1.2] — Acceptance criteria BDD, dépendance Story 1.1
- [Source: epics.md#NFR8] — Mots de passe hashés (bcrypt)

## Dev Agent Record

### Agent Model Used

Claude Opus 4.5 (claude-opus-4-5-20251101)

### Debug Log References

- Zero lint issues (`flutter analyze`)
- 49/49 tests passing (`flutter test`)

### Completion Notes List

- UX design system integration only (Tasks 1-6, 9-11 already implemented in prior session)
- Task 7: ProfilePage M3 SnackBars (theme colors, icons, action), ProfileForm FilledButton + icons + Semantics + MdbTokens, PasswordForm OutlinedButton + visibility toggles + icons + Semantics + MdbTokens
- Task 8: Already integrated via AdaptiveScaffold shell routes from Story 1.1

### File List

- `mobile-app/lib/features/profile/presentation/pages/profile_page.dart` — M3 SnackBars, MdbTokens, Semantics
- `mobile-app/lib/features/profile/presentation/widgets/profile_form.dart` — FilledButton, prefixIcons, Semantics, MdbTokens
- `mobile-app/lib/features/profile/presentation/widgets/password_form.dart` — OutlinedButton, visibility toggles, prefixIcons, Semantics, MdbTokens
