import 'package:mdb_copilot/core/api/token_storage.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/auth/data/auth_remote_source.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';

class AuthRepository {
  const AuthRepository({
    required AuthRemoteSource remoteSource,
    required TokenStorage tokenStorage,
  })  : _remoteSource = remoteSource,
        _tokenStorage = tokenStorage;

  final AuthRemoteSource _remoteSource;
  final TokenStorage _tokenStorage;

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final result = await _remoteSource.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    await _tokenStorage.saveToken(result.token);
    return result.user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteSource.login(
      email: email,
      password: password,
    );
    await _tokenStorage.saveToken(result.token);
    return result.user;
  }

  Future<void> logout() async {
    try {
      await _remoteSource.logout();
    } on AuthException {
      // Continue logout even if API fails
    } finally {
      await _tokenStorage.deleteToken();
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final token = await _tokenStorage.getToken();
    if (token == null) return null;

    try {
      return await _remoteSource.getUser();
    } on AuthException {
      // Token invalid, clear it
      await _tokenStorage.deleteToken();
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _tokenStorage.getToken();
    return token != null;
  }
}
