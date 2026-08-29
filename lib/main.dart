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
import 'core/constants/service_account_keys.dart';
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
          print("listtttt222222${studItem.lastAttendance ?? studItem.absences?.last?.studentId}");
          print("listttt333333${studItem.lastAttendance}");

          await DioHelper.putData(
            url: EndPoint.updateStudentAbsence(studItem.absences.last.id!),
            data: {
              'id': studItem.absences.last.id,
              'studentId': studItem.absences.last.studentId,
              'absenceDate': studItem.absences.last.absenceDate,
              'absenceReason': studItem.absences.last.absenceReason ?? '',
              'Attendant': studItem.lastAttendance ?? studItem.absences.last.attendant,
              'ServantId': CacheHelper.getDataString(key: 'id')
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
  List<String> scopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging"
  ];

  http.Client client = await auth.clientViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(ServiceAccountKeys.credentials),
    scopes,
  );

  auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(ServiceAccountKeys.credentials),
          scopes,
          client);

  client.close();
  return credentials.accessToken.data;
}
