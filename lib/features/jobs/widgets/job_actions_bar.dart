import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobActionsBar extends StatelessWidget {
  const JobActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Apply Now'),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border),
            )
          ],
        ),
      ),
    );
  }
}
// Job Actions Bar Widget
