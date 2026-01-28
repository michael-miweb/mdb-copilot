<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\UpdatePasswordRequest;
use App\Http\Requests\UpdateProfileRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;

class ProfileController extends Controller
{
    public function updateProfile(UpdateProfileRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $user->update($request->validated());

        return response()->json([
            'user' => $user->fresh(),
            'message' => 'Profil mis à jour avec succès.',
        ]);
    }

    public function updatePassword(UpdatePasswordRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        /** @var array{current_password: string, password: string} $data */
        $data = $request->validated();

        if (! Hash::check($data['current_password'], $user->password)) {
            return response()->json([
                'message' => 'Le mot de passe actuel est incorrect.',
                'errors' => [
                    'current_password' => ['Le mot de passe actuel est incorrect.'],
                ],
            ], 422);
        }

        $user->update([
            'password' => $data['password'],
        ]);

        return response()->json([
            'message' => 'Mot de passe mis à jour avec succès.',
        ]);
    }
}
