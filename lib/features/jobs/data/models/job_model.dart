enum EmploymentType {
  fullTime,
  partTime,
  contract,
  internship,
}

enum ExperienceLevel {
  junior,
  mid,
  senior,
}

class Job {
  final String? id;
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
    this.id,
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
      employmentType: _parseEmploymentType(json['employmentType']),
      experienceLevel: _parseExperienceLevel(json['experienceLevel']),
      salaryRange: json['salaryRange'],
      techStack: List<String>.from(json['techStack'] ?? []),
      keywords: List<String>.from(json['keywords'] ?? []),
      source: json['source'],
      isActive: json['isActive'] ?? true,
      expiresAt: DateTime.parse(json['expiresAt']),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      logoUrl: json['logoUrl'],
      submissionLink: json['submissionLink'],
    );
  }

  static EmploymentType _parseEmploymentType(String type) {
    switch (type.toLowerCase()) {
      case 'full-time':
      case 'fulltime':
        return EmploymentType.fullTime;
      case 'part-time':
      case 'parttime':
        return EmploymentType.partTime;
      case 'contract':return EmploymentType.contract;
      case 'internship':
        return EmploymentType.internship;
      default:
        return EmploymentType.fullTime;
    }
  }

  static ExperienceLevel _parseExperienceLevel(String level) {
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

  PaginatedResponse({
    required this.data,
    required this.nextCursor,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    final items = (json['data'] as List)
        .map((e) => fromJsonT(e as Map<String, dynamic>))
        .toList();

    return PaginatedResponse(
      data: items,
      nextCursor: json['nextCursor'],
    );
  }
}
class JobSearchFilters {
  final String? search;
  final String? location;
  final EmploymentType? employmentType;
  final ExperienceLevel? experienceLevel;
  final int? limit;
  final String? cursor;

  JobSearchFilters({
    this.search,
    this.location,
    this.employmentType,
    this.experienceLevel,
    this.limit,
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


