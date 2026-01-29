import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobSkills extends StatelessWidget {
  final List<String> skills;
  const JobSkills({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key skills',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: skills
              .map((s) => Chip(label: Text(s)))
              .toList(),
        ),
      ],
    );
  }
}
// Job Skills Widget
