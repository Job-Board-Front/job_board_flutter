import 'package:dio/dio.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_filters_model.dart';

import '../datasources/job_remote_datasource/job_remote_datasource.dart';
import '../datasources/job_remote_datasource_provider.dart';
import '../models/job_model.dart';

class JobRepository {
  final JobRemoteDataSource _remoteDataSource;

  JobRepository({JobRemoteDataSource? remoteDataSource})
    : _remoteDataSource =
          remoteDataSource ?? JobRemoteDataSourceProvider.create();

  Future<List<Job>> getJobs({
    String? search,
    String? location,
    String? employmentType,
    String? experienceLevel,
    int? limit,
  }) async {
    print('🔎 Fetching jobs...');
    try {
      return (await _remoteDataSource.getJobs(
        search: search,
        location: location,
        employmentType: employmentType,
        experienceLevel: experienceLevel,
        limit: limit,
      )).data;
    } on DioException catch (e) {
      print(e);
      throw _handleDioException(e);
    }
  }

  Future<Job> getJobById(String id) async {
    try {
      return await _remoteDataSource.getJobById(id);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<List<Job>> getJobsByIds(List<String> ids) async {
    try {
      return await _remoteDataSource.getJobsByIds(ids.join(','));
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Job> createJob(Job job) async {
    try {
      return await _remoteDataSource.createJob(job);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<void> deleteJob(String id) async {
    try {
      return await _remoteDataSource.deleteJob(id);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<List<Job>> getSimilarJobs(String jobId, {int limit = 3}) async {
    try {
      print('🔎 Fetching similar jobs for: $jobId');

      // Fetch the current job
      final currentJob = await getJobById(jobId);
      print('📋 Current job: ${currentJob.title}');
      print('🏢 Employment type: ${currentJob.employmentType}');

      // Fetch a larger set of jobs to find similar ones
      final allJobs = await getJobs(limit: (limit + 5));
      print('📦 Total jobs fetched: ${allJobs.length}');

      // Filter similar jobs based on common characteristics
      final similarJobs = allJobs
          .where(
            (job) =>
                job.id != jobId && // Exclude current job
                (job.employmentType ==
                        currentJob.employmentType || // Same employment type
                    job.techStack.any(
                      (tech) => currentJob.techStack.contains(tech),
                    ) || // Overlapping tech stack
                    job.experienceLevel ==
                        currentJob.experienceLevel), // Same experience level
          )
          .take(limit)
          .toList();

      print('✅ Similar jobs found: ${similarJobs.length}');
      return similarJobs;
    } catch (e) {
      print('❌ Error fetching similar jobs: $e');
      return [];
    }
  }

  Future<PaginatedResponse<Job>> getJobsPaginated(
    JobSearchFilters filters,
  ) async {
    try {
      return await _remoteDataSource.getJobsPaginated(
        search: filters.search,
        location: filters.location,
        employmentType: _getEmploymentType(filters.employmentType),
        experienceLevel: filters.experienceLevel?.name,
        limit: filters.limit,
        cursor: filters.cursor,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<JobFiltersModel> getFilters() async {
    try {
      final filtersData = await _remoteDataSource.getFilters();
      return filtersData;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.sendTimeout:
        return Exception('Request timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Response timeout. Server is taking too long to respond.',
        );
      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        if (statusCode == 404) {
          return Exception('Resource not found.');
        } else if (statusCode == 401) {
          return Exception('Unauthorized. Please log in again.');
        } else if (statusCode == 403) {
          return Exception('Access denied.');
        } else if (statusCode == 500) {
          return Exception('Server error. Please try again later.');
        }
        return Exception('Failed to load data. Status code: $statusCode');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      case DioExceptionType.unknown:
        return Exception('An unexpected error occurred: ${exception.message}');
      case DioExceptionType.badCertificate:
        return Exception('SSL certificate error.');
      default:
        return Exception(exception);
    }
  }

  String _getEmploymentType(EmploymentType? employmentType) {
    switch (employmentType) {
      case EmploymentType.fullTime:
        return 'full-time';
      case EmploymentType.partTime:
        return 'part-time';
      case EmploymentType.contract:
        return 'contract';
      case EmploymentType.internship:
        return 'internship';
      default:
        return 'full-time';
    }
  }
}
