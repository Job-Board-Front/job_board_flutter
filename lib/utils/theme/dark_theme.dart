import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_board_flutter/core/constants/app_colors.dart';

class AppDarkTheme {
  // ---------------------------------------------------------------------------
  // DARK THEME
  // ---------------------------------------------------------------------------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.slate900,
    fontFamily: GoogleFonts.inter().fontFamily,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary600,
      onPrimary: AppColors.white,
      secondary: AppColors.white,
      surface: AppColors.slate800,
      onSurface: AppColors.white,
      outline: AppColors.slate700,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.slate900, // Or slate800 for contrast
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.slate800,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: AppColors.slate500),
      border: _buildBorder(AppColors.slate700),
      enabledBorder: _buildBorder(AppColors.slate700),
      focusedBorder: _buildBorder(AppColors.primary600, width: 2.0),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary600,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.slate800,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.slate700),
      ),
    ),
  );

  // Helper for borders
  static OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
