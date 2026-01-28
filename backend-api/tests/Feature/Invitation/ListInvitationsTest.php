<?php

namespace Tests\Feature\Invitation;

use App\Models\Invitation;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Str;
use Tests\TestCase;

class ListInvitationsTest extends TestCase
{
    use RefreshDatabase;

    public function test_owner_can_list_invitations(): void
    {
        $owner = User::factory()->create(['role' => 'owner']);
        $token = $owner->createToken('auth-token', ['owner'])->plainTextToken;

        Invitation::create([
            'owner_id' => $owner->id,
            'email' => 'guest@example.com',
            'role' => 'guest-read',
            'token' => Str::random(64),
            'expires_at' => now()->addDays(7),
        ]);

        $response = $this->getJson('/api/invitations', [
            'Authorization' => "Bearer $token",
        ]);

        $response->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonFragment(['email' => 'guest@example.com']);
    }

    public function test_guest_cannot_list_invitations(): void
    {
        $guest = User::factory()->create(['role' => 'guest-read']);
        $token = $guest->createToken('auth-token', ['guest-read'])->plainTextToken;

        $response = $this->getJson('/api/invitations', [
            'Authorization' => "Bearer $token",
        ]);

        $response->assertStatus(403);
    }
}
