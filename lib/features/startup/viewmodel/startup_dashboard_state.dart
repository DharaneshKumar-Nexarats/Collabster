import '../model/startup_models.dart';

enum VerificationStatus {
  unverified,
  pending,
  verified,
  rejected,
}

class StartupDashboardState {
  const StartupDashboardState({
    this.selectedNavIndex = 0,
    this.industry = '',
    this.stage = '',
    this.country = '',
    this.city = '',
    this.tagline = '',
    this.ownerName = '',
    this.email = '',
    this.profilePhotoPath = '',
    this.connectionRequests = const [],
    this.recentActivity = const [],
    this.verificationStatus = VerificationStatus.unverified,
    this.verificationRejectionReason,
    this.verificationSubmittedAt,
  });

  final int selectedNavIndex;
  final String industry;
  final String stage;
  final String country;
  final String city;
  final String tagline;
  final String ownerName;
  final String email;
  final String profilePhotoPath;
  final List<ConnectionRequest> connectionRequests;
  final List<ActivityItem> recentActivity;
  final VerificationStatus verificationStatus;
  final String? verificationRejectionReason;
  final DateTime? verificationSubmittedAt;

  String get locationLabel {
    final parts = <String>[];
    if (city.isNotEmpty) parts.add(city);
    if (country.isNotEmpty) parts.add(country);
    return parts.join(', ');
  }

  bool get isVerified => verificationStatus == VerificationStatus.verified;
  bool get isVerificationPending => verificationStatus == VerificationStatus.pending;
  bool get isVerificationRejected => verificationStatus == VerificationStatus.rejected;
  bool get canAccessHiring => verificationStatus == VerificationStatus.verified;

  StartupDashboardState copyWith({
    int? selectedNavIndex,
    String? industry,
    String? stage,
    String? country,
    String? city,
    String? tagline,
    String? ownerName,
    String? email,
    String? profilePhotoPath,
    List<ConnectionRequest>? connectionRequests,
    List<ActivityItem>? recentActivity,
    VerificationStatus? verificationStatus,
    String? verificationRejectionReason,
    DateTime? verificationSubmittedAt,
  }) {
    return StartupDashboardState(
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      industry: industry ?? this.industry,
      stage: stage ?? this.stage,
      country: country ?? this.country,
      city: city ?? this.city,
      tagline: tagline ?? this.tagline,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      connectionRequests: connectionRequests ?? this.connectionRequests,
      recentActivity: recentActivity ?? this.recentActivity,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verificationRejectionReason: verificationRejectionReason ?? this.verificationRejectionReason,
      verificationSubmittedAt: verificationSubmittedAt ?? this.verificationSubmittedAt,
    );
  }
}
