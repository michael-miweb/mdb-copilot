# Story 12.1 : Génération de lien public pour artisan

Status: ready-for-dev

## Story

As a utilisateur,
I want générer un lien public vers une fiche projet pour un artisan,
So that l'artisan consulte les informations du bien et soumet un devis sans créer de compte.

## Acceptance Criteria

1. **Given** une fiche annonce
   **When** l'utilisateur génère un lien de partage public
   **Then** un token unique signé est créé avec durée limitée
   **And** le lien est copiable et partageable
   **And** le lien est révocable à tout moment par l'utilisateur

2. **Given** un artisan avec le lien de partage
   **When** il ouvre le lien
   **Then** il voit les informations du bien : photos organisées par zone, description des travaux, contraintes chantier
   **And** les données financières du MDB (prix achat, marge, scoring) sont masquées

3. **Given** la vue artisan
   **When** l'artisan soumet une fourchette estimative de devis
   **Then** l'estimation est enregistrée et visible par l'utilisateur owner
   **And** l'artisan n'a pas accès aux autres fiches ou au pipeline

## Tasks / Subtasks

- [ ] Task 1 : Créer le modèle `ShareToken` backend (AC: #1)
  - [ ] 1.1 Créer migration `create_share_tokens_table`
  - [ ] 1.2 Colonnes : id, property_id, user_id, token (unique), expires_at, revoked_at, created_at
  - [ ] 1.3 Créer modèle `ShareToken` dans `app/Models/ShareToken.php`
  - [ ] 1.4 Relations : `belongsTo(Property)`, `belongsTo(User)`
  - [ ] 1.5 Scope `active()` pour tokens non révoqués et non expirés

- [ ] Task 2 : Créer `ShareService` backend (AC: #1)
  - [ ] 2.1 Créer `ShareService` dans `app/Services/ShareService.php`
  - [ ] 2.2 Méthode `generateShareToken(propertyId, userId, expiresInDays = 30)`
  - [ ] 2.3 Générer token unique (hash SHA256 UUID v4)
  - [ ] 2.4 Sauvegarder dans `share_tokens` avec expiration
  - [ ] 2.5 Retourner URL complète : `{APP_URL}/share/{token}`
  - [ ] 2.6 Méthode `revokeToken(tokenId)` marque `revoked_at`

- [ ] Task 3 : Créer endpoint génération lien (AC: #1)
  - [ ] 3.1 Créer `ShareController` dans `app/Http/Controllers/Api/ShareController.php`
  - [ ] 3.2 Route POST `/api/properties/{property}/share` (auth:sanctum, ability:owner)
  - [ ] 3.3 Méthode `generateLink(Property $property)` appelle ShareService
  - [ ] 3.4 Retourner JSON : `{ "url": "...", "token_id": "...", "expires_at": "..." }`
  - [ ] 3.5 Route DELETE `/api/share-tokens/{token}` révoque le lien

- [ ] Task 4 : Créer endpoint consultation public (AC: #2)
  - [ ] 4.1 Route GET `/api/share/{token}` (pas d'auth, accès public)
  - [ ] 4.2 Vérifier token valide (exists, not revoked, not expired)
  - [ ] 4.3 Charger property avec photos et notes travaux
  - [ ] 4.4 Créer `PublicPropertyResource` qui masque données sensibles
  - [ ] 4.5 Masquer : purchase_price, sale_price, margin, score, agent info
  - [ ] 4.6 Retourner : address, photos (groupées par zone), work_description, constraints
  - [ ] 4.7 Retourner 404 si token invalide

- [ ] Task 5 : Créer endpoint soumission devis artisan (AC: #3)
  - [ ] 5.1 Route POST `/api/share/{token}/quote`
  - [ ] 5.2 Validation : artisan_name, artisan_email, estimate_min (centimes), estimate_max (centimes), notes
  - [ ] 5.3 Créer modèle `ArtisanQuote` (property_id, share_token_id, artisan_name, estimate_min, estimate_max, notes, created_at)
  - [ ] 5.4 Sauvegarder en DB liée à property
  - [ ] 5.5 Retourner confirmation JSON : `{ "message": "Devis soumis avec succès" }`
  - [ ] 5.6 Envoyer email notification au owner (optionnel)

- [ ] Task 6 : Créer UI Flutter génération lien (AC: #1)
  - [ ] 6.1 Ajouter bouton "Partager avec artisan" dans détail property
  - [ ] 6.2 Appeler `POST /api/properties/{id}/share`
  - [ ] 6.3 Afficher dialog avec URL copiable (Clipboard)
  - [ ] 6.4 Afficher liste des liens actifs pour cette property
  - [ ] 6.5 Permettre révocation : appeler `DELETE /api/share-tokens/{token}`

- [ ] Task 7 : Créer UI web consultation artisan (AC: #2, #3)
  - [ ] 7.1 Créer page Flutter web `/share/{token}` (route publique)
  - [ ] 7.2 Charger données via `GET /api/share/{token}`
  - [ ] 7.3 Afficher photos groupées par zone (extérieur, cuisine, salle de bain, etc.)
  - [ ] 7.4 Afficher description travaux et contraintes
  - [ ] 7.5 Formulaire soumission devis : nom artisan, email, fourchette estimative (min/max), notes
  - [ ] 7.6 Submit → `POST /api/share/{token}/quote`
  - [ ] 7.7 Afficher confirmation après soumission

- [ ] Task 8 : Créer UI consultation devis owner (AC: #3)
  - [ ] 8.1 Dans détail property, section "Devis artisans"
  - [ ] 8.2 Afficher liste des devis soumis via liens de partage
  - [ ] 8.3 Pour chaque devis : nom artisan, email, fourchette, notes, date soumission
  - [ ] 8.4 Permettre contact direct artisan (copier email)

- [ ] Task 9 : Tests et validation (AC: #1, #2, #3)
  - [ ] 9.1 Tester génération token unique et expiration
  - [ ] 9.2 Tester révocation token (accès refusé après révocation)
  - [ ] 9.3 Tester expiration token (accès refusé après expiration)
  - [ ] 9.4 Tester masquage données sensibles dans PublicPropertyResource
  - [ ] 9.5 Tester soumission devis artisan
  - [ ] 9.6 Tester consultation devis par owner
  - [ ] 9.7 Tester sécurité : artisan ne peut pas accéder à d'autres properties

## Dev Notes

### Architecture & Contraintes

- **Token signé** : Hash SHA256 d'un UUID v4, stocké en DB avec expiration [Source: architecture.md#Authentication & Security]
- **Accès public** : Route `/api/share/{token}` sans middleware `auth:sanctum` [Source: architecture.md#Auth Boundary]
- **Masquage données sensibles** : API Resource dédié `PublicPropertyResource` [Source: architecture.md#API & Communication Patterns]
- **Révocation** : Colonne `revoked_at` dans `share_tokens`, soft delete pattern [Source: architecture.md#Data Architecture]

### Génération token sécurisé

```php
use Illuminate\Support\Str;

$token = hash('sha256', Str::uuid());
```

### Durée de validité

- Par défaut : 30 jours
- Configurable par l'utilisateur (7, 14, 30, 60 jours)
- Stockée dans `expires_at` (timestamp)

### Versions techniques confirmées

- **Laravel** : 12.x
- **Flutter** : 3.38.x (web enabled pour consultation artisan)
- **Aucun package externe** pour génération token (native Laravel)

### Structure cible

**Laravel :**

```
app/Models/
├── ShareToken.php
└── ArtisanQuote.php

app/Services/
└── ShareService.php

app/Http/Controllers/Api/
└── ShareController.php

app/Http/Resources/
└── PublicPropertyResource.php

database/migrations/
├── xxxx_create_share_tokens_table.php
└── xxxx_create_artisan_quotes_table.php

routes/api.php (ajouter routes share)
```

**Flutter :**

```
lib/features/sharing/
├── data/
│   ├── models/
│   │   ├── share_token.dart
│   │   └── artisan_quote.dart
│   ├── repositories/
│   │   └── share_repository.dart
│   └── remote_sources/
│       └── share_remote_source.dart
└── presentation/
    ├── cubit/
    │   ├── share_cubit.dart
    │   └── share_state.dart
    ├── pages/
    │   └── public_property_page.dart (web only)
    └── widgets/
        ├── share_link_dialog.dart
        ├── artisan_quote_form.dart
        └── artisan_quote_list.dart
```

### Project Structure Notes

Cette story ajoute un système de partage public sécurisé. La consultation artisan peut être faite via Flutter web ou via un lien externe (browser classique).

- Dépend de Story 1.3 (RBAC) pour vérifier ability `owner` sur génération lien
- Les devis artisans sont stockés en DB et consultables par l'owner
- Pas de compte artisan nécessaire (accès via token uniquement)

### References

- [Source: epics.md#Story 12.1] — Acceptance criteria BDD
- [Source: architecture.md#Authentication & Security] — Token signé, révocable
- [Source: architecture.md#Auth Boundary] — Accès public `/api/share/{token}`
- [Source: architecture.md#API & Communication Patterns] — API Resource pour masquage
- [Source: architecture.md#Project Structure & Boundaries] — Sharing feature

## Dev Agent Record

### Agent Model Used

_À compléter par le dev agent_

### Debug Log References

### Completion Notes List

### File List
