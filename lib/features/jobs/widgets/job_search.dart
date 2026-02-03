import 'dart:async';

import 'package:flutter/material.dart';

class JobSearch extends StatefulWidget {
  final String? search;
  final Function(String key, String? value) onFilterChanged;

  const JobSearch({super.key, this.search, required this.onFilterChanged});

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search by job title, company, or location...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: _onSearchChanged,
    );
  }

  void _onSearchChanged(String query) {
    // If a timer is already running, cancel it
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new timer for 500 milliseconds
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onFilterChanged('search', query);
    });
  }
}
