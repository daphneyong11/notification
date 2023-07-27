import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  FirebaseApi() {
    // Initialize the FlutterLocalNotificationsPlugin
    _initializeLocalNotifications();

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Initialize FlutterLocalNotificationsPlugin
  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('launcher_icon');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    _localNotifications.initialize(initializationSettings);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(handleFirebaseMessage);
  }

  Future<void> handleFirebaseMessage(RemoteMessage message) async {
    var notification = message.notification;
    if (notification == null) return;

    // Initialize AndroidNotificationDetails for the notification channel
    final AndroidNotificationDetails androidChannel = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('cat'),
      playSound: true,
    );

    // Create the notification details
    final notificationDetails = NotificationDetails(android: androidChannel);

    // Show the local notification
    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
      payload: jsonEncode(message.toMap()),
    );
  }

  @pragma('vm:entry-point')
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    var notification = message.notification;
    if (notification == null) return;

    // Initialize AndroidNotificationDetails for the notification channel
    final AndroidNotificationDetails androidChannel = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('cat'),
      playSound: true,
    );

    // Create the notification details
    final notificationDetails = NotificationDetails(android: androidChannel);

    // Show the local notification
    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
      payload: jsonEncode(message.toMap()),
    );
  }
}
