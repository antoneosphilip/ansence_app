import 'dart:convert';

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
import 'package:summer_school_app/view_model/repo/absence_repo/absence.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              AbsenceCubit(sl.get<AbsenceRepo>())..checkConnection(),
        )
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
                    initialRoute: PageName.splash,
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


