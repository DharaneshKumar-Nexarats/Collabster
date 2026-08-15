import '../model/startup_models.dart';

class DocumentsState {
  const DocumentsState({
    this.documents = const [],
    this.collections = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
  });

  final List<DocumentItem> documents;
  final List<DocumentCollection> collections;
  final String selectedCategory;
  final String searchQuery;

  List<DocumentItem> get allDocuments => List.unmodifiable(documents);
  List<DocumentItem> get pinned => documents.where((d) => d.isPinned).toList();
  List<DocumentItem> get recent => documents.where((d) => !d.isPinned).toList();

  bool get isFiltering => selectedCategory != 'All' || searchQuery.isNotEmpty;

  List<DocumentItem> get filteredDocuments {
    return documents.where((d) {
      final matchesCat = selectedCategory == 'All' ||
          d.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesQuery = searchQuery.isEmpty ||
          d.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          d.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
          d.type.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();
  }

  List<DocumentItem> get filteredPinned =>
      filteredDocuments.where((d) => d.isPinned).toList();
  List<DocumentItem> get filteredRecent =>
      filteredDocuments.where((d) => !d.isPinned).toList();

  DocumentsState copyWith({
    List<DocumentItem>? documents,
    List<DocumentCollection>? collections,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return DocumentsState(
      documents: documents ?? this.documents,
      collections: collections ?? this.collections,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
