import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> setupFirebase() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    // إعداد الإشعارات المحلية
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // الحصول على FCM Token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // استلام الإشعارات عند تلقيها
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}, ${message.notification?.body}');
      _showNotification(message);
    });
  }

  // عرض الإشعار باستخدام flutter_local_notifications
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'default_channel_id',  // معرف القناة
        'Default Channel',     // اسم القناة
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',  // أيقونة مخصصة
        color: ColorManager.colorPrimary,  // لون الإشعار (أخضر)
        sound: RawResourceAndroidNotificationSound('notification'),  // صوت مخصص
        actions: [
          AndroidNotificationAction('action_1', 'Open',),
          AndroidNotificationAction('action_2', 'Dismiss',)
        ]
    );


    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      0, // معرف الإشعار (يمكن تغييره حسب الحاجة)
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }
}
