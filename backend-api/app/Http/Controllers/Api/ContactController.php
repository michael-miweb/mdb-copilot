<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreContactRequest;
use App\Http\Requests\UpdateContactRequest;
use App\Http\Resources\ContactResource;
use App\Models\Contact;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class ContactController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        /** @var User $user */
        $user = $request->user();

        $query = Contact::where('user_id', $user->id)
            ->orderBy('last_name')
            ->orderBy('first_name');

        if ($request->has('type')) {
            $query->where('contact_type', $request->query('type'));
        }

        return ContactResource::collection($query->get());
    }

    public function store(StoreContactRequest $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        $contact = Contact::create([
            ...$request->validated(),
            'user_id' => $user->id,
        ]);

        return (new ContactResource($contact))
            ->response()
            ->setStatusCode(201);
    }

    public function show(Request $request, Contact $contact): ContactResource
    {
        /** @var User $user */
        $user = $request->user();

        if ($contact->user_id !== $user->id) {
            abort(403);
        }

        return new ContactResource($contact);
    }

    public function update(UpdateContactRequest $request, Contact $contact): ContactResource
    {
        /** @var User $user */
        $user = $request->user();

        if ($contact->user_id !== $user->id) {
            abort(403);
        }

        $contact->update($request->validated());

        return new ContactResource($contact->fresh());
    }

    public function destroy(Request $request, Contact $contact): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        if ($contact->user_id !== $user->id) {
            abort(403);
        }

        $contact->delete();

        return response()->json(['message' => 'Contact supprimé.']);
    }
}
