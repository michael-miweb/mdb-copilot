<?php

declare(strict_types=1);

namespace App\Services\Scraping;

/**
 * DTO representing the result of a scraping operation
 */
class ScrapingResult
{
    public const STATUS_SUCCESS = 'success';

    public const STATUS_PARTIAL = 'partial';

    public const STATUS_ERROR = 'error';

    public const STATUS_NOT_IMPLEMENTED = 'not_implemented';

    /**
     * @param  array<string>  $photos
     */
    public function __construct(
        public readonly string $status,
        public readonly ?string $title = null,
        public readonly ?int $price = null, // in centimes
        public readonly ?int $surface = null, // in m²
        public readonly ?string $address = null,
        public readonly ?string $description = null,
        public readonly array $photos = [],
        public readonly string $source = '',
        public readonly string $url = '',
        public readonly ?string $errorMessage = null,
    ) {}

    /**
     * Convert the result to an array for JSON serialization
     *
     * @return array<string, mixed>
     */
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

    /**
     * Check if the scraping was successful
     */
    public function isSuccess(): bool
    {
        return $this->status === self::STATUS_SUCCESS;
    }

    /**
     * Check if the scraping was partial (some fields missing)
     */
    public function isPartial(): bool
    {
        return $this->status === self::STATUS_PARTIAL;
    }

    /**
     * Check if there was an error
     */
    public function isError(): bool
    {
        return $this->status === self::STATUS_ERROR;
    }

    /**
     * Check if the scraper is not implemented for this source
     */
    public function isNotImplemented(): bool
    {
        return $this->status === self::STATUS_NOT_IMPLEMENTED;
    }
}
