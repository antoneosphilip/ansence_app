import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../color_manager/color_manager.dart';

abstract class TextStyleManager {
  static final TextStyle textStyle36w700 = TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.w700,
      color: ColorManager.colorSecondary
  );
  static final TextStyle textStyle20w700 = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w500,
      color: ColorManager.colorWhite
  );
  static final TextStyle textStyle18Bold = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: ColorManager.colorWhite
  );

}
