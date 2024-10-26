import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../core/assets_manager/assets_manager.dart';
import '../../../../core/color_manager/color_manager.dart';
import '../../../../core/route_manager/page_name.dart';
import '../../../../core/style_font_manager/style_manager.dart';
import '../../../../core/text_manager/text_manager.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();

}

class _SplashWidgetState extends State<SplashWidget> {

  void initState() {
    // TODO: implement initState
    super.initState();
    navigateToLogin();
  }
  navigateToLogin() async{
    await Future.delayed(const Duration(milliseconds: 4000),(){});
    Get.offAllNamed(PageName.homeLayout);
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360.w,
      height: 800.h,

      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AssetsImage.logo2),
        ],
      ),
    );
  }
}
