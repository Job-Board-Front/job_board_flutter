import 'package:flutter/material.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

class JobHeader extends StatelessWidget {
  final Job job;
  const JobHeader({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          child: Text(job.company[0]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(job.title,
                  style: Theme.of(context).textTheme.titleLarge),
              Text(job.company,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  _iconText(Icons.location_on, job.location),
                  _iconText(Icons.work, _formatEmploymentType(job.employmentType)),
                  _iconText(Icons.attach_money, job.salaryRange ?? 'N/A'),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  String _formatEmploymentType(EmploymentType type) {
    switch (type) {
      case EmploymentType.fullTime:
        return 'Full-time';
      case EmploymentType.partTime:
        return 'Part-time';
      case EmploymentType.contract:
        return 'Contract';
      case EmploymentType.internship:
        return 'Internship';
    }
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
