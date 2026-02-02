import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

class JobDetailsState {
  final bool isLoading;
  final String? error;
  final Job? job;
  final List<Job> similarJobs;
  final bool isBookmarked;

  JobDetailsState({
    this.isLoading = false,
    this.error,
    this.job,
    this.similarJobs = const [],
    this.isBookmarked = false,
  });

  JobDetailsState copyWith({
    bool? isLoading,
    String? error,
    Job? job,
    List<Job>? similarJobs,
    bool? isBookmarked,
  }) {
    return JobDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      job: job ?? this.job,
      similarJobs: similarJobs ?? this.similarJobs,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

// Job Details State
