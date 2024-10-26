import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:summer_school_app/core/route_manager/page_name.dart';
import 'package:summer_school_app/core/theme/themr.dart';

import 'core/route_manager/route_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        locale: const Locale('ar'),
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        initialRoute: PageName.splash,
        getPages: pages,
        theme: ThemeApp.light,
      ),
    );
  }
}
