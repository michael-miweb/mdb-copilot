<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdatePropertyRequest extends FormRequest
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
            'address' => ['sometimes', 'required', 'string', 'max:500'],
            'surface' => ['sometimes', 'required', 'integer', 'min:1'],
            'price' => ['sometimes', 'required', 'integer', 'min:0'],
            'property_type' => ['sometimes', 'required', 'in:appartement,maison,terrain,immeuble,commercial'],
            'agent_name' => ['nullable', 'string', 'max:255'],
            'agent_agency' => ['nullable', 'string', 'max:255'],
            'agent_phone' => ['nullable', 'string', 'max:50'],
            'sale_urgency' => ['nullable', 'in:not_specified,low,medium,high'],
            'notes' => ['nullable', 'string', 'max:10000'],
        ];
    }
}
