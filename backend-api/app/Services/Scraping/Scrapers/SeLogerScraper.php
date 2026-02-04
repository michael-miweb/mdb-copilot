<?php

declare(strict_types=1);

namespace App\Services\Scraping\Scrapers;

use App\Services\Scraping\ScrapingResult;

class SeLogerScraper implements ScraperInterface
{
    private const SOURCE = 'seloger';

    public function supports(string $url): bool
    {
        return str_contains($url, 'seloger.com');
    }

    public function scrape(string $url): ScrapingResult
    {
        return new ScrapingResult(
            status: ScrapingResult::STATUS_NOT_IMPLEMENTED,
            url: $url,
            source: self::SOURCE,
            errorMessage: 'SeLoger scraper is not implemented yet',
        );
    }
}
