import 'package:flutter/material.dart';

class JobSkills extends StatelessWidget {
  final List<String> skills;
  const JobSkills({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox();

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
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Colors.blueAccent,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Key skills',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: skills
                  .map((s) => Chip(label: Text(s)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
// Job Skills Widget
