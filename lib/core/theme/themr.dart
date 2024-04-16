import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../color_manager/color_manager.dart';

abstract class ThemeApp {
  static ThemeData get light => ThemeData(
    // appBarTheme: const AppBarTheme(
    //     backgroundColor: ColorsManager.whiteXXColor, elevation: 0),
    // fontFamily: GoogleFonts.aBeeZee().fontFamily,

    scaffoldBackgroundColor: ColorManager.colorScaffold,
    primaryColor: ColorManager.colorPrimary,
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: ColorManager.colorWhite),
    textTheme:  TextTheme(
      bodyLarge: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: ColorManager.colorBlack,
      ),
      bodySmall: TextStyle(
        fontSize: 16.0.sp,
        fontWeight: FontWeight.normal,
        color: ColorManager.colorBlack,
      ),
      bodyMedium: TextStyle(
        fontSize: 24.0.sp,
        fontWeight: FontWeight.w900,
        color: ColorManager.colorBlack,
      ),

    ),

    // fontFamily: GoogleFonts.barlowCondensed().fontFamily,
  );

  static ThemeData get dark => ThemeData(
    // appBarTheme: const AppBarTheme(
    //     backgroundColor: ColorsManager.whiteXXColor, elevation: 0),
    // fontFamily: GoogleFonts.aBeeZee().fontFamily,

    scaffoldBackgroundColor: ColorManager.colorDark,
    primaryColor: ColorManager.colorPrimary,
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: ColorManager.colorDark,)

    // fontFamily: GoogleFonts.barlowCondensed().fontFamily,
  );
}
