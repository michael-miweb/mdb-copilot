<?php

namespace Tests\Feature\Contact;

use App\Models\Contact;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ContactControllerTest extends TestCase
{
    use RefreshDatabase;

    private User $user;

    protected function setUp(): void
    {
        parent::setUp();
        $this->user = User::factory()->create();
        $this->actingAs($this->user);
    }

    public function test_index_returns_user_contacts(): void
    {
        Contact::factory()->count(3)->create(['user_id' => $this->user->id]);
        Contact::factory()->create(); // another user's contact

        $response = $this->getJson('/api/contacts');

        $response->assertOk()
            ->assertJsonCount(3, 'data');
    }

    public function test_index_filters_by_type(): void
    {
        Contact::factory()->create([
            'user_id' => $this->user->id,
            'contact_type' => 'agent_immobilier',
        ]);
        Contact::factory()->create([
            'user_id' => $this->user->id,
            'contact_type' => 'artisan',
        ]);

        $response = $this->getJson('/api/contacts?type=agent_immobilier');

        $response->assertOk()
            ->assertJsonCount(1, 'data');
    }

    public function test_store_creates_contact(): void
    {
        $payload = [
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'company' => 'Agence Immo',
            'phone' => '0601020304',
            'email' => 'jean@agence.fr',
            'contact_type' => 'agent_immobilier',
            'notes' => 'Contact principal',
        ];

        $response = $this->postJson('/api/contacts', $payload);

        $response->assertCreated()
            ->assertJsonPath('data.first_name', 'Jean')
            ->assertJsonPath('data.last_name', 'Dupont')
            ->assertJsonPath('data.contact_type', 'agent_immobilier');

        $this->assertDatabaseHas('contacts', [
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'user_id' => $this->user->id,
        ]);
    }

    public function test_store_validates_required_fields(): void
    {
        $response = $this->postJson('/api/contacts', []);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors(['first_name', 'last_name', 'contact_type']);
    }

    public function test_show_returns_own_contact(): void
    {
        $contact = Contact::factory()->create([
            'user_id' => $this->user->id,
        ]);

        $response = $this->getJson("/api/contacts/{$contact->id}");

        $response->assertOk()
            ->assertJsonPath('data.id', $contact->id);
    }

    public function test_show_forbids_other_users_contact(): void
    {
        $contact = Contact::factory()->create();

        $response = $this->getJson("/api/contacts/{$contact->id}");

        $response->assertForbidden();
    }

    public function test_update_modifies_contact(): void
    {
        $contact = Contact::factory()->create([
            'user_id' => $this->user->id,
            'first_name' => 'Old',
            'last_name' => 'Name',
        ]);

        $response = $this->putJson("/api/contacts/{$contact->id}", [
            'first_name' => 'New',
            'last_name' => 'Name',
        ]);

        $response->assertOk()
            ->assertJsonPath('data.first_name', 'New');
    }

    public function test_update_forbids_other_users_contact(): void
    {
        $contact = Contact::factory()->create();

        $response = $this->putJson("/api/contacts/{$contact->id}", [
            'first_name' => 'Hack',
        ]);

        $response->assertForbidden();
    }

    public function test_destroy_soft_deletes_contact(): void
    {
        $contact = Contact::factory()->create([
            'user_id' => $this->user->id,
        ]);

        $response = $this->deleteJson("/api/contacts/{$contact->id}");

        $response->assertOk();
        $this->assertSoftDeleted('contacts', ['id' => $contact->id]);
    }

    public function test_destroy_forbids_other_users_contact(): void
    {
        $contact = Contact::factory()->create();

        $response = $this->deleteJson("/api/contacts/{$contact->id}");

        $response->assertForbidden();
    }
}
