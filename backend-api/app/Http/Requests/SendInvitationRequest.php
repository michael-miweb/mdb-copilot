<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class SendInvitationRequest extends FormRequest
{
    /**
     * @return array<string, array<int, string>>
     */
    public function rules(): array
    {
        return [
            'email' => ['required', 'email'],
            'role' => ['required', 'in:guest-read,guest-extended'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'email.required' => "L'adresse email est requise.",
            'email.email' => "L'adresse email n'est pas valide.",
            'role.required' => 'Le rôle est requis.',
            'role.in' => 'Le rôle doit être guest-read ou guest-extended.',
        ];
    }
}
