import 'package:job_board_flutter/features/jobs/data/models/job_model.dart';

class JobFiltersModel {
  final List<String> locations;
  final List<String> techStacks;
  final List<EmploymentType> employmentTypes;
  final List<ExperienceLevel> experienceLevels;

  JobFiltersModel({
    required this.locations,
    required this.techStacks,
    required this.employmentTypes,
    required this.experienceLevels,
  });

  factory JobFiltersModel.fromJson(Map<String, dynamic> json) {
    return JobFiltersModel(
      locations: List<String>.from(json['locations'] ?? []),
      techStacks: List<String>.from(json['techStacks'] ?? []),
      employmentTypes: List<String>.from(
        json['employmentTypes'] ?? [],
      ).map((e) => Job.parseEmploymentType(e)).toList(),
      experienceLevels: List<String>.from(
        json['experienceLevels'] ?? [],
      ).map((e) => Job.parseExperienceLevel(e)).toList(),
    );
  }
}
