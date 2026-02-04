# Story 0.7: Service de scraping backend

Status: ready-for-dev

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

- [ ] Task 1: Installer dépendances (AC: #3)
  - [ ] `composer require symfony/dom-crawler symfony/css-selector guzzlehttp/guzzle`
  - [ ] Vérifier installation

- [ ] Task 2: Créer ScraperInterface (AC: #3)
  - [ ] Créer `app/Services/Scraping/Scrapers/ScraperInterface.php`
  - [ ] Définir méthode `supports(string $url): bool`
  - [ ] Définir méthode `scrape(string $url): ScrapingResult`

- [ ] Task 3: Créer ScrapingResult DTO (AC: #6)
  - [ ] Créer `app/Services/Scraping/ScrapingResult.php`
  - [ ] Propriétés : title, price, surface, address, description, photos[], source, url
  - [ ] Propriété success/partial/error status
  - [ ] Méthode `toArray()` pour serialization JSON

- [ ] Task 4: Implémenter LeBonCoinScraper (AC: #4)
  - [ ] Créer `app/Services/Scraping/Scrapers/LeBonCoinScraper.php`
  - [ ] Implémenter `supports()` : regex sur leboncoin.fr
  - [ ] Implémenter `scrape()` avec DomCrawler
  - [ ] Extraire titre, prix, surface, adresse, description
  - [ ] Extraire URLs des photos
  - [ ] Gérer les cas où certains champs sont absents

- [ ] Task 5: Créer stubs pour autres scrapers (AC: #5)
  - [ ] Créer `SeLogerScraper.php` avec stub
  - [ ] Créer `PapScraper.php` avec stub
  - [ ] Créer `LogicImmoScraper.php` avec stub
  - [ ] Retourner ScrapingResult avec status "not_implemented"

- [ ] Task 6: Créer ScrapingService (AC: #2)
  - [ ] Créer `app/Services/Scraping/ScrapingService.php`
  - [ ] Injecter tous les scrapers
  - [ ] Méthode `scrape(string $url)` qui délègue au bon scraper
  - [ ] Retourner erreur si aucun scraper ne supporte l'URL

- [ ] Task 7: Créer ScrapingController (AC: #1)
  - [ ] Créer `app/Http/Controllers/Api/ScrapingController.php`
  - [ ] Route `POST /api/scrape`
  - [ ] Validation : url required, url format
  - [ ] Retourner ScrapingResult en JSON

- [ ] Task 8: Écrire tests (AC: #7)
  - [ ] Créer fixtures HTML LeBonCoin dans `tests/fixtures/`
  - [ ] Test unitaire LeBonCoinScraper avec fixture
  - [ ] Test feature ScrapingController
  - [ ] Tester cas succès, partiel, échec

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
{{agent_model_name_version}}

### Completion Notes List

### File List
