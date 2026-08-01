import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class StartupDashboardViewModel extends ChangeNotifier {
  int _selectedNavIndex = 0;
  int get selectedNavIndex => _selectedNavIndex;

  final List<ConnectionRequest> _connectionRequests = [
    const ConnectionRequest(name: 'Sarah Miller', role: 'Lead Designer', initials: 'SM'),
    const ConnectionRequest(name: 'Alex Johnson', role: 'AI Researcher', initials: 'AJ'),
  ];
  List<ConnectionRequest> get connectionRequests => _connectionRequests;

  final List<ActivityItem> _recentActivity = const [
    ActivityItem(icon: Icons.person_add_outlined, title: 'Team Member Joined', subtitle: '2 hours ago • Sarah Miller', color: Color(0xFF5B21B6)),
    ActivityItem(icon: Icons.work_outline, title: 'Job Application Received', subtitle: '5 hours ago • Frontend Role', color: Color(0xFF2563EB)),
    ActivityItem(icon: Icons.trending_up, title: 'Profile Views Increased', subtitle: 'Yesterday • +14% this week', color: Color(0xFF059669)),
  ];
  List<ActivityItem> get recentActivity => _recentActivity;

  void selectNav(int index) {
    _selectedNavIndex = index;
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
