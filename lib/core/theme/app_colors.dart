import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // 🔵 Blue Palette
  static const Color blueLight = Color(0xFFEBF3FF);
  static const Color blueLightHover = Color(0xFFE1EDFF);
  static const Color blueLightActive = Color(0xFFC1D9FE);

  static const Color blueNormal = Color(0xFF3884FC);
  static const Color blueNormalHover = Color(0xFF3277E3);
  static const Color blueNormalActive = Color(0xFF2D6ACA);

  static const Color blueDark = Color(0xFF2A63BD);
  static const Color blueDarkHover = Color(0xFF224F97);
  static const Color blueDarkActive = Color(0xFF193B71);
  static const Color blueDarker = Color(0xFF142E58);

  // ⚪ White Palette
  static const Color whiteLight = Color(0xFFFFFFFF);
  static const Color whiteLightHover = Color(0xFFFFFFFF);
  static const Color whiteLightActive = Color(0xFFFFFFFF);

  static const Color whiteNormal = Color(0xFFFFFFFF);
  static const Color whiteNormalHover = Color(0xFFE6E6E6);
  static const Color whiteNormalActive = Color(0xFFCCCCCC);

  static const Color whiteDark = Color(0xFFBFBFBF);
  static const Color whiteDarkHover = Color(0xFF999999);
  static const Color whiteDarkActive = Color(0xFF737373);
  static const Color whiteDarker = Color(0xFF595959);

  // ⚫ Black Palette
  static const Color blackLight = Color(0xFFE6E6E6);
  static const Color blackLightHover = Color(0xFFD9D9D9);
  static const Color blackLightActive = Color(0xFFB0B0B0);
  static const Color blackNormal = Color(0xFF000000);

  // 🟣 Purple Palette
  static const Color purpleNormal = Color(0xFF6C3FB5);

  // 🟢 Green Palette (Benefit / Success)
  static const Color greenLight = Color(0xFFE8FDF2);
  static const Color greenBorder = Color(0xFF34D399);
  static const Color greenNormal = Color(0xFF10B981);
  static const Color greenDark = Color(0xFF047857);

  // 🔴 Red Palette (Deadline / Warning)
  static const Color redLight = Color(0xFFFFF1F2);
  static const Color redNormal = Color(0xFFF43F5E);
  static const Color redDark = Color(0xFFBE123C);

  // 🔵 Blue Gradient
  static const Color blueGradientStart = Color(0xFF4F7CF3);
  static const Color blueGradientEnd = Color(0xFF6FA8FF);

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blueGradientStart, blueGradientEnd],
  );
}
