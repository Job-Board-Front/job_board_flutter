import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

class JobsState {
  final List<Job> jobs;
  final bool isLoading;
  final String? error;
  final String? nextCursor;
  final bool hasMore;

  JobsState({
    this.jobs = const [],
    this.isLoading = false,
    this.error,
    this.nextCursor,
    this.hasMore = true,
  });

  JobsState copyWith({
    List<Job>? jobs,
    bool? isLoading,
    String? error,
    String? nextCursor,
    bool? hasMore,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

