import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:summer_school_app/core/route_manager/page_name.dart';
import 'package:summer_school_app/core/route_manager/route_manager.dart';
import 'package:summer_school_app/core/theme/themr.dart';
import 'package:summer_school_app/utility/database/local/absence.dart';
import 'package:summer_school_app/utility/database/local/cache_helper.dart';
import 'package:summer_school_app/utility/database/local/student.dart';
import 'package:summer_school_app/utility/database/network/dio-helper.dart';
import 'package:summer_school_app/utility/database/network/end_points.dart';
import 'package:summer_school_app/utility/database/network/publish_notification.dart';
import 'package:summer_school_app/view/core_widget/custom_animation/custom_animation.dart';
import 'package:summer_school_app/view/core_widget/custom_loading/custom_loading.dart';
import 'package:summer_school_app/view/core_widget/work_manager_function.dart';
import 'package:summer_school_app/view/screens/setting/setting_screen/loading_Screen.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_cubit.dart';
import 'package:summer_school_app/view_model/block/absence_cubit/absence_states.dart';
import 'package:summer_school_app/view_model/block/login_cubit/login_cubit.dart';
import 'package:summer_school_app/view_model/repo/absence_repo/absence.dart';
import 'package:summer_school_app/view_model/repo/auth_repo/auth.dart';
import 'package:workmanager/workmanager.dart';

import 'core/color_manager/color_manager.dart';
import 'core/service_locator/service_locator.dart';
import 'model/get_absence_model/get_absence_model.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup();
  await DioHelper.init();
  await CacheHelper.init();
  // final appDocumentDir = await getApplicationDocumentsDirectory();
  // await Hive.initFlutter(appDocumentDir.path); // تهيئة Hive
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(AbsenceAdapter()); // Register the Absence adapter
  Hive.registerAdapter(StudentDataAdapter()); // Regist er StudentData adapter
  Workmanager().initialize(callbackDispatcher, isInDebugMode: !kReleaseMode);
  Workmanager().registerPeriodicTask("task-identifier", "task1",
      constraints: Constraints(networkType: NetworkType.connected),
      frequency: const Duration(minutes:17));
  Workmanager().registerPeriodicTask(
    "download_data", "task2",
    constraints: Constraints(networkType: NetworkType.connected),
    frequency: const Duration(hours:2),
  );
  Workmanager().registerPeriodicTask(
    "alarm", "task3",
    frequency: const Duration(hours:24),
  );

  print("Workmanager initialized successfully");
  final pushNotificationService = PushNotificationService();

  await pushNotificationService.setupFirebase();

  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _requestIgnoreBatteryOptimizations();
    }
    // Defer cubit usage until after the first frame is rendered.
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        print("online");
        initAysnc();
      }
      else{
        print("offline");

      }
    });



  }


  Future<void> initAysnc() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    String? token = await _firebaseMessaging.getToken();

    final String accessToken = await getAccessToken();
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
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              AbsenceCubit(sl.get<AbsenceRepo>())..checkConnection(),
        ),
        BlocProvider(
          create: (BuildContext context) =>
          AuthCubit(sl.get<AuthRepo>()),
        ),
      ],
      child: BlocBuilder<AbsenceCubit, AbsenceStates>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(360, 800),
            minTextAdapt: true,
            splitScreenMode: true,
            child: state is GetAllAbsenceLoadingState
                ?Padding(
                  padding:  EdgeInsets.only(bottom: 190.h),
                  child: const Center(child: CustomLoading()),
                )
                : GetMaterialApp(
                    locale: const Locale('ar'),
                    useInheritedMediaQuery: true,
                    debugShowCheckedModeBanner: false,
                    initialRoute: PageName.login,
                    getPages: pages,
                    theme: ThemeApp.light,
                    builder: EasyLoading.init(),
                  ),
          );
        },
      ),
    );
  }
}

void _requestIgnoreBatteryOptimizations() async {
  // استدعاء الـ Intent لتوجيه المستخدم إلى صفحة إعدادات تجاوز تحسين البطارية
  const intent = AndroidIntent(
    action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
    data: 'package:com.example.summer_school_app', // استبدل 'your.package.name' باسم الباكدج الخاص بتطبيقك
  );
  await intent.launch();
}

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

