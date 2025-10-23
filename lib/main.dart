import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:video_upload_with_fcm/app.dart';
import 'package:video_upload_with_fcm/core/services/push_background_handler.dart';
import 'package:video_upload_with_fcm/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Register top-level background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // After runApp you can call PushService.init (it needs navigatorKey from app)
  // Alternatively, call it inside a top-level Provider or inside MyApp's initState
  runApp(const ProviderScope(child: MyApp()));
}
