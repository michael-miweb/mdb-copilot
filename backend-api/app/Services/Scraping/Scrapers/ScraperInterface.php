<?php

declare(strict_types=1);

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
