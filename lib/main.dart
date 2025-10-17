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
import 'package:summer_school_app/view/screens/home/home_widget/local_statistic.dart';
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
   DioHelper.init();
  await CacheHelper.init();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(AbsenceAdapter());
  Hive.registerAdapter(StudentDataAdapter());
  Hive.registerAdapter(ClassStatisticsAdapter());

  Workmanager().initialize(callbackDispatcher, isInDebugMode: !kReleaseMode);
  Workmanager().registerPeriodicTask("task-identifier", "task1",
      constraints: Constraints(networkType: NetworkType.connected),
      frequency: const Duration(minutes:17));
  Workmanager().registerPeriodicTask(
    "download_data", "task2",
    constraints: Constraints(networkType: NetworkType.connected),
    frequency: const Duration(minutes:15),
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
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _requestIgnoreBatteryOptimizations();
    }

    _subscription = Connectivity().onConnectivityChanged.listen(
          (result) {
        if (!mounted) return; // تحقق من mounted قبل أي عملية

        if (result.contains(ConnectivityResult.wifi) ||
            result.contains(ConnectivityResult.mobile)) {
          print("online");
          initAysnc();

        } else {
          print("offline");
        }
      },
      onError: (error) {
        print("Connectivity error: $error");
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel(); // إلغاء الـ subscription
    super.dispose();
  }

  Future<void> initAysnc() async {
    if (!mounted) return;

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();
    final String accessToken = await getAccessToken();
    final box = await Hive.openBox<List<dynamic>>('studentsAbsenceBox');
    List<dynamic> studentDataList = box.get('studentsAbsence') ?? [];

    print("ssdsdasdasdasdasdasdasd");
    if (studentDataList.isNotEmpty) {
      try {
        for (var studItem in studentDataList) {
          print("listttttt${studItem}");
          print("listtttt222222${studItem.lastAttendance}");
          print("listttt333333${studItem.lastAttendance}");

          await DioHelper.putData(
            url: EndPoint.updateStudentAbsence(studItem.absences.last.id!),
            data: {
              'id': studItem.absences.last.id,
              'studentId': studItem.absences.last.studentId,
              'absenceDate': studItem.absences.last.absenceDate,
              'absenceReason': studItem.absences.last.absenceReason ?? '',
              'Attendant': studItem.lastAttendance,
              'ServantId':CacheHelper.getDataString(key: 'id')
            },
          );
          print("${studItem.lastAttendance} upload success");
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
        print("Error in background task upload: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
          AbsenceCubit(sl.get<AbsenceRepo>())..checkConnection()
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
            child: GetMaterialApp(
              locale: const Locale('ar'),
              useInheritedMediaQuery: true,
              debugShowCheckedModeBanner: false,
              initialRoute: CacheHelper.getDataString(key: 'id') != null
                  ? PageName.homeLayout
                  : PageName.login,
              getPages: pages,
              theme: ThemeApp.light,

              builder: (context, widget) {
                Widget child = widget ?? SizedBox.shrink();

                child = EasyLoading.init()(context, child);

                return Stack(
                  children: [
                    child,
                    if (state is GetAllAbsenceLoadingState)
                      Container(
                        color: Colors.black54,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 190.h),
                            child: const CustomLoading(),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

void _requestIgnoreBatteryOptimizations() async {
  const intent = AndroidIntent(
    action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
    data: 'package:com.example.summer_school_app',
  );
  await intent.launch();
}

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
