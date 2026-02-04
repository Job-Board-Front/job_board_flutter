import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/core/bloc/cubit/theme_cubit.dart';
import 'package:job_board_flutter/features/auth/bloc/auth_cubit.dart';
import 'package:job_board_flutter/features/auth/bloc/auth_state.dart';
import 'package:job_board_flutter/features/auth/services/auth_service.dart';
import 'package:job_board_flutter/features/bookmarks/cubit/bookmarks_cubit.dart';
import 'package:job_board_flutter/features/bookmarks/data/repositories/bookmarks_repository.dart';
import 'package:job_board_flutter/features/jobs/bloc/job-details/job_details_cubit.dart';
import 'package:job_board_flutter/features/jobs/bloc/jobs/jobs_cubit.dart';
import 'package:job_board_flutter/features/jobs/data/repositories/job_repository.dart';
import 'package:job_board_flutter/features/jobs/pages/home_page.dart';
import 'package:job_board_flutter/features/jobs/pages/job_details_page.dart';
import 'package:job_board_flutter/features/jobs/pages/job_create_page.dart';
import 'package:job_board_flutter/features/jobs/pages/job_edit_page.dart';
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
        RepositoryProvider(create: (_) => BookmarksRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit(authService)),
          BlocProvider(create: (_) => ThemeCubit()..loadTheme()),
          BlocProvider(
            create: (context) =>
                JobsCubit(repository: context.read<JobRepository>())
                  ..loadJobs(),
          ),
          BlocProvider(
            create: (context) =>
                BookmarksCubit(context.read<BookmarksRepository>())
                  ..loadBookmarks(),
          ),
        ],
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) {
              // Réinitialiser les favoris lors du logout
              context.read<BookmarksCubit>().clearBookmarks();

              // Recharger les jobs pour rafraîchir leur état de bookmark
              context.read<JobsCubit>().loadJobs();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
              );

            }
          },
        child: BlocConsumer<ThemeCubit, ThemeState>(
          listener: (_, _) {},
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Job Board',
              debugShowCheckedModeBanner: false,
              theme: AppLightTheme.lightTheme,
              darkTheme: AppDarkTheme.darkTheme,
              themeMode: themeState.themeMode,
              // ERROR FIX: We use 'home' for the default route ('/')
              // Do NOT add '/' to the routes map below.
              home: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthLoading) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (authState is AuthSuccess) {
                    return const HomePage();
                  }

                  if (authState is AuthInitial) {
                    return const HomePage();
                  }

                  // AuthInitial - montrer la page de login
                  return const HomePage();
                },
              ),
              routes: {
                '/login': (_) => const LoginPage(),
                '/register': (_) => const RegisterPage(),
              },
              onGenerateRoute: (settings) {
                if (settings.name == '/job-details') {
                  final jobId = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) {
                        final cubit = JobDetailsCubit(
                          repository: RepositoryProvider.of(context),
                        );
                        // Always reload fresh data when navigating to job details
                        cubit.loadJobDetails(jobId);
                        return cubit;
                      },
                      child: const JobDetailsPage(),
                    ),
                  );
                }
                if (settings.name == '/job-create') {
                  return MaterialPageRoute(
                    builder: (_) => const JobCreatePage(),
                  );
                }
                if (settings.name == '/job-edit') {
                  return MaterialPageRoute(
                    builder: (_) => JobEditPage(
                      jobId: settings.arguments as String,
                    ),
                  );
                }
                return null;
              },
            );
          },
        ),
      ),
      ),
    );
  }
}
