import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_upload_with_fcm/core/utils/app_routes.dart';
import '../viewmodel/splash_viewmodel.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(splashViewModelProvider);

    return Scaffold(
      body: Center(
        child: sessionAsync.when(
          data: (isLoggedIn) {
            Future.microtask(() {
              Navigator.pushReplacementNamed(
                context,
                isLoggedIn ? AppRoutes.home : AppRoutes.login,
              );
            });
            return const CircularProgressIndicator();
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, _) {
            print('[SplashScreen] ❌ Error: $err');
            Future.microtask(() {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            });
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
