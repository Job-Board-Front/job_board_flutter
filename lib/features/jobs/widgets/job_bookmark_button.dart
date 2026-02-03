import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/features/bookmarks/cubit/bookmarks_cubit.dart';
import '../../jobs/data/models/job_model.dart';

class BookmarkButton extends StatelessWidget {
  final Job job;

  const BookmarkButton({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final isBookmarked = context.select<BookmarksCubit, bool>((cubit) {
      final state = cubit.state;

      if (state is BookmarksLoaded) {
        // --- DEBUG PRINT START ---
        // Uncomment this if you want to see every check (can be spammy)

        if (state.bookmarks.isNotEmpty) {
          final firstId = state.bookmarks.first.id;
          print(
            "Checking Job ID: '${job.id}' (${job.id.runtimeType}) vs Bookmark ID: '$firstId' (${firstId.runtimeType})",
          );
        }

        // --- DEBUG PRINT END ---

        // Force both to String and trim to be absolutely safe
        return state.bookmarks.any(
          (b) => b.id.toString().trim() == job.id.toString().trim(),
        );
      }
      return false;
    });

    return IconButton(
      icon: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: isBookmarked ? Colors.blue : Colors.grey,
      ),
      onPressed: () {
        context.read<BookmarksCubit>().toggleBookmark(job);
      },
    );
  }
}
