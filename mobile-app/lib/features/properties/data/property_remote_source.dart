import 'package:dio/dio.dart';
import 'package:mdb_copilot/core/api/api_client.dart';
import 'package:mdb_copilot/features/properties/data/models/property_model.dart';
import 'package:mdb_copilot/features/properties/data/property_exception.dart';

class PropertyRemoteSource {
  const PropertyRemoteSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<PropertyModel>> fetchAll() async {
    try {
      final response =
          await _apiClient.get<Map<String, dynamic>>('/properties');
      final data = response.data!['data'] as List<dynamic>;
      return data
          .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PropertyModel> fetchById(String id) async {
    try {
      final response =
          await _apiClient.get<Map<String, dynamic>>('/properties/$id');
      return PropertyModel.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PropertyModel> create(PropertyModel property) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/properties',
        data: property.toJson(),
      );
      return PropertyModel.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PropertyModel> update(String id, PropertyModel property) async {
    try {
      final response = await _apiClient.put<Map<String, dynamic>>(
        '/properties/$id',
        data: property.toJson(),
      );
      return PropertyModel.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _apiClient.delete<Map<String, dynamic>>('/properties/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  PropertyException _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const PropertyNetworkException();
    }

    final statusCode = e.response?.statusCode;
    if (statusCode == 404) {
      return const PropertyNotFoundException();
    }

    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      if (message != null) return PropertyServerException(message);
    }

    return const PropertyServerException();
  }
}
