<?php

declare(strict_types=1);

namespace App\Services\Scraping\Scrapers;

use App\Services\Scraping\ScrapingResult;

class LogicImmoScraper implements ScraperInterface
{
    private const SOURCE = 'logic-immo';

    public function supports(string $url): bool
    {
        return str_contains($url, 'logic-immo.com');
    }

    public function scrape(string $url): ScrapingResult
    {
        return new ScrapingResult(
            status: ScrapingResult::STATUS_NOT_IMPLEMENTED,
            url: $url,
            source: self::SOURCE,
            errorMessage: 'Logic-Immo scraper is not implemented yet',
        );
    }
}
