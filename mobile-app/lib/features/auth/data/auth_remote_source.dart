import 'package:dio/dio.dart';
import 'package:mdb_copilot/core/api/api_client.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';

class AuthRemoteSource {
  const AuthRemoteSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<({UserModel user, String token})> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final data = response.data!;
      return (
        user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
        token: data['token'] as String,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<({UserModel user, String token})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data!;
      return (
        user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
        token: data['token'] as String,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post<void>('/auth/logout');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> getUser() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/auth/user');
      return UserModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AuthException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (statusCode == 401) {
      return const InvalidCredentialsException();
    }

    if (statusCode == 422 && data is Map<String, dynamic>) {
      final errors = data['errors'] as Map<String, dynamic>?;
      if (errors != null && errors.containsKey('email')) {
        return const EmailAlreadyUsedException();
      }
      final message = data['message'] as String?;
      return ServerException(message);
    }

    return const ServerException();
  }
}
