<?php

namespace App\Mail;

use App\Models\Invitation;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class InvitationMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public Invitation $invitation,
        public string $invitationUrl,
    ) {}

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Invitation à rejoindre MDB Copilot',
        );
    }

    public function content(): Content
    {
        return new Content(
            markdown: 'emails.invitation',
        );
    }
}
