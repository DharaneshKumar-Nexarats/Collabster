import 'package:flutter/foundation.dart';
import '../model/startup_models.dart';

class FundraisingViewModel extends ChangeNotifier {
  double _raisedAmount = 1.2;
  final double _targetAmount = 2.0;

  int _meetingsCount = 12;
  int _introsCount = 4;
  int _reachCount = 150;
  int _repliesCount = 85;

  double get raisedAmount => _raisedAmount;
  double get targetAmount => _targetAmount;
  double get progress => (_raisedAmount / _targetAmount).clamp(0.0, 1.0);

  int get meetingsCount => _meetingsCount;
  int get introsCount => _introsCount;
  int get reachCount => _reachCount;
  int get repliesCount => _repliesCount;

  final List<FundraisingInvestor> _activeInvestors = [
    const FundraisingInvestor(
      name: 'Horizon Ventures',
      fund: 'Series A',
      amount: '\$350K',
      meetingIn: 'Meeting Tomorrow',
      initials: 'HV',
      colorKey: '0xFF4F46E5',
      leadPartner: 'Anish Srivastava',
      email: 'anish@horizonvc.com',
      notes: 'Interested in B2B AI & Cloud Infrastructure platforms.',
    ),
    const FundraisingInvestor(
      name: 'NorthStar Ventures',
      fund: 'Pre-seed',
      amount: '\$400K',
      meetingIn: 'Not Engaged',
      initials: 'NV',
      colorKey: '0xFF0D9488',
      leadPartner: 'Rachel Green',
      email: 'rachel@northstarvc.io',
      notes: 'Focusing on early-stage developer tools & developer ecosystem.',
    ),
    const FundraisingInvestor(
      name: 'SeedFounders',
      fund: 'Seed',
      amount: '\$150K',
      meetingIn: '2 weeks ago',
      initials: 'SF',
      colorKey: '0xFFF59E0B',
      leadPartner: 'Michael Chang',
      email: 'm.chang@seedfounders.com',
      notes: 'Follow-on investor from initial incubator batch.',
    ),
  ];

  List<FundraisingInvestor> get activeInvestors =>
      List.unmodifiable(_activeInvestors);

  final List<FundraisingTask> _attentionTasks = [
    const FundraisingTask(
      title: 'Investor Meeting Tomorrow',
      subtitle: 'Horizon Ventures – 10:00 AM',
      iconKey: 'event_outlined',
      isUrgent: true,
    ),
    const FundraisingTask(
      title: 'Update Pitch Deck',
      subtitle: 'Slides are 2 months outdated.',
      iconKey: 'description_outlined',
      isUrgent: false,
    ),
  ];

  List<FundraisingTask> get attentionTasks =>
      List.unmodifiable(_attentionTasks);

  final List<FundraisingDocument> _documents = [
    const FundraisingDocument(
      name: 'Pitch Deck v3.pdf',
      size: '2.4 MB',
      dateAdded: 'Added 3 days ago',
    ),
    const FundraisingDocument(
      name: 'Financial Projections.pdf',
      size: '1.6 MB',
      dateAdded: 'Added 1 week ago',
    ),
  ];

  List<FundraisingDocument> get documents => List.unmodifiable(_documents);

  void addInvestor(FundraisingInvestor investor, double checkSizeInMillions) {
    _activeInvestors.insert(0, investor);
    _raisedAmount = (_raisedAmount + checkSizeInMillions).clamp(0.0, 10.0);
    _meetingsCount += 1;
    _reachCount += 5;
    _introsCount += 1;
    _repliesCount += 2;
    notifyListeners();
  }

  void updateInvestorStatus(
      FundraisingInvestor investor, String newStatus) {
    final idx = _activeInvestors.indexWhere((i) => i.name == investor.name);
    if (idx != -1) {
      _activeInvestors[idx] =
          _activeInvestors[idx].copyWith(meetingIn: newStatus);
      notifyListeners();
    }
  }

  void addDocument(FundraisingDocument doc) {
    _documents.insert(0, doc);
    notifyListeners();
  }

  void removeDocument(FundraisingDocument doc) {
    _documents.removeWhere((d) => d.name == doc.name);
    notifyListeners();
  }

  void addAttentionTask(FundraisingTask task) {
    _attentionTasks.insert(0, task);
    notifyListeners();
  }

  void resolveTask(FundraisingTask task) {
    _attentionTasks.remove(task);
    notifyListeners();
  }
}
