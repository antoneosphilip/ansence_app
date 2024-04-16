import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:summer_school_app/core/route_manager/page_name.dart';
import 'package:summer_school_app/view/screens/search/search_screen/search_screen.dart';

import '../../view/screens/splash/splash_screen/splash_screen.dart';


List<GetPage> pages = [

  GetPage(
      name: PageName.search,
      page: () => const SearchScreen(),
  )


  // GetPage(
  //     name: PageName.rateScreen,
  //     page: () =>  RateScreen(),
  //     transition: Transition.zoom,
  //     transitionDuration: const Duration(
  //       milliseconds: 250,
  //     )),
];
