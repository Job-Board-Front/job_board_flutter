import 'package:flutter/material.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_filters_model.dart';
import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

class CategoryFilter extends StatelessWidget {
  final JobFiltersModel? filtersData;
  final JobSearchFilters activeFilters;
  final Function(String key, String? value) onFilterChanged;
  const CategoryFilter({
    super.key,
    this.filtersData,
    required this.activeFilters,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Filter by', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),

        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildDropdown(
              'Experience Level',
              'experience',
              filtersData?.experienceLevels.map((e) => e.name).toList() ??
                  ['All', 'Junior', 'Mid', 'Senior'],
              activeFilters.experienceLevel?.name,
            ),
            _buildDropdown(
              'Location',
              'location',
              filtersData?.locations ?? [],
              activeFilters.location,
            ),
            _buildDropdown(
              'Employment Type',
              'employment',
              filtersData?.employmentTypes.map((e) => e.name).toList() ??
                  ['All', 'Full Time', 'Part Time', 'Contract', 'Internship'],
              activeFilters.employmentType?.name,
            ),
            _buildDropdown(
              "Tech Stacks",
              'tech',
              filtersData?.techStacks ?? [],
              activeFilters.experienceLevel?.name,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String key,
    List<String> items,
    String? currentValue,
  ) {
    return SizedBox(
      width: 160,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        initialValue: (items.contains(currentValue)) ? currentValue : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) => onFilterChanged(key, val),
      ),
    );
  }
}
