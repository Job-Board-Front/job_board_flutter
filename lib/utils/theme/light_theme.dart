import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_board_flutter/core/constants/app_colors.dart';

class AppLightTheme {
  AppLightTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.slate50,
    fontFamily: GoogleFonts.inter().fontFamily,

    // 1. Color Scheme (The foundation)
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary600,
      onPrimary: AppColors.white,
      secondary: AppColors.slate900, // Used for secondary buttons
      surface: AppColors.white, // Card background
      onSurface: AppColors.slate900, // Text color
      error: AppColors.error,
      outline: AppColors.slate200, // Border color
    ),

    // 2. AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: AppColors.slate900),
      titleTextStyle: TextStyle(
        color: AppColors.slate900,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark, // Status bar icons
    ),

    // 3. Inputs (TextFields) - Matches Tailwind 'ring' styles
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: AppColors.slate400),
      border: _buildBorder(AppColors.slate200),
      enabledBorder: _buildBorder(AppColors.slate200),
      focusedBorder: _buildBorder(AppColors.primary600, width: 2.0),
      errorBorder: _buildBorder(AppColors.error),
    ),

    // 4. Buttons
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

    // 5. Cards
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Matches rounded-2xl
        side: const BorderSide(color: AppColors.slate100),
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
