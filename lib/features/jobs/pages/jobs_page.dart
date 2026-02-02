import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/app_navbar.dart';
import '../bloc/jobs/jobs_cubit.dart';
import '../bloc/jobs/jobs_state.dart';
import '../data/datasources/job_remote_datasource.dart';
import '../data/repositories/job_repository.dart';
import '../widgets/job_list.dart';
import '../widgets/job_search.dart';
import '../widgets/category_filter.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  late final JobsCubit cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialise le repository + datasource
    final repository = JobRepository(JobRemoteDataSource(http.Client()));
    cubit = JobsCubit(repository: repository);

    cubit.loadJobs(); // charge la première page

    // Scroll listener pour la pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          cubit.state.hasMore &&
          !cubit.state.isLoading) {
        cubit.loadMoreJobs();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppNavbar(),
        drawer: AppDrawer(),
        body: SafeArea(
          child: BlocBuilder<JobsCubit, JobsState>(
            builder: (context, state) {
              if (state.isLoading && state.jobs.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null && state.jobs.isEmpty) {
                return Center(child: Text('Error: ${state.error}'));
              }

              final jobs = state.jobs;
              final jobCount = jobs.length;

              return SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'All Job Offers',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore top career opportunities from leading companies',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    const JobSearch(),
                    const SizedBox(height: 16),
                    const CategoryFilter(),

                    const SizedBox(height: 16),

                    Text(
                      'Showing $jobCount jobs',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),

                    // Job list
                    JobList(jobs: jobs),

                    // Loader de fin pour pagination
                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
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
