import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

class JobsState {
  final bool isLoading;
  final String? error;
  final List<Job> jobs;
  final bool hasMore;
  final Map<String, dynamic>? filters;

  JobsState({
    this.isLoading = false,
    this.error,
    this.jobs = const [],
    this.hasMore = true,
    this.filters,
  });

  JobsState copyWith({
    bool? isLoading,
    String? error,
    List<Job>? jobs,
    bool? hasMore,
    Map<String, dynamic>? filters,
  }) {
    return JobsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      jobs: jobs ?? this.jobs,
      hasMore: hasMore ?? this.hasMore,
      filters: filters ?? this.filters,
    );
  }
}
