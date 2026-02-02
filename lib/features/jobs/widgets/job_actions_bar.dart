import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobActionsBar extends StatelessWidget {
  final String? submissionLink;
  final VoidCallback? onBookmarkTap;
  final bool isBookmarked;

  const JobActionsBar({
    super.key,
    required this.submissionLink,
    this.onBookmarkTap,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final canApply = submissionLink != null && submissionLink!.isNotEmpty;

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
                    final uri = Uri.tryParse(submissionLink!);
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: IconButton(
                  onPressed: onBookmarkTap,
                  icon: Icon(
                    isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: Colors.blueAccent,
                  ),
                  tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
                  iconSize: 24,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
