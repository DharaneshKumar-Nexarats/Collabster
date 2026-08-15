class JobItem {
  final String logo;
  final String title;
  final String company;
  final String location;
  final String salaryTag;
  final List<String> tags;
  final String timeAgo;
  final bool showNew;
  final String roleType; // 'job' | 'internship'

  const JobItem({
    required this.logo,
    required this.title,
    required this.company,
    required this.location,
    required this.salaryTag,
    required this.tags,
    required this.timeAgo,
    this.showNew = false,
    this.roleType = 'job',
  });
}

class JobApplication {
  final String id;
  final String jobId;
  final String jobTitle;
  final String company;
  final String status;
  final DateTime appliedAt;

  const JobApplication({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.company,
    required this.status,
    required this.appliedAt,
  });
}

class Resume {
  final String id;
  final String name;
  final String fileName;
  final DateTime uploadedAt;
  final double atsScore;

  const Resume({
    required this.id,
    required this.name,
    required this.fileName,
    required this.uploadedAt,
    this.atsScore = 0.0,
  });
}
