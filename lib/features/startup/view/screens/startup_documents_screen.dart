import 'package:flutter/material.dart';
import '../../model/startup_models.dart';

class StartupDocumentsScreen extends StatefulWidget {
  const StartupDocumentsScreen({super.key});

  @override
  State<StartupDocumentsScreen> createState() => _StartupDocumentsScreenState();
}

class _StartupDocumentsScreenState extends State<StartupDocumentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<DocumentItem> _pinned = const [
    DocumentItem(name: 'Business Plan', type: 'PDF', size: '26.8 MB', category: 'Fundraising', color: Color(0xFF5B21B6)),
    DocumentItem(name: 'Cap Table', type: 'Spreadsheet', size: '1.1 MB', category: 'Finance', color: Color(0xFF059669)),
  ];

  final List<DocumentItem> _recent = const [
    DocumentItem(name: 'Investor Pitch Deck', type: 'PDF', size: '2.6 MB', category: 'Fundraising', color: Color(0xFF5B21B6)),
    DocumentItem(name: 'Financial Model', type: 'XLSX', size: '1.2 MB', category: 'Finance', color: Color(0xFF059669)),
    DocumentItem(name: 'Product Roadmap', type: 'PDF', size: '3.0 MB', category: 'Product', color: Color(0xFF2563EB)),
  ];

  final List<DocumentCollection> _collections = const [
    DocumentCollection(name: 'Fundraising Pack', count: 4, color: Color(0xFF5B21B6)),
    DocumentCollection(name: 'MVP Launch', count: 3, color: Color(0xFF2563EB)),
    DocumentCollection(name: 'Hiring', count: 5, color: Color(0xFF059669)),
  ];

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
                      const Text('Documents', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search documents, files or folders...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                      prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.7)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.2,
                    children: [
                      _catChip(Icons.monetization_on_outlined, 'Fundraising', const Color(0xFF5B21B6)),
                      _catChip(Icons.gavel_outlined, 'Legal', const Color(0xFFDC2626)),
                      _catChip(Icons.inventory_2_outlined, 'Product', const Color(0xFF2563EB)),
                      _catChip(Icons.account_balance_outlined, 'Finance', const Color(0xFF059669)),
                      _catChip(Icons.people_outline, 'HR', const Color(0xFFF59E0B)),
                      _catChip(Icons.folder_outlined, 'Other', const Color(0xFF6B7280)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Pinned', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                      const SizedBox(width: 8),
                      const Icon(Icons.push_pin, size: 16, color: Color(0xFF5B21B6)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._pinned.map((d) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _DocCard(doc: d, pinned: true))),
                  const SizedBox(height: 10),
                  const Text('Recent Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  const SizedBox(height: 10),
                  ..._recent.map((d) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _DocCard(doc: d, pinned: false))),
                  const SizedBox(height: 10),
                  const Text('Smart Collections', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF12233D))),
                  const SizedBox(height: 4),
                  const Text('AI organized document groups for faster access.', style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
                  const SizedBox(height: 12),
                  ..._collections.map((c) => Padding(padding: const EdgeInsets.only(bottom: 10), child: DocumentCollectionCard(collection: c))),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document upload coming soon'), behavior: SnackBarBehavior.floating)),
                  icon: const Icon(Icons.upload_outlined),
                  label: const Text('+ Upload New Document', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF5B21B6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _catChip(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label documents'), behavior: SnackBarBehavior.floating)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF374151))),
          ],
        ),
      ),
    );
  }
}

class _DocCard extends StatelessWidget {
  const _DocCard({required this.doc, required this.pinned});
  final DocumentItem doc;
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: doc.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(
              doc.type == 'PDF' ? Icons.picture_as_pdf_outlined : Icons.table_chart_outlined,
              color: doc.color, size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF12233D))),
                Text('${doc.type} · ${doc.size}', style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          if (pinned) const Icon(Icons.push_pin, size: 16, color: Color(0xFF5B21B6)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Color(0xFF9CA3AF), size: 20),
          ),
        ],
      ),
    );
  }
}

class DocumentCollectionCard extends StatelessWidget {
  const DocumentCollectionCard({required this.collection});
  final DocumentCollection collection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: collection.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.folder_outlined, color: collection.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(collection.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF12233D))),
                Text('${collection.count} documents', style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(color: collection.color.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text('Open →', style: TextStyle(color: collection.color, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

