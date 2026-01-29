<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\ForgotPasswordRequest;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Requests\ResetPasswordRequest;
use App\Mail\ResetPasswordMail;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(RegisterRequest $request): JsonResponse
    {
        $user = User::create($request->validated());

        $token = $user->createToken('auth-token', ['owner'])->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    public function login(LoginRequest $request): JsonResponse
    {
        if (! Auth::attempt($request->validated())) {
            return response()->json([
                'message' => 'Identifiants incorrects.',
            ], 401);
        }

        /** @var User $user */
        $user = Auth::user();
        $abilities = match ($user->role) {
            'guest-read' => ['guest-read'],
            'guest-extended' => ['guest-extended'],
            default => ['owner'],
        };
        $token = $user->createToken('auth-token', $abilities)->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        /** @var \App\Models\User $user */
        $user = $request->user();
        $user->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Déconnexion réussie.',
        ]);
    }

    public function user(Request $request): JsonResponse
    {
        return response()->json($request->user());
    }

    public function forgotPassword(ForgotPasswordRequest $request): JsonResponse
    {
        $email = $request->validated()['email'];
        $user = User::where('email', $email)->first();

        // Silent failure — don't leak user existence
        if ($user) {
            $token = Str::random(64);

            DB::table('password_reset_tokens')->updateOrInsert(
                ['email' => $email],
                [
                    'token' => Hash::make($token),
                    'created_at' => now(),
                ],
            );

            Mail::to($user)->send(new ResetPasswordMail($user, $token));
        }

        return response()->json([
            'message' => 'Lien de réinitialisation envoyé.',
        ]);
    }

    /**
     * @throws ValidationException
     */
    public function resetPassword(ResetPasswordRequest $request): JsonResponse
    {
        /** @var array{token: string, email: string, password: string, password_confirmation: string} $validated */
        $validated = $request->validated();

        $resetRecord = DB::table('password_reset_tokens')
            ->where('email', $validated['email'])
            ->first();

        /** @var string|null $storedToken */
        $storedToken = $resetRecord?->token;

        if (! $resetRecord || ! $storedToken || ! Hash::check($validated['token'], $storedToken)) {
            throw ValidationException::withMessages([
                'token' => ['Le lien de réinitialisation est invalide.'],
            ]);
        }

        /** @var string $createdAt */
        $createdAt = $resetRecord->created_at;
        $tokenCreatedAt = Carbon::parse($createdAt);
        if ($tokenCreatedAt->diffInMinutes(now(), false) > 60) {
            DB::table('password_reset_tokens')
                ->where('email', $validated['email'])
                ->delete();

            throw ValidationException::withMessages([
                'token' => ['Le lien de réinitialisation a expiré.'],
            ]);
        }

        $user = User::where('email', $validated['email'])->first();

        if (! $user) {
            throw ValidationException::withMessages([
                'email' => ['Aucun utilisateur trouvé avec cette adresse email.'],
            ]);
        }

        $user->password = $validated['password'];
        $user->save();

        // Revoke all existing tokens
        $user->tokens()->delete();

        DB::table('password_reset_tokens')
            ->where('email', $validated['email'])
            ->delete();

        return response()->json([
            'message' => 'Mot de passe réinitialisé.',
        ]);
    }
}
