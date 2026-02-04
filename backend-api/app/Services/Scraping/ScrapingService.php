<?php

declare(strict_types=1);

namespace App\Services\Scraping;

use App\Services\Scraping\Scrapers\LeBonCoinScraper;
use App\Services\Scraping\Scrapers\LogicImmoScraper;
use App\Services\Scraping\Scrapers\PapScraper;
use App\Services\Scraping\Scrapers\ScraperInterface;
use App\Services\Scraping\Scrapers\SeLogerScraper;

class ScrapingService
{
    /**
     * @var array<ScraperInterface>
     */
    private array $scrapers;

    public function __construct(
        LeBonCoinScraper $leBonCoinScraper,
        SeLogerScraper $seLogerScraper,
        PapScraper $papScraper,
        LogicImmoScraper $logicImmoScraper,
    ) {
        $this->scrapers = [
            $leBonCoinScraper,
            $seLogerScraper,
            $papScraper,
            $logicImmoScraper,
        ];
    }

    /**
     * Scrape data from the given URL
     */
    public function scrape(string $url): ScrapingResult
    {
        foreach ($this->scrapers as $scraper) {
            if ($scraper->supports($url)) {
                return $scraper->scrape($url);
            }
        }

        return new ScrapingResult(
            status: ScrapingResult::STATUS_ERROR,
            url: $url,
            errorMessage: 'No scraper available for this URL. Supported sites: LeBonCoin, SeLoger, PAP, Logic-Immo',
        );
    }

    /**
     * Check if a URL is supported by any scraper
     */
    public function isSupported(string $url): bool
    {
        foreach ($this->scrapers as $scraper) {
            if ($scraper->supports($url)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Get the source name for a supported URL
     */
    public function getSource(string $url): ?string
    {
        $supportedSources = [
            'leboncoin.fr' => 'leboncoin',
            'seloger.com' => 'seloger',
            'pap.fr' => 'pap',
            'logic-immo.com' => 'logic-immo',
        ];

        foreach ($supportedSources as $domain => $source) {
            if (str_contains($url, $domain)) {
                return $source;
            }
        }

        return null;
    }
}
