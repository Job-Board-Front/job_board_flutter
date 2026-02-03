import 'package:dio/dio.dart';
import 'package:job_board_flutter/features/bookmarks/data/bookmarks_remote_provider.dart';
import 'package:job_board_flutter/features/bookmarks/data/datasources/bookmarks_remote_datasource/bookmarks_remote_datasource.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';
import 'package:rxdart/rxdart.dart';

class BookmarksRepository {
  final BookmarksRemoteDataSource _remoteDataSource;

  BookmarksRepository({BookmarksRemoteDataSource? remoteDataSource})
    : _remoteDataSource =
          remoteDataSource ?? BookmarksRemoteDataSourceProvider.create();

  final _bookmarksSubject = BehaviorSubject<List<Job>>.seeded([]);

  Stream<List<Job>> get bookmarksStream => _bookmarksSubject.stream;

  List<Job> get currentBookmarks => _bookmarksSubject.value;

  Future<void> fetchBookmarks() async {
    try {
      print('🔎 Fetching bookmarks');
      final bookmarks = await _remoteDataSource.getUserBookmarks();
      _bookmarksSubject.add(bookmarks);
      print('🔎 Fetched bookmarks: ${_bookmarksSubject.value.length}');
    } catch (e) {
      // Handle error (log it, or rethrow if you want the Cubit to know)
      rethrow;
    }
  }

  bool isJobBookmarked(String jobId) {
    final bookmarked = _bookmarksSubject.value.any((job) => job.id == jobId);
    print('🔎 Is bookmarked: ${_bookmarksSubject.value}');
    return bookmarked;
  }

  Future<void> toggleBookmark(Job job) async {
    final currentList = _bookmarksSubject.value;
    // Check if WE think it's bookmarked
    final isBookmarkedLocal = currentList.any((j) => j.id == job.id);

    // 1. OPTIMISTIC UPDATE: Update UI immediately
    List<Job> optimisticList;
    if (isBookmarkedLocal) {
      optimisticList = currentList.where((j) => j.id != job.id).toList();
    } else {
      optimisticList = [...currentList, job];
    }
    _bookmarksSubject.add(optimisticList);

    // 2. SYNC WITH SERVER
    try {
      if (isBookmarkedLocal) {
        // Local says YES -> We try to REMOVE
        await _remoteDataSource.unbookmarkJob(job.id);
      } else {
        // Local says NO -> We try to ADD
        await _remoteDataSource.bookmarkJob(job.id);
      }
    } on DioException catch (e) {
      // --- HERE IS THE FIX ---

      // Case A: We tried to ADD, but server says "Already exists" (409)
      if (e.response?.statusCode == 409) {
        // This is actually a success! We wanted it bookmarked, and it is.
        // We implicitly trust the optimistic update we just did.
        return;
      }

      // Case B: We tried to REMOVE, but server says "Doesn't exist" (404)
      if (e.response?.statusCode == 404) {
        // This is also a success! We wanted it removed, and it's gone.
        return;
      }

      // Case C: Real Error (e.g., No Internet, 500 Server Error)
      // Revert the optimistic update because it actually failed.
      _bookmarksSubject.add(currentList);
      rethrow;
    } catch (e) {
      // Revert on any other unknown error
      _bookmarksSubject.add(currentList);
      rethrow;
    }
  }
}
