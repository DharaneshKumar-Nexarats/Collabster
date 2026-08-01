import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class FundraisingViewModel extends ChangeNotifier {
  double _raisedAmount = 1.2;
  final double _targetAmount = 2.0;

  double get raisedAmount => _raisedAmount;
  double get targetAmount => _targetAmount;
  double get progress => _raisedAmount / _targetAmount;

  final List<FundraisingInvestor> _activeInvestors = const [
    FundraisingInvestor(name: 'Horizon Ventures', fund: 'Series A', amount: '\$350K', meetingIn: 'Meeting Tomorrow', initials: 'HV', color: Color(0xFF4F46E5)),
    FundraisingInvestor(name: 'NorthStar Ventures', fund: 'Pre-seed', amount: '\$400K', meetingIn: 'Not Engaged', initials: 'NV', color: Color(0xFF0D9488)),
    FundraisingInvestor(name: 'SeedFounders', fund: 'Seed', amount: '\$150K', meetingIn: '2 weeks ago', initials: 'SF', color: Color(0xFFF59E0B)),
  ];
  List<FundraisingInvestor> get activeInvestors => _activeInvestors;

  void addInvestor() {
    _raisedAmount = (_raisedAmount + 0.1).clamp(0, _targetAmount);
    notifyListeners();
  }
}
