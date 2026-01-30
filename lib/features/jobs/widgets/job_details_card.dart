import 'package:flutter/material.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

class JobDetailsCard extends StatelessWidget {
  final Job job;
  const JobDetailsCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            _item(Icons.business, 'Company', job.company),
            const SizedBox(height: 16),
            _item(Icons.location_on, 'Location', job.location),
            const SizedBox(height: 16),
            _item(Icons.work_outline, 'Employment Type', _formatEmploymentType(job.employmentType)),
            const SizedBox(height: 16),
            _item(Icons.payments_outlined, 'Salary', job.salaryRange ?? 'Not specified'),
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

  Widget _item(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
