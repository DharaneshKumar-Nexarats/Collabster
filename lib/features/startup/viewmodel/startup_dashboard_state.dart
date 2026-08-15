import '../model/startup_models.dart';

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

  String get locationLabel {
    final parts = <String>[];
    if (city.isNotEmpty) parts.add(city);
    if (country.isNotEmpty) parts.add(country);
    return parts.join(', ');
  }

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
    );
  }
}
