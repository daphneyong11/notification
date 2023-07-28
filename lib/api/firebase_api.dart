import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(jsonEncode(message.toMap()));
}

Future<void> handleFirebaseMessage(RemoteMessage message) async {
  print(jsonEncode(message.toMap()));
  var notification = message.notification;
  if (notification == null) return;

  // Create the notification details
  var notificationDetails = NotificationDetails(android: androidChannel);

  // Show the local notification
  await _localNotifications.show(
    notification.hashCode,
    notification.title,
    notification.body,
    notificationDetails,
    payload: jsonEncode(message.toMap()),
  );
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  
  FirebaseApi() {
    // Initialize the FlutterLocalNotificationsPlugin
    _initializeLocalNotifications();

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

  }

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
    //FirebaseMessaging.onMessage.listen(handleFirebaseMessage);
  }

}
