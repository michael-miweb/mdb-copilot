<?php

namespace Tests\Feature\Invitation;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Mail;
use Tests\TestCase;

class SendInvitationTest extends TestCase
{
    use RefreshDatabase;

    public function test_owner_can_send_invitation(): void
    {
        Mail::fake();

        $owner = User::factory()->create(['role' => 'owner']);
        $token = $owner->createToken('auth-token', ['owner'])->plainTextToken;

        $response = $this->postJson('/api/invitations', [
            'email' => 'guest@example.com',
            'role' => 'guest-read',
        ], ['Authorization' => "Bearer $token"]);

        $response->assertStatus(201)
            ->assertJsonStructure(['invitation', 'message']);

        $this->assertDatabaseHas('invitations', [
            'email' => 'guest@example.com',
            'role' => 'guest-read',
            'owner_id' => $owner->id,
        ]);

        Mail::assertSent(\App\Mail\InvitationMail::class);
    }

    public function test_guest_cannot_send_invitation(): void
    {
        $guest = User::factory()->create(['role' => 'guest-read']);
        $token = $guest->createToken('auth-token', ['guest-read'])->plainTextToken;

        $response = $this->postJson('/api/invitations', [
            'email' => 'other@example.com',
            'role' => 'guest-read',
        ], ['Authorization' => "Bearer $token"]);

        $response->assertStatus(403);
    }

    public function test_cannot_invite_existing_user_email(): void
    {
        Mail::fake();

        $owner = User::factory()->create(['role' => 'owner']);
        $token = $owner->createToken('auth-token', ['owner'])->plainTextToken;
        User::factory()->create(['email' => 'existing@example.com']);

        $response = $this->postJson('/api/invitations', [
            'email' => 'existing@example.com',
            'role' => 'guest-read',
        ], ['Authorization' => "Bearer $token"]);

        $response->assertStatus(422)
            ->assertJsonFragment(['message' => 'Cet email possède déjà un compte.']);
    }

    public function test_unauthenticated_cannot_send_invitation(): void
    {
        $response = $this->postJson('/api/invitations', [
            'email' => 'guest@example.com',
            'role' => 'guest-read',
        ]);

        $response->assertStatus(401);
    }

    public function test_cannot_invite_email_with_pending_invitation(): void
    {
        Mail::fake();

        $owner = User::factory()->create(['role' => 'owner']);
        $token = $owner->createToken('auth-token', ['owner'])->plainTextToken;

        // Create first invitation
        $this->postJson('/api/invitations', [
            'email' => 'pending@example.com',
            'role' => 'guest-read',
        ], ['Authorization' => "Bearer $token"]);

        // Try to create another invitation for the same email
        $response = $this->postJson('/api/invitations', [
            'email' => 'pending@example.com',
            'role' => 'guest-extended',
        ], ['Authorization' => "Bearer $token"]);

        $response->assertStatus(422)
            ->assertJsonFragment([
                'message' => 'Une invitation est déjà en attente pour cet email.',
            ]);
    }
}
