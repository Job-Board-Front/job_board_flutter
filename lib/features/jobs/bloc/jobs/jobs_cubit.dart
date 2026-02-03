import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_filters_model.dart';
import '../../data/models/job_model.dart';
import '../../data/repositories/job_repository.dart';
import 'jobs_state.dart';

class JobsCubit extends Cubit<JobsState> {
  final JobRepository repository;

  JobsCubit({required this.repository}) : super(JobsState(isLoading: true));

  Future<void> loadJobs() async {
    try {
      emit(state.copyWith(isLoading: true, error: null, jobs: []));
      final response = await repository.getJobsPaginated(state.activeFilters);
      final filtersData = state.filtersData ?? await repository.getFilters();
      emit(
        state.copyWith(
          isLoading: false,
          jobs: response.data,
          nextCursor: response.nextCursor,
          hasMore: response.nextCursor != null,
          filtersData: filtersData,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // Charger la page suivante (infinite scroll)
  Future<void> loadMoreJobs() async {
    if (!state.hasMore || state.isLoading) return;
    final filters = state.activeFilters;
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final newFilters = JobSearchFilters(
        search: filters.search,
        location: filters.location,
        employmentType: filters.employmentType,
        experienceLevel: filters.experienceLevel,
        limit: filters.limit,
        cursor: state.nextCursor,
      );

      final response = await repository.getJobsPaginated(newFilters);

      emit(
        state.copyWith(
          isLoading: false,
          jobs: [...state.jobs, ...response.data],
          nextCursor: response.nextCursor,
          hasMore: response.nextCursor != null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> refreshJobs() async {
    await loadJobs();
  }

  void updateFilter(String key, String? value) {
    // Clone current filters and update the specific key
    final current = state.activeFilters;
    if (value == null) {
      return;
    }
    final newFilters = JobSearchFilters(
      search: key == "search" ? value : current.search,
      location: key == 'location' ? value : current.location,
      employmentType: key == 'employment'
          ? Job.parseEmploymentType(value)
          : current.employmentType,
      experienceLevel: key == 'experience'
          ? Job.parseExperienceLevel(value)
          : current.experienceLevel,
      // Add other fields as needed
      limit: key == 'limit' ? int.parse(value) : current.limit,
      cursor: key == 'cursor' ? value : current.cursor,
    );
    // Update state with new filters, then reload jobs
    emit(state.copyWith(activeFilters: newFilters));
    loadJobs();
  }
}
