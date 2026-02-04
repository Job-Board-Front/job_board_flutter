import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_board_flutter/core/widgets/app_drawer.dart';
import 'package:job_board_flutter/core/widgets/app_navbar.dart';
import 'package:job_board_flutter/features/bookmarks/cubit/bookmarks_cubit.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';
import 'package:job_board_flutter/features/jobs/widgets/job_list.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      appBar: AppNavbar(),
      drawer: AppDrawer(),
      body: SafeArea(
        child: BlocBuilder<BookmarksCubit, BookmarksState>(
          builder: (context, state) {
            if (state is BookmarksLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Loading bookmarks...',
                      style: TextStyle(color: mutedColor),
                    ),
                  ],
                ),
              );
            }

            if (state is BookmarksError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load bookmarks',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final List<Job> bookmarks =
                state is BookmarksLoaded ? state.bookmarks : [];
            final count = bookmarks.length;

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<BookmarksCubit>().loadBookmarks(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.bookmark_rounded,
                          size: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Bookmarks',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$count job${count == 1 ? '' : 's'} saved for later',
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (count == 0)
                      _EmptyBookmarksContent(isDark: isDark)
                    else
                      JobList(jobs: bookmarks),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyBookmarksContent extends StatelessWidget {
  final bool isDark;

  const _EmptyBookmarksContent({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final mutedColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 64,
              color: mutedColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookmarks yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start browsing and bookmark jobs you're interested in!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
