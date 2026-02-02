import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/job_model.dart';
import '../data/repositories/job_repository.dart';
import 'jobs_state.dart';


class JobsCubit extends Cubit<JobsState> {
  final JobRepository repository;

  JobsCubit({required this.repository}) : super(JobsState(isLoading: true));

  Future<void> loadJobs({JobSearchFilters? filters}) async {
    try {
      emit(state.copyWith(isLoading: true, error: null, jobs: []));
      final response = await repository.getJobsPaginated(filters: filters);
      emit(state.copyWith(
        isLoading: false,
        jobs: response.data,
        nextCursor: response.nextCursor,
        hasMore: response.nextCursor != null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // Charger la page suivante (infinite scroll)
  Future<void> loadMoreJobs({JobSearchFilters? filters}) async {
    if (!state.hasMore || state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true, error: null));

      final newFilters = JobSearchFilters(
        search: filters?.search,
        location: filters?.location,
        employmentType: filters?.employmentType,
        experienceLevel: filters?.experienceLevel,
        limit: filters?.limit ?? 10,
        cursor: state.nextCursor,
      );

      final response = await repository.getJobsPaginated(filters: newFilters);

      emit(state.copyWith(
        isLoading: false,
        jobs: [...state.jobs, ...response.data],
        nextCursor: response.nextCursor,
        hasMore: response.nextCursor != null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }


  Future<void> refreshJobs({JobSearchFilters? filters}) async {
    await loadJobs(filters: filters);
  }
}
