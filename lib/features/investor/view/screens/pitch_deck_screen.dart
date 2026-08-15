import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../model/investor_model.dart';
import '../widgets/pitch_deck_card.dart';

/// Pitch deck library — search, filter, preview slides, & request full access.
class PitchDeckScreen extends ConsumerStatefulWidget {
  const PitchDeckScreen({super.key});

  @override
  ConsumerState<PitchDeckScreen> createState() => _PitchDeckScreenState();
}

class _PitchDeckScreenState extends ConsumerState<PitchDeckScreen> {
  String _filter = 'All';
  String _searchQuery = '';
  final Set<String> _bookmarkedIds = {};

  List<PitchDeck> _filtered(List<PitchDeck> decks) {
    var result = decks;
    if (_filter == 'Public') {
      result = result.where((d) => d.isPublic).toList();
    } else if (_filter == 'Private') {
      result = result.where((d) => !d.isPublic).toList();
    } else if (_filter == 'Bookmarked') {
      result = result.where((d) => _bookmarkedIds.contains(d.id)).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      result = result
          .where((d) => d.title.toLowerCase().contains(q) || d.description.toLowerCase().contains(q))
          .toList();
    }

    return result;
  }

  void _toggleBookmark(String id) {
    setState(() {
      if (_bookmarkedIds.contains(id)) {
        _bookmarkedIds.remove(id);
      } else {
        _bookmarkedIds.add(id);
      }
    });
  }

  void _showSlideViewerSheet(PitchDeck deck) {
    final slides = [
      {'title': '1. Problem & Vision', 'body': 'Current legacy tools lack cross-platform collaboration for early-stage founders and angel networks.'},
      {'title': '2. Product Solution', 'body': 'CollabSphere combines instant deal-flow management, chat, and real-time equity tracking in one hub.'},
      {'title': '3. Market & Opportunity', 'body': '\$45B global early-stage venture funding market with 32% annual expansion.'},
      {'title': '4. Traction & Metrics', 'body': '12,500 active founders, \$4.2M total capital deployed across 85 closed funding rounds.'},
      {'title': '5. Business Model', 'body': 'SaaS subscription for VC syndicates + 1.5% transaction fee on closed investment rounds.'},
      {'title': '6. Funding Ask', 'body': 'Seeking \$1.5M Series A for engineering expansion and European market launch.'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 14),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: InvestorColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: InvestorColors.goldShimmer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.description_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deck.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: InvestorColors.ink,
                            ),
                          ),
                          Text(
                            'Interactive Deck Viewer • ${deck.slideCount} Slides',
                            style: const TextStyle(fontSize: 12, color: InvestorColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded, color: InvestorColors.textMuted),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: InvestorColors.border),
              Expanded(
                child: PageView.builder(
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: InvestorColors.goldBg,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: InvestorColors.goldLight),
                          boxShadow: const [
                            BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 6)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: InvestorColors.goldDeep,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'SLIDE ${index + 1} OF ${slides.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.slideshow_rounded, color: InvestorColors.goldDeep, size: 22),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              slide['title']!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: InvestorColors.ink,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              slide['body']!,
                              style: const TextStyle(
                                fontSize: 14.5,
                                height: 1.6,
                                color: InvestorColors.inkSoft,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.swipe_rounded, size: 16, color: InvestorColors.textMuted),
                                const SizedBox(width: 6),
                                Text(
                                  index < slides.length - 1 ? 'Swipe left for next slide' : 'End of preview slides',
                                  style: const TextStyle(fontSize: 12, color: InvestorColors.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Requested full access to ${deck.title}'),
                          backgroundColor: InvestorColors.goldDeep,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: InvestorColors.goldDeep,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.handshake_rounded, size: 18),
                    label: const Text(
                      'Request Full Data Room Access',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pitchDeckViewModelProvider);
    final decks = _filtered(state.pitchDecks);
    final publicCount = state.pitchDecks.where((d) => d.isPublic).length;

    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: InvestorColors.headerGradient),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 21),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pitch Decks',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Review & analyze startup pitch decks',
                                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.description_rounded, color: Colors.white, size: 21),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Stats Row
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            _headerStat('${state.pitchDecks.length}', 'DECKS RECEIVED'),
                            _divider(),
                            _headerStat('$publicCount', 'PUBLIC DECKS'),
                            _divider(),
                            _headerStat('${_bookmarkedIds.length}', 'BOOKMARKED'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                        ),
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            hintText: 'Search decks by title or keyword...',
                            hintStyle: TextStyle(color: Colors.white60, fontSize: 13.5),
                            prefixIcon: Icon(Icons.search_rounded, color: Colors.white70, size: 20),
                            filled: false,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final label = ['All', 'Public', 'Private', 'Bookmarked'][index];
                      final isSelected = label == _filter;
                      return GestureDetector(
                        onTap: () => setState(() => _filter = label),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? InvestorColors.goldDeep : Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isSelected ? InvestorColors.goldDeep : InvestorColors.border,
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? Colors.white : InvestorColors.inkSoft,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                if (decks.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: InvestorColors.border),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.folder_open_rounded, size: 44, color: InvestorColors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty ? 'No matching decks found' : 'No decks in this category',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: InvestorColors.ink,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Try modifying your search or changing the filter.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.5, color: InvestorColors.textMuted),
                        ),
                      ],
                    ),
                  )
                else
                  ...decks.map(
                    (deck) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Stack(
                        children: [
                          PitchDeckCard(
                            deck: deck,
                            onTap: () => _showSlideViewerSheet(deck),
                          ),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: IconButton(
                              icon: Icon(
                                _bookmarkedIds.contains(deck.id)
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_outline_rounded,
                                color: _bookmarkedIds.contains(deck.id)
                                    ? InvestorColors.goldDeep
                                    : InvestorColors.textMuted,
                                size: 20,
                              ),
                              onPressed: () => _toggleBookmark(deck.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.white.withValues(alpha: 0.25),
    );
  }
}