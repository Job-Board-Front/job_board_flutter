import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/job_model.dart';
import '../data/repositories/job_repository.dart';
import 'jobs_state.dart';


class JobsCubit extends Cubit<JobsState> {
  final JobRepository repository;

  JobsCubit({required this.repository}) : super(JobsState(isLoading: true));

  Future<void> loadJobs({Map<String, dynamic>? filters}) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final jobs = await repository.getJobs(filters: filters);
      emit(state.copyWith(isLoading: false, jobs: jobs));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> refreshJobs({Map<String, dynamic>? filters}) async {
    await loadJobs(filters: filters);
  }
}
