import 'package:flutter/material.dart';
import '../model/startup_models.dart';

class ProductsViewModel extends ChangeNotifier {
  final List<StartupProduct> _products = [
    StartupProduct(name: 'MedVision Diagnostic AI', description: 'AI platform for early disease detection using medical imaging.', status: 'LIVE', statusColor: Color(0xFF059669), version: 'v3.2', rating: 4.9, saves: 12000, downloads: 5000, tagColor: Color(0xFF059669)),
    StartupProduct(name: 'MedVision Scan', description: 'Mobile app for scanning and uploading medical reports.', status: 'BETA', statusColor: Color(0xFFF59E0B), version: 'v0.9', rating: 4.3, saves: 450, downloads: 99, tagColor: Color(0xFFF59E0B)),
    StartupProduct(name: 'Insight Engine', description: 'Real-time predictive patient monitoring.', status: 'BETA', statusColor: Color(0xFFF59E0B), version: 'v0.9', rating: 4.1, saves: 450, downloads: 150, tagColor: Color(0xFFF59E0B)),
  ];
  List<StartupProduct> get products => _products;

  void addProduct(String name) {
    _products.add(StartupProduct(
      name: name,
      description: 'New product added to your portfolio.',
      status: 'BETA',
      statusColor: const Color(0xFFF59E0B),
      version: 'v0.1',
      rating: 0,
      saves: 0,
      downloads: 0,
      tagColor: const Color(0xFFF59E0B),
    ));
    notifyListeners();
  }

  List<StartupProduct> filterProducts(String query) {
    if (query.isEmpty) return _products;
    final q = query.toLowerCase();
    return _products.where((p) => p.name.toLowerCase().contains(q) || p.description.toLowerCase().contains(q)).toList();
  }
}
