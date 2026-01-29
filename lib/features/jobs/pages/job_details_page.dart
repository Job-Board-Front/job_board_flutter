import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/features/jobs/bloc/job_details_cubit.dart';
import 'package:job_board_flutter/features/jobs/bloc/job_details_state.dart';
import 'package:job_board_flutter/features/jobs/widgets/job_actions_bar.dart';
import 'package:job_board_flutter/features/jobs/widgets/job_description.dart';
import 'package:job_board_flutter/features/jobs/widgets/job_details_card.dart';
import 'package:job_board_flutter/features/jobs/widgets/job_header.dart';
import 'package:job_board_flutter/features/jobs/widgets/job_skills.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Details')),
      bottomNavigationBar: const JobActionsBar(),
      body: BlocBuilder<JobDetailsCubit, JobDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          final job = state.job!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                JobHeader(job: job),
                const SizedBox(height: 24),
                JobDescription(description: job.description),
                const SizedBox(height: 24),
                JobSkills(skills: job.techStack),
                const SizedBox(height: 24),
                JobDetailsCard(job: job),
                const SizedBox(height: 32),
                //SimilarJobs(jobs: state.similarJobs),
              ],
            ),
          );
        },
      ),
    );
  }
}
// Job Details Page
