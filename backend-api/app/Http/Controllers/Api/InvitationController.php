<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\AcceptInvitationRequest;
use App\Http\Requests\SendInvitationRequest;
use App\Mail\InvitationMail;
use App\Models\Invitation;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;

class InvitationController extends Controller
{
    public function store(SendInvitationRequest $request): JsonResponse
    {
        /** @var array{email: string, role: string} $data */
        $data = $request->validated();

        if (User::where('email', $data['email'])->exists()) {
            return response()->json([
                'message' => 'Cet email possède déjà un compte.',
            ], 422);
        }

        $pendingInvitation = Invitation::where('email', $data['email'])
            ->whereNull('accepted_at')
            ->where('expires_at', '>', now())
            ->exists();

        if ($pendingInvitation) {
            return response()->json([
                'message' => 'Une invitation est déjà en attente pour cet email.',
            ], 422);
        }

        /** @var User $owner */
        $owner = $request->user();

        $invitation = Invitation::create([
            'owner_id' => $owner->id,
            'email' => $data['email'],
            'role' => $data['role'],
            'token' => Str::random(64),
            'expires_at' => now()->addDays(7),
        ]);

        /** @var string $frontendUrl */
        $frontendUrl = config('app.frontend_url');
        $invitationUrl = $frontendUrl . '/invitations/accept?token=' . $invitation->token;
        Mail::to($invitation->email)->send(new InvitationMail($invitation, $invitationUrl));

        return response()->json([
            'invitation' => $invitation,
            'message' => 'Invitation envoyée avec succès.',
        ], 201);
    }

    public function accept(AcceptInvitationRequest $request): JsonResponse
    {
        /** @var array{token: string, first_name: string, last_name: string, password: string} $data */
        $data = $request->validated();

        $invitation = Invitation::where('token', $data['token'])->first();

        if ($invitation === null) {
            return response()->json([
                'message' => 'Invitation introuvable.',
            ], 404);
        }

        if ($invitation->isExpired()) {
            return response()->json([
                'message' => 'Cette invitation a expiré.',
            ], 422);
        }

        if ($invitation->isAccepted()) {
            return response()->json([
                'message' => 'Cette invitation a déjà été acceptée.',
            ], 422);
        }

        $user = User::create([
            'first_name' => $data['first_name'],
            'last_name' => $data['last_name'],
            'email' => $invitation->email,
            'password' => $data['password'],
            'role' => $invitation->role,
        ]);

        $invitation->update(['accepted_at' => now()]);

        $abilities = [$invitation->role];
        $token = $user->createToken('auth-token', $abilities)->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ]);
    }

    public function index(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $invitations = $user->invitations()
            ->orderByDesc('created_at')
            ->get()
            ->map(function (Invitation $invitation): array {
                $status = 'pending';
                if ($invitation->isAccepted()) {
                    $status = 'accepted';
                } elseif ($invitation->isExpired()) {
                    $status = 'expired';
                }

                return [
                    ...$invitation->toArray(),
                    'status' => $status,
                ];
            });

        return response()->json([
            'data' => $invitations,
        ]);
    }

    public function revoke(Request $request, Invitation $invitation): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        if ($invitation->owner_id !== $user->id) {
            return response()->json([
                'message' => 'Accès non autorisé.',
            ], 403);
        }

        $invitation->delete();

        return response()->json([
            'message' => 'Invitation révoquée.',
        ]);
    }
}
