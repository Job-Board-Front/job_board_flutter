import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/features/jobs/bloc/job-form/job_form_state.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_dto.dart';
import 'package:job_board_flutter/features/jobs/data/repositories/job_repository.dart';

class JobFormCubit extends Cubit<JobFormState> {
  final JobRepository repository;

  JobFormCubit({required this.repository}) : super(const JobFormInitial());

  String _extractErrorMessage(dynamic error) {
    if (error is Exception) {
      final errorString = error.toString();
      
      // Extract user-friendly messages from common error patterns
      if (errorString.contains('Connection timeout') || 
          errorString.contains('Connection failed')) {
        return 'Connection failed. Please check your internet connection and try again.';
      }
      if (errorString.contains('401') || errorString.contains('Unauthorized')) {
        return 'You are not authorized to perform this action. Please log in again.';
      }
      if (errorString.contains('403') || errorString.contains('Forbidden')) {
        return 'You do not have permission to perform this action.';
      }
      if (errorString.contains('404') || errorString.contains('Not found')) {
        return 'The requested resource was not found.';
      }
      if (errorString.contains('500') || errorString.contains('Server error')) {
        return 'Server error occurred. Please try again later.';
      }
      if (errorString.contains('400') || errorString.contains('Bad request')) {
        return 'Invalid data provided. Please check your input and try again.';
      }
      
      // Try to extract message from error string
      final match = RegExp(r'message[:\s]+(.+?)(?:\.|$)').firstMatch(errorString);
      if (match != null) {
        return match.group(1)?.trim() ?? 'An error occurred. Please try again.';
      }
      
      // Fallback to a generic message
      return 'An error occurred. Please try again.';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  Future<void> loadJob(String jobId) async {
    try {
      emit(const JobFormLoading(existingJob: null));
      final job = await repository.getJobById(jobId);
      emit(JobFormJobLoaded(job: job));
    } catch (e) {
      emit(JobFormError(message: _extractErrorMessage(e)));
    }
  }

  Future<void> createJob(CreateJobDto dto, String? logoPath, Uint8List? logoBytes) async {
    try {
      emit(const JobFormLoading(existingJob: null));
      final jobId = await repository.createJob(dto);
      
      if (logoPath != null || logoBytes != null) {
        try {
          await repository.uploadLogo(jobId, logoPath, logoBytes);
        } catch (e) {
          // Job created but logo upload failed
          emit(JobFormError(
            message: 'Job created successfully, but logo upload failed: ${_extractErrorMessage(e)}',
          ));
          return;
        }
      }
      
      emit(JobFormSuccess(jobId: jobId));
    } catch (e) {
      emit(JobFormError(message: _extractErrorMessage(e)));
    }
  }

  Future<void> updateJob(String jobId, UpdateJobDto dto, String? logoPath, Uint8List? logoBytes) async {
    try {
      final currentState = state;
      final existingJob = currentState is JobFormJobLoaded ? currentState.job : null;
      emit(JobFormLoading(existingJob: existingJob));
      await repository.updateJob(jobId, dto);
      
      if (logoPath != null || logoBytes != null) {
        try {
          await repository.uploadLogo(jobId, logoPath, logoBytes);
        } catch (e) {
          // Job updated but logo upload failed
          emit(JobFormError(
            message: 'Job updated successfully, but logo upload failed: ${_extractErrorMessage(e)}',
          ));
          return;
        }
      }
      
      emit(JobFormSuccess(jobId: jobId));
    } catch (e) {
      emit(JobFormError(message: _extractErrorMessage(e)));
    }
  }
}
