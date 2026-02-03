import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/core/widgets/app_drawer.dart';
import 'package:job_board_flutter/core/widgets/app_navbar.dart';
import 'package:job_board_flutter/features/auth/bloc/auth_cubit.dart';
import 'package:job_board_flutter/features/auth/bloc/auth_state.dart';
import 'package:job_board_flutter/features/jobs/bloc/job-form/job_form_cubit.dart';
import 'package:job_board_flutter/features/jobs/bloc/job-form/job_form_state.dart';
import 'package:job_board_flutter/features/jobs/data/datasources/job_remote_datasource_provider.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_dto.dart';
import 'package:job_board_flutter/features/jobs/data/repositories/job_repository.dart';
import 'package:job_board_flutter/features/jobs/widgets/job_form.dart';

class JobEditPage extends StatelessWidget {
  final String jobId;

  const JobEditPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<JobRepository>(context);

    return BlocProvider(
      create: (_) => JobFormCubit(repository: repository)..loadJob(jobId),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, authState) {
          // Redirect to home if user logs out
          if (authState is AuthInitial) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/',
              (route) => false,
            );
          }
        },
        child: Scaffold(
          appBar: AppNavbar(),
          drawer: AppDrawer(),
          body: BlocConsumer<JobFormCubit, JobFormState>(
          listener: (context, state) {
            if (state is JobFormSuccess) {
              // Clear cache for this job to ensure fresh data is loaded
              JobRemoteDataSourceProvider.clearJobCache(state.jobId);
              
              // Navigate and force reload
              Navigator.of(context).pushReplacementNamed(
                '/job-details',
                arguments: state.jobId,
              );
            } else if (state is JobFormError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<JobFormCubit>();
            
            if (state is JobFormLoading && state.existingJob == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is JobFormError && state is! JobFormJobLoaded && state is! JobFormLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => cubit.loadJob(jobId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final job = state is JobFormJobLoaded 
                ? state.job 
                : state is JobFormLoading 
                    ? state.existingJob 
                    : null;
            final isSubmitting = state is JobFormLoading;
            final errorMessage = state is JobFormError ? state.message : null;

            if (job == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return JobForm(
              initialJob: job,
              onSubmit: (dto, logoPath, logoBytes) {
                final updateDto = UpdateJobDto(
                  title: dto.title,
                  description: dto.description,
                  company: dto.company,
                  location: dto.location,
                  employmentType: dto.employmentType,
                  experienceLevel: dto.experienceLevel,
                  salaryRange: dto.salaryRange,
                  techStack: dto.techStack,
                  submissionLink: dto.submissionLink,
                );
                cubit.updateJob(jobId, updateDto, logoPath, logoBytes);
              },
              isSubmitting: isSubmitting,
              errorMessage: errorMessage,
              submitLabel: 'Update Job',
              onCancel: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
        ),
      ),
    );
  }
}
