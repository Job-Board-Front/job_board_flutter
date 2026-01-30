import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/core/bloc/cubit/theme_cubit.dart';
import 'package:job_board_flutter/core/widgets/app_drawer.dart';
import 'package:job_board_flutter/core/widgets/app_navbar.dart';
import 'package:job_board_flutter/features/jobs/bloc/job_details_cubit.dart';
import 'package:job_board_flutter/features/jobs/data/datasources/job_remote_datasource.dart';
import 'package:job_board_flutter/features/jobs/data/repositories/job_repository.dart';
import 'package:job_board_flutter/features/jobs/pages/job_details_page.dart';
import 'package:job_board_flutter/utils/theme/dark_theme.dart';
import 'package:job_board_flutter/utils/theme/light_theme.dart';

import 'features/jobs/pages/home_page.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => JobRepository(
        JobRemoteDataSource(http.Client()),
      ),
      child: BlocProvider(
        create: (context) => ThemeCubit()..loadTheme(),
        child: BlocConsumer<ThemeCubit, ThemeState>(
          listener: (context, state) => {},
          builder: (context, state) {
            return MaterialApp(
              title: 'Job Board Flutter',
              debugShowCheckedModeBanner: false,
              theme: AppLightTheme.lightTheme,
              darkTheme: AppDarkTheme.darkTheme,
              themeMode: state.themeMode,
              home: const HomePage(),
              onGenerateRoute: (settings) {
                if (settings.name == '/job-details') {
                  final jobId = settings.arguments as String;

                  return MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => JobDetailsCubit(
                        repository: RepositoryProvider.of<JobRepository>(context),
                      )..loadJobDetails(jobId),
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


