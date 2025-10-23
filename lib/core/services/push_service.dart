// lib/core/services/push_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../utils/app_routes.dart'; // ✅ Import your route constants

class PushService {
  PushService._();
  static final instance = PushService._();

  final _fcm = FirebaseMessaging.instance;
  final _local = FlutterLocalNotificationsPlugin();

  Future<void> init({required GlobalKey<NavigatorState> navigatorKey}) async {
    await _fcm.requestPermission();

    // 🔥 Fetch and log token
    final token = await _fcm.getToken();
    debugPrint('🔥 FCM Token: $token');

    // 🔔 Local notifications setup
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (res) {
        _handleTap(res.payload, navigatorKey);
      },
    );

    // 🟢 Foreground message listener
    FirebaseMessaging.onMessage.listen((msg) {
      _showLocal(msg);
    });

    // 🟡 App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      _handleTap(jsonEncode(msg.data), navigatorKey);
    });

    // 🔵 App opened from terminated
    final initialMsg = await _fcm.getInitialMessage();
    if (initialMsg != null) {
      _handleTap(jsonEncode(initialMsg.data), navigatorKey);
    }
  }

  // 🔔 Show local notification for foreground messages
  void _showLocal(RemoteMessage msg) {
    final n = msg.notification;
    final p = jsonEncode(msg.data);

    _local.show(
      msg.hashCode,
      n?.title ?? 'Notification',
      n?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Default Channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: p,
    );
  }

  // 🧭 Handle notification tap and route navigation
  void _handleTap(String? payload, GlobalKey<NavigatorState> nav) {
    if (payload == null) return;

    final data = jsonDecode(payload);

    // 🔹 Example payload: { "type": "video", "id": "123" }
    String? route;
    Object? args;

    switch (data['type']) {
      case 'video':
        route = AppRoutes.videoDetail;
        args = data; // or data['id'] if you only need id
        break;

      case 'photo':
        route = AppRoutes.photoDetail;
        args = data;
        break;

      case 'user':
        route = AppRoutes.userProfile;
        args = data;
        break;

      default:
        route = AppRoutes.home;
    }

    // Push the route only if navigator is ready
    final context = nav.currentContext;
    if (context != null) {
      nav.currentState?.pushNamed(route, arguments: args);
    }
  }
}
