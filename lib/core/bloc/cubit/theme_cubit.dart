import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = "theme_mode";
  ThemeCubit() : super(ThemeInitial(themeMode: ThemeMode.system));

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey);

    if (isDark == null) {
      emit(const ThemeInitial(themeMode: ThemeMode.system));
    } else {
      emit(
        ThemeLoadState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light),
      );
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    emit(ThemeToggleState(themeMode: newMode));

    //Persist
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      _themeKey,
      newMode == ThemeMode.dark,
    ); //true = dark theme
  }
}
