import 'package:flutter/material.dart';

class ColorManager {
  // Brand Core Colors
  static const Color colorPrimary = Color(0xff4F46E5); // Indigo 600
  static const Color colorXPrimary = Color(0xff6366F1); // Indigo 500
  static const Color colorPrimary2 = Color(0xff4338CA); // Indigo 700
  static const Color colorPrimaryLight = Color(0xffEEF2FF); // Indigo 50
  static const Color colorPrimaryDark = Color(0xff312E81); // Indigo 900
  static const Color colorThird = Color(0xff8B5CF6); // Purple 500

  // Semantic & Status
  static const Color colorGreen = Color(0xff10B981); // Emerald 500
  static const Color colorGreenLight = Color(0xffECFDF5);
  static const Color colorRed = Color(0xffF43F5E); // Rose 500
  static const Color colorRedLight = Color(0xffFFF1F2);
  static const Color colorGold = Color(0xffF59E0B); // Amber 500
  static const Color colorGoldLight = Color(0xffFFFBEB);
  static const Color colorBlue = Color(0xff0EA5E9); // Sky 500
  static const Color colorCyan = Color(0xff06B6D4); // Cyan 500
  static const Color colorTeal = Color(0xff14B8A6); // Teal 500

  // Neutrals & Surfaces
  static const Color colorWhite = Color(0xffFFFFFF);
  static const Color colorWhite2 = Color(0xffF8FAFC); // Slate 50
  static const Color colorScaffold = Color(0xffF1F5F9); // Slate 100
  static const Color colorGrey4 = Color(0xffE2E8F0); // Slate 200
  static const Color colorXGrey = Color(0xffCBD5E1); // Slate 300
  static const Color colorGrey = Color(0xff94A3B8); // Slate 400
  static const Color colorXXGrey = Color(0xff64748B); // Slate 500
  static const Color colorLightBlack = Color(0xff334155); // Slate 700
  static const Color colorDarkBlue = Color(0xff1E293B); // Slate 800
  static const Color colorLightDark = Color(0xff0F172A); // Slate 900
  static const Color colorBlack = Color(0xff020617); // Slate 950

  // Compatibility aliases
  static const Color colorSecondary = Color(0xff1E293B);
  static const Color colorDark = Color(0xff0F172A);
  static const Color colorXWhite = Color(0xffF1F5F9);
  static const Color colorXXWhite = Color(0xffF8FAFC);
  static const Color colorWhiteDarkMode = Color(0xff1E293B);
  static const Color colorXXPrimary = Color(0xffC7D2FE);
  static const Color colorLightColorPrimary = Color(0xffE0E7FF);

  // Modern Shadows
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xff0F172A).withOpacity(0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xff0F172A).withOpacity(0.04),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: const Color(0xff0F172A).withOpacity(0.02),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> glowShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.35),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];
}

abstract class GradiantLinearColor {
  static const List<Color> violetGradient = [
    Color(0xff6366F1),
    Color(0xff8B5CF6),
  ];

  static const List<Color> primaryGradiant = [
    Color(0xff4F46E5),
    Color(0xff06B6D4),
  ];

  static const List<Color> emeraldGradient = [
    Color(0xff10B981),
    Color(0xff059669),
  ];

  static const List<Color> sunsetGradient = [
    Color(0xffF43F5E),
    Color(0xffFB923C),
  ];

  static const List<Color> oceanGradient = [
    Color(0xff0EA5E9),
    Color(0xff3B82F6),
  ];

  static const List<Color> amberGradient = [
    Color(0xffF59E0B),
    Color(0xffD97706),
  ];

  static const List<Color> darkCardGradient = [
    Color(0xff1E293B),
    Color(0xff0F172A),
  ];
}
