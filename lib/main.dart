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
    "private_key_id": "d2d3280286cfb290e3bfa88f13a912e455c6e400",
    "private_key":
    "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDHsVL41atYbSnx\nOrKHbDdjfPxF5eLfJ4THbZ0cmBAClZ8oFAy2ud+7ER4NQF4ObPJsKd1GLlJcVyRD\naOtI01Si/5XybmMuflleNFkasN/Wj41CHViC023r9iwWGk5hPIawixPftfxYd/zA\ndSaJovd5jnwutd5ILo+76mjDQuCWT0JfpvBGtdi8D7axtwAftN/wwdkRddon39KL\n/oD928WdMmw6uHQMigdX34hIdHbf92eNVjFo/Y8pzjlKsV17TSamxnT/2r+86kDs\n9l8J+U0h8v/03Z+kXxKg8ePnpTS6SPABaVY9eVn/FwpFD5MCTJGYUrepj/G1EL/i\ncnvbIpx3AgMBAAECggEATii+k/x1gze+6dcSl2SozTzXNLiEstkx5CioDNALvCc5\n0yL90usvgXVysLcX2UeVHvbHz7dDrzbAT84aATgN8XpeAzRnh4QWkIOmuIawJbes\nD0uTICmG5YtFuCT1tqNNCH52+eGt8iaMe/ueaNKrUB2Px2yRoujugxt9g6eCZfHQ\nDFMa7ypkMyXckxRcP6ZHvHifsZBV8NpU3/Rmhxw3p+bKLgy0c3IHKGcXk7h3CmVZ\ndsZHhO+/4E84A7a98gytKtyHzOvxDDLj8pNCl6AS2vW49R99TJ2nVelmfgOv+cCX\nn8T32FucSQ99Fhghp+Dc/0Qrdn1/GsG6/LB4zHjt0QKBgQD3nXvHAlZf12BXwF9p\n4A+H0EetQfvQbQPnCgD4ftXdJXDqwXr74Aug6LBDgAEa6q9sGxbc3175bKVsofRq\nJdB7wvGGjaZJafcjDGrpoYsnJRgVVyyB3bVvzSU7I/zlOReRl0q3mFJyNg/salKb\nMKeoBiLfGZegiOrRLDQaMR1miQKBgQDOdGl26OHHa+Ui8+15mwdOI6W2dl0ro/ZC\nnIPH6iwTCrLdNmJruiMEIsY89eEz6Mg89FxZdzGIttnafgQAnAzZH1sv9gjt4mob\nsmJ39sevaeHVYTziNrCfY3dD68klL0AbDhtj1sndRP47m/2xDMBRrB+hhoJduZP8\nXEnNyg8q/wKBgQD16jqmr6SWtLDjFZPs83CZIno9EN4E5m/Mwfuqz1SYt/mHvDXm\n9mC2IsIDl5oBYHht9g1juJd7QbKcy8+QqBOBBl+WkRFHseyWq1t2wlAPxWBAuX3j\nUAxEh8nlDV25TVUh685xvd6LvTNdSU7W/6BSWB3D0ofrEG+c47ivFn4reQKBgDpy\nGD0ydmBXOhnoBi1r5uiHDO2Xmo61LwzydBgPQgTt/W7Ea55lpm4QTiCJ1wQz/SPM\nZaxqItq6MPg6vnVRuA1rZAwy0ZpOg41ttZSShzswdV9L1MmRg/TLWsMep+Xf93zx\nRG3CK4l5c6N6aJpLqtI0MQwwIQ3ZcHx7v+UDM8IPAoGBAM/hhKShzzvN8eTOL2H/\nmQWShsZklSbmE7lkwR/lUIBFt2P0KJcT7W4ET85+Etyn6MVrXQEzmxiluzYnYIxl\nskpZGaQyMDWSotCZcYsFaPXwfADU0Uh47yws4KcPnYUAYyGuBhroNgvqCbdbP4dQ\n409MrSLu2HDxnuwyi1mgVzIZ\n-----END PRIVATE KEY-----\n",
    "client_email":
    "firebase-adminsdk-jcch7@absence-app-633e1.iam.gserviceaccount.com",
    "client_id": "117323631294260373207",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url":
    "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
    "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-jcch7%40absence-app-633e1.iam.gserviceaccount.com",
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

