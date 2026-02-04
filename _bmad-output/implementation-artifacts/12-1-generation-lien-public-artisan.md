# Story 12.1: Génération de lien public pour artisan

Status: ready-for-dev

## Story

As a utilisateur,
I want générer un lien public vers une fiche projet pour un artisan,
so that l'artisan consulte les informations du bien sans créer de compte.

## Acceptance Criteria

1. **Given** une fiche annonce
   **When** l'utilisateur génère un lien de partage public
   **Then** un token unique signé est créé avec durée limitée (7 jours par défaut)
   **And** le lien est copiable et partageable
   **And** le lien est révocable à tout moment par l'utilisateur

2. **Given** le lien généré
   **When** l'utilisateur configure le partage
   **Then** il peut choisir la durée de validité (1 jour, 7 jours, 30 jours)
   **And** il peut choisir les sections visibles (photos, description, travaux, contraintes)

## Tasks / Subtasks

- [ ] Task 1: Backend - Modèle ShareToken (AC: #1)
  - [ ] Créer migration pour table share_tokens
  - [ ] Colonnes: id, property_id, token, expires_at, revoked_at, visible_sections
  - [ ] Créer modèle ShareToken.php
  - [ ] Relation avec Property

- [ ] Task 2: Backend - ShareController (AC: #1, #2)
  - [ ] POST /api/properties/{id}/share - créer token
  - [ ] DELETE /api/share-tokens/{token} - révoquer
  - [ ] GET /api/share/{token} - consulter (public, pas d'auth)

- [ ] Task 3: Backend - Token signé (AC: #1)
  - [ ] Générer token unique (UUID ou hash signé)
  - [ ] Vérifier expiration sur chaque accès
  - [ ] Retourner 410 Gone si expiré

- [ ] Task 4: Frontend - UI génération lien (AC: #1, #2)
  - [ ] Bouton "Partager" sur fiche détail
  - [ ] Modal/Bottom sheet de configuration
  - [ ] Sélecteur durée (1j, 7j, 30j)
  - [ ] Checkboxes sections visibles
  - [ ] Bouton copier le lien
  - [ ] Liste des liens actifs avec option révoquer

- [ ] Task 5: Tests
  - [ ] Test création token
  - [ ] Test expiration
  - [ ] Test révocation
  - [ ] Test accès public

## Dev Notes

### API Endpoints
```
POST   /api/properties/{id}/share    # Créer un lien de partage
DELETE /api/share-tokens/{token}     # Révoquer un lien
GET    /api/share/{token}            # Accès public (pas d'auth)
```

### ShareToken Model
```php
// app/Models/ShareToken.php
class ShareToken extends Model
{
    protected $fillable = [
        'property_id',
        'token',
        'expires_at',
        'visible_sections', // JSON: ['photos', 'description', 'travaux']
    ];

    protected $casts = [
        'expires_at' => 'datetime',
        'visible_sections' => 'array',
    ];

    public function isExpired(): bool
    {
        return $this->expires_at->isPast();
    }

    public function property()
    {
        return $this->belongsTo(Property::class);
    }
}
```

### References
- [Source: epics.md#Story 12.1]
- [Source: architecture.md#Authentication & Security]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
