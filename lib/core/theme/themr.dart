import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../color_manager/color_manager.dart';

abstract class ThemeApp {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: null, // Uses system font with crisp rendering
        scaffoldBackgroundColor: ColorManager.colorScaffold,
        primaryColor: ColorManager.colorPrimary,
        colorScheme: const ColorScheme.light(
          primary: ColorManager.colorPrimary,
          secondary: ColorManager.colorCyan,
          surface: ColorManager.colorWhite,
          error: ColorManager.colorRed,
          onPrimary: ColorManager.colorWhite,
          onSecondary: ColorManager.colorWhite,
          onSurface: ColorManager.colorDarkBlue,
          onError: ColorManager.colorWhite,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          titleTextStyle: TextStyle(
            color: ColorManager.colorDarkBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: ColorManager.colorDarkBlue,
          ),
        ),
        cardTheme: CardThemeData(
          color: ColorManager.colorWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: ColorManager.colorGrey4,
              width: 1,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColorManager.colorWhite,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: ColorManager.colorGrey4, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: ColorManager.colorGrey4, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: ColorManager.colorPrimary, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: ColorManager.colorRed, width: 1.2),
          ),
          hintStyle: const TextStyle(
            color: ColorManager.colorXXGrey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIconColor: ColorManager.colorPrimary,
          suffixIconColor: ColorManager.colorXXGrey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.colorPrimary,
            foregroundColor: ColorManager.colorWhite,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: ColorManager.colorWhite,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: ColorManager.colorWhite,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorManager.colorPrimary,
          selectionColor: ColorManager.colorPrimary.withOpacity(0.2),
          selectionHandleColor: ColorManager.colorPrimary,
        ),
      );
}
