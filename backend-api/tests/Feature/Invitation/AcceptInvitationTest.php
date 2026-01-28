<?php

namespace Tests\Feature\Invitation;

use App\Models\Invitation;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Str;
use Tests\TestCase;

class AcceptInvitationTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_accept_valid_invitation(): void
    {
        $owner = User::factory()->create(['role' => 'owner']);
        $invitation = Invitation::create([
            'owner_id' => $owner->id,
            'email' => 'guest@example.com',
            'role' => 'guest-read',
            'token' => Str::random(64),
            'expires_at' => now()->addDays(7),
        ]);

        $response = $this->postJson('/api/invitations/accept', [
            'token' => $invitation->token,
            'first_name' => 'Guest',
            'last_name' => 'User',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertOk()
            ->assertJsonStructure(['user', 'token']);

        $this->assertDatabaseHas('users', [
            'email' => 'guest@example.com',
            'first_name' => 'Guest',
            'last_name' => 'User',
            'role' => 'guest-read',
        ]);

        $this->assertNotNull($invitation->fresh()?->accepted_at);
    }

    public function test_cannot_accept_expired_invitation(): void
    {
        $owner = User::factory()->create(['role' => 'owner']);
        $invitation = Invitation::create([
            'owner_id' => $owner->id,
            'email' => 'guest@example.com',
            'role' => 'guest-read',
            'token' => Str::random(64),
            'expires_at' => now()->subDay(),
        ]);

        $response = $this->postJson('/api/invitations/accept', [
            'token' => $invitation->token,
            'first_name' => 'Guest',
            'last_name' => 'User',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertStatus(422)
            ->assertJsonFragment(['message' => 'Cette invitation a expiré.']);
    }

    public function test_cannot_accept_already_accepted_invitation(): void
    {
        $owner = User::factory()->create(['role' => 'owner']);
        $invitation = Invitation::create([
            'owner_id' => $owner->id,
            'email' => 'guest@example.com',
            'role' => 'guest-read',
            'token' => Str::random(64),
            'expires_at' => now()->addDays(7),
            'accepted_at' => now(),
        ]);

        $response = $this->postJson('/api/invitations/accept', [
            'token' => $invitation->token,
            'first_name' => 'Guest',
            'last_name' => 'User',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertStatus(422)
            ->assertJsonFragment(['message' => 'Cette invitation a déjà été acceptée.']);
    }

    public function test_cannot_accept_with_invalid_token(): void
    {
        $response = $this->postJson('/api/invitations/accept', [
            'token' => 'invalid-token',
            'first_name' => 'Guest',
            'last_name' => 'User',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertStatus(404);
    }
}
