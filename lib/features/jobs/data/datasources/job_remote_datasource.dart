import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/job_model.dart';

part 'job_remote_datasource.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class JobRemoteDataSource {
  factory JobRemoteDataSource(Dio dio, {String? baseUrl}) =
      _JobRemoteDataSource;

  @GET('/jobs')
  Future<List<Job>> getJobs({
    @Query('search') String? search,
    @Query('location') String? location,
    @Query('employmentType') String? employmentType,
    @Query('experienceLevel') String? experienceLevel,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
  });

  @GET('/jobs/{id}')
  Future<Job> getJobById(@Path('id') String id);

  @GET('/jobs/bulk')
  Future<List<Job>> getJobsByIds(@Query('ids') String ids);

  @POST('/jobs')
  Future<Job> createJob(@Body() Job job);

  @DELETE('/jobs/{id}')
  Future<void> deleteJob(@Path('id') String id);

  @GET('/jobs')
  Future<PaginatedResponse<Job>> getJobsPaginated({
    @Query('search') String? search,
    @Query('location') String? location,
    @Query('employmentType') EmploymentType? employmentType,
    @Query('experienceLevel') ExperienceLevel? experienceLevel,
    @Query('limit') int? limit,
    @Query('cursor') String? cursor,
  });
}
