import 'job_model.dart';

class CreateJobDto {
  final String title;
  final String description;
  final String company;
  final String location;
  final EmploymentType employmentType;
  final ExperienceLevel experienceLevel;
  final String? salaryRange;
  final List<String> techStack;
  final String submissionLink;

  CreateJobDto({
    required this.title,
    required this.description,
    required this.company,
    required this.location,
    required this.employmentType,
    required this.experienceLevel,
    this.salaryRange,
    required this.techStack,
    this.submissionLink = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'company': company,
      'location': location,
      'employmentType': _employmentTypeToString(employmentType),
      'experienceLevel': _experienceLevelToString(experienceLevel),
      if (salaryRange != null && salaryRange!.isNotEmpty) 'salaryRange': salaryRange,
      'techStack': techStack,
      'submissionLink': submissionLink,
    };
  }

  static String _employmentTypeToString(EmploymentType type) {
    switch (type) {
      case EmploymentType.fullTime:
        return 'full-time';
      case EmploymentType.partTime:
        return 'part-time';
      case EmploymentType.contract:
        return 'contract';
      case EmploymentType.internship:
        return 'internship';
    }
  }

  static String _experienceLevelToString(ExperienceLevel level) {
    return level.toString().split('.').last;
  }
}

class UpdateJobDto {
  final String? title;
  final String? description;
  final String? company;
  final String? location;
  final EmploymentType? employmentType;
  final ExperienceLevel? experienceLevel;
  final String? salaryRange;
  final List<String>? techStack;
  final String? submissionLink;

  UpdateJobDto({
    this.title,
    this.description,
    this.company,
    this.location,
    this.employmentType,
    this.experienceLevel,
    this.salaryRange,
    this.techStack,
    this.submissionLink,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    
    if (title != null) map['title'] = title;
    if (description != null) map['description'] = description;
    if (company != null) map['company'] = company;
    if (location != null) map['location'] = location;
    if (employmentType != null) {
      map['employmentType'] = _employmentTypeToString(employmentType!);
    }
    if (experienceLevel != null) {
      map['experienceLevel'] = _experienceLevelToString(experienceLevel!);
    }
    if (salaryRange != null && salaryRange!.isNotEmpty) {
      map['salaryRange'] = salaryRange;
    }
    if (techStack != null) map['techStack'] = techStack;
    if (submissionLink != null && submissionLink!.isNotEmpty) {
      map['submissionLink'] = submissionLink;
    }
    
    return map;
  }

  static String _employmentTypeToString(EmploymentType type) {
    switch (type) {
      case EmploymentType.fullTime:
        return 'full-time';
      case EmploymentType.partTime:
        return 'part-time';
      case EmploymentType.contract:
        return 'contract';
      case EmploymentType.internship:
        return 'internship';
    }
  }

  static String _experienceLevelToString(ExperienceLevel level) {
    return level.toString().split('.').last;
  }

  factory UpdateJobDto.fromJob(Job job) {
    return UpdateJobDto(
      title: job.title,
      description: job.description,
      company: job.company,
      location: job.location,
      employmentType: job.employmentType,
      experienceLevel: job.experienceLevel,
      salaryRange: job.salaryRange,
      techStack: job.techStack,
      submissionLink: job.submissionLink,
    );
  }
}
