import 'package:dio/dio.dart';
import 'package:mdb_copilot/core/api/api_client.dart';
import 'package:mdb_copilot/features/auth/data/auth_exception.dart';
import 'package:mdb_copilot/features/auth/data/models/user_model.dart';
import 'package:mdb_copilot/features/invitations/data/models/invitation_model.dart';

class InvitationRemoteSource {
  const InvitationRemoteSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<InvitationModel> sendInvitation({
    required String email,
    required String role,
  }) async {
    try {
      final response =
          await _apiClient.post<Map<String, dynamic>>(
        '/invitations',
        data: {'email': email, 'role': role},
      );
      final data = response.data!;
      return InvitationModel.fromJson(
        data['invitation'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<InvitationModel>> getInvitations() async {
    try {
      final response =
          await _apiClient.get<Map<String, dynamic>>(
        '/invitations',
      );
      final data = response.data!;
      final list = data['data'] as List<dynamic>;
      return list
          .map(
            (e) => InvitationModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> revokeInvitation(String invitationId) async {
    try {
      await _apiClient.delete<void>(
        '/invitations/$invitationId',
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<({UserModel user, String token})> acceptInvitation({
    required String token,
    required String firstName,
    required String lastName,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response =
          await _apiClient.post<Map<String, dynamic>>(
        '/invitations/accept',
        data: {
          'token': token,
          'first_name': firstName,
          'last_name': lastName,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      final data = response.data!;
      return (
        user: UserModel.fromJson(
          data['user'] as Map<String, dynamic>,
        ),
        token: data['token'] as String,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AuthException _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (statusCode == 403) {
      return const AuthException('Accès non autorisé.');
    }

    if (statusCode == 404) {
      return const AuthException('Invitation introuvable.');
    }

    if (statusCode == 422 && data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      return ServerException(message);
    }

    return const ServerException();
  }
}
