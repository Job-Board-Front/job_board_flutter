import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_board_flutter/features/bookmarks/data/repositories/bookmarks_repository.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

part 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final BookmarksRepository _repository;

  BookmarksCubit(this._repository) : super(BookmarksInitial()) {
    // Listen to the Repository's stream and emit new states automatically
    _repository.bookmarksStream.listen((bookmarks) {
      emit(BookmarksLoaded(bookmarks));
    });
  }

  Future<void> loadBookmarks() async {
    // Only show loading indicator if we have NO data yet
    if (state is! BookmarksLoaded) {
      emit(BookmarksLoading());
    }

    try {
      await _repository.fetchBookmarks();
      print('🔎 Fetched bookmarks: ${_repository.currentBookmarks.length}');
    } catch (e) {
      emit(BookmarksError(e.toString()));
    }
  }

  Future<void> toggleBookmark(Job job) async {
    try {
      await _repository.toggleBookmark(job);
    } catch (e) {
      //a snackbar/toast error here*.
      emit(BookmarksError("Failed to update bookmark"));

      //Re-emit the current valid list to clear the error state
      emit(BookmarksLoaded(_repository.currentBookmarks));
    }
  }

  bool isBookmarked(String jobId) {
    return _repository.isJobBookmarked(jobId);
  }
  void clearBookmarks() {
    _repository.clearAllBookmarks(); // Appeler la méthode du repository
    emit(BookmarksInitial()); // Réinitialiser l'état
  }


}
