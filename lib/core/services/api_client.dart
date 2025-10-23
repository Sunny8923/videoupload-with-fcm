// core/services/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient._internal()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://media-upload-1.onrender.com',
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    dio.interceptors.add(QueuedAuthInterceptor(this));
  }

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  /// --- Simple HTTP methods ---
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) => dio.get<T>(
    path,
    queryParameters: query,
    options: Options(headers: headers),
  );

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) => dio.post<T>(
    path,
    data: data,
    options: Options(headers: headers),
  );

  /// --- Secure token handling ---
  static const _tokenKey = 'access_token';

  Future<void> setAccessToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<String?> getStoredToken() async => await _storage.read(key: _tokenKey);

  Future<void> clearAuth() async {
    await _storage.delete(key: _tokenKey);
    dio.options.headers.remove('Authorization');
  }
}

/// Interceptor that automatically adds Authorization header
class QueuedAuthInterceptor extends Interceptor {
  final ApiClient _client;

  QueuedAuthInterceptor(this._client);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final stored =
          options.headers['Authorization'] ?? await _client.getStoredToken();
      if (stored is String && stored.isNotEmpty) {
        options.headers['Authorization'] = stored.startsWith('Bearer ')
            ? stored
            : 'Bearer $stored';
      }
    } catch (_) {
      // ignore errors
    }
    handler.next(options);
  }
}
