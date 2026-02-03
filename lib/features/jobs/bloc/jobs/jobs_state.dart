import 'package:job_board_flutter/features/jobs/data/models/job_filters_model.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

class JobsState {
  final List<Job> jobs;
  final bool isLoading;
  final String? error;
  final String? nextCursor;
  final bool hasMore;
  final JobFiltersModel? filtersData;
  final JobSearchFilters activeFilters;

  JobsState({
    this.jobs = const [],
    this.isLoading = false,
    this.error,
    this.nextCursor,
    this.hasMore = true,
    this.filtersData,
    JobSearchFilters? activeFilters,
  }) : activeFilters = activeFilters ?? JobSearchFilters();

  JobsState copyWith({
    List<Job>? jobs,
    bool? isLoading,
    String? error,
    String? nextCursor,
    bool? hasMore,
    JobFiltersModel? filtersData,
    JobSearchFilters? activeFilters,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      filtersData: filtersData ?? this.filtersData,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}
