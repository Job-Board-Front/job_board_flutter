import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../bloc/jobs_cubit.dart';
import '../bloc/jobs_state.dart';
import '../data/datasources/job_remote_datasource.dart';
import '../data/repositories/job_repository.dart';
import '../widgets/job_list.dart';
import '../widgets/job_search.dart';
import '../widgets/category_filter.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialise le repository + datasource ici
    final repository = JobRepository(JobRemoteDataSource(http.Client()));

    return BlocProvider(
      create: (_) => JobsCubit(repository: repository)..loadJobs(),
      child: Scaffold(
        appBar: AppBar(title: const Text('All Jobs')),
        body: SafeArea(
          child: BlocBuilder<JobsCubit, JobsState>(
            builder: (context, state) {
              // Loader
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Erreur
              if (state.error != null) {
                return Center(child: Text('Error: ${state.error}'));
              }

              // Liste de jobs
              final jobs = state.jobs;
              final jobCount = jobs.length;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Text(
                      'All Job Offers',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Browse through $jobCount available positions',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),

                    // Search
                    JobSearch(

                    ),

                    const SizedBox(height: 16),

                    // Filters
                    CategoryFilter(

                    ),

                    const SizedBox(height: 16),

                    // Counter
                    Text(
                      'Showing $jobCount jobs',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),

                    // Job list
                    JobList(jobs: jobs),
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
