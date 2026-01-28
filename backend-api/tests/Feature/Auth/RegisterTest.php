<?php

namespace Tests\Feature\Auth;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class RegisterTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register_with_valid_data(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'email' => 'jean@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertStatus(201)
            ->assertJsonStructure([
                'user' => ['id', 'first_name', 'last_name', 'email'],
                'token',
            ]);

        $this->assertDatabaseHas('users', [
            'email' => 'jean@example.com',
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
        ]);
    }

    public function test_registration_fails_with_invalid_email(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'email' => 'invalid-email',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['email']);
    }

    public function test_registration_fails_with_duplicate_email(): void
    {
        User::factory()->create(['email' => 'existing@example.com']);

        $response = $this->postJson('/api/auth/register', [
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'email' => 'existing@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['email']);
    }

    public function test_registration_fails_with_short_password(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'email' => 'jean@example.com',
            'password' => 'short',
            'password_confirmation' => 'short',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['password']);
    }

    public function test_registration_fails_with_mismatched_password_confirmation(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'email' => 'jean@example.com',
            'password' => 'password123',
            'password_confirmation' => 'different123',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['password']);
    }
}
