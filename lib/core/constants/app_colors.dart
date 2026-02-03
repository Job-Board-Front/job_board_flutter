import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Primary Brand Colors (Tech Blue) ---
  static const Color primary50 = Color(0xFFEFF6FF);
  static const Color primary100 = Color(0xFFDBEAFE);
  static const Color primary400 = Color(
    0xFF60A5FA,
  ); // ← added (Tailwind blue-400)
  static const Color primary500 = Color(0xFF3B82F6);
  static const Color primary600 = Color(0xFF2563EB); // Main Brand Color
  static const Color primary700 = Color(0xFF1D4ED8);
  static const Color primary900 = Color(0xFF1E3A8A);

  // --- Neutrals (Slate) ---
  static const Color slate50 = Color(0xFFF8FAFC); // Light background
  static const Color slate100 = Color(0xFFF1F5F9); // Light borders
  static const Color slate200 = Color(0xFFE2E8F0); // Input borders
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8); // Subtitles
  static const Color slate500 = Color(0xFF64748B); // Icons
  static const Color slate600 = Color(
    0xFF475569,
  ); // ← added (Tailwind slate-600)
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B); // Dark Card bg
  static const Color slate850 = Color(0xFF1A202C); // Darker Card bg
  static const Color slate900 = Color(0xFF0F172A); // Dark Scaffold bg

  // --- Semantic Colors ---
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}
