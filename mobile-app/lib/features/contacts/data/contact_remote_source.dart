import 'package:dio/dio.dart';
import 'package:mdb_copilot/core/api/api_client.dart';
import 'package:mdb_copilot/features/contacts/data/contact_exception.dart';
import 'package:mdb_copilot/features/contacts/data/models/contact_model.dart';

class ContactRemoteSource {
  const ContactRemoteSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<ContactModel>> fetchAll({String? type}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null) queryParams['type'] = type;
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/contacts',
        queryParameters: queryParams,
      );
      final data = response.data!['data'] as List<dynamic>;
      return data
          .map((e) => ContactModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ContactModel> fetchById(String id) async {
    try {
      final response =
          await _apiClient.get<Map<String, dynamic>>('/contacts/$id');
      return ContactModel.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ContactModel> create(ContactModel contact) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/contacts',
        data: contact.toJson(),
      );
      return ContactModel.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ContactModel> update(String id, ContactModel contact) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        '/contacts/$id',
        data: contact.toJson(),
      );
      return ContactModel.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _apiClient.delete<Map<String, dynamic>>('/contacts/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ContactException _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const ContactNetworkException();
    }

    final statusCode = e.response?.statusCode;
    if (statusCode == 404) {
      return const ContactNotFoundException();
    }

    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      if (message != null) return ContactServerException(message);
    }

    return const ContactServerException();
  }
}
