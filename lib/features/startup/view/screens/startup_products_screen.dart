import 'package:flutter/material.dart';

import '../../model/startup_models.dart';

class StartupProductsScreen extends StatefulWidget {
  const StartupProductsScreen({super.key, required this.startupName});
  final String startupName;

  @override
  State<StartupProductsScreen> createState() => _StartupProductsScreenState();
}

class _StartupProductsScreenState extends State<StartupProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<StartupProduct> _products = [
    StartupProduct(
      name: 'MedVision Diagnostic AI',
      description: 'AI platform for early disease detection using medical imaging.',
      status: 'LIVE',
      statusColor: Color(0xFF059669),
      version: 'v3.2',
      rating: 4.9,
      saves: 12000,
      downloads: 5000,
      tagColor: Color(0xFF059669),
    ),
    StartupProduct(
      name: 'MedVision Scan',
      description: 'Mobile app for scanning and uploading medical reports.',
      status: 'BETA',
      statusColor: Color(0xFFF59E0B),
      version: 'v0.9',
      rating: 4.3,
      saves: 450,
      downloads: 99,
      tagColor: Color(0xFFF59E0B),
    ),
    StartupProduct(
      name: 'Insight Engine',
      description: 'Real-time predictive patient monitoring.',
      status: 'BETA',
      statusColor: Color(0xFFF59E0B),
      version: 'v0.9',
      rating: 4.1,
      saves: 450,
      downloads: 150,
      tagColor: Color(0xFFF59E0B),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3FF),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B21B6), Color(0xFF7C3AED), Color(0xFF4338CA)],
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20, right: 20, bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Our Products', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _showAddProductSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.add, color: Color(0xFF5B21B6), size: 16),
                              SizedBox(width: 4),
                              Text('Add Product', style: TextStyle(color: Color(0xFF5B21B6), fontSize: 13, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                      prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.7)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            sliver: Builder(
              builder: (context) {
                final filteredProducts = _products.where((p) {
                  final q = _searchController.text.toLowerCase();
                  return q.isEmpty || p.name.toLowerCase().contains(q) || p.description.toLowerCase().contains(q);
                }).toList();
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= filteredProducts.length) return null;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StartupProductCard(product: filteredProducts[index]),
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(999)))),
              const SizedBox(height: 18),
              const Text('Add New Product', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: 'Product Name',
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                  filled: true, fillColor: const Color(0xFFF6F3FF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (nameCtrl.text.isNotEmpty) {
                      setState(() {
                        _products.add(StartupProduct(
                          name: nameCtrl.text,
                          description: 'New product added to your portfolio.',
                          status: 'BETA',
                          statusColor: const Color(0xFFF59E0B),
                          version: 'v0.1',
                          rating: 0,
                          saves: 0,
                          downloads: 0,
                          tagColor: const Color(0xFFF59E0B),
                        ));
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('"${nameCtrl.text}" added!'), behavior: SnackBarBehavior.floating),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: const Color(0xFF5B21B6), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StartupProductCard extends StatelessWidget {
  const StartupProductCard({required this.product});
  final StartupProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF6D28D9).withValues(alpha: 0.8), const Color(0xFF4338CA)],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.biotech, size: 64, color: Colors.white.withValues(alpha: 0.3)),
                ),
                Positioned(
                  top: 12, left: 12,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: product.tagColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(product.status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(product.version, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                const SizedBox(height: 6),
                Text(product.description, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.45)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
                    const SizedBox(width: 4),
                    Text(product.rating > 0 ? product.rating.toStringAsFixed(1) : '-', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF12233D))),
                    const SizedBox(width: 16),
                    const Icon(Icons.bookmark_outline, color: Color(0xFF9CA3AF), size: 16),
                    const SizedBox(width: 4),
                    Text(_formatK(product.saves), style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                    const SizedBox(width: 16),
                    const Icon(Icons.download_outlined, color: Color(0xFF9CA3AF), size: 16),
                    const SizedBox(width: 4),
                    Text(_formatK(product.downloads), style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 36),
                        foregroundColor: const Color(0xFF5B21B6),
                        side: const BorderSide(color: Color(0xFF5B21B6)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                      child: const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatK(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return '$value';
  }
}

