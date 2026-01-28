<?php

namespace Tests\Feature\Auth;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_get_profile(): void
    {
        $user = User::factory()->create([
            'first_name' => 'Jean',
            'last_name' => 'Dupont',
            'email' => 'jean@example.com',
        ]);
        Sanctum::actingAs($user);

        $response = $this->getJson('/api/auth/user');

        $response->assertStatus(200)
            ->assertJson([
                'first_name' => 'Jean',
                'last_name' => 'Dupont',
                'email' => 'jean@example.com',
            ]);
    }

    public function test_unauthenticated_user_cannot_get_profile(): void
    {
        $response = $this->getJson('/api/auth/user');

        $response->assertStatus(401);
    }
}
