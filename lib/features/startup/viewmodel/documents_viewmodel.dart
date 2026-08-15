import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'documents_state.dart';

class DocumentsViewModel extends StateNotifier<DocumentsState> {
  DocumentsViewModel() : super(const DocumentsState());

  void loadDocuments() {
    state = state.copyWith(
      documents: const [
        DocumentItem(
          name: 'Business Plan',
          type: 'PDF',
          size: '26.8 MB',
          category: 'Fundraising',
          colorKey: 'primary',
          dateAdded: 'Aug 01, 2024',
          description: 'Comprehensive 5-year strategic business vision and roadmap.',
          isPinned: true,
        ),
        DocumentItem(
          name: 'Cap Table',
          type: 'Spreadsheet',
          size: '1.1 MB',
          category: 'Finance',
          colorKey: 'live',
          dateAdded: 'Jul 28, 2024',
          description: 'Equity distribution, option pools, and investor shares.',
          isPinned: true,
        ),
        DocumentItem(
          name: 'Investor Pitch Deck',
          type: 'PDF',
          size: '2.6 MB',
          category: 'Fundraising',
          colorKey: 'primary',
          dateAdded: 'Jul 24, 2024',
          description: 'Series A fundraising deck with financial projections.',
        ),
        DocumentItem(
          name: 'Financial Model',
          type: 'XLSX',
          size: '1.2 MB',
          category: 'Finance',
          colorKey: 'live',
          dateAdded: 'Jul 15, 2024',
          description: 'Revenue forecast, burn rate calculations, and unit economics.',
        ),
        DocumentItem(
          name: 'Product Roadmap',
          type: 'PDF',
          size: '3.0 MB',
          category: 'Product',
          colorKey: 'blue',
          dateAdded: 'Jul 10, 2024',
          description: 'Q3/Q4 feature release schedule and architecture diagram.',
        ),
        DocumentItem(
          name: 'Incorporation Certificate',
          type: 'PDF',
          size: '4.5 MB',
          category: 'Legal',
          colorKey: 'red',
          dateAdded: 'Jun 12, 2024',
          description: 'Official corporate filing and registration documents.',
        ),
        DocumentItem(
          name: 'Employee Handbook',
          type: 'PDF',
          size: '1.8 MB',
          category: 'HR',
          colorKey: 'amber',
          dateAdded: 'May 20, 2024',
          description: 'Company guidelines, policies, and onboarding handbook.',
        ),
      ],
      collections: const [
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
      ],
    );
  }

  void togglePin(DocumentItem doc) {
    final updated = state.documents.map((d) {
      if (d.name == doc.name) {
        return d.copyWith(isPinned: !d.isPinned);
      }
      return d;
    }).toList();
    state = state.copyWith(documents: updated);
  }

  void removeDocument(DocumentItem doc) {
    final updated = state.documents.where((d) => d.name != doc.name).toList();
    state = state.copyWith(documents: updated);
  }

  void addDocument(DocumentItem doc) {
    state = state.copyWith(documents: [doc, ...state.documents]);
  }

  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}
