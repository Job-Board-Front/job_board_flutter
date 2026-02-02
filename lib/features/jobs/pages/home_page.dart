import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/app_navbar.dart';
import '../bloc/jobs/jobs_cubit.dart';
import '../bloc/jobs/jobs_state.dart';
import '../data/datasources/job_remote_datasource.dart';
import '../data/repositories/job_repository.dart';
import '../widgets/home/hero_section.dart';
import '../widgets/job_card.dart';
import '../widgets/job_search.dart';
import 'jobs_page.dart';
import 'package:job_board_flutter/core/bloc/cubit/theme_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final JobsCubit cubit;

  @override
  void initState() {
    super.initState();
    final repository = JobRepository(JobRemoteDataSource(http.Client()));
    cubit = JobsCubit(repository: repository);
    cubit.loadJobs(filters: JobSearchFilters(limit: 3));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppNavbar(),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<JobsCubit, JobsState>(
            builder: (context, state) {
              if (state.isLoading && state.jobs.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null && state.jobs.isEmpty) {
                return Center(child: Text('Error: ${state.error}'));
              }

              final jobs = state.jobs;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroSection(),
                    SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Job Offers',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Latest opportunities posted',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const JobsPage(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.blue,
                          ),
                          label: const Text(
                            'View All',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: jobs
                          .map(
                            (job) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: JobCard(job: job),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
