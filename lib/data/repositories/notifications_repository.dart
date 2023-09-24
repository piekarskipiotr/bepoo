import 'dart:developer';
import 'dart:io';

import 'package:bepoo/data/models/notification/notification.dart' as model;
import 'package:bepoo/data/models/notification/notification_content.dart';
import 'package:bepoo/data/models/notification/notification_data.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@singleton
class NotificationRepository {
  final _instance = FirebaseMessaging.instance;
  final _messaging = FirebaseMessaging.onMessage;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );

  Stream<RemoteMessage> messageStream() => _messaging;

  Future<String?> getToken() => _instance.getToken();

  Future<void> requestPermission() async {
    final settings = await _instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      // show permission dialog
    }
  }

  Future<void> initializeNotification() async {
    await _configureLocalTimeZone();
    const initializationSettingsIOS = DarwinInitializationSettings();

    const initializationSettingsAndroid = AndroidInitializationSettings(
      'ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  void cancelAll() => flutterLocalNotificationsPlugin.cancelAll();

  void cancel(int id) => flutterLocalNotificationsPlugin.cancel(id);

  Future<void> loadFCM() async {
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> listenFCM() async {
    messageStream().listen(
      (message) {
        final notification = message.notification;
        final android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: 'launch_background',
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> sendPushMessage(
    String title,
    String body,
    List<String> tokens,
    String action,
  ) async {
    try {
      final dio = Dio(
        BaseOptions(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer 26a94cd3aa330cbbe312800b3ca366b6ff9837e1',
          },
        ),
      );

      for (final token in tokens) {
        final notification = model.Notification(
          content: NotificationContent(
            title: title,
            body: body,
          ),
          data: NotificationData(
            id: '1',
            action: action,
            status: 'done',
          ),
          priority: 'high',
          destinationToken: token,
        );

        await dio.post<void>(
          'https://fcm.googleapis.com/v1/projects/pooapp-d70ed/messages:send',
          data: notification,
        );
      }
    } catch (e) {
      log('error push notification');
    }
  }
}
