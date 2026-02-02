<?php

namespace Tests\Feature\Property;

use App\Models\Property;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PropertyControllerTest extends TestCase
{
    use RefreshDatabase;

    private User $user;

    private string $token;

    protected function setUp(): void
    {
        parent::setUp();

        $this->user = User::factory()->create(['role' => 'owner']);
        $this->token = $this->user->createToken('test', ['owner'])->plainTextToken;
    }

    public function test_store_creates_property_with_required_fields(): void
    {
        $response = $this->withToken($this->token)->postJson('/api/properties', [
            'address' => '12 rue de la Paix, 75002 Paris',
            'surface' => 85,
            'price' => 35000000,
            'property_type' => 'appartement',
        ]);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'data' => [
                    'id', 'user_id', 'address', 'surface', 'price',
                    'property_type', 'agent_name', 'agent_agency', 'agent_phone',
                    'sale_urgency', 'notes', 'created_at', 'updated_at',
                ],
            ])
            ->assertJsonPath('data.address', '12 rue de la Paix, 75002 Paris')
            ->assertJsonPath('data.surface', 85)
            ->assertJsonPath('data.price', 35000000)
            ->assertJsonPath('data.property_type', 'appartement')
            ->assertJsonPath('data.sale_urgency', 'not_specified');

        $this->assertDatabaseHas('properties', [
            'user_id' => $this->user->id,
            'address' => '12 rue de la Paix, 75002 Paris',
        ]);
    }

    public function test_store_creates_property_with_all_fields(): void
    {
        $response = $this->withToken($this->token)->postJson('/api/properties', [
            'address' => '5 avenue Foch, 75016 Paris',
            'surface' => 120,
            'price' => 85000000,
            'property_type' => 'maison',
            'agent_name' => 'Jean Dupont',
            'agent_agency' => 'Immobilier Plus',
            'agent_phone' => '06 12 34 56 78',
            'sale_urgency' => 'high',
            'notes' => 'Appartement lumineux, balcon sud.',
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.agent_name', 'Jean Dupont')
            ->assertJsonPath('data.agent_agency', 'Immobilier Plus')
            ->assertJsonPath('data.agent_phone', '06 12 34 56 78')
            ->assertJsonPath('data.sale_urgency', 'high')
            ->assertJsonPath('data.notes', 'Appartement lumineux, balcon sud.');
    }

    public function test_store_fails_without_required_fields(): void
    {
        $response = $this->withToken($this->token)->postJson('/api/properties', []);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['address', 'surface', 'price', 'property_type']);
    }

    public function test_store_fails_with_invalid_property_type(): void
    {
        $response = $this->withToken($this->token)->postJson('/api/properties', [
            'address' => '1 rue Test',
            'surface' => 50,
            'price' => 10000000,
            'property_type' => 'invalid_type',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['property_type']);
    }

    public function test_index_returns_user_properties(): void
    {
        Property::create([
            'user_id' => $this->user->id,
            'address' => 'Adresse 1',
            'surface' => 50,
            'price' => 10000000,
            'property_type' => 'appartement',
        ]);

        Property::create([
            'user_id' => $this->user->id,
            'address' => 'Adresse 2',
            'surface' => 80,
            'price' => 20000000,
            'property_type' => 'maison',
        ]);

        $response = $this->withToken($this->token)->getJson('/api/properties');

        $response->assertStatus(200)
            ->assertJsonCount(2, 'data');
    }

    public function test_index_does_not_return_other_user_properties(): void
    {
        $otherUser = User::factory()->create();
        Property::create([
            'user_id' => $otherUser->id,
            'address' => 'Autre adresse',
            'surface' => 50,
            'price' => 10000000,
            'property_type' => 'terrain',
        ]);

        $response = $this->withToken($this->token)->getJson('/api/properties');

        $response->assertStatus(200)
            ->assertJsonCount(0, 'data');
    }

    public function test_show_returns_property(): void
    {
        $property = Property::create([
            'user_id' => $this->user->id,
            'address' => 'Adresse show',
            'surface' => 60,
            'price' => 15000000,
            'property_type' => 'immeuble',
        ]);

        $response = $this->withToken($this->token)->getJson("/api/properties/{$property->id}");

        $response->assertStatus(200)
            ->assertJsonPath('data.address', 'Adresse show');
    }

    public function test_show_forbidden_for_other_user(): void
    {
        $otherUser = User::factory()->create();
        $property = Property::create([
            'user_id' => $otherUser->id,
            'address' => 'Forbidden',
            'surface' => 50,
            'price' => 10000000,
            'property_type' => 'commercial',
        ]);

        $response = $this->withToken($this->token)->getJson("/api/properties/{$property->id}");

        $response->assertStatus(403);
    }

    public function test_update_property(): void
    {
        $property = Property::create([
            'user_id' => $this->user->id,
            'address' => 'Old address',
            'surface' => 50,
            'price' => 10000000,
            'property_type' => 'appartement',
        ]);

        $response = $this->withToken($this->token)->putJson("/api/properties/{$property->id}", [
            'address' => 'New address',
            'price' => 12000000,
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('data.address', 'New address')
            ->assertJsonPath('data.price', 12000000);
    }

    public function test_destroy_soft_deletes_property(): void
    {
        $property = Property::create([
            'user_id' => $this->user->id,
            'address' => 'To delete',
            'surface' => 50,
            'price' => 10000000,
            'property_type' => 'terrain',
        ]);

        $response = $this->withToken($this->token)->deleteJson("/api/properties/{$property->id}");

        $response->assertStatus(200);
        $this->assertSoftDeleted('properties', ['id' => $property->id]);
    }

    public function test_unauthenticated_access_returns_401(): void
    {
        $response = $this->getJson('/api/properties');

        $response->assertStatus(401);
    }
}
