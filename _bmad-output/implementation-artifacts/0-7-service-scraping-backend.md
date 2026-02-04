# Story 0.7: Service de scraping backend

Status: done

## Story

As a développeur,
I want implémenter le service de scraping côté Laravel,
so that l'import via lien fonctionne dès Epic 2.

## Acceptance Criteria

1. **Given** le projet `backend-api/` existant
   **When** le développeur implémente le controller
   **Then** `ScrapingController` expose `POST /api/scrape` avec paramètre `url`

2. **Given** une URL d'annonce
   **When** le service analyse l'URL
   **Then** `ScrapingService` détecte le site source (LeBonCoin, SeLoger, PAP, Logic-Immo)

3. **Given** le service de scraping
   **When** l'interface est définie
   **Then** `ScraperInterface` définit le contrat commun pour tous les scrapers

4. **Given** une URL LeBonCoin
   **When** le scraper est appelé
   **Then** `LeBonCoinScraper` extrait : titre, prix, surface, adresse, description, photos

5. **Given** une URL SeLoger, PAP ou Logic-Immo
   **When** le scraper est appelé
   **Then** les scrapers retournent un stub "non implémenté" pour le MVP

6. **Given** le résultat du scraping
   **When** l'API répond
   **Then** `ScrapingResult` est un DTO typé retourné par l'API

7. **Given** le scraper LeBonCoin
   **When** les tests sont exécutés
   **Then** les tests unitaires couvrent le scraper avec des fixtures HTML

## Tasks / Subtasks

- [x] Task 1: Installer dépendances (AC: #3)
  - [x] `composer require symfony/dom-crawler symfony/css-selector guzzlehttp/guzzle`
  - [x] Vérifier installation

- [x] Task 2: Créer ScraperInterface (AC: #3)
  - [x] Créer `app/Services/Scraping/Scrapers/ScraperInterface.php`
  - [x] Définir méthode `supports(string $url): bool`
  - [x] Définir méthode `scrape(string $url): ScrapingResult`

- [x] Task 3: Créer ScrapingResult DTO (AC: #6)
  - [x] Créer `app/Services/Scraping/ScrapingResult.php`
  - [x] Propriétés : title, price, surface, address, description, photos[], source, url
  - [x] Propriété success/partial/error status
  - [x] Méthode `toArray()` pour serialization JSON

- [x] Task 4: Implémenter LeBonCoinScraper (AC: #4)
  - [x] Créer `app/Services/Scraping/Scrapers/LeBonCoinScraper.php`
  - [x] Implémenter `supports()` : regex sur leboncoin.fr
  - [x] Implémenter `scrape()` avec DomCrawler
  - [x] Extraire titre, prix, surface, adresse, description
  - [x] Extraire URLs des photos
  - [x] Gérer les cas où certains champs sont absents

- [x] Task 5: Créer stubs pour autres scrapers (AC: #5)
  - [x] Créer `SeLogerScraper.php` avec stub
  - [x] Créer `PapScraper.php` avec stub
  - [x] Créer `LogicImmoScraper.php` avec stub
  - [x] Retourner ScrapingResult avec status "not_implemented"

- [x] Task 6: Créer ScrapingService (AC: #2)
  - [x] Créer `app/Services/Scraping/ScrapingService.php`
  - [x] Injecter tous les scrapers
  - [x] Méthode `scrape(string $url)` qui délègue au bon scraper
  - [x] Retourner erreur si aucun scraper ne supporte l'URL

- [x] Task 7: Créer ScrapingController (AC: #1)
  - [x] Créer `app/Http/Controllers/Api/ScrapingController.php`
  - [x] Route `POST /api/scrape`
  - [x] Validation : url required, url format
  - [x] Retourner ScrapingResult en JSON

- [x] Task 8: Écrire tests (AC: #7)
  - [x] Créer fixtures HTML LeBonCoin dans `tests/fixtures/`
  - [x] Test unitaire LeBonCoinScraper avec fixture
  - [x] Test feature ScrapingController
  - [x] Tester cas succès, partiel, échec

## Dev Notes

### ScraperInterface

```php
<?php

namespace App\Services\Scraping\Scrapers;

use App\Services\Scraping\ScrapingResult;

interface ScraperInterface
{
    /**
     * Check if this scraper supports the given URL
     */
    public function supports(string $url): bool;

    /**
     * Scrape data from the URL
     */
    public function scrape(string $url): ScrapingResult;
}
```

### ScrapingResult DTO

```php
<?php

namespace App\Services\Scraping;

class ScrapingResult
{
    public function __construct(
        public readonly string $status, // 'success' | 'partial' | 'error' | 'not_implemented'
        public readonly ?string $title = null,
        public readonly ?int $price = null, // centimes
        public readonly ?int $surface = null, // m²
        public readonly ?string $address = null,
        public readonly ?string $description = null,
        public readonly array $photos = [],
        public readonly string $source = '',
        public readonly string $url = '',
        public readonly ?string $errorMessage = null,
    ) {}

    public function toArray(): array
    {
        return [
            'status' => $this->status,
            'title' => $this->title,
            'price' => $this->price,
            'surface' => $this->surface,
            'address' => $this->address,
            'description' => $this->description,
            'photos' => $this->photos,
            'source' => $this->source,
            'url' => $this->url,
            'error_message' => $this->errorMessage,
        ];
    }
}
```

### LeBonCoin Scraper Example

```php
<?php

namespace App\Services\Scraping\Scrapers;

use App\Services\Scraping\ScrapingResult;
use Symfony\Component\DomCrawler\Crawler;
use Illuminate\Support\Facades\Http;

class LeBonCoinScraper implements ScraperInterface
{
    public function supports(string $url): bool
    {
        return str_contains($url, 'leboncoin.fr');
    }

    public function scrape(string $url): ScrapingResult
    {
        $response = Http::withHeaders([
            'User-Agent' => 'Mozilla/5.0 ...',
        ])->get($url);

        if (!$response->successful()) {
            return new ScrapingResult(
                status: 'error',
                url: $url,
                source: 'leboncoin',
                errorMessage: 'Failed to fetch URL',
            );
        }

        $crawler = new Crawler($response->body());

        // Extract data using CSS selectors
        // ...

        return new ScrapingResult(
            status: 'success',
            title: $title,
            price: $price,
            // ...
        );
    }
}
```

### API Route

```php
// routes/api.php
Route::post('/scrape', [ScrapingController::class, 'scrape'])
    ->middleware('auth:sanctum');
```

### Project Structure

```
app/Services/Scraping/
├── ScrapingService.php
├── ScrapingResult.php
└── Scrapers/
    ├── ScraperInterface.php
    ├── LeBonCoinScraper.php
    ├── SeLogerScraper.php
    ├── PapScraper.php
    └── LogicImmoScraper.php
```

### References
- [Source: architecture.md#Scraping Service]
- [Source: architecture.md#API & Communication Patterns]
- [Source: epics.md#Story 0.7]

## Dev Agent Record

### Agent Model Used
Claude Opus 4.5 (claude-opus-4-5-20251101)

### Completion Notes List
- Service de scraping complet implémenté avec architecture extensible
- LeBonCoinScraper fonctionnel avec extraction : titre, prix, surface, adresse, description, photos
- Stubs pour SeLoger, PAP, Logic-Immo retournant "not_implemented"
- ScrapingService délègue au bon scraper selon l'URL
- ScrapingController expose POST /api/scrape avec validation
- 23 tests ajoutés (10 unit LeBonCoinScraper, 6 unit ScrapingService, 7 feature Controller)
- PHPStan niveau max, Pint formaté

### Code Review Fixes Applied
- [HIGH] Route /api/scrape restreinte au middleware abilities:owner
- [MEDIUM] Rate limiting ajouté (throttle:10,1) pour prévenir abus
- [MEDIUM] Fix double appel extractDescription dans extractSurface
- [MEDIUM] Ajout tests HTTP mock (scrape success, HTTP error, network exception)
- [LOW] Documentation des CSS selectors fragiles vs stables
- [LOW] Logging des erreurs de scraping (Log::warning, Log::error)
- [LOW] Documentation @internal sur parseHtml pour testabilité

### File List
- backend-api/composer.json (modified - added dependencies)
- backend-api/composer.lock (modified)
- backend-api/app/Services/Scraping/ScrapingResult.php (created)
- backend-api/app/Services/Scraping/ScrapingService.php (created)
- backend-api/app/Services/Scraping/Scrapers/ScraperInterface.php (created)
- backend-api/app/Services/Scraping/Scrapers/LeBonCoinScraper.php (created)
- backend-api/app/Services/Scraping/Scrapers/SeLogerScraper.php (created)
- backend-api/app/Services/Scraping/Scrapers/PapScraper.php (created)
- backend-api/app/Services/Scraping/Scrapers/LogicImmoScraper.php (created)
- backend-api/app/Http/Controllers/Api/ScrapingController.php (created)
- backend-api/routes/api.php (modified - added scrape route)
- backend-api/tests/fixtures/leboncoin/complete-listing.html (created)
- backend-api/tests/fixtures/leboncoin/partial-listing.html (created)
- backend-api/tests/fixtures/leboncoin/minimal-listing.html (created)
- backend-api/tests/Unit/Services/Scraping/LeBonCoinScraperTest.php (created)
- backend-api/tests/Unit/Services/Scraping/ScrapingServiceTest.php (created)
- backend-api/tests/Feature/Scraping/ScrapingControllerTest.php (created)
