# Story 2.3: Creation fiche annonce - Import via lien

Status: ready-for-dev

## Story

As a utilisateur,
I want creer une fiche annonce en collant un lien (LeBonCoin, SeLoger, PAP, Logic-Immo),
so that je gagne du temps en evitant la saisie manuelle.

## Acceptance Criteria

**Given** un utilisateur sur l'ecran de creation de fiche
**When** il colle un lien d'annonce LeBonCoin
**Then** le systeme detecte le site source et affiche "Analyse en cours..."
**And** l'API backend `/api/scrape` est appelee avec l'URL
**And** les donnees extraites (adresse, surface, prix, type, photos, description) pre-remplissent le formulaire

**Given** un lien SeLoger, PAP ou Logic-Immo
**When** l'utilisateur colle le lien
**Then** le scraper correspondant est utilise
**And** les donnees disponibles sont extraites

**Given** une extraction reussie complete
**When** les donnees sont retournees
**Then** le formulaire est pre-rempli entierement
**And** l'utilisateur peut modifier les champs avant validation
**And** les photos sont affichees en miniature
**And** l'utilisateur peut associer un agent (comme dans Story 2.2)

## Tasks / Subtasks

### Backend (Laravel)
- [ ] Verifier endpoint `POST /api/scrape` existe (Epic 0.7)
- [ ] Retourner ScrapingResult DTO avec: title, address, price, surface, property_type, description, photos[], source
- [ ] Gerer timeout (max 30s)
- [ ] Logger les echecs pour monitoring

### Mobile (Flutter)
- [ ] Creer `LinkImportInput` widget (champ saisie lien avec validation URL)
- [ ] Detecter site source via regex (leboncoin.fr, seloger.com, pap.fr, logic-immo.com)
- [ ] Afficher indicateur "Analyse en cours..." pendant appel API
- [ ] Mapper ScrapingResult vers formulaire property
- [ ] Pre-remplir tous les champs disponibles
- [ ] Marquer visuellement les champs pre-remplis
- [ ] Afficher miniatures photos extraites
- [ ] Stocker source_url dans la property

### UX
- [ ] Auto-focus sur champ lien a l'ouverture
- [ ] Detection auto du contenu clipboard (optionnel)
- [ ] Animation transition analyse -> formulaire

### Tests
- [ ] Test unitaire backend: scraping LeBonCoin (avec fixture HTML)
- [ ] Test widget Flutter: LinkImportInput validation
- [ ] Test widget Flutter: mapping scraping result
- [ ] Test integration: flow complet lien -> formulaire

## Dev Notes

### Architecture Reference
- Scraping uniquement cote backend (evite CORS, gere changements structure)
- ScrapingService avec interface ScraperInterface
- Scrapers: LeBonCoinScraper, SeLogerScraper, PapScraper, LogicImmoScraper

### API Contract
```json
POST /api/scrape
Headers: Authorization: Bearer {token}
Request:
{
  "url": "https://www.leboncoin.fr/ventes_immobilieres/..."
}

Response 200 (success):
{
  "success": true,
  "source": "leboncoin",
  "data": {
    "title": "string",
    "address": "string",
    "price_cents": 25000000,
    "surface_m2": 75.5,
    "property_type": "appartement",
    "description": "string",
    "photos": [
      "https://img.leboncoin.fr/...",
      "https://img.leboncoin.fr/..."
    ]
  }
}

Response 200 (partial):
{
  "success": true,
  "partial": true,
  "source": "leboncoin",
  "data": {
    "title": "string",
    "address": null,
    "price_cents": 25000000,
    ...
  },
  "missing_fields": ["address", "surface_m2"]
}
```

### Supported Sites Regex
```dart
final sitePatterns = {
  'leboncoin': RegExp(r'leboncoin\.fr'),
  'seloger': RegExp(r'seloger\.com'),
  'pap': RegExp(r'pap\.fr'),
  'logic-immo': RegExp(r'logic-immo\.com'),
};
```

### References
- [Source: epics.md#Story 2.3]
- [Source: epics.md#Story 0.7 - Service scraping backend]
- [Source: prd.md#FR13, FR14]
- [Source: architecture.md#AR25-AR28 Scraping Service]

## Dev Agent Record

### Agent Model Used
{{agent_model_name_version}}

### Completion Notes List

### File List
