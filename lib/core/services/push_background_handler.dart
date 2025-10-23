// lib/core/services/push_background_handler.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as developer;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Always initialize firebase in the background isolate
  await Firebase.initializeApp();

  // Do minimal work: log or store notification to local DB / increment badge count
  developer.log('FCM background message received: ${message.messageId}');
  // Avoid heavy UI work here. Use local notifications only if necessary and safe.
}
