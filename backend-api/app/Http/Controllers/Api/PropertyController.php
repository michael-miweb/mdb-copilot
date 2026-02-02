<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StorePropertyRequest;
use App\Http\Requests\UpdatePropertyRequest;
use App\Http\Resources\PropertyResource;
use App\Models\Property;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class PropertyController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        /** @var User $user */
        $user = $request->user();

        $properties = Property::where('user_id', $user->id)
            ->orderByDesc('created_at')
            ->get();

        return PropertyResource::collection($properties);
    }

    public function store(StorePropertyRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $property = Property::create([
            ...$request->validated(),
            'user_id' => $user->id,
            'sale_urgency' => $request->validated('sale_urgency', 'not_specified'),
        ]);

        return (new PropertyResource($property))
            ->response()
            ->setStatusCode(201);
    }

    public function show(Request $request, Property $property): PropertyResource
    {
        /** @var User $user */
        $user = $request->user();

        if ((int) $property->user_id !== (int) $user->id) {
            abort(403);
        }

        return new PropertyResource($property);
    }

    public function update(UpdatePropertyRequest $request, Property $property): PropertyResource
    {
        /** @var User $user */
        $user = $request->user();

        if ((int) $property->user_id !== (int) $user->id) {
            abort(403);
        }

        $property->update($request->validated());

        return new PropertyResource($property->fresh());
    }

    public function destroy(Request $request, Property $property): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        if ((int) $property->user_id !== (int) $user->id) {
            abort(403);
        }

        $property->delete();

        return response()->json(['message' => 'Fiche supprimée.']);
    }
}
