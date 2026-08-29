import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color_manager/color_manager.dart';

abstract class TextStyleManager {
  static TextStyle get textStyle36w700 => GoogleFonts.cairo(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: ColorManager.colorSecondary,
      );

  static TextStyle get textStyle20w700 => GoogleFonts.cairo(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: ColorManager.colorWhite,
      );

  static TextStyle get textStyle20Bold => GoogleFonts.cairo(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: ColorManager.colorWhite,
      );

  static TextStyle get textStyle22w800 => GoogleFonts.cairo(
        fontSize: 20.sp,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get textStyle20w500 => GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get textStyle12w500 => GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get textStyle14w500 => GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get textStyle12w400 => GoogleFonts.cairo(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get textStyle16w600 => GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get textStyle16w800 => GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get textStyle18w600 => GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get textStyle16w400 => GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get textStyle18w500 => GoogleFonts.cairo(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      );
}
