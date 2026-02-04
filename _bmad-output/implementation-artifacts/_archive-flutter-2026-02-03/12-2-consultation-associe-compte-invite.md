# Story 12.2 : Consultation associé via compte invité

Status: ready-for-dev

## Story

As a associé potentiel,
I want consulter le pipeline et les fiches via un compte invité,
So that j'évalue l'activité MDB avant de m'engager.

## Acceptance Criteria

1. **Given** un utilisateur invité avec rôle `guest-extended`
   **When** il se connecte à l'application
   **Then** il voit le pipeline Kanban avec les projets en cours
   **And** il peut consulter les fiches annonces (selon les permissions de son rôle)
   **And** il ne voit pas les données de négociation sensibles définies par l'owner

2. **Given** un utilisateur invité avec rôle `guest-read`
   **When** il se connecte
   **Then** il a un accès en lecture seule au pipeline et aux fiches
   **And** il ne peut modifier aucune donnée

## Tasks / Subtasks

- [ ] Task 1 : Vérifier RBAC existant (dépendance Story 1.3) (AC: #1, #2)
  - [ ] 1.1 Vérifier token abilities implémentées : `owner`, `guest-read`, `guest-extended`
  - [ ] 1.2 Vérifier middleware `EnsureTokenAbility` fonctionnel
  - [ ] 1.3 Vérifier routes API protégées par abilities
  - [ ] 1.4 Si Story 1.3 non complète, bloquer cette story

- [ ] Task 2 : Créer `PropertyResource` avec filtrage conditionnel (AC: #1)
  - [ ] 2.1 Modifier `PropertyResource` pour accepter paramètre `$userAbilities`
  - [ ] 2.2 Si ability `guest-extended` : masquer négociation sensible (prix achat, marge cible, notes privées)
  - [ ] 2.3 Si ability `guest-read` : masquer toutes données financières + notes privées
  - [ ] 2.4 Si ability `owner` : retourner toutes les données
  - [ ] 2.5 Champs toujours visibles : address, type, surface, photos, description travaux

- [ ] Task 3 : Implémenter filtrage backend properties (AC: #1, #2)
  - [ ] 3.1 Modifier `PropertyController@index` pour vérifier token abilities
  - [ ] 3.2 Si `guest-extended` : retourner toutes properties avec données filtrées
  - [ ] 3.3 Si `guest-read` : retourner toutes properties avec données filtrées (lecture seule)
  - [ ] 3.4 Si `owner` : retourner toutes properties sans filtre
  - [ ] 3.5 Utiliser `PropertyResource` avec filtrage conditionnel

- [ ] Task 4 : Implémenter filtrage backend pipeline (AC: #1, #2)
  - [ ] 4.1 Modifier `PipelineController@index` pour vérifier token abilities
  - [ ] 4.2 Retourner pipeline Kanban avec properties filtrées selon ability
  - [ ] 4.3 `guest-read` et `guest-extended` voient le pipeline complet
  - [ ] 4.4 Données financières masquées selon niveau ability

- [ ] Task 5 : Bloquer modifications pour guest-read (AC: #2)
  - [ ] 5.1 Routes POST/PUT/DELETE sur properties vérifier ability `owner` ou `guest-extended`
  - [ ] 5.2 Retourner 403 Forbidden si `guest-read` tente modification
  - [ ] 5.3 Routes déplacement pipeline vérifier ability `owner` ou `guest-extended`
  - [ ] 5.4 Message erreur clair : "Votre rôle ne permet pas de modifier les données"

- [ ] Task 6 : Implémenter UI Flutter avec permissions (AC: #1, #2)
  - [ ] 6.1 Récupérer abilities du token depuis AuthCubit
  - [ ] 6.2 Stocker abilities dans app state global (ou AuthState)
  - [ ] 6.3 Conditionner affichage boutons modification selon abilities
  - [ ] 6.4 Si `guest-read` : cacher tous boutons edit/delete/create
  - [ ] 6.5 Si `guest-extended` : afficher boutons selon permissions définies
  - [ ] 6.6 Afficher badge "Invité" dans UI pour clarifier le rôle

- [ ] Task 7 : Masquer données sensibles côté Flutter (AC: #1)
  - [ ] 7.1 Créer widget `SensitiveDataField` qui masque données si non owner
  - [ ] 7.2 Utiliser `SensitiveDataField` pour prix achat, marge, notes privées
  - [ ] 7.3 Afficher placeholder "Non disponible (accès restreint)" si guest
  - [ ] 7.4 Vérifier cohérence filtrage backend + UI (double protection)

- [ ] Task 8 : Tester scénarios multi-rôles (AC: #1, #2)
  - [ ] 8.1 Créer user owner via endpoint register
  - [ ] 8.2 Créer invitation guest-read et guest-extended via endpoint invite
  - [ ] 8.3 Login en tant que guest-read → vérifier lecture seule
  - [ ] 8.4 Login en tant que guest-extended → vérifier accès étendu
  - [ ] 8.5 Vérifier masquage données sensibles dans responses API
  - [ ] 8.6 Vérifier UI affiche/cache boutons selon rôle
  - [ ] 8.7 Tester tentative modification en guest-read → 403 attendu

- [ ] Task 9 : Documentation permissions (AC: #1, #2)
  - [ ] 9.1 Documenter matrice permissions dans CLAUDE.md
  - [ ] 9.2 Tableau : Ability × Ressource × Action (read/write/delete)
  - [ ] 9.3 Documenter champs masqués par niveau ability
  - [ ] 9.4 Documenter routes protégées par ability

## Dev Notes

### Architecture & Contraintes

- **Dépendance Story 1.3** : Cette story nécessite RBAC complet (token abilities, middleware) [Source: epics.md#Story 1.3]
- **Token abilities Sanctum** : `owner`, `guest-read`, `guest-extended` [Source: architecture.md#Authentication & Security]
- **Filtrage double** : Backend (API Resource) + Frontend (UI conditionnelle) pour sécurité [Source: architecture.md#API & Communication Patterns]
- **Lecture seule** : `guest-read` ne peut modifier aucune donnée [Source: epics.md#FR4]

### Matrice permissions

| Ability | Consulter pipeline | Consulter fiches | Modifier fiches | Voir prix achat | Voir marge |
|---------|-------------------|------------------|----------------|----------------|-----------|
| **owner** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **guest-extended** | ✅ | ✅ | ⚠️ Partiel | ❌ | ❌ |
| **guest-read** | ✅ | ✅ | ❌ | ❌ | ❌ |

### Champs masqués par ability

**guest-extended :**
- Masqué : `purchase_price`, `target_margin`, `private_notes`, `agent_negotiation_notes`
- Visible : `address`, `surface`, `property_type`, `photos`, `work_description`, `sale_urgency`, `public_notes`

**guest-read :**
- Masqué : tous les champs financiers + notes privées
- Visible : `address`, `surface`, `property_type`, `photos` (limité), `work_description`

### Vérification token abilities Laravel

```php
// Dans controller
if (!$request->user()->tokenCan('owner')) {
    return response()->json(['message' => 'Forbidden'], 403);
}

// Dans middleware
Route::middleware(['auth:sanctum', 'ability:owner'])->group(function () {
    // Routes owner only
});
```

### Versions techniques confirmées

- **Laravel Sanctum** : 4.x (abilities natif)
- **Flutter** : 3.38.x
- **Bloc** : 8.x

### Structure cible

**Laravel :**

```
app/Http/Resources/
└── PropertyResource.php (modifier pour filtrage conditionnel)

app/Http/Middleware/
└── EnsureTokenAbility.php (déjà créé Story 1.3)

app/Http/Controllers/Api/
├── PropertyController.php (modifier index/show)
└── PipelineController.php (modifier index)
```

**Flutter :**

```
lib/core/widgets/
└── sensitive_data_field.dart

lib/features/auth/
└── presentation/cubit/auth_state.dart (ajouter abilities)

lib/features/properties/
└── presentation/widgets/
    └── property_card.dart (conditionnement UI)

lib/features/pipeline/
└── presentation/widgets/
    └── pipeline_column.dart (conditionnement actions)
```

### Project Structure Notes

Cette story complète le système RBAC initié dans Story 1.3. Elle applique les permissions à toutes les features métier (properties, pipeline).

- Si Story 1.3 n'est pas complète, cette story est bloquée
- Le filtrage est appliqué côté backend ET frontend pour sécurité maximale
- Les abilities sont stockées dans le token Sanctum et vérifiées à chaque requête

### References

- [Source: epics.md#Story 12.2] — Acceptance criteria BDD
- [Source: epics.md#Story 1.3] — Dépendance RBAC
- [Source: architecture.md#Authentication & Security] — Token abilities
- [Source: architecture.md#API & Communication Patterns] — API Resource filtrage
- [Source: epics.md#FR4] — Accès restreint par rôle

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
