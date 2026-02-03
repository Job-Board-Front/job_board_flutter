enum EmploymentType { fullTime, partTime, contract, internship }

enum ExperienceLevel { junior, mid, senior }

class Job {
  final String id;
  final String title;
  final String description;
  final String company;
  final String location;
  final EmploymentType employmentType;
  final ExperienceLevel experienceLevel;
  final String? salaryRange;
  final List<String> techStack;
  final List<String> keywords;
  final String source;
  final bool isActive;
  final DateTime expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? logoUrl;
  final String? submissionLink;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.location,
    required this.employmentType,
    required this.experienceLevel,
    this.salaryRange,
    required this.techStack,
    required this.keywords,
    required this.source,
    required this.isActive,
    required this.expiresAt,
    this.createdAt,
    this.updatedAt,
    this.logoUrl,
    this.submissionLink,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      company: json['company'],
      location: json['location'],
      employmentType: parseEmploymentType(json['employmentType']),
      experienceLevel: parseExperienceLevel(json['experienceLevel']),
      salaryRange: json['salaryRange'],
      techStack: List<String>.from(json['techStack'] ?? []),
      keywords: List<String>.from(json['keywords'] ?? []),
      source: json['source'],
      isActive: json['isActive'] ?? true,
      expiresAt: DateTime.parse(json['expiresAt']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      logoUrl: json['logoUrl'],
      submissionLink: json['submissionLink'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'company': company,
      'location': location,
      'employmentType': _employmentTypeToString(employmentType),
      'experienceLevel': _experienceLevelToString(experienceLevel),
      'salaryRange': salaryRange,
      'techStack': techStack,
      'keywords': keywords,
      'source': source,
      'isActive': isActive,
      'expiresAt': expiresAt.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'logoUrl': logoUrl,
      'submissionLink': submissionLink,
    };
  }

  // Helpers to convert Enums back to the String format your API expects
  static String _employmentTypeToString(EmploymentType type) {
    switch (type) {
      case EmploymentType.fullTime:
        return 'full-time'; // Assuming API expects this kebab-case based on your parser
      case EmploymentType.partTime:
        return 'part-time';
      case EmploymentType.contract:
        return 'contract';
      case EmploymentType.internship:
        return 'internship';
    }
  }

  static String _experienceLevelToString(ExperienceLevel level) {
    return level
        .toString()
        .split('.')
        .last; // Returns 'junior', 'mid', 'senior'
  }

  static EmploymentType parseEmploymentType(String type) {
    switch (type.toLowerCase()) {
      case 'full-time':
      case 'fulltime':
        return EmploymentType.fullTime;
      case 'part-time':
      case 'parttime':
        return EmploymentType.partTime;
      case 'contract':
        return EmploymentType.contract;
      case 'internship':
        return EmploymentType.internship;
      default:
        return EmploymentType.fullTime;
    }
  }

  static ExperienceLevel parseExperienceLevel(String level) {
    switch (level.toLowerCase()) {
      case 'junior':
        return ExperienceLevel.junior;
      case 'mid':
        return ExperienceLevel.mid;
      case 'senior':
        return ExperienceLevel.senior;
      default:
        return ExperienceLevel.mid;
    }
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final String? nextCursor;

  PaginatedResponse({required this.data, required this.nextCursor});

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final items = (json['data'] as List)
        .map((e) => fromJsonT(e as Map<String, dynamic>))
        .toList();

    return PaginatedResponse(data: items, nextCursor: json['nextCursor']);
  }
}

class JobSearchFilters {
  final String? search;
  final String? location;
  final EmploymentType? employmentType;
  final ExperienceLevel? experienceLevel;
  final int limit;
  final String? cursor;

  JobSearchFilters({
    this.search,
    this.location,
    this.employmentType,
    this.experienceLevel,
    this.limit = 10,
    this.cursor,
  });

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};

    if (search != null && search!.isNotEmpty) {
      params['search'] = search!;
    }
    if (location != null && location!.isNotEmpty) {
      params['location'] = location!;
    }
    if (employmentType != null) {
      params['employmentType'] = employmentType.toString().split('.').last;
    }
    if (experienceLevel != null) {
      params['experienceLevel'] = experienceLevel.toString().split('.').last;
    }
    if (limit != null) {
      params['limit'] = limit.toString();
    }
    if (cursor != null) {
      params['cursor'] = cursor!;
    }

    return params;
  }
}
