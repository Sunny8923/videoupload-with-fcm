import 'package:video_upload_with_fcm/core/services/api_client.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final ApiClient _api = ApiClient();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _api.post(
        '/v1/auth/token',
        data: {
          'grant_type': 'password',
          'username': username,
          'password': password,
        },
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      print('[AuthRepository] ❌ Dio error: ${e.response?.data}');
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setAccessToken(String token) async {
    print('[AuthRepository] → setAccessToken() $token');
    await _api.setAccessToken(token);
  }

  Future<void> logout() async {
    await _api.clearAuth();
  }

  Future<void> register(String email, String password, String username) async {
    await _api.post(
      '/v1/auth/register',
      data: {
        'email': email,
        'password': password,
        'role': 'user',
        'username': username,
      },
    );
  }
}
