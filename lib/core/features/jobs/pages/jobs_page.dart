import 'package:flutter/material.dart';
import '../../mocks/mock_jobs.dart';
import '../widgets/category_filter/category_filter.dart';
import '../widgets/job_list/job_list.dart';
import '../widgets/job_search/job_search.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final ScrollController _scrollController = ScrollController();
  int jobCount = mockJobs.length;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // équivalent scrolledToBottom
        onScrollBottom();
      }
    });
  }

  void onScrollBottom() {
    debugPrint('Reached bottom → load more');
    // ici tu brancheras l’API plus tard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const Text(
                'All Job Offers',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Browse through $jobCount available positions',
                style: TextStyle(color: Colors.grey[600]),
              ),

              const SizedBox(height: 24),

              /// Search
              const JobSearch(),

              const SizedBox(height: 16),

              /// Filters
              const CategoryFilter(),

              const SizedBox(height: 16),

              /// Counter
              Text(
                'Showing $jobCount jobs',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 16),

              /// Job list
              JobList(
                jobs: mockJobs,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
