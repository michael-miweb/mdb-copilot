<?php

namespace Tests\Feature\Auth;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class RbacTest extends TestCase
{
    use RefreshDatabase;

    public function test_owner_has_owner_ability(): void
    {
        $owner = User::factory()->create(['role' => 'owner']);
        $token = $owner->createToken('auth-token', ['owner'])->plainTextToken;

        $response = $this->getJson('/api/invitations', [
            'Authorization' => "Bearer $token",
        ]);

        $response->assertOk();
    }

    public function test_guest_read_cannot_access_owner_routes(): void
    {
        $guest = User::factory()->create(['role' => 'guest-read']);
        $token = $guest->createToken('auth-token', ['guest-read'])->plainTextToken;

        $response = $this->postJson('/api/invitations', [
            'email' => 'test@example.com',
            'role' => 'guest-read',
        ], ['Authorization' => "Bearer $token"]);

        $response->assertStatus(403);
    }

    public function test_guest_extended_cannot_access_owner_routes(): void
    {
        $guest = User::factory()->create(['role' => 'guest-extended']);
        $token = $guest->createToken('auth-token', ['guest-extended'])->plainTextToken;

        $response = $this->postJson('/api/invitations', [
            'email' => 'test@example.com',
            'role' => 'guest-read',
        ], ['Authorization' => "Bearer $token"]);

        $response->assertStatus(403);
    }

    public function test_login_returns_correct_abilities_for_role(): void
    {
        $user = User::factory()->create([
            'role' => 'guest-read',
            'password' => 'password123',
        ]);

        $response = $this->postJson('/api/auth/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertOk()
            ->assertJsonStructure(['user', 'token']);
    }
}
