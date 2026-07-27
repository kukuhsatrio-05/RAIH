import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blueNormal,
        primary: AppColors.blueNormal,
        onPrimary: AppColors.whiteNormal,
        surface: AppColors.whiteNormal,
        onSurface: AppColors.blackNormal,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }
}
