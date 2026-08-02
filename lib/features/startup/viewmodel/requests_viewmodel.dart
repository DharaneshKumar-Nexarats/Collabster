import 'package:flutter/foundation.dart';
import '../model/startup_models.dart';

/// Singleton ChangeNotifier so both StartupNetworkScreen and
/// StartupRequestsScreen share the exact same request list.
class RequestsViewModel extends ChangeNotifier {
  RequestsViewModel._();
  static final RequestsViewModel instance = RequestsViewModel._();

  final List<ConnectionRequest> _pending = [
    const ConnectionRequest(
      name: 'Priya Sharma',
      role: 'Angel Investor • Mumbai',
      initials: 'PS',
      category: 'Investor',
      note:
          'Interested in your B2B SaaS traction. Would love to review your pitch deck!',
      time: '10m ago',
      mutualConnections: 12,
    ),
    const ConnectionRequest(
      name: 'Ravi Kumar',
      role: 'CTO at TechNova • Bangalore',
      initials: 'RK',
      category: 'Founder',
      note:
          'Hey! Looking to collaborate on cloud infrastructure and API integrations.',
      time: '1h ago',
      mutualConnections: 8,
    ),
    const ConnectionRequest(
      name: 'Ananya Patel',
      role: 'Product Designer • Delhi',
      initials: 'AP',
      category: 'Design',
      note:
          'Loved your product design! Would like to connect and share feedback.',
      time: '3h ago',
      mutualConnections: 4,
    ),
    const ConnectionRequest(
      name: 'Suresh Menon',
      role: 'Startup Advisor • Hyderabad',
      initials: 'SM',
      category: 'Mentor',
      note:
          'Advising Series-A founders in FinTech. Happy to connect and offer insights.',
      time: 'Yesterday',
      mutualConnections: 19,
    ),
    const ConnectionRequest(
      name: 'Kavitha Reddy',
      role: 'VC Partner at SeedFund • Chennai',
      initials: 'KR',
      category: 'Investor',
      note:
          "We are active seed investors in your space. Let's schedule a quick call.",
      time: '2d ago',
      mutualConnections: 15,
    ),
  ];

  final List<ConnectionRequest> _accepted = [];
  int _connected = 24;
  int _ignored = 8;

  List<ConnectionRequest> get pending => List.unmodifiable(_pending);
  List<ConnectionRequest> get accepted => List.unmodifiable(_accepted);
  int get pendingCount => _pending.length;
  int get connectedCount => _connected;
  int get ignoredCount => _ignored;

  void accept(String name) {
    final requestIndex = _pending.indexWhere((r) => r.name == name);
    if (requestIndex == -1) return;

    _accepted.add(_pending.removeAt(requestIndex));
    _connected++;
    notifyListeners();
  }

  void ignore(String name) {
    _pending.removeWhere((r) => r.name == name);
    _ignored++;
    notifyListeners();
  }

  List<ConnectionRequest> filtered(String category) {
    if (category == 'All') return pending;
    return _pending
        .where((r) => r.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
