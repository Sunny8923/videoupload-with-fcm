import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:video_upload_with_fcm/features/auth/data/auth_repository.dart';
import 'package:video_upload_with_fcm/core/utils/app_routes.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, bool>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<bool> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final _repo = AuthRepository();

  @override
  bool build() {
    ref.onDispose(() {
      print('[AuthViewModel] Disposing controllers...');
      emailController.dispose();
      passwordController.dispose();
    });
    return false;
  }

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter email & password')));
      return;
    }

    state = true;
    try {
      final tokenData = await _repo.login(email, password);
      final token = tokenData['access_token'] as String?;

      if (token == null || token.isEmpty) {
        throw Exception('No access token returned');
      }

      await _repo.setAccessToken(token);
      passwordController.clear();

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?.toString() ?? e.message ?? 'Unknown error';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $message')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally {
      state = false;
    }
  }

  Future<void> register(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final username = usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter all fields')));
      return;
    }

    state = true;
    try {
      print('[AuthViewModel] → register() called');
      await _repo.register(email, password, username);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please login.')),
      );

      // Navigate to login screen
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?.toString() ?? e.message ?? 'Unknown error';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: $message')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    } finally {
      state = false;
    }
  }
}
