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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayText = _isExpanded || !isLongText
        ? widget.description
        : '${widget.description.substring(0, widget.description.length > maxLength ? maxLength : widget.description.length)}...';

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                displayText,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: isDark ? Colors.grey : Colors.black54,
                ),
              ),
              if (isLongText) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  ),
                  label: Text(
                    _isExpanded ? 'Read Less' : 'Read More',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
