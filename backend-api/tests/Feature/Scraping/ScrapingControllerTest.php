<?php

declare(strict_types=1);

namespace Tests\Feature\Scraping;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use PHPUnit\Framework\Attributes\Test;
use Tests\TestCase;

class ScrapingControllerTest extends TestCase
{
    use RefreshDatabase;

    private User $owner;

    protected function setUp(): void
    {
        parent::setUp();
        $this->owner = User::factory()->create();
    }

    /**
     * Create a token with specified abilities
     *
     * @param  array<string>  $abilities
     */
    private function actingAsWithAbilities(User $user, array $abilities): self
    {
        $token = $user->createToken('test-token', $abilities)->plainTextToken;

        return $this->withHeader('Authorization', 'Bearer '.$token);
    }

    #[Test]
    public function it_requires_authentication(): void
    {
        $response = $this->postJson('/api/scrape', [
            'url' => 'https://www.leboncoin.fr/ventes/123',
        ]);

        $response->assertUnauthorized();
    }

    #[Test]
    public function it_requires_owner_ability(): void
    {
        // Guest-read users should be denied
        $response = $this->actingAsWithAbilities($this->owner, ['guest-read'])
            ->postJson('/api/scrape', [
                'url' => 'https://www.leboncoin.fr/ventes/123',
            ]);

        $response->assertForbidden();
    }

    #[Test]
    public function it_validates_url_is_required(): void
    {
        $response = $this->actingAsWithAbilities($this->owner, ['owner'])
            ->postJson('/api/scrape', []);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors(['url']);
    }

    #[Test]
    public function it_validates_url_format(): void
    {
        $response = $this->actingAsWithAbilities($this->owner, ['owner'])
            ->postJson('/api/scrape', [
                'url' => 'not-a-valid-url',
            ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors(['url']);
    }

    #[Test]
    public function it_returns_error_for_unsupported_url(): void
    {
        $response = $this->actingAsWithAbilities($this->owner, ['owner'])
            ->postJson('/api/scrape', [
                'url' => 'https://www.example.com/property/123',
            ]);

        $response->assertOk()
            ->assertJsonPath('data.status', 'error')
            ->assertJsonPath('data.url', 'https://www.example.com/property/123');
    }

    #[Test]
    public function it_returns_not_implemented_for_seloger(): void
    {
        $response = $this->actingAsWithAbilities($this->owner, ['owner'])
            ->postJson('/api/scrape', [
                'url' => 'https://www.seloger.com/annonces/123',
            ]);

        $response->assertOk()
            ->assertJsonPath('data.status', 'not_implemented')
            ->assertJsonPath('data.source', 'seloger');
    }

    #[Test]
    public function it_returns_scraping_result_structure(): void
    {
        $response = $this->actingAsWithAbilities($this->owner, ['owner'])
            ->postJson('/api/scrape', [
                'url' => 'https://www.pap.fr/annonces/123',
            ]);

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    'status',
                    'title',
                    'price',
                    'surface',
                    'address',
                    'description',
                    'photos',
                    'source',
                    'url',
                    'error_message',
                ],
            ]);
    }
}
