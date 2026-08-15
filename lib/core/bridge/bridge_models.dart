import '../../features/career/model/job_model.dart';
import '../../features/career/model/notification_model.dart';
import '../../features/community/model/notification_model.dart';
import '../../features/community/model/post_model.dart';
import '../../features/event/model/event_model.dart';
import '../../features/event/model/notification_model.dart';
import '../../features/investor/model/funding_round_model.dart';
import '../../features/investor/model/investor_model.dart';
import '../../features/investor/model/notification_model.dart';
import '../../features/startup/model/notification_model.dart';
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

/// Career board jobs & internships → unified opportunities.
List<BridgeOpportunity> careerJobOpportunities(List<JobItem> jobs) {
  return jobs
      .map(
        (j) => BridgeOpportunity(
          id: 'career-${j.title}',
          kind: j.roleType,
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

/// Unified funding round / deal surfaced across Startup → Investor modes.
class BridgeFundingRound {
  final String id;
  final String startup;
  final String sector;
  final String stage;
  final double targetAmount;
  final double raisedAmount;
  final String location;
  final String source; // 'investor-mode' | 'startup-fundraising'
  final String sourceLabel;
  final DateTime closeDate;
  final int investors;

  const BridgeFundingRound({
    required this.id,
    required this.startup,
    required this.sector,
    required this.stage,
    required this.targetAmount,
    required this.raisedAmount,
    required this.location,
    required this.source,
    required this.sourceLabel,
    required this.closeDate,
    required this.investors,
  });

  double get progress => targetAmount == 0 ? 0 : (raisedAmount / targetAmount).clamp(0.0, 1.0);
}

/// Investor mode funding rounds → unified funding rounds.
List<BridgeFundingRound> investorFundingRoundsToBridge(
  List<FundingRound> rounds, {
  required String sourceLabel,
}) {
  DateTime parseCloseDate(String closeDate) {
    // closeDate format: "Aug 28" (MMM dd)
    final now = DateTime.now();
    final parts = closeDate.split(' ');
    if (parts.length != 2) return now.add(const Duration(days: 30));
    final monthStr = parts[0];
    final dayStr = parts[1];
    final months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
    };
    final month = months[monthStr] ?? now.month;
    final day = int.tryParse(dayStr) ?? now.day;
    final year = now.month > month ? now.year + 1 : now.year;
    return DateTime(year, month, day);
  }

  return rounds
      .map(
        (r) => BridgeFundingRound(
          id: 'investor-fr-${r.id}',
          startup: r.startup,
          sector: r.sector,
          stage: r.stage,
          targetAmount: r.targetAmount,
          raisedAmount: r.raisedAmount,
          location: r.location,
          source: 'investor-mode',
          sourceLabel: sourceLabel,
          closeDate: parseCloseDate(r.closeDate),
          investors: r.investors,
        ),
      )
      .toList();
}

/// Startup fundraising rounds → unified funding rounds.
List<BridgeFundingRound> startupFundraisingToBridge(
  double targetAmount,
  double raisedAmount,
  String startupName,
) {
  return [
    BridgeFundingRound(
      id: 'startup-fr-$startupName',
      startup: startupName,
      sector: 'Multi-sector',
      stage: 'Active Raise',
      targetAmount: targetAmount * 1000000,
      raisedAmount: raisedAmount * 1000000,
      location: 'Global',
      source: 'startup-fundraising',
      sourceLabel: startupName,
      closeDate: DateTime.now().add(const Duration(days: 30)),
      investors: 0,
    ),
  ];
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

/// Unified cross-mode notification surfaced across all modes.
class BridgeNotification {
  final String id;
  final String title;
  final String subtitle;
  final String body;
  final String type; // 'connection' | 'message' | 'milestone' | 'funding' | 'team' | 'document' | 'system' | 'post' | 'event' | 'job' | 'interview'
  final String iconKey;
  final String colorKey;
  final DateTime createdAt;
  final bool isRead;
  final String source; // 'startup' | 'career' | 'community' | 'event' | 'investor'
  final String sourceLabel;
  final String? deepLink;

  const BridgeNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.type,
    required this.iconKey,
    required this.colorKey,
    required this.createdAt,
    this.isRead = false,
    required this.source,
    required this.sourceLabel,
    this.deepLink,
  });
}

/// Startup notifications → unified notifications.
List<BridgeNotification> startupNotificationsToBridge(
  List<AppNotification> notifications, {
  required String startupName,
}) {
  return notifications
      .map(
        (n) => BridgeNotification(
          id: 'startup-${n.id}',
          title: n.title,
          subtitle: n.subtitle,
          body: n.body ?? '',
          type: n.type.name,
          iconKey: n.iconKey,
          colorKey: n.colorKey,
          createdAt: n.createdAt,
          isRead: n.isRead,
          source: 'startup',
          sourceLabel: startupName,
          deepLink: n.deepLink,
        ),
      )
      .toList();
}

/// Community notifications → unified notifications.
List<BridgeNotification> communityNotificationsToBridge(
  List<CommunityNotification> notifications,
) {
  return notifications
      .map(
        (n) => BridgeNotification(
          id: 'community-${n.id}',
          title: n.title,
          subtitle: n.subtitle,
          body: n.body,
          type: n.type.name,
          iconKey: n.iconName,
          colorKey: '0x${n.iconColor.toRadixString(16).padLeft(8, '0')}',
          createdAt: n.createdAt,
          isRead: n.isRead,
          source: 'community',
          sourceLabel: 'Community Hub',
          deepLink: n.deepLink,
        ),
      )
      .toList();
}

/// Career notifications → unified notifications.
List<BridgeNotification> careerNotificationsToBridge(
  List<CareerNotification> notifications,
) {
  return notifications
      .map(
        (n) => BridgeNotification(
          id: 'career-${n.id}',
          title: n.title,
          subtitle: n.description,
          body: '',
          type: n.type.name,
          iconKey: n.iconName,
          colorKey: '0x${n.iconColor.toRadixString(16).padLeft(8, '0')}',
          createdAt: DateTime.now().subtract(_parseCareerTime(n.time)),
          isRead: n.isRead,
          source: 'career',
          sourceLabel: 'Career Hub',
          deepLink: n.deepLink,
        ),
      )
      .toList();
}

/// Event notifications → unified notifications.
List<BridgeNotification> eventNotificationsToBridge(
  List<EventNotification> notifications,
) {
  return notifications
      .map(
        (n) => BridgeNotification(
          id: 'event-${n.id}',
          title: n.title,
          subtitle: n.subtitle,
          body: n.body,
          type: n.type.name,
          iconKey: n.iconName,
          colorKey: '0x${n.iconColor.toRadixString(16).padLeft(8, '0')}',
          createdAt: n.createdAt,
          isRead: n.isRead,
          source: 'event',
          sourceLabel: 'Event Hub',
          deepLink: n.deepLink,
        ),
      )
      .toList();
}

/// Investor notifications → unified notifications.
List<BridgeNotification> investorNotificationsToBridge(
  List<InvestorNotification> notifications,
) {
  return notifications
      .map(
        (n) => BridgeNotification(
          id: 'investor-${n.id}',
          title: n.title,
          subtitle: n.subtitle,
          body: n.body,
          type: n.type.name,
          iconKey: n.iconName,
          colorKey: '0x${n.iconColor.toRadixString(16).padLeft(8, '0')}',
          createdAt: n.createdAt,
          isRead: n.isRead,
          source: 'investor',
          sourceLabel: 'Investor Hub',
          deepLink: n.deepLink,
        ),
      )
      .toList();
}

Duration _parseCareerTime(String time) {
  final parts = time.toLowerCase().split(' ');
  if (parts.length != 2) return Duration.zero;
  final value = int.tryParse(parts[0]) ?? 0;
  final unit = parts[1];
  switch (unit) {
    case 'm':
    case 'min':
    case 'mins':
    case 'minute':
    case 'minutes':
      return Duration(minutes: value);
    case 'h':
    case 'hr':
    case 'hrs':
    case 'hour':
    case 'hours':
      return Duration(hours: value);
    case 'd':
    case 'day':
    case 'days':
      return Duration(days: value);
    default:
      return Duration.zero;
  }
}