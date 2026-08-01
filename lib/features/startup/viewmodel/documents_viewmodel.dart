import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class DocumentsViewModel extends ChangeNotifier {
  final List<DocumentItem> _pinned = const [
    DocumentItem(name: 'Business Plan', type: 'PDF', size: '26.8 MB', category: 'Fundraising', color: Color(0xFF5B21B6)),
    DocumentItem(name: 'Cap Table', type: 'Spreadsheet', size: '× 1.1 MB', category: 'Finance', color: Color(0xFF059669)),
  ];
  List<DocumentItem> get pinned => _pinned;

  final List<DocumentItem> _recent = const [
    DocumentItem(name: 'Investor Pitch Deck', type: 'PDF', size: '2.6 MB', category: 'Fundraising', color: Color(0xFF5B21B6)),
    DocumentItem(name: 'Financial Model', type: 'XLSX', size: '1.2 MB', category: 'Finance', color: Color(0xFF059669)),
    DocumentItem(name: 'Product Roadmap', type: 'PDF', size: '3.0 MB', category: 'Product', color: Color(0xFF2563EB)),
  ];
  List<DocumentItem> get recent => _recent;

  final List<DocumentCollection> _collections = const [
    DocumentCollection(name: 'Fundraising Pack', count: 4, color: Color(0xFF5B21B6)),
    DocumentCollection(name: 'MVP Launch', count: 3, color: Color(0xFF2563EB)),
    DocumentCollection(name: 'Hiring', count: 5, color: Color(0xFF059669)),
  ];
  List<DocumentCollection> get collections => _collections;
}
