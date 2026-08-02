import 'package:flutter/foundation.dart';
import '../model/startup_models.dart';

class StartupDashboardViewModel extends ChangeNotifier {
  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;

  String _industry = '';
  String get industry => _industry;

  String _stage = '';
  String get stage => _stage;

  String _country = '';
  String get country => _country;

  String _city = '';
  String get city => _city;

  String _tagline = '';
  String get tagline => _tagline;

  String _ownerName = '';
  String get ownerName => _ownerName;

  String _email = '';
  String get email => _email;

  String _profilePhotoPath = '';
  String get profilePhotoPath => _profilePhotoPath;

  String get locationLabel {
    final parts = <String>[];
    if (_city.isNotEmpty) parts.add(_city);
    if (_country.isNotEmpty) parts.add(_country);
    return parts.join(', ');
  }

  final List<ConnectionRequest> _connectionRequests = [
    const ConnectionRequest(name: 'Sarah Miller', role: 'Lead Designer', initials: 'SM'),
    const ConnectionRequest(name: 'Alex Johnson', role: 'AI Researcher', initials: 'AJ'),
  ];
  List<ConnectionRequest> get connectionRequests => _connectionRequests;

  List<ActivityItem> _recentActivity = [];
  List<ActivityItem> get recentActivity => _recentActivity;

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
    _industry = startupIndustry ?? '';
    _stage = startupStage ?? '';
    _country = startupCountry ?? country ?? '';
    _city = startupCity ?? city ?? '';
    _tagline = startupTagline ?? '';
    _ownerName = fullName;
    _email = email;
    _profilePhotoPath = profilePhotoPath ?? '';
    _recentActivity = [
      ActivityItem(
        iconKey: _tagline.startsWith('Member of') ? 'group' : 'rocket',
        title: _tagline.startsWith('Member of')
            ? 'Joined $startupName'
            : 'Startup profile created',
        subtitle: 'Your startup details are saved to this dashboard.',
        colorKey: 'primary',
      ),
    ];
    notifyListeners();
  }

  void selectNav(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  void resetNav() {
    _selectedNavIndex = 0;
    notifyListeners();
  }

  void acceptConnection(int index) {
    _connectionRequests.removeAt(index);
    notifyListeners();
  }

  void ignoreConnection(int index) {
    _connectionRequests.removeAt(index);
    notifyListeners();
  }
}
