<?php

namespace Tests\Feature\Invitation;

use App\Models\Invitation;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Str;
use Tests\TestCase;

class RevokeInvitationTest extends TestCase
{
    use RefreshDatabase;

    public function test_owner_can_revoke_invitation(): void
    {
        $owner = User::factory()->create(['role' => 'owner']);
        $token = $owner->createToken('auth-token', ['owner'])->plainTextToken;

        $invitation = Invitation::create([
            'owner_id' => $owner->id,
            'email' => 'guest@example.com',
            'role' => 'guest-read',
            'token' => Str::random(64),
            'expires_at' => now()->addDays(7),
        ]);

        $response = $this->deleteJson("/api/invitations/{$invitation->id}", [], [
            'Authorization' => "Bearer $token",
        ]);

        $response->assertOk()
            ->assertJsonFragment(['message' => 'Invitation révoquée.']);

        $this->assertDatabaseMissing('invitations', ['id' => $invitation->id]);
    }

    public function test_guest_cannot_revoke_invitation(): void
    {
        $owner = User::factory()->create(['role' => 'owner']);
        $guest = User::factory()->create(['role' => 'guest-read']);
        $guestToken = $guest->createToken('auth-token', ['guest-read'])->plainTextToken;

        $invitation = Invitation::create([
            'owner_id' => $owner->id,
            'email' => 'other@example.com',
            'role' => 'guest-read',
            'token' => Str::random(64),
            'expires_at' => now()->addDays(7),
        ]);

        $response = $this->deleteJson("/api/invitations/{$invitation->id}", [], [
            'Authorization' => "Bearer $guestToken",
        ]);

        $response->assertStatus(403);
    }
}
