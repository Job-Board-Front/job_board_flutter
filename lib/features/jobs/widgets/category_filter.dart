import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Filter by', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildDropdown('Salary', ['All', '0-30k', '30k-60k']),
            _buildDropdown('Job Title', ['All', 'Flutter', 'Backend']),
            _buildDropdown('Location', ['All', 'Remote', 'Onsite']),
            _buildDropdown('Recent', ['All', 'Last 7 days', 'Last 30 days']),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (_) {},
      ),
    );
  }
}
