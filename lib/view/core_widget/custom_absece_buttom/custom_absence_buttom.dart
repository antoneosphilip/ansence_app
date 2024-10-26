import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:summer_school_app/core/color_manager/color_manager.dart';
import 'package:summer_school_app/core/style_font_manager/style_manager.dart';

class CustomAbsenceButton extends StatelessWidget {
  final String text;
  final Widget screen;
  final Transition transition;
  const CustomAbsenceButton({super.key, required this.text, required this.screen,  this.transition=Transition.rightToLeft});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: ColorManager.colorPrimary, // Tex,t color
          padding:   EdgeInsets.symmetric(horizontal: 48.w, vertical: 15.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r), // Rounded corners
          ),
        ),
        onPressed: () {
          Get.to(
            screen,
            transition: transition, // Slide in from right
            duration: const Duration(milliseconds: 350), // Adjust animation speed
          );
        },
        child: Text(text,style: TextStyleManager.textStyle20w700,),
      ),
    );
  }
}
