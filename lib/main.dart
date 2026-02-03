import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:job_board_flutter/core/bloc/cubit/theme_cubit.dart';
import 'package:job_board_flutter/features/auth/bloc/auth_cubit.dart';
import 'package:job_board_flutter/features/auth/services/auth_service.dart';
import 'package:job_board_flutter/features/jobs/bloc/job-details/job_details_cubit.dart';
import 'package:job_board_flutter/features/jobs/data/repositories/job_repository.dart';
import 'package:job_board_flutter/features/jobs/pages/home_page.dart';
import 'package:job_board_flutter/features/jobs/pages/job_details_page.dart';
import 'package:job_board_flutter/features/auth/pages/login_page.dart';
import 'package:job_board_flutter/features/auth/pages/register_page.dart';
import 'package:job_board_flutter/utils/theme/dark_theme.dart';
import 'package:job_board_flutter/utils/theme/light_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthService>(create: (_) => authService),
        RepositoryProvider(create: (_) => JobRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit(authService)),
          BlocProvider(create: (_) => ThemeCubit()..loadTheme()),
        ],
        child: BlocConsumer<ThemeCubit, ThemeState>(
          listener: (_, __) {},
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Job Board',
              debugShowCheckedModeBanner: false,
              theme: AppLightTheme.lightTheme,
              darkTheme: AppDarkTheme.darkTheme,
              themeMode: themeState.themeMode,
              // ERROR FIX: We use 'home' for the default route ('/')
              // Do NOT add '/' to the routes map below.
              home: const HomePage(),
              routes: {
                '/login': (_) => const LoginPage(),
                '/register': (_) => const RegisterPage(),
              },
              onGenerateRoute: (settings) {
                if (settings.name == '/job-details') {
                  return MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => JobDetailsCubit(
                        repository: RepositoryProvider.of(context),
                      )..loadJobDetails(settings.arguments as String),
                      child: const JobDetailsPage(),
                    ),
                  );
                }
                return null;
              },
            );
          },
        ),
      ),
    );
  }
}
