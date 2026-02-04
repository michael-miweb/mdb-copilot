# Story 2.4: Import via lien - Extraction partielle et fallback

Status: ready-for-dev

## Story

As a utilisateur,
I want que l'import fonctionne meme si l'extraction est partielle,
so that je ne suis pas bloque si le site source a change.

## Acceptance Criteria

**Given** un lien d'annonce dont l'extraction est partielle
**When** le scraping retourne des donnees incompletes
**Then** un message positif s'affiche : "On a trouve des infos ! Aide-nous a completer."
**And** le formulaire est pre-rempli avec les champs extraits (marques visuellement)
**And** les champs manquants sont vides avec placeholder indicatif

**Given** une extraction sans photos
**When** le formulaire s'affiche
**Then** une section "Ajouter des photos" permet l'upload depuis la galerie

**Given** un lien non supporte ou extraction totalement vide
**When** le scraping echoue
**Then** un message s'affiche : "Ce site n'est pas encore supporte, creons la fiche ensemble"
**And** le formulaire de saisie manuelle s'affiche vide

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Retourner `partial: true` si extraction incomplete
- [ ] Retourner `missing_fields[]` avec liste des champs manquants
- [ ] Retourner `success: false` si extraction totalement echouee
- [ ] Retourner message d'erreur explicite si site non supporte

### Mobile (Flutter)
- [ ] Creer `PartialImportForm` widget
- [ ] Afficher message positif pour extraction partielle
- [ ] Marquer visuellement champs pre-remplis (icone ou couleur)
- [ ] Placeholders indicatifs sur champs vides ("Ex: 12 rue de la Paix, 75001 Paris")
- [ ] Section upload photos si aucune photo extraite
- [ ] Gerer cas echec total avec message encourageant
- [ ] Transition fluide vers formulaire manuel

### UX
- [ ] Message positif meme en cas partiel (pas de ton negatif)
- [ ] Differencier visuellement champs extraits vs a completer
- [ ] Permettre modification des champs pre-remplis
- [ ] Progress indicator pendant analyse

### Photo Upload
- [ ] Widget `PhotoUploadSection`
- [ ] Acces galerie device (permission)
- [ ] Compression photo < 500KB
- [ ] Preview miniatures
- [ ] Suppression photo avant validation

### Tests
- [ ] Test unitaire backend: response partielle
- [ ] Test unitaire backend: response echec total
- [ ] Test widget Flutter: PartialImportForm avec donnees partielles
- [ ] Test widget Flutter: fallback formulaire vide
- [ ] Test widget Flutter: upload photos

## Dev Notes

### Architecture Reference
- NFR-R4: Recuperation gracieuse si scraping echoue (formulaire pre-rempli partiel)
- Photos compressees < 500KB avant upload (NFR-SC3)

### API Response Scenarios

#### Extraction complete
```json
{
  "success": true,
  "partial": false,
  "source": "leboncoin",
  "data": {
    "title": "Appartement 3 pieces",
    "address": "12 rue de la Paix, 75001 Paris",
    "price_cents": 45000000,
    "surface_m2": 65.0,
    "property_type": "appartement",
    "description": "Bel appartement...",
    "photos": ["url1", "url2", "url3"]
  }
}
```

#### Extraction partielle
```json
{
  "success": true,
  "partial": true,
  "source": "leboncoin",
  "data": {
    "title": "Appartement 3 pieces",
    "address": null,
    "price_cents": 45000000,
    "surface_m2": null,
    "property_type": "appartement",
    "description": "Bel appartement...",
    "photos": []
  },
  "missing_fields": ["address", "surface_m2", "photos"]
}
```

#### Echec total
```json
{
  "success": false,
  "error": "site_not_supported",
  "message": "Ce site n'est pas encore supporte"
}
```

### UI Messages
```dart
// Extraction partielle
"On a trouve des infos ! Aide-nous a completer les details manquants."

// Echec total
"Ce site n'est pas encore supporte, creons la fiche ensemble !"

// Site non reconnu
"On ne reconnait pas ce lien. Tu peux creer la fiche manuellement."
```

### References
- [Source: epics.md#Story 2.4]
- [Source: prd.md#FR15]
- [Source: architecture.md#AR49, AR50 - LinkImportInput, PartialImportForm]
- [Source: architecture.md#NFR-R4, NFR-SC3]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
