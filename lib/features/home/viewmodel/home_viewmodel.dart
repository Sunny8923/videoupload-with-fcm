import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_upload_with_fcm/features/auth/data/auth_repository.dart';
import 'package:video_upload_with_fcm/core/utils/app_routes.dart';

final homeViewModelProvider = NotifierProvider<HomeViewModel, bool>(
  HomeViewModel.new,
);

class HomeViewModel extends Notifier<bool> {
  final _authRepo = AuthRepository();

  @override
  bool build() => false;

  Future<void> logout(BuildContext context) async {
    state = true;
    try {
      print('[HomeViewModel] → logout() called');
      await _authRepo.logout();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged out successfully')));

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
    } catch (e) {
      print('[HomeViewModel] ❌ Logout error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    } finally {
      state = false;
    }
  }
}
