import 'package:flutter/foundation.dart';
import '../model/startup_models.dart';

class ProductsViewModel extends ChangeNotifier {
  final List<StartupProduct> _products = [
    const StartupProduct(
      name: 'MedVision Diagnostic AI',
      description: 'AI platform for early disease detection using medical imaging.',
      status: 'LIVE',
      statusColorKey: 'live',
      version: 'v3.2',
      rating: 4.9,
      saves: 12000,
      downloads: 5000,
      tagColorKey: 'live',
    ),
    const StartupProduct(
      name: 'MedVision Scan',
      description: 'Mobile app for scanning and uploading medical reports.',
      status: 'BETA',
      statusColorKey: 'beta',
      version: 'v0.9',
      rating: 4.3,
      saves: 450,
      downloads: 99,
      tagColorKey: 'beta',
    ),
    const StartupProduct(
      name: 'Insight Engine',
      description: 'Real-time predictive patient monitoring.',
      status: 'BETA',
      statusColorKey: 'beta',
      version: 'v0.9',
      rating: 4.1,
      saves: 450,
      downloads: 150,
      tagColorKey: 'beta',
    ),
  ];

  List<StartupProduct> get products => List.unmodifiable(_products);

  List<StartupProduct> filterProducts(String query) {
    if (query.isEmpty) return products;
    final q = query.toLowerCase();
    return _products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.status.toLowerCase().contains(q))
        .toList();
  }

  void addProduct(StartupProduct product) {
    _products.insert(0, product);
    notifyListeners();
  }

  void updateProduct(int index, StartupProduct product) {
    if (index >= 0 && index < _products.length) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(int index) {
    if (index >= 0 && index < _products.length) {
      _products.removeAt(index);
      notifyListeners();
    }
  }
}
