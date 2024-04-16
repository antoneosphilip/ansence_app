import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../../core/color_manager/color_manager.dart';

class ElevatedButtonCustom extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  final double? radius;
  final double? width;
  final double? height;
  final double? elevation;
  final Color? colors;
  final Color? textColor;
  final double? fontSize;
  final Widget? widget;
  final Color? borderColor;
  final FontWeight? fontWeight;
  final bool? disable;
  const ElevatedButtonCustom({
    this.disable = true,
    Key? key,
    this.text,
    this.onPressed,
    this.radius = 10,
    this.width = 300,
    this.height = 50,
    this.elevation = 0,
    this.colors,
    this.fontSize,
    this.textColor = ColorManager.colorWhite2,
    this.widget,
    this.borderColor = ColorManager.colorPrimary,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        // BoxShadow(
        //   color: ColorManager.colorPrimary.withOpacity(0.1),
        //
        //   blurRadius: 3.475,
        //   offset:  Offset(0, 3.475.h),
        // ),
      ]),
      child: ElevatedButton(
          onPressed: () {
            onPressed!();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius!.r),
              side: BorderSide(color: borderColor!, width: 1),
            ),
            backgroundColor: colors,
            elevation: elevation,
            textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: ColorManager.colorWhite2),
            fixedSize: Size(width!.w, height!.h),

            // padding:
            //     EdgeInsets.symmetric(horizontal: width!.w, vertical: height!.h),
          ),
          child: widget),
    );
  }
}
