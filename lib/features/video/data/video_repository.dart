import 'dart:io';
import 'package:dio/dio.dart';
import 'package:video_upload_with_fcm/core/constants/api_endpoints.dart';
import 'package:video_upload_with_fcm/core/services/api_client.dart';

class VideoRepository {
  final ApiClient _client = ApiClient();

  Future<Response> uploadVideo(
    File videoFile, {
    required void Function(int, int) onSendProgress,
  }) async {
    print('\n[VideoRepo] 🚀 Starting video upload...');
    print('[VideoRepo] Video path: ${videoFile.path}');
    final fileName = videoFile.path.split('/').last;

    final token = await _client.getStoredToken();
    if (token == null || token.isEmpty) {
      print('[VideoRepo] ❌ No token found! Upload will fail.');
      throw Exception('No token found. Please log in first.');
    }

    print('[VideoRepo] ✅ Token retrieved successfully.');

    // Create FormData
    print('[VideoRepo] 🧩 Preparing FormData with file: $fileName');
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        videoFile.path,
        filename: fileName,
        contentType: DioMediaType('video', 'mp4'),
      ),
    });

    try {
      print('[VideoRepo] 🌐 Upload request started...');
      final response = await _client.dio.post(
        ApiEndpoints.uploadVideo,
        data: formData,
        onSendProgress: (sent, total) {
          final progress = total > 0
              ? (sent / total * 100).toStringAsFixed(1)
              : '0';
          print(
            '[VideoRepo] 📤 Uploading... $progress% ($sent / $total bytes)',
          );
          onSendProgress(sent, total);
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('[VideoRepo] ✅ Upload successful!');
      print('[VideoRepo] Response status: ${response.statusCode}');
      print('[VideoRepo] Response data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('[VideoRepo] ❌ DioException during upload!');
      print('[VideoRepo] Status: ${e.response?.statusCode}');
      print('[VideoRepo] Data: ${e.response?.data}');
      print('[VideoRepo] Message: ${e.message}');
      rethrow;
    } catch (e) {
      print('[VideoRepo] ❌ Unexpected error during upload: $e');
      rethrow;
    }
  }

  Future<Response> getVideos() async {
    print('\n[VideoRepo] 🔍 Fetching uploaded videos list...');
    try {
      final response = await _client.get(ApiEndpoints.getVideos);
      print('[VideoRepo] ✅ Fetch successful, status: ${response.statusCode}');
      print('[VideoRepo] Response data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('[VideoRepo] ❌ Error fetching videos!');
      print('[VideoRepo] Status: ${e.response?.statusCode}');
      print('[VideoRepo] Data: ${e.response?.data}');
      rethrow;
    }
  }
}
