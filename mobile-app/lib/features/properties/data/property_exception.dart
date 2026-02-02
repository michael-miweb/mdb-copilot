class PropertyException implements Exception {
  const PropertyException([this.message = 'Une erreur est survenue.']);

  final String message;

  @override
  String toString() => message;
}

class PropertyNetworkException extends PropertyException {
  const PropertyNetworkException()
      : super('Connexion impossible. Vérifiez votre réseau.');
}

class PropertyServerException extends PropertyException {
  const PropertyServerException([super.message = 'Erreur serveur.']);
}

class PropertyNotFoundException extends PropertyException {
  const PropertyNotFoundException()
      : super('Fiche introuvable.');
}
