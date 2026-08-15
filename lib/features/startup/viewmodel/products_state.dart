import '../model/startup_models.dart';

class ProductsState {
  const ProductsState({
    this.products = const [],
    this.searchQuery = '',
  });

  final List<StartupProduct> products;
  final String searchQuery;

  List<StartupProduct> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    final q = searchQuery.toLowerCase();
    return products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.status.toLowerCase().contains(q))
        .toList();
  }

  ProductsState copyWith({
    List<StartupProduct>? products,
    String? searchQuery,
  }) {
    return ProductsState(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
