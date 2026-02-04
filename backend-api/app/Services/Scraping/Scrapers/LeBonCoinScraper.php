<?php

declare(strict_types=1);

namespace App\Services\Scraping\Scrapers;

use App\Services\Scraping\ScrapingResult;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Symfony\Component\DomCrawler\Crawler;

class LeBonCoinScraper implements ScraperInterface
{
    private const SOURCE = 'leboncoin';

    private const USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

    public function supports(string $url): bool
    {
        return str_contains($url, 'leboncoin.fr');
    }

    public function scrape(string $url): ScrapingResult
    {
        try {
            $response = Http::withHeaders([
                'User-Agent' => self::USER_AGENT,
                'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
                'Accept-Language' => 'fr-FR,fr;q=0.9,en;q=0.8',
            ])->timeout(30)->get($url);

            if (! $response->successful()) {
                Log::warning('LeBonCoin scraping failed: HTTP error', [
                    'url' => $url,
                    'status' => $response->status(),
                ]);

                return new ScrapingResult(
                    status: ScrapingResult::STATUS_ERROR,
                    url: $url,
                    source: self::SOURCE,
                    errorMessage: 'Failed to fetch URL: HTTP '.$response->status(),
                );
            }

            return $this->parseHtml($response->body(), $url);
        } catch (\Exception $e) {
            Log::error('LeBonCoin scraping exception', [
                'url' => $url,
                'exception' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return new ScrapingResult(
                status: ScrapingResult::STATUS_ERROR,
                url: $url,
                source: self::SOURCE,
                errorMessage: 'Scraping failed: '.$e->getMessage(),
            );
        }
    }

    /**
     * Parse HTML content from LeBonCoin
     *
     * @internal Exposed as public for testing purposes
     */
    public function parseHtml(string $html, string $url): ScrapingResult
    {
        $crawler = new Crawler($html);

        $title = $this->extractTitle($crawler);
        $price = $this->extractPrice($crawler);
        $description = $this->extractDescription($crawler);
        $surface = $this->extractSurface($crawler, $description);
        $address = $this->extractAddress($crawler);
        $photos = $this->extractPhotos($crawler);

        // Determine status based on extracted data
        $hasEssentialData = $title !== null && $price !== null;
        $hasAllData = $hasEssentialData && $surface !== null && $address !== null;

        $status = match (true) {
            $hasAllData => ScrapingResult::STATUS_SUCCESS,
            $hasEssentialData => ScrapingResult::STATUS_PARTIAL,
            default => ScrapingResult::STATUS_ERROR,
        };

        return new ScrapingResult(
            status: $status,
            title: $title,
            price: $price,
            surface: $surface,
            address: $address,
            description: $description,
            photos: $photos,
            source: self::SOURCE,
            url: $url,
            errorMessage: $status === ScrapingResult::STATUS_ERROR ? 'Could not extract essential data (title and price)' : null,
        );
    }

    private function extractTitle(Crawler $crawler): ?string
    {
        // LeBonCoin selectors - ordered by stability:
        // 1. data-qa-id attributes are stable (used for QA testing)
        // 2. .styles_* classes are dynamic/fragile (CSS modules hash)
        // 3. Generic HTML tags as last resort
        $selectors = [
            '[data-qa-id="adview_title"]',        // Stable
            'h1[data-qa-id="adview_title"]',      // Stable
            '.styles_adTitle__3NI5f',             // Fragile - may change
            'h1',                                  // Fallback
        ];

        foreach ($selectors as $selector) {
            try {
                $node = $crawler->filter($selector)->first();
                if ($node->count() > 0) {
                    $text = trim($node->text());
                    if (! empty($text)) {
                        return $text;
                    }
                }
            } catch (\Exception) {
                continue;
            }
        }

        return null;
    }

    private function extractPrice(Crawler $crawler): ?int
    {
        // Selectors ordered by stability (data-* stable, .styles_* fragile)
        $selectors = [
            '[data-qa-id="adview_price"]',   // Stable
            '.styles_price__3Nka5',          // Fragile
            '[data-test-id="price"]',        // Stable
        ];

        foreach ($selectors as $selector) {
            try {
                $node = $crawler->filter($selector)->first();
                if ($node->count() > 0) {
                    $text = $node->text();
                    // Extract numeric value and convert to centimes
                    $price = $this->parsePrice($text);
                    if ($price !== null) {
                        return $price;
                    }
                }
            } catch (\Exception) {
                continue;
            }
        }

        return null;
    }

    private function parsePrice(string $text): ?int
    {
        // Remove spaces, € symbol, and other non-numeric chars except comma/dot
        $cleaned = preg_replace('/[^\d,.]/', '', $text);
        if ($cleaned === null || $cleaned === '') {
            return null;
        }

        // Handle French format (1 234,56 €) - replace comma with dot for decimals
        $cleaned = str_replace(',', '.', $cleaned);

        // Remove thousands separator dots that might remain
        if (substr_count($cleaned, '.') > 1) {
            $parts = explode('.', $cleaned);
            $lastPart = array_pop($parts);
            $cleaned = implode('', $parts).'.'.$lastPart;
        }

        $price = (float) $cleaned;

        // Convert to centimes (prices on LeBonCoin are in euros)
        return $price > 0 ? (int) round($price * 100) : null;
    }

    private function extractSurface(Crawler $crawler, ?string $description): ?int
    {
        // Look for surface in criteria/attributes section
        $selectors = [
            '[data-qa-id="criteria_item_square"]',
            '[data-qa-id="adview_features"] li',
            '.styles_feature__3-8XE',
        ];

        foreach ($selectors as $selector) {
            try {
                $nodes = $crawler->filter($selector);
                foreach ($nodes as $node) {
                    $text = trim($node->textContent);
                    // Look for pattern like "85 m²" or "85m²"
                    if (preg_match('/(\d+)\s*m[²2]/i', $text, $matches)) {
                        return (int) $matches[1];
                    }
                }
            } catch (\Exception) {
                continue;
            }
        }

        // Fallback: check description for surface (already extracted, no double call)
        if ($description !== null && preg_match('/(\d+)\s*m[²2]/i', $description, $matches)) {
            return (int) $matches[1];
        }

        return null;
    }

    private function extractAddress(Crawler $crawler): ?string
    {
        $selectors = [
            '[data-qa-id="adview_location_informations"]',
            '[data-qa-id="adview_location"]',
            '.styles_location__2gGXJ',
        ];

        foreach ($selectors as $selector) {
            try {
                $node = $crawler->filter($selector)->first();
                if ($node->count() > 0) {
                    $text = trim($node->text());
                    if (! empty($text)) {
                        return $text;
                    }
                }
            } catch (\Exception) {
                continue;
            }
        }

        return null;
    }

    private function extractDescription(Crawler $crawler): ?string
    {
        $selectors = [
            '[data-qa-id="adview_description_container"]',
            '.styles_description__3-7o4',
            '[data-qa-id="adview_description"]',
        ];

        foreach ($selectors as $selector) {
            try {
                $node = $crawler->filter($selector)->first();
                if ($node->count() > 0) {
                    $text = trim($node->text());
                    if (! empty($text)) {
                        return $text;
                    }
                }
            } catch (\Exception) {
                continue;
            }
        }

        return null;
    }

    /**
     * @return array<string>
     */
    private function extractPhotos(Crawler $crawler): array
    {
        /** @var array<string> $photos */
        $photos = [];

        $selectors = [
            '[data-qa-id="adview_gallery_container"] img',
            '.styles_slider__2_2mU img',
            '.slick-slide img',
            'picture img',
        ];

        foreach ($selectors as $selector) {
            try {
                $nodes = $crawler->filter($selector);
                foreach ($nodes as $node) {
                    if (! $node instanceof \DOMElement) {
                        continue;
                    }
                    $src = $node->getAttribute('src');
                    $dataSrc = $node->getAttribute('data-src');

                    $imageUrl = $dataSrc !== '' ? $dataSrc : $src;

                    if ($imageUrl !== '' && $this->isValidImageUrl($imageUrl)) {
                        $photos[] = $imageUrl;
                    }
                }

                if (count($photos) > 0) {
                    break; // Found photos, stop looking
                }
            } catch (\Exception) {
                continue;
            }
        }

        return array_values(array_unique($photos));
    }

    private function isValidImageUrl(string $url): bool
    {
        // Filter out placeholder images, tracking pixels, etc.
        if (str_contains($url, 'data:image')) {
            return false;
        }

        if (str_contains($url, 'placeholder')) {
            return false;
        }

        // Must be an absolute URL or start with //
        return str_starts_with($url, 'http') || str_starts_with($url, '//');
    }
}
