class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException()
      : super('Identifiants incorrects.');
}

class EmailAlreadyUsedException extends AuthException {
  const EmailAlreadyUsedException()
      : super('Cette adresse email est déjà utilisée.');
}

class NetworkException extends AuthException {
  const NetworkException()
      : super('Erreur réseau. Vérifiez votre connexion.');
}

class ServerException extends AuthException {
  const ServerException([String? message])
      : super(message ?? 'Erreur serveur. Réessayez plus tard.');
}
