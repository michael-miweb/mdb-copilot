<?php

namespace Tests\Feature\Profile;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class UpdatePasswordTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_update_password(): void
    {
        $user = User::factory()->create([
            'password' => 'oldpassword123',
        ]);
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/profile/password', [
            'current_password' => 'oldpassword123',
            'password' => 'newpassword123',
            'password_confirmation' => 'newpassword123',
        ]);

        $response->assertStatus(200)
            ->assertJson(['message' => 'Mot de passe mis à jour avec succès.']);

        $user->refresh();
        $this->assertTrue(Hash::check('newpassword123', $user->password));
    }

    public function test_update_password_fails_with_incorrect_current(): void
    {
        $user = User::factory()->create([
            'password' => 'correctpassword',
        ]);
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/profile/password', [
            'current_password' => 'wrongpassword',
            'password' => 'newpassword123',
            'password_confirmation' => 'newpassword123',
        ]);

        $response->assertStatus(422)
            ->assertJsonPath('errors.current_password.0', 'Le mot de passe actuel est incorrect.');
    }

    public function test_update_password_fails_with_short_password(): void
    {
        $user = User::factory()->create(['password' => 'oldpassword123']);
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/profile/password', [
            'current_password' => 'oldpassword123',
            'password' => 'short',
            'password_confirmation' => 'short',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['password']);
    }

    public function test_update_password_fails_with_mismatch(): void
    {
        $user = User::factory()->create(['password' => 'oldpassword123']);
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/profile/password', [
            'current_password' => 'oldpassword123',
            'password' => 'newpassword123',
            'password_confirmation' => 'different123',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['password']);
    }

    public function test_update_password_requires_authentication(): void
    {
        $response = $this->putJson('/api/profile/password', [
            'current_password' => 'test',
            'password' => 'newpassword123',
            'password_confirmation' => 'newpassword123',
        ]);

        $response->assertStatus(401);
    }
}
