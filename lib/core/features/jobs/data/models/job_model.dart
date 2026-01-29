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
      employmentType:
      EmploymentType.values.firstWhere(
            (e) => e.name.replaceAll('Time', '-time') == json['employmentType'],
      ),
      experienceLevel:
      ExperienceLevel.values.firstWhere(
            (e) => e.name == json['experienceLevel'],
      ),
      salaryRange: json['salaryRange'],
      techStack: List<String>.from(json['techStack']),
      keywords: List<String>.from(json['keywords']),
      source: json['source'],
      isActive: json['isActive'],
      expiresAt: DateTime.parse(json['expiresAt']),
      createdAt:
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
      json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      logoUrl: json['logoUrl'],
      submissionLink: json['submissionLink'],
    );
  }
}