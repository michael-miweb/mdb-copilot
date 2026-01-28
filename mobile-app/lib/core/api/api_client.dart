import 'package:dio/dio.dart';
import 'package:mdb_copilot/core/api/token_storage.dart';

class ApiClient {
  ApiClient({
    required String baseUrl,
    required TokenStorage tokenStorage,
    Dio? dio,
  })  : _tokenStorage = tokenStorage,
        _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['Content-Type'] = 'application/json';

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) => handler.next(error),
      ),
    );
  }

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
  }) {
    return _dio.post<T>(path, data: data);
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
  }) {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) {
    return _dio.delete<T>(path);
  }
}
