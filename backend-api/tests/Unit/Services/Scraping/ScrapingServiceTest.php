<?php

declare(strict_types=1);

namespace Tests\Unit\Services\Scraping;

use App\Services\Scraping\Scrapers\LeBonCoinScraper;
use App\Services\Scraping\Scrapers\LogicImmoScraper;
use App\Services\Scraping\Scrapers\PapScraper;
use App\Services\Scraping\Scrapers\SeLogerScraper;
use App\Services\Scraping\ScrapingResult;
use App\Services\Scraping\ScrapingService;
use PHPUnit\Framework\Attributes\Test;
use Tests\TestCase;

class ScrapingServiceTest extends TestCase
{
    private ScrapingService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new ScrapingService(
            new LeBonCoinScraper,
            new SeLogerScraper,
            new PapScraper,
            new LogicImmoScraper,
        );
    }

    #[Test]
    public function it_checks_if_url_is_supported(): void
    {
        $this->assertTrue($this->service->isSupported('https://www.leboncoin.fr/ventes/123'));
        $this->assertTrue($this->service->isSupported('https://www.seloger.com/annonces/123'));
        $this->assertTrue($this->service->isSupported('https://www.pap.fr/annonces/123'));
        $this->assertTrue($this->service->isSupported('https://www.logic-immo.com/detail/123'));
        $this->assertFalse($this->service->isSupported('https://www.example.com/property'));
    }

    #[Test]
    public function it_returns_correct_source_for_url(): void
    {
        $this->assertEquals('leboncoin', $this->service->getSource('https://www.leboncoin.fr/ventes/123'));
        $this->assertEquals('seloger', $this->service->getSource('https://www.seloger.com/annonces/123'));
        $this->assertEquals('pap', $this->service->getSource('https://www.pap.fr/annonces/123'));
        $this->assertEquals('logic-immo', $this->service->getSource('https://www.logic-immo.com/detail/123'));
        $this->assertNull($this->service->getSource('https://www.example.com'));
    }

    #[Test]
    public function it_returns_error_for_unsupported_url(): void
    {
        $result = $this->service->scrape('https://www.example.com/property/123');

        $this->assertEquals(ScrapingResult::STATUS_ERROR, $result->status);
        $this->assertNotNull($result->errorMessage);
        $this->assertStringContainsString('No scraper available', $result->errorMessage);
    }

    #[Test]
    public function it_returns_not_implemented_for_seloger(): void
    {
        $result = $this->service->scrape('https://www.seloger.com/annonces/123');

        $this->assertEquals(ScrapingResult::STATUS_NOT_IMPLEMENTED, $result->status);
        $this->assertEquals('seloger', $result->source);
    }

    #[Test]
    public function it_returns_not_implemented_for_pap(): void
    {
        $result = $this->service->scrape('https://www.pap.fr/annonces/123');

        $this->assertEquals(ScrapingResult::STATUS_NOT_IMPLEMENTED, $result->status);
        $this->assertEquals('pap', $result->source);
    }

    #[Test]
    public function it_returns_not_implemented_for_logic_immo(): void
    {
        $result = $this->service->scrape('https://www.logic-immo.com/detail/123');

        $this->assertEquals(ScrapingResult::STATUS_NOT_IMPLEMENTED, $result->status);
        $this->assertEquals('logic-immo', $result->source);
    }
}
