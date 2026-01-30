import 'package:flutter/material.dart';
import '../../../core/utils/url_utils.dart';
import '../data/models/job_model.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final bool isBookmarked;

  const JobCard({
    Key? key,
    required this.job,
    this.onTap,
    this.onBookmarkTap,
    this.isBookmarked = false,
  }) : super(key: key);

  String getEmploymentLabel(EmploymentType type) {
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

  Color getEmploymentColor(EmploymentType type) {
    switch (type) {
      case EmploymentType.fullTime:
        return const Color(0xFF60A5FA); // blue-400
      case EmploymentType.partTime:
        return const Color(0xFFFB923C); // orange-400
      case EmploymentType.contract:
        return const Color(0xFFA78BFA); // purple-400
      case EmploymentType.internship:
        return const Color(0xFF34D399); // green-400
    }
  }

  Color getTechStackColor(int index) {
    final colors = [
      const Color(0xFFEC4899), // rose-500
      const Color(0xFF14B8A6), // teal-500
      const Color(0xFFF59E0B), // amber-500
      const Color(0xFF8B5CF6), // violet-500
      const Color(0xFF06B6D4), // cyan-500
      const Color(0xFFF97316), // orange-500
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.cardColor,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Logo + Title/Company + Bookmark
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: job.logoUrl != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        absoluteUrl(job.logoUrl!)!,
                        fit: BoxFit.cover,

                        errorBuilder: (_, __, ___) => Center(
                          child: Text(
                            job.company
                                .split(' ')
                                .map((e) => e[0])
                                .take(2)
                                .join(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ),
                    )
                        : Center(
                      child: Text(
                        job.company
                            .split(' ')
                            .map((e) => e[0])
                            .take(2)
                            .join(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF1F5F9),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.company,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onBookmarkTap != null)
                    IconButton(
                      onPressed: onBookmarkTap,
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: isBookmarked
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFF64748B),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                job.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFCBD5E1),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 14),

              // Tech Stack
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.techStack.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tag = entry.value;
                  final color = getTechStackColor(index);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(0.15),
                          color.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                        letterSpacing: 0.2,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Footer: Location + EmploymentType + Salary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            job.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: getEmploymentColor(job.employmentType)
                                .withOpacity(0.15),
                            border: Border.all(
                              color: getEmploymentColor(job.employmentType)
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            getEmploymentLabel(job.employmentType),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: getEmploymentColor(job.employmentType),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (job.salaryRange != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF60A5FA).withOpacity(0.15),
                            const Color(0xFF3B82F6).withOpacity(0.15),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF60A5FA).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        job.salaryRange!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF60A5FA),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Remplacez 'your-job-id' par un ID de job réel de votre API
                    Navigator.pushNamed(
                      context,
                      '/job-details',
                      arguments: 'jepP1lkX4HguINPq0vqs',
                    );
                  },
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
