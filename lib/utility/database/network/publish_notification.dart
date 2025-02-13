import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/view/core_widget/flutter_toast/flutter_toast.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> setupFirebase() async {
    try {
      // طلب الإذن للإشعارات
      NotificationSettings settings = await _requestNotificationPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission: ${settings.authorizationStatus}');

        // إعداد الإشعارات المحلية
        await _initializeLocalNotifications();

        // الحصول على FCM Token
        String? token = await _firebaseMessaging.getToken();
        print("FCM Token: $token");

        // استلام الإشعارات عند تلقيهائ
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('Received message: ${message.notification?.title}, ${message.notification?.body}');
          _showNotification(message);
        });
      } else {
        print('User denied or did not determine notification permission.');
      }
    } catch (e) {
      print("Error during Firebase setup: $e");
      showFlutterToast(
        message: "حدث خطأ أثناء إعداد الإشعارات",
        state: ToastState.ERROR,
      );
    }
  }

  Future<NotificationSettings> _requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    while (settings.authorizationStatus == AuthorizationStatus.notDetermined ||
        settings.authorizationStatus == AuthorizationStatus.denied) {
      showFlutterToast(
        message: "تم رفض الإذن. برجاء قبول إذن الإشعارات.",
        state: ToastState.ERROR,
      );

      settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        showFlutterToast(
          message: "تم رفض الإذن. حاول لاحقًا.",
          state: ToastState.WARNING,
        );
        break;
      }
    }
    return settings;
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher', // أيقونة مخصصة
      color: ColorManager.colorPrimary, // لون الإشعار (أخضر)
      sound: RawResourceAndroidNotificationSound('notification'), // صوت مخصص
      actions: [
        AndroidNotificationAction('action_1', 'Open'),
        AndroidNotificationAction('action_2', 'Dismiss'),
      ],
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
