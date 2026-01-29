import 'package:flutter/material.dart';

class JobDescription extends StatefulWidget {
  final String description;

  const JobDescription({super.key, required this.description});

  @override
  State<JobDescription> createState() => _JobDescriptionState();
}

class _JobDescriptionState extends State<JobDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final maxLength = 300;
    final isLongText = widget.description.length > maxLength;
    final displayText = _isExpanded || !isLongText
        ? widget.description
        : '${widget.description.substring(0, widget.description.length > maxLength ? maxLength : widget.description.length)}...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayText),
        if (isLongText)
          TextButton(
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(_isExpanded ? 'Voir moins' : 'Voir plus'),
          ),
      ],
    );
  }
}
