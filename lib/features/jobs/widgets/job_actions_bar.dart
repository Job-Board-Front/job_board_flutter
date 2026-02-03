import 'package:flutter/material.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';
import 'package:job_board_flutter/features/jobs/widgets/job_bookmark_button.dart';
import 'package:url_launcher/url_launcher.dart';

class JobActionsBar extends StatelessWidget {
  final Job job;
  final VoidCallback? onBookmarkTap;
  final bool isBookmarked;

  const JobActionsBar({
    super.key,
    required this.job,
    this.onBookmarkTap,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final canApply =
        job.submissionLink != null && job.submissionLink!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Apply button
              Expanded(
                child: ElevatedButton(
                  onPressed: canApply
                      ? () async {
                          final uri = Uri.tryParse(job.submissionLink!);
                          if (uri != null) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    canApply ? 'Apply Now' : 'Applications closed',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Bookmark button
              SizedBox(width: 56, height: 56, child: BookmarkButton(job: job)),
            ],
          ),
        ),
      ),
    );
  }
}
