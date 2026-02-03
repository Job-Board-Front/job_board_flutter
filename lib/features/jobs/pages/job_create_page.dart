import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/core/widgets/app_drawer.dart';
import 'package:job_board_flutter/core/widgets/app_navbar.dart';
import 'package:job_board_flutter/features/auth/bloc/auth_cubit.dart';
import 'package:job_board_flutter/features/auth/bloc/auth_state.dart';
import 'package:job_board_flutter/features/jobs/bloc/job-form/job_form_cubit.dart';
import 'package:job_board_flutter/features/jobs/bloc/job-form/job_form_state.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_dto.dart';
import 'package:job_board_flutter/features/jobs/data/repositories/job_repository.dart';
import 'package:job_board_flutter/features/jobs/widgets/job_form.dart';

class JobCreatePage extends StatelessWidget {
  const JobCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<JobRepository>(context);

    return BlocProvider(
      create: (_) => JobFormCubit(repository: repository),
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
            final isSubmitting = state is JobFormLoading;
            final errorMessage = state is JobFormError ? state.message : null;

            return JobForm(
              onSubmit: (dto, logoPath, logoBytes) {
                cubit.createJob(dto, logoPath, logoBytes);
              },
              isSubmitting: isSubmitting,
              errorMessage: errorMessage,
              submitLabel: 'Create Job',
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
