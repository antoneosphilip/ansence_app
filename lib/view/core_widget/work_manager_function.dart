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
import '../../model/get_absence_model/get_capacity.dart';
import '../../utility/database/local/absence.dart';
import '../../utility/database/local/cache_helper.dart';
import '../../utility/database/local/student.dart';
import '../../utility/database/network/dio-helper.dart';
import '../../utility/database/network/end_points.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Executing background task: $task");
    print("versionnn 2 $task");

    await Firebase.initializeApp();
     DioHelper.init();
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
        "private_key_id": "6263d2238691f39f8184e0cdaa3f0e9da04bc32d",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC0+fVfPQA8Y9C+\n5Mkl+BEsoLBOeTQpmEUoa2DwoGAdsaxiAbtZsKBMw6lH1Ok0k8sJJZ7gnLJ5WZPU\n+GH4JAb0NCYhF/ig2hxKRk8LJIqN33Q5XB+o57rKQihZOQwZDOyItVWD0FCEtcBN\n0tLuCjDe1N6iL7CMb58MCFAvCXRVCh/oEidWN1eKuHViR2dKENLOYWBPzk6ojid8\nJPtRkIKz73d8pNQSxWYuEsG6Ts+q1RJPfbYsdl5/GE/2TruEH0/pIlCwR5jRKZS1\nXfQWLTXEEeIJfr907CP2/gXAq4YaRZ/wtMpg41hZ6uqwtpLnMgHwQivrB0fBPMiu\nWLewKopRAgMBAAECggEAH0EDpRzty4AZbr4oFsyOeryNdh/saDqJxv80UJoBv18N\nvCc8abLdHCS2OVeFprTXXY8Hrxago+BabW8vzCC8qrPO2ew/3deNBy65O91lqDas\n5bMJLKxIT+G5Ah+d/T2EI9/dEtSI80JIIaiFEOLlqbXtdOjzfm1QdE2DO3xQgNbi\nOApXuhi+4u1M41bIk7FcbtXZDln6eZMlY/b6kSri/jsqusNKfyAqeEE1sjDXXYBS\nffC++X30V8RZQ4jgbkCdEReccN9ffdvOAWqgWeo5nqPAJh7L92Q4jpmQ/Cx3EWKb\nV6fpUTo/+4IGMReLN3K7oRb6zkWQcf2jKQmPuzuqmQKBgQDoTwa9l0aHaPUnamnx\ncUYhpvBET5sSc+VNG2Jhi9QaiBFJaRqi93spbLqdaXcYVeoiRb5sWaWFeuvHAV6f\njPNzIyPiyFDlkZPX2EQIaRFWtyCoBL/dypkMr/AzAKwVUsDUuN15kndBanQ3F9Es\napBaWAPCgfzGb1Bf7DHIwF3urwKBgQDHbsem/NxAvGGM1YmASTVzOCDQoVvLcDNw\nfybKQ43mIgw10EVbWWLmqI+x4MbaP1ivNOA+9gjyOFE+okkXsAi6ZkFv1yO0FH1E\nadJE9o/Tcz0psM7wXQJXxJXz6kMiHUv1dtQsF8MlDhblG3U/yUPl2INED5kIaOb/\n+QJRlQVW/wKBgQDBwMeacQU+AugVS8e4vAUGJDnYf5ySs17YBLL1MK5iwoHIfITe\nzxJF5o1upHvULDPvCcRckhhfT7o+bIIDCIgzy2cuymvOTLDGIXX8ncT8UhhGik+M\nKGGmF0d7AmCEGFUEFnuB3grg4Gy1VoP7S5XCBA5+t/OffU/H8TNEgEzXuQKBgQC7\nE/MbdRWTcGM9vk4G1iXamGtH6iV22CCYxd34XJhuqb+0d1OoVlhNMQ/id41xy3yA\nlmRJC3jm5udnjspr+wik+ikmJbVrRtEfbPj/Eh9m5jIYuq/UkBsTg+h6b2VcSgko\nELkFR6EaUHYvoqtBE6aqpIi2Pr96QRV4Rvji2JyytwKBgQCJUNWvn2/bQuNl7RS+\nS5lNJMwj1YATCncTAbNBEpoi0GMmZ893FMFCRH75gm034cht479tOitC5hHfPxml\nJWH5PiTVwApcrFQPpNGnPbtwE43zOSiF58KNFTgjddA9jaRJlw1KNOWIEjhn0+5S\nyicpTHDsO911lA41oHjX+XbCuw==\n-----END PRIVATE KEY-----\n",
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
            print("listttttt${studItem}");
            print("listtttt222222${studItem.absences.last.studentId}");
            print("listttt333333${studItem.absences.last.alhanAttendant}");

            await DioHelper.putData(
              url: EndPoint.updateStudentAbsence(studItem.absences.last.id!),
              data: {
                'id': studItem.absences.last.id,
                'studentId': studItem.absences.last.studentId,
                'absenceDate': studItem.absences.last.absenceDate,
                'absenceReason': studItem.absences.last.absenceReason ?? '',
                'Attendant': studItem.lastAttendance,
                'ServantId':CacheHelper.get(key: 'id')
              },
            );
            print("${studItem.absences.last.alhanAttendant} upload success");
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

      if (now.weekday == DateTime.saturday && now.hour < 15 ) {
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
            print("studId ${student.absences?.last.id??""}");
            // final lastAbsenceStudent=item.student.absences!.last;
            final lastAbsence = student.absences?.isNotEmpty == true
                ? Absence(
              id: student.absences?.last.id??"0",
              studentId: student.absences?.last.studentId??"0",
              absenceDate: student.absences?.last.absenceDate??"",
              absenceReason: student.absences?.last.absenceReason??"",
              attendant: student.lastAttendance??true,

            )
                : null;

            final studentModel = StudentData(
              id: student.id??"",
              name: student.studentName??"",
              studentClass: student.studentClass??0,
              level: student.level??0,
              birthDate: student.birthDate,
              absences: lastAbsence != null ? [lastAbsence] : [],
              gender: student.gender??0,
              notes: student.notes ?? "",
              numberOfAbsences: student.numberOfAbsences??0,
              shift: student.shift??0,
              age: student.age,
              dadPhone: student.dadPhone,
              mamPhone: student.mamPhone,
              studPhone: student.studPhone,
              profileImage: student.profileImage, lastAttendance:
            student.lastAttendance??true,
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
          try{
            final capacityResponse= await DioHelper.getData(
              url: EndPoint.getCapacity,
              queryParameters: {'servantId':  CacheHelper.getDataString(key: 'id')},
            );
            final capacityBox = await Hive.openBox<List<dynamic>>('capacityBox');
            await capacityBox.clear();
            final capacityModel=ClassStatisticsResponse.fromJson(capacityResponse.data);
            // ✅ Convert ClassStatistics objects to JSON maps
            List<Map<String, dynamic>> classesJson =
            capacityModel.classes.map((cls) => cls.toJson()).toList();

            await capacityBox.put('capacity', classesJson);
            print("storeee capacirttyyy ${classesJson}");
          }
          catch(e){
            print("errror capacityyy${e}");

          }
          print("Data stored successfully!");
        } catch (e) {
          print("error in download dataaaaaaaa ${e}");
        }
      }
      else {
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