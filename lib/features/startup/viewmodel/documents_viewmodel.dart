import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class DocumentsViewModel extends ChangeNotifier {
  final List<DocumentItem> _documents = [
    const DocumentItem(
      name: 'Business Plan',
      type: 'PDF',
      size: '26.8 MB',
      category: 'Fundraising',
      colorKey: 'primary',
      dateAdded: 'Aug 01, 2024',
      description: 'Comprehensive 5-year strategic business vision and roadmap.',
      isPinned: true,
    ),
    const DocumentItem(
      name: 'Cap Table',
      type: 'Spreadsheet',
      size: '1.1 MB',
      category: 'Finance',
      colorKey: 'live',
      dateAdded: 'Jul 28, 2024',
      description: 'Equity distribution, option pools, and investor shares.',
      isPinned: true,
    ),
    const DocumentItem(
      name: 'Investor Pitch Deck',
      type: 'PDF',
      size: '2.6 MB',
      category: 'Fundraising',
      colorKey: 'primary',
      dateAdded: 'Jul 24, 2024',
      description: 'Series A fundraising deck with financial projections.',
      isPinned: false,
    ),
    const DocumentItem(
      name: 'Financial Model',
      type: 'XLSX',
      size: '1.2 MB',
      category: 'Finance',
      colorKey: 'live',
      dateAdded: 'Jul 15, 2024',
      description: 'Revenue forecast, burn rate calculations, and unit economics.',
      isPinned: false,
    ),
    const DocumentItem(
      name: 'Product Roadmap',
      type: 'PDF',
      size: '3.0 MB',
      category: 'Product',
      colorKey: 'blue',
      dateAdded: 'Jul 10, 2024',
      description: 'Q3/Q4 feature release schedule and architecture diagram.',
      isPinned: false,
    ),
    const DocumentItem(
      name: 'Incorporation Certificate',
      type: 'PDF',
      size: '4.5 MB',
      category: 'Legal',
      colorKey: 'red',
      dateAdded: 'Jun 12, 2024',
      description: 'Official corporate filing and registration documents.',
      isPinned: false,
    ),
    const DocumentItem(
      name: 'Employee Handbook',
      type: 'PDF',
      size: '1.8 MB',
      category: 'HR',
      colorKey: 'amber',
      dateAdded: 'May 20, 2024',
      description: 'Company guidelines, policies, and onboarding handbook.',
      isPinned: false,
    ),
  ];

  List<DocumentItem> get allDocuments => List.unmodifiable(_documents);
  List<DocumentItem> get pinned => _documents.where((d) => d.isPinned).toList();
  List<DocumentItem> get recent => _documents.where((d) => !d.isPinned).toList();

  final List<DocumentCollection> _collections = const [
    DocumentCollection(
      name: 'Fundraising Pack',
      count: 4,
      colorKey: 'primary',
      description: 'Pitch Deck, Financial Model, Cap Table & Executive Summary',
    ),
    DocumentCollection(
      name: 'MVP Launch',
      count: 3,
      colorKey: 'blue',
      description: 'Roadmap, Tech Specs & User Feedback Surveys',
    ),
    DocumentCollection(
      name: 'Hiring & HR',
      count: 5,
      colorKey: 'live',
      description: 'Employee Handbook, Offer Templates & Benefits Plan',
    ),
  ];

  List<DocumentCollection> get collections => _collections;

  void togglePin(DocumentItem doc) {
    final index = _documents.indexWhere((d) => d.name == doc.name);
    if (index != -1) {
      _documents[index] = _documents[index].copyWith(isPinned: !_documents[index].isPinned);
      notifyListeners();
    }
  }

  void removeDocument(DocumentItem doc) {
    _documents.removeWhere((d) => d.name == doc.name);
    notifyListeners();
  }

  void addDocument(DocumentItem doc) {
    _documents.insert(0, doc);
    notifyListeners();
  }

  List<DocumentItem> filterByCategory(String category, String query) {
    return _documents.where((d) {
      final matchesCat = category == 'All' || d.category.toLowerCase() == category.toLowerCase();
      final matchesQuery = query.isEmpty ||
          d.name.toLowerCase().contains(query.toLowerCase()) ||
          d.category.toLowerCase().contains(query.toLowerCase()) ||
          d.type.toLowerCase().contains(query.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();
  }
}
