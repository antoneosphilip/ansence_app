import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis/authorizedbuyersmarketplace/v1.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:workmanager/workmanager.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import '../../core/color_manager/color_manager.dart';
import '../../model/get_absence_model/get_absence_model.dart';
import '../../utility/database/local/absence.dart';
import '../../utility/database/local/cache_helper.dart';
import '../../utility/database/local/student.dart';
import '../../utility/database/network/dio-helper.dart';
import '../../utility/database/network/end_points.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Executing background task: $task");

    await Firebase.initializeApp();
    await DioHelper.init();
    await CacheHelper.init();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
    await Hive.initFlutter();
    Hive.registerAdapter(AbsenceAdapter());
    Hive.registerAdapter(StudentDataAdapter());
    // استلام الإشعارات عند تلقيها
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          'Received message: ${message.notification?.title}, ${message.notification?.body}');
      const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          'default_channel_id', // معرف القناة
          'Default Channel', // اسم القناة
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
          // أيقونة مخصصة
          color: ColorManager.colorPrimary,
          // لون الإشعار (أخضر)
          sound: RawResourceAndroidNotificationSound('notification'),
          // صوت مخصص
          actions: [
            AndroidNotificationAction(
              'action_1',
              'Open',
            ),
            AndroidNotificationAction(
              'action_2',
              'Dismiss',
            )
          ]);

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

      await _flutterLocalNotificationsPlugin.show(
        0, // معرف الإشعار (يمكن تغييره حسب الحاجة)
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        notificationDetails,
      );
    });

    Future<String> getAccessToken() async {
      final Map<String, dynamic> serviceAccountJson = <String, String>{
        "type": "service_account",
        "project_id": "absence-app-633e1",
        "private_key_id": "cafd3ade563bc0d724e8814a8aaa198ce967eaa9",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC/KRec3DfcMnm0\ncnzXFvzVYUqfULqqrGCoFTL4Ff1NuQGQFMZA1TD5MhFrjprQmkPB6q1GNJ0W7cRe\n4NvLGeFuJTKmfUWm8jhO93l9p6MUkCN3YsFSyauzuALV/CpnO6bjlCB0wqYoAdlO\n95EMCZB61i+w2NeYgWW6jMfuR0LaG09Rcw/wH7g6hL4QCeGbfavaM8Ud2xusDXp3\n41IcBD+QjfNxXdUqET5wyF2w0/iMlDH3vS/Q4eVEntvIoYqQFG8dh2DW5opq8fQU\nL9nfO8aUrnPxWdO/HQTsKozJZxo6m3Pw51AziAkTglWd4IJBHr3y79f8zbl3gecl\nBGTEYpxtAgMBAAECggEAJMI33G27XyAkp5aRW4H73eNOyGprbrjlgETNT4fY9Opj\nustH4T0tpOmkEGj0a7MSXvZr2fFxmLBhf7YhBcHlB7tm7T1vGJ6AxeyQI+HJugFK\nlKE8mBkYJ5+1ieTq2X2Oxrnb8N/iOBS87xKrhWNMcVaBBrJ36MdPIsuCAZeZ6xsa\nWEibTLLurGYi2MYusoNPvcq+B+r5r8KKdGvDBlT8NM2WX+d1bDP2HhCqF5koZpIe\n374bDmE1j3eMGKmF/v5txgJRW4qO7AV6DFPQQrqXVvvWYmI1XxKZBMUswD8EHlYv\nPNbArxu8Tgf9u+X7+qHO8b2yBmHtnVYE+fPeu2/+qQKBgQDywEtwOB+Ty+8T0CtL\n/nv8gxpvvOpy7+yc4uxXRz58M3+kiQ23JxSZmrVW7MabbnbpS7g6uwMLpPjvbRNS\nMiQZAZWCPjSjht4iZ8Nfd2zXotak+2agbYu3NWA0bJa/0H93I4tz+tSn7r7+qfdu\nSBKI01Mug5UUSg6pIf/Q3uJKKQKBgQDJl/nkBI8FsguwQQlzyB9dBC2gI/aAlwfc\nJT1G5PZiLmyyqzuO3fEf4Gc79mE1iA+Nh0mLyK15NJzD+XzzQPzw1KqymDBUtLUm\na/c2+lr3I8qGn694Dg9uKGwMRL8pB4un/dAGQO3vlCsSaoiisL1mAK0dqsSFcSSu\nqvSY3fxQpQKBgBL+iOiW+6GM64AZYcnod7siZwcnOREVROZhuyx5HqKJRQuSzcfu\n/uWl/Vp33HJ9CkDm89tklrBqkC/r0P81fS2XuiMeyu+gtfDrPZZSuemFjFYMddNH\nvw7u1kBD3ufTYKXp2heRIOKjA77ZfcrbSNf78R5KnXeg89S4HFQznHFBAoGAO4Vp\nvM8zw0S8er/ZIJxX1kjjh8LWh0UQhwlfvEziCj8WzPIN1bLl/LlvAZ9POFUB8pGd\nP25y+bR1DM/e+puXkyvXcn/I1Vm9mqiKB2uH7CxfIbyIPHQ6ThYVQNITdvPJYkJo\nZ1BIcFJZHUjjKtXwNevBMV84QwYTBJdpPLFeTBkCgYEA1Wu5pJruZjOthDBmyBFq\nYH3sMi0z7dIf4bXZMLEg4vPt/k922v4vKUnmjXPWZ4pvKfdXw0ga8hTBJaiP2SUk\nMGJdKQuYmJ8yLeNA+m4za5YkY9XhrCZ6dUVU3L9qqKoUevZZdoC0ATq4dLekA9vR\n0NF4a662d70d/snTLJa7YCY=\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-jcch7@absence-app-633e1.iam.gserviceaccount.com",
        "client_id": "117323631294260373207",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-jcch7%40absence-app-633e1.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      };
      List<String> scopes = [
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/firebase.database",
        "https://www.googleapis.com/auth/firebase.messaging"
      ];
      http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
      );
      auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);
      client.close();
      return credentials.accessToken.data;
    }

    final String accessToken = await getAccessToken();

    if (task == "task1") {
      final box = await Hive.openBox<List<dynamic>>('studentsAbsenceBox');
      List<dynamic> studentDataList = box.get('studentsAbsence') ?? [];
      print("ssdsdasdasdasdasdasdasd");
      if (studentDataList.isNotEmpty) {
        try {
          for (var studItem in studentDataList) {
            print("listttttt${studItem.name}");
            await DioHelper.putData(
              url: EndPoint.updateStudentAbsence(studItem.absences.last.id!),
              data: {
                'Id': studItem.absences.last.id,
                'StudentId': studItem.absences.last.studentId,
                'AbsenceDate': studItem.absences.last.absenceDate!,
                'AbsenceReason': studItem.absences.last.absenceReason!,
                'attendant': studItem.absences.last.attendant,
              },
            );
            print("${studItem.name} upload success");
          }
          // تنظيف البيانات
          studentDataList.clear();
          await box.put('studentsAbsence', studentDataList);
          var body = {
            "message": {
              "token": token,
              "notification": {
                "title": "تم إرسال بيانات الغياب",
                "body": "تم إرسال بيانات الغياب إلى السيرقر بنجاح"
              },
              "android": {
                "notification": {"sound": "notification"}
              }
            }
          };
          try {
            final http.Response response = await http.post(
              Uri.parse(EndPoint.sendNotification),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken'
              },
              body: jsonEncode(body),
            );
            if (response.statusCode == 200) {
              print('Notification sent successfully');
            } else {
              print('Failed to send notification${response.body}');
            }
          } catch (e) {
            print("errror${e}");
          }
          print("Task executed successfully.");
        } catch (e) {
          try {
            var body = {
              "message": {
                "token": token,
                "notification": {
                  "title": "حدث خطأ في ارسال البيانات الي السيرفر",
                  "body": "حدث خطأ في ارسال بيانات الغياب الي السيرفر"
                },
                "android": {
                  "notification": {"sound": "notification"}
                }
              }
            };

            final http.Response response = await http.post(
              Uri.parse(EndPoint.sendNotification),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken'
              },
              body: jsonEncode(body),
            );
            if (response.statusCode == 200) {
              print('Notification sent successfully');
            } else {
              print('Failed to send notification${response.body}');
            }
          } catch (e) {
            print("errror${e}");
          }
          print("Error in background task: $e");
        }
      }
    }
    if (task == "task2") {
      print("successsssss");
      final now = DateTime.now();

      if (now.weekday == DateTime.friday && now.hour < 15) {
        try {
          final response = await DioHelper.getData(url: EndPoint.getAllAbsence);
          final box = await Hive.openBox<List<dynamic>>('studentsBox');
          List<dynamic> jsonData = response.data;

          await box.clear();
          List<dynamic> studentList = [];
          List<Student> allStudentData =
          jsonData.map((item) => Student.fromJson(item)).toList();

          for (var item in allStudentData) {
            final student = item;
            print("studId ${student.absences!.last.id}");
            // final lastAbsenceStudent=item.student.absences!.last;
            final lastAbsence = student.absences?.isNotEmpty == true
                ? Absence(
              id: student.absences!.last.id!,
              studentId: student.absences!.last.studentId!,
              absenceDate: student.absences!.last.absenceDate!,
              absenceReason: student.absences!.last.absenceReason!,
              attendant: student.absences!.last.attendant!,
            )
                : null;

            final studentModel = StudentData(
              id: student.id!,
              name: student.studentName!,
              studentClass: student.studentClass!,
              level: student.level!,
              birthDate: student.birthDate,
              absences: lastAbsence != null ? [lastAbsence] : [],
              gender: student.gender!,
              notes: student.notes ?? "",
              numberOfAbsences: student.numberOfAbsences!,
              shift: student.shift!,
              age: student.age,
              dadPhone: student.dadPhone,
              mamPhone: student.mamPhone,
              studPhone: student.studPhone,
              profileImage: student.profileImage,
            );

            if (!studentList
                .any((s) => s.id == studentModel.id || studentList.isEmpty)) {
              studentList.add(studentModel);
            }
          }

          await box.put('students', studentList);
          var body = {
            "message": {
              "token": token,
              "notification": {
                "title": "تم تحميل الداتا بنجاح",
                "body": "تم تحميل داتا الطلاب بنجاح"
              },
              "android": {
                "notification": {"sound": "notification"}
              }
            }
          };
          try {
            final http.Response response = await http.post(
              Uri.parse(EndPoint.sendNotification),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $accessToken'
              },
              body: jsonEncode(body),
            );
            if (response.statusCode == 200) {
              print('Notification sent successfully');
            } else {
              print('Failed to send notification${response.body}');
            }
          } catch (e) {
            print("errror${e}");
          }

          print("Data stored successfully!");
        } catch (e) {
          print("error in download data");
        }
      } else {
        print("nowww${now.weekday}");
        print(DateTime.sunday);
        print("الوقت أو اليوم غير مناسبين");
      }
    }
    if (task == "task3") {
      var body = {
        "message": {
          "token": token,
          "notification": {
            "title":
            "ثُمَّ بَعْدَ أَيَّامٍ قَالَ بُولُسُ لِبَرْنَابَا: «لِنَرْجِعْ وَنَفْتَقِدْ إِخْوَتَنَا فِي كُلِّ مَدِينَةٍ نَادَيْنَا فِيهَا بِكَلِمَةِ الرَّبِّ، كَيْفَ هُم» ْ(أع 15: 36)",
            "body": "متنساش افتقادك"
          },
          "android": {
            "notification": {"sound": "notification"}
          }
        }
      };
      try {
        final http.Response response = await http.post(
          Uri.parse(EndPoint.sendNotification),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
          body: jsonEncode(body),
        );
        if (response.statusCode == 200) {
          print('Notification sent successfully');
        } else {
          print('Failed to send notification${response.body}');
        }
      } catch (e) {
        print("errror${e}");
      }
    }

    return Future.value(true);
  });
}