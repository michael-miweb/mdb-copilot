<?php

declare(strict_types=1);

namespace Tests\Unit\Services\Scraping;

use App\Services\Scraping\Scrapers\LeBonCoinScraper;
use App\Services\Scraping\ScrapingResult;
use Illuminate\Support\Facades\Http;
use PHPUnit\Framework\Attributes\Test;
use Tests\TestCase;

class LeBonCoinScraperTest extends TestCase
{
    private LeBonCoinScraper $scraper;

    protected function setUp(): void
    {
        parent::setUp();
        $this->scraper = new LeBonCoinScraper;
    }

    #[Test]
    public function it_supports_leboncoin_urls(): void
    {
        $this->assertTrue($this->scraper->supports('https://www.leboncoin.fr/ventes_immobilieres/123456789.htm'));
        $this->assertTrue($this->scraper->supports('https://leboncoin.fr/ad/123'));
        $this->assertFalse($this->scraper->supports('https://www.seloger.com/annonces/123'));
        $this->assertFalse($this->scraper->supports('https://example.com'));
    }

    #[Test]
    public function it_parses_complete_listing_successfully(): void
    {
        $html = file_get_contents(base_path('tests/fixtures/leboncoin/complete-listing.html'));
        $this->assertIsString($html);
        $url = 'https://www.leboncoin.fr/ventes_immobilieres/123456789.htm';

        $result = $this->scraper->parseHtml($html, $url);

        $this->assertEquals(ScrapingResult::STATUS_SUCCESS, $result->status);
        $this->assertEquals('Appartement 3 pièces 85m² proche métro', $result->title);
        $this->assertEquals(28500000, $result->price); // 285 000 € in centimes
        $this->assertEquals(85, $result->surface);
        $this->assertEquals('75011 Paris 11ème', $result->address);
        $this->assertNotNull($result->description);
        $this->assertStringContainsString('Magnifique appartement', $result->description);
        $this->assertCount(3, $result->photos);
        $this->assertEquals('leboncoin', $result->source);
        $this->assertEquals($url, $result->url);
        $this->assertNull($result->errorMessage);
    }

    #[Test]
    public function it_parses_partial_listing_with_partial_status(): void
    {
        $html = file_get_contents(base_path('tests/fixtures/leboncoin/partial-listing.html'));
        $this->assertIsString($html);
        $url = 'https://www.leboncoin.fr/ventes_immobilieres/987654321.htm';

        $result = $this->scraper->parseHtml($html, $url);

        $this->assertEquals(ScrapingResult::STATUS_PARTIAL, $result->status);
        $this->assertEquals('Belle maison à rénover', $result->title);
        $this->assertEquals(15000000, $result->price); // 150 000 € in centimes
        $this->assertNull($result->surface);
        $this->assertNull($result->address);
        $this->assertNotNull($result->description);
        $this->assertStringContainsString('Maison à rénover', $result->description);
        $this->assertEmpty($result->photos);
        $this->assertEquals('leboncoin', $result->source);
    }

    #[Test]
    public function it_returns_error_status_when_essential_data_missing(): void
    {
        $html = file_get_contents(base_path('tests/fixtures/leboncoin/minimal-listing.html'));
        $this->assertIsString($html);
        $url = 'https://www.leboncoin.fr/ventes_immobilieres/111222333.htm';

        $result = $this->scraper->parseHtml($html, $url);

        // Should find title via fallback h1 but not price
        $this->assertEquals(ScrapingResult::STATUS_ERROR, $result->status);
        $this->assertEquals('Terrain à bâtir', $result->title);
        $this->assertNull($result->price);
        $this->assertNotNull($result->errorMessage);
    }

    #[Test]
    public function it_converts_result_to_array(): void
    {
        $html = file_get_contents(base_path('tests/fixtures/leboncoin/complete-listing.html'));
        $this->assertIsString($html);
        $url = 'https://www.leboncoin.fr/ventes_immobilieres/123456789.htm';

        $result = $this->scraper->parseHtml($html, $url);
        $array = $result->toArray();

        $this->assertIsArray($array);
        $this->assertArrayHasKey('status', $array);
        $this->assertArrayHasKey('title', $array);
        $this->assertArrayHasKey('price', $array);
        $this->assertArrayHasKey('surface', $array);
        $this->assertArrayHasKey('address', $array);
        $this->assertArrayHasKey('description', $array);
        $this->assertArrayHasKey('photos', $array);
        $this->assertArrayHasKey('source', $array);
        $this->assertArrayHasKey('url', $array);
        $this->assertArrayHasKey('error_message', $array);
    }

    #[Test]
    public function it_handles_various_price_formats(): void
    {
        // Test prices with different formats
        $testCases = [
            ['<div data-qa-id="adview_price">285 000 €</div>', 28500000],
            ['<div data-qa-id="adview_price">1 500 000 €</div>', 150000000],
            ['<div data-qa-id="adview_price">99000€</div>', 9900000],
            ['<div data-qa-id="adview_price">50 €</div>', 5000],
        ];

        foreach ($testCases as [$priceHtml, $expectedCentimes]) {
            $html = <<<HTML
            <!DOCTYPE html>
            <html>
            <body>
                <h1 data-qa-id="adview_title">Test Property</h1>
                {$priceHtml}
            </body>
            </html>
            HTML;

            $result = $this->scraper->parseHtml($html, 'https://www.leboncoin.fr/test');
            $this->assertEquals($expectedCentimes, $result->price, "Failed for price HTML: {$priceHtml}");
        }
    }

    #[Test]
    public function it_extracts_surface_from_description_as_fallback(): void
    {
        $html = <<<'HTML'
        <!DOCTYPE html>
        <html>
        <body>
            <h1 data-qa-id="adview_title">Appartement centre ville</h1>
            <div data-qa-id="adview_price">200 000 €</div>
            <div data-qa-id="adview_description_container">
                Superbe appartement de 72 m² en plein centre.
            </div>
        </body>
        </html>
        HTML;

        $result = $this->scraper->parseHtml($html, 'https://www.leboncoin.fr/test');

        $this->assertEquals(72, $result->surface);
    }

    #[Test]
    public function it_scrapes_successfully_with_http_mock(): void
    {
        $html = file_get_contents(base_path('tests/fixtures/leboncoin/complete-listing.html'));
        $this->assertIsString($html);

        Http::fake([
            'leboncoin.fr/*' => Http::response($html, 200),
        ]);

        $url = 'https://www.leboncoin.fr/ventes_immobilieres/123456789.htm';
        $result = $this->scraper->scrape($url);

        $this->assertEquals(ScrapingResult::STATUS_SUCCESS, $result->status);
        $this->assertEquals('Appartement 3 pièces 85m² proche métro', $result->title);
        $this->assertEquals(28500000, $result->price);
        $this->assertEquals('leboncoin', $result->source);
    }

    #[Test]
    public function it_returns_error_on_http_failure(): void
    {
        Http::fake([
            'leboncoin.fr/*' => Http::response('Not Found', 404),
        ]);

        $url = 'https://www.leboncoin.fr/ventes_immobilieres/999999999.htm';
        $result = $this->scraper->scrape($url);

        $this->assertEquals(ScrapingResult::STATUS_ERROR, $result->status);
        $this->assertNotNull($result->errorMessage);
        $this->assertStringContainsString('HTTP 404', $result->errorMessage);
    }

    #[Test]
    public function it_returns_error_on_network_exception(): void
    {
        Http::fake([
            'leboncoin.fr/*' => fn () => throw new \Exception('Connection timeout'),
        ]);

        $url = 'https://www.leboncoin.fr/ventes_immobilieres/123.htm';
        $result = $this->scraper->scrape($url);

        $this->assertEquals(ScrapingResult::STATUS_ERROR, $result->status);
        $this->assertNotNull($result->errorMessage);
        $this->assertStringContainsString('Connection timeout', $result->errorMessage);
    }
}
