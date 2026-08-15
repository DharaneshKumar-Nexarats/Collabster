import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/startup_models.dart';
import 'products_state.dart';

class ProductsViewModel extends StateNotifier<ProductsState> {
  ProductsViewModel() : super(const ProductsState());

  void loadInitialData() {
    state = state.copyWith(
      products: const [
        StartupProduct(
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
        StartupProduct(
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
        StartupProduct(
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
      ],
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void addProduct(StartupProduct product) {
    state = state.copyWith(products: [product, ...state.products]);
  }

  void updateProduct(int index, StartupProduct product) {
    if (index >= 0 && index < state.products.length) {
      final updated = List<StartupProduct>.from(state.products);
      updated[index] = product;
      state = state.copyWith(products: updated);
    }
  }

  void removeProduct(int index) {
    if (index >= 0 && index < state.products.length) {
      final updated = List<StartupProduct>.from(state.products);
      updated.removeAt(index);
      state = state.copyWith(products: updated);
    }
  }
}
