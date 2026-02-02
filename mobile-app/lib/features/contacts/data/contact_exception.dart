class ContactException implements Exception {
  const ContactException([this.message = 'Une erreur est survenue.']);

  final String message;

  @override
  String toString() => message;
}

class ContactNetworkException extends ContactException {
  const ContactNetworkException()
      : super('Connexion impossible. Vérifiez votre réseau.');
}

class ContactServerException extends ContactException {
  const ContactServerException([super.message = 'Erreur serveur.']);
}

class ContactNotFoundException extends ContactException {
  const ContactNotFoundException() : super('Contact introuvable.');
}
