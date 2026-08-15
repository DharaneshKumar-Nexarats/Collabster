import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'startup_dashboard_state.dart';

class StartupDashboardViewModel extends StateNotifier<StartupDashboardState> {
  StartupDashboardViewModel() : super(const StartupDashboardState());

  void loadSessionData({
    String? startupIndustry,
    String? startupStage,
    String? startupCountry,
    String? country,
    String? startupCity,
    String? city,
    String? startupTagline,
    String? profilePhotoPath,
    required String fullName,
    required String email,
    required String startupName,
  }) {
    final tagline = startupTagline ?? '';
    state = state.copyWith(
      industry: startupIndustry ?? '',
      stage: startupStage ?? '',
      country: startupCountry ?? country ?? '',
      city: startupCity ?? city ?? '',
      tagline: tagline,
      ownerName: fullName,
      email: email,
      profilePhotoPath: profilePhotoPath ?? '',
      recentActivity: [
        ActivityItem(
          iconKey: tagline.startsWith('Member of') ? 'group' : 'rocket',
          title: tagline.startsWith('Member of')
              ? 'Joined $startupName'
              : 'Startup profile created',
          subtitle: 'Your startup details are saved to this dashboard.',
          colorKey: 'primary',
        ),
      ],
    );
  }

  void selectNav(int index) {
    state = state.copyWith(selectedNavIndex: index);
  }

  void resetNav() {
    state = state.copyWith(selectedNavIndex: 0);
  }

  void acceptConnection(int index) {
    final updated = List<ConnectionRequest>.from(state.connectionRequests);
    updated.removeAt(index);
    state = state.copyWith(connectionRequests: updated);
  }

  void ignoreConnection(int index) {
    final updated = List<ConnectionRequest>.from(state.connectionRequests);
    updated.removeAt(index);
    state = state.copyWith(connectionRequests: updated);
  }
}
