import 'package:flutter/material.dart';
import 'package:video_upload_with_fcm/core/services/push_service.dart';
import 'package:video_upload_with_fcm/core/utils/app_routes.dart';
import 'package:video_upload_with_fcm/features/auth/view/login_screen.dart';
import 'package:video_upload_with_fcm/features/auth/view/registration_screen.dart';
import 'package:video_upload_with_fcm/features/home/view/home_screen.dart';
import 'package:video_upload_with_fcm/features/splash/view/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      PushService.instance.init(navigatorKey: navigatorKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Upload with FCM',
      navigatorKey: navigatorKey, // 👈 Important
      initialRoute: AppRoutes.splash,

      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.videoDetail: (_) =>
            const Scaffold(body: Center(child: Text('Video Detail Screen'))),
        AppRoutes.photoDetail: (_) =>
            const Scaffold(body: Center(child: Text('Photo Detail Screen'))),
        AppRoutes.userProfile: (_) =>
            const Scaffold(body: Center(child: Text('User Profile Screen'))),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
