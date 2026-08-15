import '../../features/career/model/job_model.dart';
import '../../features/community/model/post_model.dart';
import '../../features/event/model/event_model.dart';
import '../../features/investor/model/investor_model.dart';
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

/// Unified cross-mode event surfaced across Event → Startup → Community hubs.
class BridgeEvent {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime startDate;
  final String category;
  final bool isOnline;
  final int attendeeCount;
  final String source; // 'event' | 'startup' | 'community'
  final String sourceLabel;

  const BridgeEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.category,
    required this.source,
    required this.sourceLabel,
    this.isOnline = false,
    this.attendeeCount = 0,
  });
}

/// Event hub event → unified event.
BridgeEvent eventToBridge(Event event) {
  return BridgeEvent(
    id: 'event-${event.id}',
    title: event.title,
    description: event.description,
    location: event.location,
    startDate: event.startDate,
    category: event.category,
    isOnline: event.isOnline,
    attendeeCount: event.attendeeCount,
    source: 'event',
    sourceLabel: 'Event Hub',
  );
}

/// Unified investor / funding connection across Startup → Investor modes.
class BridgeInvestor {
  final String id;
  final String name;
  final String fund;
  final String amount;
  final String status;
  final String initials;
  final String source; // 'startup-pipeline' | 'investor'
  final String sourceLabel;

  const BridgeInvestor({
    required this.id,
    required this.name,
    required this.fund,
    required this.amount,
    required this.status,
    required this.initials,
    required this.source,
    required this.sourceLabel,
  });
}

/// Startup pipeline investors → unified investors.
List<BridgeInvestor> startupPipelineToBridge(
  List<InvestorEntry> entries, {
  required String sourceLabel,
}) {
  return entries
      .map(
        (e) => BridgeInvestor(
          id: 'pipeline-${e.name}',
          name: e.name,
          fund: e.fund,
          amount: e.amount,
          status: e.status,
          initials: e.initials,
          source: 'startup-pipeline',
          sourceLabel: sourceLabel,
        ),
      )
      .toList();
}

/// Investor mode investors → unified investors.
List<BridgeInvestor> investorModeToBridge(List<Investor> investors) {
  return investors
      .map(
        (i) => BridgeInvestor(
          id: 'investor-${i.id}',
          name: i.name,
          fund: i.focus,
          amount: '\$${(i.investmentRange / 1000).round()}K',
          status: i.isFollowing ? 'Following' : 'Discover',
          initials: i.initials,
          source: 'investor',
          sourceLabel: i.firm,
        ),
      )
      .toList();
}