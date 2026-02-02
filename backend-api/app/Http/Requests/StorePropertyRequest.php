<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePropertyRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, array<int, string>>
     */
    public function rules(): array
    {
        return [
            'address' => ['required', 'string', 'max:500'],
            'surface' => ['required', 'integer', 'min:1'],
            'price' => ['required', 'integer', 'min:0'],
            'property_type' => ['required', 'in:appartement,maison,terrain,immeuble,commercial'],
            'agent_name' => ['nullable', 'string', 'max:255'],
            'agent_agency' => ['nullable', 'string', 'max:255'],
            'agent_phone' => ['nullable', 'string', 'max:50'],
            'sale_urgency' => ['nullable', 'in:not_specified,low,medium,high'],
            'notes' => ['nullable', 'string', 'max:10000'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'address.required' => "L'adresse est obligatoire.",
            'surface.required' => 'La surface est obligatoire.',
            'surface.min' => 'La surface doit être supérieure à 0.',
            'price.required' => 'Le prix est obligatoire.',
            'price.min' => 'Le prix ne peut pas être négatif.',
            'property_type.required' => 'Le type de bien est obligatoire.',
            'property_type.in' => 'Le type de bien est invalide.',
            'sale_urgency.in' => "Le niveau d'urgence est invalide.",
        ];
    }
}
