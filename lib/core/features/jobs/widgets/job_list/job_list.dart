import 'package:flutter/material.dart';
import '../../data/models/job_model.dart';
import '../job_card/job_card.dart';

class JobList extends StatelessWidget {
  final List<Job> jobs;

  const JobList({
    super.key,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: jobs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return JobCard(job: jobs[index]);
      },
    );
  }
}
