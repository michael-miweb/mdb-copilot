<x-mail::message>
# Invitation à rejoindre MDB Copilot

Bonjour,

**{{ $invitation->owner->first_name }} {{ $invitation->owner->last_name }}** vous invite à rejoindre son espace MDB Copilot en tant que **{{ $invitation->role === 'guest-read' ? 'consultant' : 'collaborateur étendu' }}**.

<x-mail::button :url="$invitationUrl">
Accepter l'invitation
</x-mail::button>

Ce lien expire le **{{ $invitation->expires_at->format('d/m/Y à H:i') }}**.

Si vous n'êtes pas concerné par cette invitation, ignorez cet email.

Cordialement,<br>
L'équipe {{ config('app.name') }}
</x-mail::message>
