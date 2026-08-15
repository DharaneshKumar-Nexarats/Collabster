import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/career/view/screens/internships_screen.dart';
import '../../../features/career/view/screens/jobs_screen.dart';
import '../../../features/community/view/screens/posts_list_screen.dart';
import '../../../features/event/model/event_model.dart';
import '../../../features/event/view/screens/events/event_detail_screen.dart';
import '../../../features/startup/view/screens/investor_pipeline_screen.dart';
import '../../../features/startup/view/screens/startup_posts_feed_screen.dart';
import '../../di/providers.dart';
import '../bridge_models.dart';
import '../bridge_state.dart';

const _bg = Color(0xFFF8FAFC);
const _textPrimary = Color(0xFF0F172A);
const _textSecondary = Color(0xFF64748B);
const _borderColor = Color(0xFFE2E8F0);

/// The Connection Bridge hub: one feed across every mode.
/// Aggregates Startup hiring, Career jobs, Community & Startup posts,
/// Event hub events and Investor connections — each tagged with its source.
class ConnectScreen extends ConsumerStatefulWidget {
  const ConnectScreen({super.key});

  @override
  ConsumerState<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends ConsumerState<ConnectScreen> {
  int _tabIndex = 0;

  static const _tabs = ['All', 'Opportunities', 'Posts', 'Events', 'Investors'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(bridgeViewModelProvider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bridgeState = ref.watch(bridgeViewModelProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(bridgeState),
            _buildTabBar(),
            Expanded(
              child: _buildTabContent(bridgeState),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────
  Widget _buildHeader(BridgeState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A0E8F), Color(0xFF6D28D9), Color(0xFF4F46E5)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Connect',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.alt_route_rounded, color: Colors.white, size: 15),
                    SizedBox(width: 5),
                    Text(
                      'All Modes',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'One feed across Startup, Career, Community, Events & Investors',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statChip(Icons.rocket_launch_rounded, '${state.startupCount}', 'Startup'),
              _statChip(Icons.work_rounded, '${state.careerCount}', 'Career'),
              _statChip(Icons.forum_rounded, '${state.communityCount}', 'Community'),
              _statChip(Icons.event_rounded, '${state.eventCount}', 'Events'),
              _statChip(Icons.trending_up_rounded, '${state.investors.length}', 'Investors'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 13),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ─── Tabs ───────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final isSelected = _tabIndex == i;
            return GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6D28D9) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _tabs[i],
                  style: TextStyle(
                    color: isSelected ? Colors.white : _textSecondary,
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─── Content ────────────────────────────────────────────────
  Widget _buildTabContent(BridgeState state) {
    if (!state.isLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF6D28D9)),
      );
    }

    final items = <Widget>[];
    final showAll = _tabIndex == 0;

    if (showAll || _tabIndex == 1) {
      final opportunities = state.opportunities;
      if (showAll || opportunities.isNotEmpty) {
        items.add(_sectionHeader(
          'Opportunities',
          'Startup hiring + Career board',
          onViewAll: () => _openTab(1),
        ));
        if (opportunities.isEmpty) {
          items.add(_emptyRow('No open opportunities right now'));
        } else {
          items.addAll(opportunities.take(6).map(_buildOpportunityCard));
        }
      }
    }

    if (showAll || _tabIndex == 2) {
      final posts = state.posts;
      if (showAll || posts.isNotEmpty) {
        items.add(_sectionHeader(
          'Posts',
          'Startup updates + Community talks',
          onViewAll: () => _openTab(2),
        ));
        if (posts.isEmpty) {
          items.add(_emptyRow('No posts yet — create one from Startup or Community'));
        } else {
          items.addAll(posts.take(6).map(_buildPostCard));
        }
      }
    }

    if (showAll || _tabIndex == 3) {
      final events = state.events;
      if (showAll || events.isNotEmpty) {
        items.add(_sectionHeader(
          'Events',
          'From the Event hub',
          onViewAll: () => _openTab(3),
        ));
        if (events.isEmpty) {
          items.add(_emptyRow('No events scheduled yet'));
        } else {
          items.addAll(events.take(4).map(_buildEventCard));
        }
      }
    }

    if (showAll || _tabIndex == 4) {
      final investors = state.investors;
      if (showAll || investors.isNotEmpty) {
        items.add(_sectionHeader(
          'Investors',
          'Startup pipeline + Investor network',
          onViewAll: () => _openTab(4),
        ));
        if (investors.isEmpty) {
          items.add(_emptyRow('No investor connections yet'));
        } else {
          items.addAll(investors.take(6).map(_buildInvestorCard));
        }
      }
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 40),
      children: items,
    );
  }

  void _openTab(int index) {
    setState(() => _tabIndex = index);
  }

  Widget _sectionHeader(String title, String subtitle, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: const Text(
                'View all',
                style: TextStyle(
                  color: Color(0xFF6D28D9),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _emptyRow(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _borderColor),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: _textSecondary, fontSize: 12.5),
      ),
    );
  }

  // ─── Cards ──────────────────────────────────────────────────
  Widget _buildOpportunityCard(BridgeOpportunity opp) {
    final isStartup = opp.fromStartup;
    return _card(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => opp.kind == 'internship'
                ? const InternshipsScreen()
                : const JobsScreen(),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isStartup ? const Color(0xFFF3E8FF) : const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              isStartup ? Icons.rocket_launch_rounded : Icons.work_rounded,
              color: isStartup ? const Color(0xFF6D28D9) : const Color(0xFF0284C7),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opp.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${opp.company} • ${opp.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _sourceBadge(isStartup ? 'STARTUP' : 'CAREER', isStartup),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              opp.salary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF15803D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BridgePost post) {
    final isStartup = post.source == 'startup';
    return _card(
      onTap: () {
        if (isStartup) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StartupPostsFeedScreen(startupName: post.sourceLabel),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostsListScreen()),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isStartup ? const Color(0xFFF3E8FF) : const Color(0xFFFFF4E6),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              isStartup ? Icons.rocket_launch_rounded : Icons.forum_rounded,
              color: isStartup ? const Color(0xFF6D28D9) : const Color(0xFFEA580C),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${post.authorName} • ${post.authorRole} • ${post.likes} likes',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _sourceBadge(isStartup ? 'STARTUP' : 'COMMUNITY', isStartup),
        ],
      ),
    );
  }

  Widget _buildEventCard(BridgeEvent event) {
    return _card(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(
              event: Event(
                id: event.id,
                title: event.title,
                description: event.description,
                location: event.location,
                startDate: event.startDate,
                endDate: event.startDate,
                organizerName: event.sourceLabel,
                category: event.category,
                attendeeCount: event.attendeeCount,
                isOnline: event.isOnline,
              ),
            ),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.event_rounded, color: Color(0xFF059669), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${event.category} • ${event.location} • ${event.attendeeCount} going',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _sourceBadge('EVENT', false),
        ],
      ),
    );
  }

  Widget _buildInvestorCard(BridgeInvestor investor) {
    final isPipeline = investor.source == 'startup-pipeline';
    return _card(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InvestorPipelineScreen()),
        );
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isPipeline ? const Color(0xFFE0F2FE) : const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Text(
                investor.initials,
                style: TextStyle(
                  color: isPipeline ? const Color(0xFF0284C7) : const Color(0xFF6D28D9),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investor.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${investor.fund} • ${investor.amount}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              investor.status,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF15803D),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _sourceBadge(isPipeline ? 'PIPELINE' : 'INVESTOR', isPipeline),
        ],
      ),
    );
  }

  Widget _sourceBadge(String label, bool purple) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: purple ? const Color(0xFFEDE9FE) : const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _card({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor),
        ),
        child: child,
      ),
    );
  }
}