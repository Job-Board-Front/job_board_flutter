import 'package:dio/dio.dart';
import 'package:job_board_flutter/core/constants/api_constants.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';
import 'package:retrofit/retrofit.dart';

part 'bookmarks_remote_datasource.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class BookmarksRemoteDataSource {
  factory BookmarksRemoteDataSource(Dio dio, {String? baseUrl}) =
      _BookmarksRemoteDataSource;

  // Angular: getBookmarks()
  @GET('/bookmarks')
  Future<List<Job>> getUserBookmarks();

  // Angular: bookmarkJob(jobId)
  @POST('/bookmarks/{jobId}')
  Future<void> bookmarkJob(@Path('jobId') String jobId);

  // Angular: unbookmarkJob(jobId)
  @DELETE('/bookmarks/{jobId}')
  Future<void> unbookmarkJob(@Path('jobId') String jobId);
}
