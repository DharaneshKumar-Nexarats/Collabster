import '../../features/career/model/job_model.dart';
import '../../features/community/model/post_model.dart';
import '../../features/startup/model/startup_models.dart';

/// Unified cross-mode opportunity (job or internship) surfaced across
/// Startup → Career → Community hubs.
class BridgeOpportunity {
  final String id;
  final String kind; // 'job' | 'internship'
  final String title;
  final String company;
  final String location;
  final String salary;
  final String experience;
  final List<String> tags;
  final bool fromStartup;

  const BridgeOpportunity({
    required this.id,
    required this.kind,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    this.experience = '',
    this.tags = const [],
    this.fromStartup = false,
  });
}

/// Unified cross-mode post (startup update or community discussion).
class BridgePost {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String authorRole;
  final DateTime createdAt;
  final String source; // 'startup' | 'community'
  final String sourceLabel;
  final int likes;
  final int comments;

  const BridgePost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorRole,
    required this.createdAt,
    required this.source,
    required this.sourceLabel,
    this.likes = 0,
    this.comments = 0,
  });
}

/// Startup hiring roles (status HIRING) → unified opportunities.
List<BridgeOpportunity> startupHiringOpportunities(
  List<OpenRole> roles, {
  required String startupName,
}) {
  return roles
      .where((r) => r.status == 'HIRING')
      .map(
        (r) => BridgeOpportunity(
          id: '${r.title}-${r.department}-${r.roleType}',
          kind: r.roleType,
          title: r.title,
          company: startupName,
          location: r.location ?? 'On-site',
          salary: r.salaryLpa ?? (r.roleType == 'internship' ? 'Stipend on apply' : 'Salary on apply'),
          experience: r.experience ?? '',
          tags: (r.skills ?? '')
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .take(4)
              .toList(),
          fromStartup: true,
        ),
      )
      .toList();
}

/// Career board jobs → unified opportunities.
List<BridgeOpportunity> careerJobOpportunities(List<JobItem> jobs) {
  return jobs
      .map(
        (j) => BridgeOpportunity(
          id: 'career-${j.title}',
          kind: 'job',
          title: j.title,
          company: j.company,
          location: j.location,
          salary: j.salaryTag,
          experience: j.timeAgo,
          tags: j.tags,
        ),
      )
      .toList();
}

/// Startup post → unified post.
BridgePost startupPostToBridge(StartupPost post, {required String startupName}) {
  return BridgePost(
    id: 'startup-${post.id}',
    title: post.title,
    content: post.description,
    authorName: startupName,
    authorRole: post.type,
    createdAt: post.createdAt,
    source: 'startup',
    sourceLabel: startupName,
    comments: 0,
    likes: 0,
  );
}

/// Community post → unified post.
BridgePost careerPostToBridge(CareerPost post) {
  return BridgePost(
    id: 'community-${post.id}',
    title: post.title,
    content: post.content,
    authorName: post.authorName,
    authorRole: post.authorRole,
    createdAt: post.createdAt,
    source: 'community',
    sourceLabel: 'Community Talk',
    likes: post.likes,
    comments: post.comments,
  );
}