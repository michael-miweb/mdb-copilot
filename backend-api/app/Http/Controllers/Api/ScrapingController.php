<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\Scraping\ScrapingService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ScrapingController extends Controller
{
    public function __construct(
        private readonly ScrapingService $scrapingService,
    ) {}

    /**
     * Scrape property data from a given URL
     */
    public function scrape(Request $request): JsonResponse
    {
        /** @var array{url: string} $validated */
        $validated = $request->validate([
            'url' => ['required', 'url'],
        ]);

        $result = $this->scrapingService->scrape($validated['url']);

        return response()->json([
            'data' => $result->toArray(),
        ]);
    }
}
