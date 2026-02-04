<?php

declare(strict_types=1);

namespace App\Services\Scraping\Scrapers;

use App\Services\Scraping\ScrapingResult;

class PapScraper implements ScraperInterface
{
    private const SOURCE = 'pap';

    public function supports(string $url): bool
    {
        return str_contains($url, 'pap.fr');
    }

    public function scrape(string $url): ScrapingResult
    {
        return new ScrapingResult(
            status: ScrapingResult::STATUS_NOT_IMPLEMENTED,
            url: $url,
            source: self::SOURCE,
            errorMessage: 'PAP scraper is not implemented yet',
        );
    }
}
