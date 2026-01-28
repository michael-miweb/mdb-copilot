<?php

namespace Tests\Feature\Profile;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class UpdateProfileTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_update_first_name(): void
    {
        $user = User::factory()->create(['first_name' => 'Jean']);
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/profile', [
            'first_name' => 'Pierre',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('user.first_name', 'Pierre')
            ->assertJsonPath('message', 'Profil mis à jour avec succès.');

        $this->assertDatabaseHas('users', ['id' => $user->id, 'first_name' => 'Pierre']);
    }

    public function test_user_can_update_last_name(): void
    {
        $user = User::factory()->create(['last_name' => 'Dupont']);
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/profile', [
            'last_name' => 'Martin',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('user.last_name', 'Martin');

        $this->assertDatabaseHas('users', ['id' => $user->id, 'last_name' => 'Martin']);
    }

    public function test_user_can_update_email(): void
    {
        $user = User::factory()->create(['email' => 'old@example.com']);
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/profile', [
            'email' => 'new@example.com',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('user.email', 'new@example.com');
    }

    public function test_user_can_keep_same_email(): void
    {
        $user = User::factory()->create(['email' => 'same@example.com']);
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/profile', [
            'email' => 'same@example.com',
        ]);

        $response->assertStatus(200);
    }

    public function test_update_profile_fails_with_duplicate_email(): void
    {
        User::factory()->create(['email' => 'taken@example.com']);
        $user = User::factory()->create(['email' => 'mine@example.com']);
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/profile', [
            'email' => 'taken@example.com',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['email']);
    }

    public function test_update_profile_fails_with_invalid_email(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/profile', [
            'email' => 'not-an-email',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['email']);
    }

    public function test_update_profile_requires_authentication(): void
    {
        $response = $this->putJson('/api/profile', ['first_name' => 'Test']);

        $response->assertStatus(401);
    }
}
