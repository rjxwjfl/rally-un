import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rally/main.dart';

import 'notification_config.dart';

@pragma('vm:entry-point')
Future<void> onBackgroundHandler(RemoteMessage message) async {
  await firebasePermission();
  backgroundHandler(message);
}

@pragma('vm:entry-point')
void backgroundHandler(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? androidNotification = notification?.android;

  if (notification != null && androidNotification != null && !kIsWeb) {
    LocalNotification.firebaseCloudMessaging(message: message);
  }
}

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  final String payload = notificationResponse.payload ?? "";
  if (notificationResponse.payload != null || notificationResponse.payload!.isNotEmpty) {
    final data = jsonDecode(payload);

    if (data['type'] == 'route') {
      var routeData = jsonDecode(data['payload']);
      await navigatorKey.currentState?.pushNamed('/taskView');
      // GoRouter.of(navigatorKey.currentContext!).push('/group/${groupBloc.groupId}/task/${taskData.taskModel.taskId}/$date');
    }
  }
}

Future<void> firebasePermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

Future<String> getToken() async {
  String? token;
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    token = await FirebaseMessaging.instance.getAPNSToken();
  } else {
    token = await FirebaseMessaging.instance.getToken();
  }
  return token!;
}
