// core/providers/session_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_upload_with_fcm/core/services/api_client.dart';
import 'package:video_upload_with_fcm/features/auth/data/auth_repository.dart';

final sessionProvider = FutureProvider<bool>((ref) async {
  print('[SessionProvider] Checking for stored token...');
  final api = ApiClient();
  final repo = AuthRepository();

  final token = await api.getStoredToken();
  if (token == null || token.isEmpty) {
    print('[SessionProvider] ❌ No token found');
    return false;
  }

  print('[SessionProvider] ✅ Token found, validating...');
  await repo.setAccessToken(token);
  return true;
});
