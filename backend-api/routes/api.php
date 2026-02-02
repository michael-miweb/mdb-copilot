<?php

// Permissions RBAC :
// owner: full access
// guest-read: read-only access to properties, pipeline
// guest-extended: read + update properties, read pipeline

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ContactController;
use App\Http\Controllers\Api\InvitationController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\PropertyController;
use Illuminate\Support\Facades\Route;

Route::get('/health', function () {
    return response()->json(['status' => 'ok']);
});

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/forgot-password', [AuthController::class, 'forgotPassword'])
    ->middleware('throttle:5,1');
Route::post('/auth/reset-password', [AuthController::class, 'resetPassword']);
Route::post('/invitations/accept', [InvitationController::class, 'accept']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/user', [AuthController::class, 'user']);

    Route::put('/profile', [ProfileController::class, 'updateProfile']);
    Route::put('/profile/password', [ProfileController::class, 'updatePassword']);

    Route::apiResource('properties', PropertyController::class);

    Route::middleware('abilities:owner')->group(function () {
        Route::apiResource('contacts', ContactController::class);
        Route::post('/invitations', [InvitationController::class, 'store']);
        Route::get('/invitations', [InvitationController::class, 'index']);
        Route::delete('/invitations/{invitation}', [InvitationController::class, 'revoke']);
    });
});
