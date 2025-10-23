import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_upload_with_fcm/core/services/api_client.dart';
import 'package:video_upload_with_fcm/features/auth/data/auth_repository.dart';

final splashViewModelProvider = FutureProvider<bool>((ref) async {
  print('[SplashVM] Checking stored token...');
  final api = ApiClient();
  final repo = AuthRepository();

  final token = await api.getStoredToken();
  if (token == null || token.isEmpty) {
    print('[SplashVM] ❌ No token found');
    return false;
  }

  print('[SplashVM] ✅ Token found, setting in client');
  await repo.setAccessToken(token);

  // Instead of calling /users/me, just trust token presence
  print('[SplashVM] 🚀 Proceeding with token validation skipped');
  return true;
});
