import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/core/constants/api_constants.dart';
import 'package:job_board_flutter/features/jobs/bloc/job_details_state.dart';
import 'package:job_board_flutter/features/jobs/data/repositories/job_repository.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {
  final JobRepository repository;

  JobDetailsCubit({required this.repository})
      : super(JobDetailsState(isLoading: true));

  // Ajoutez cette méthode pour correspondre à l'appel dans main.dart
  Future<void> loadJobDetails(String jobId) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      print('🔍 Loading job with ID: $jobId');
      print('🌐 API URL: ${ApiConstants.baseUrl}/jobs/$jobId');

      final job = await repository.getJobById(jobId);
      print('✅ Job loaded: ${job.title}');

      emit(state.copyWith(job: job, isLoading: false));
    } catch (e, stackTrace) {
      print('❌ Error: $e');
      print('📚 StackTrace: $stackTrace');
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> loadJob(String jobId) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final job = await repository.getJobById(jobId);
      final allJobs = await repository.getJobs();
      final similarJobs = _findSimilarJobs(job, allJobs);

      emit(state.copyWith(
        isLoading: false,
        job: job,
        similarJobs: similarJobs,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load job: ${e.toString()}',
      ));
    }
  }

  List<Job> _findSimilarJobs(Job currentJob, List<Job> allJobs) {
    return allJobs
        .where((job) =>
    job.id != currentJob.id &&
        job.techStack.any((tech) => currentJob.techStack.contains(tech)))
        .take(3)
        .toList();
  }
}
