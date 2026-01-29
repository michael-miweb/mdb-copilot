<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class ResetPasswordMail extends Mailable
{
    use Queueable, SerializesModels;

    public string $resetUrl;

    public function __construct(
        public User $user,
        public string $token,
    ) {
        $email = urlencode($user->email);
        /** @var string $frontendUrl */
        $frontendUrl = config('app.frontend_url', 'https://mdb-copilot.app');
        $this->resetUrl = "{$frontendUrl}/reset-password?token={$token}&email={$email}";
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Réinitialisation de votre mot de passe',
        );
    }

    public function content(): Content
    {
        return new Content(
            markdown: 'emails.reset-password',
        );
    }
}
