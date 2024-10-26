import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:summer_school_app/core/route_manager/page_name.dart';
import 'package:summer_school_app/view/screens/add_student/add_student_screen/add_student_screen.dart';
import 'package:summer_school_app/view/screens/details_student/student_details_screen/student_details_screen.dart';
import 'package:summer_school_app/view/screens/home/home_screen/home_screen.dart';
import 'package:summer_school_app/view/screens/home_layout/home_layout.dart';

import '../../view/screens/splash/splash_screen/splash_screen.dart';


List<GetPage> pages = [
  GetPage(
    name: PageName.splash,
    page: () => const SplashScreen(),
  ),
  GetPage(
      name: PageName.search,
      page: () => const HomeScreen(),
  ),
  GetPage(
    name: PageName.studentDetails,
    page: () => const StudentDetailsScreen(),
  ),
  GetPage(
    name: PageName.addStudent,
    page: () => const AddStudentScreen(),
  ),
  GetPage(
    name: PageName.homeLayout,
    page: () =>  HomeLayoutScreen(),
  )




  // GetPage(
  //     name: PageName.rateScreen,
  //     page: () =>  RateScreen(),
  //     transition: Transition.zoom,
  //     transitionDuration: const Duration(
  //       milliseconds: 250,
  //     )),
];
