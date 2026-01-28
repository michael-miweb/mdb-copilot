import 'package:dio/dio.dart';
import 'package:mdb_copilot/core/api/api_client.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';

class ProfileRemoteSource {
  const ProfileRemoteSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (email != null) data['email'] = email;

      final response = await _apiClient.put<Map<String, dynamic>>(
        '/profile',
        data: data,
      );

      return UserModel.fromJson(
        response.data!['user'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _apiClient.put<Map<String, dynamic>>(
        '/profile/password',
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
      );
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

    if (statusCode == 422 && data is Map<String, dynamic>) {
      final errors = data['errors'] as Map<String, dynamic>?;
      if (errors != null &&
          errors.containsKey('current_password')) {
        return const AuthException(
          'Le mot de passe actuel est incorrect.',
        );
      }
      final message = data['message'] as String?;
      return ServerException(message);
    }

    if (statusCode == 401) {
      return const InvalidCredentialsException();
    }

    return const ServerException();
  }
}
