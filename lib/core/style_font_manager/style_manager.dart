import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../color_manager/color_manager.dart';

abstract class TextStyleManager {
  static final TextStyle textStyle36w700 = TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: ColorManager.colorSecondary
  );
  static final TextStyle textStyle20w700 = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w500,
      color: ColorManager.colorWhite
  );
  static final TextStyle textStyle20Bold = TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: ColorManager.colorWhite
  );
  static final TextStyle textStyle22w800 = TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w800,
  );
  static final TextStyle textStyle20w500 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,

  );


}
