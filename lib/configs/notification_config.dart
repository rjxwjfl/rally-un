import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rally/configs/fcm_config.dart';

class LocalNotification {
  LocalNotification._();

  static AndroidNotificationChannel highImportant = const AndroidNotificationChannel(
      'high_priority', 'high_priority_channel');
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static initialize() async {
    flutterLocalNotificationsPlugin.cancelAll();
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings(
        'mipmap/ic_launcher');

    DarwinInitializationSettings iOSInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings =
    InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  static Future<void> requestNotificationPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation!.requestNotificationsPermission();
    }
  }

  static Future<void> firebaseCloudMessaging(
      {required RemoteMessage message}) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max,
          priority: Priority.max,
          fullScreenIntent: true);

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails(
          badgeNumber: 1,
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: jsonEncode(message.data),
      );
    }
  }
}

  // static Future<void> setReminder({required TodoModel data}) async {
  //   tz.TZDateTime date = setDate(dateTime: data.replicatedTodo.executionDate);
  //
  //   AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
  //     '${data.todoData.todoId}',
  //     data.todoData.title,
  //     channelDescription: data.replicatedTodo.description,
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     showWhen: true,
  //   );
  //
  //   NotificationDetails platformChannelSpecifics = NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: const DarwinNotificationDetails(
  //       badgeNumber: 1,
  //       presentAlert: true,
  //       presentBadge: true,
  //       presentSound: true,
  //     ),
  //   );
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       data.replicatedTodo.replicatedId, data.todoData.title, data.replicatedTodo.description, date, platformChannelSpecifics,
  //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  //