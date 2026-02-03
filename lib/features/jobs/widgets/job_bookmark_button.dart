import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/features/bookmarks/cubit/bookmarks_cubit.dart';
import '../../jobs/data/models/job_model.dart';

class BookmarkButton extends StatelessWidget {
  final Job job;

  const BookmarkButton({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final isBookmarked = context.select<BookmarksCubit, bool>(
      (cubit) => cubit.isBookmarked(job.id),
    );

    return IconButton(
      icon: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: isBookmarked ? Colors.blue : Colors.grey,
      ),
      onPressed: () {
        // 2. Call the dedicated BookmarksCubit to toggle
        context.read<BookmarksCubit>().toggleBookmark(job);
      },
    );
  }
}
