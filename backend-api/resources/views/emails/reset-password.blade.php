<x-mail::message>
# Réinitialisation de votre mot de passe

Bonjour **{{ $user->first_name }}**,

Vous avez demandé la réinitialisation de votre mot de passe pour votre compte MDB Copilot.

<x-mail::button :url="$resetUrl">
Réinitialiser mon mot de passe
</x-mail::button>

Ce lien expire dans **60 minutes**.

Si vous n'avez pas demandé cette réinitialisation, ignorez cet email. Votre mot de passe restera inchangé.

Cordialement,<br>
L'équipe {{ config('app.name') }}
</x-mail::message>
