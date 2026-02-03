import 'package:equatable/equatable.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

abstract class JobFormState extends Equatable {
  const JobFormState();

  @override
  List<Object?> get props => [];
}

class JobFormInitial extends JobFormState {
  const JobFormInitial();
}

class JobFormLoading extends JobFormState {
  final Job? existingJob;
  
  const JobFormLoading({this.existingJob});
  
  @override
  List<Object?> get props => [existingJob];
}

class JobFormSuccess extends JobFormState {
  final String jobId;

  const JobFormSuccess({required this.jobId});

  @override
  List<Object?> get props => [jobId];
}

class JobFormError extends JobFormState {
  final String message;

  const JobFormError({required this.message});

  @override
  List<Object?> get props => [message];
}

class JobFormJobLoaded extends JobFormState {
  final Job job;

  const JobFormJobLoaded({required this.job});

  @override
  List<Object?> get props => [job];
}
