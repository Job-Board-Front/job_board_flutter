import 'package:flutter/material.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

class JobDetailsCard extends StatelessWidget {
  final Job job;
  const JobDetailsCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item('Company', job.company),
            _item('Location', job.location),
            _item('Employment Type', _formatEmploymentType(job.employmentType)),
            _item('Salary', job.salaryRange ?? 'Not specified'),
          ],
        ),
      ),
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

  Widget _item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
