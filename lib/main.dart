import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/core/bloc/cubit/theme_cubit.dart';
import 'package:job_board_flutter/utils/theme/dark_theme.dart';
import 'package:job_board_flutter/utils/theme/light_theme.dart';

import 'features/jobs/pages/home_page.dart';
import 'features/jobs/pages/jobs_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit()..loadTheme(),
      child: BlocConsumer<ThemeCubit, ThemeState>(
        listener: (context, state) => {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Job Board Flutter',
            debugShowCheckedModeBanner: false,

            // Apply the themes we defined
            theme: AppLightTheme.lightTheme,
            darkTheme: AppDarkTheme.darkTheme,
            themeMode: state.themeMode,

            home: const HomePage(),
          );
        },
      ),
    );
  }
}


