import 'package:flutter/material.dart';
import '../data/models/job_model.dart';
import 'job_card.dart';

class SimilarJobs extends StatelessWidget {
  final List<Job> jobs;
  final VoidCallback? onMoreTap;
  final Function(Job)? onJobTap;
  final Function(Job)? onBookmarkTap;
  final Set<String> bookmarkedJobIds;

  const SimilarJobs({
    Key? key,
    required this.jobs,
    this.onMoreTap,
    this.onJobTap,
    this.onBookmarkTap,
    this.bookmarkedJobIds = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Similar Jobs',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF1F5F9),
            ),
          ),
        ),

        // Liste des 3 premiers jobs similaires
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: jobs.length > 3 ? 3 : jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return JobCard(
              job: job,
              onTap: () => onJobTap?.call(job),
              onBookmarkTap: () => onBookmarkTap?.call(job),
              isBookmarked: bookmarkedJobIds.contains(job.id),
            );
          },
        ),

        // Bouton "More Similar Jobs"
        if (jobs.length > 3)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onMoreTap,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('More Similar Jobs'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(
                    color: Color(0xFF60A5FA),
                    width: 1.5,
                  ),foregroundColor: const Color(0xFF60A5FA),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
