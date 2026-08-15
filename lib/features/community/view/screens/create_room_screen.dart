import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../model/activity_model.dart';
import '../../model/community_model.dart';
import 'create_community_screen.dart';

class CreateRoomScreen extends ConsumerStatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  ConsumerState<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  final _roomNameController = TextEditingController();
  String _selectedCommunityId = '';

  static const _accent = Color(0xFF7C3AED);
  static const _accentLight = Color(0xFFA78BFA);

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  void _closeScreen() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submitRoom() {
    FocusScope.of(context).unfocus();

    if (_roomNameController.text.trim().isEmpty) {
      _showError('Please enter a room name');
      return;
    }
    if (_selectedCommunityId.isEmpty) {
      _showError('Please choose a community for this room');
      return;
    }

    final communities = ref.read(communityViewModelProvider).myCommunities;
    final community = communities.firstWhere(
      (c) => c.id == _selectedCommunityId,
      orElse: () => communities.first,
    );

    final now = DateTime.now();
    final roomName = _roomNameController.text.trim();
    final room = CommunityRoom(
      id: 'room_${now.millisecondsSinceEpoch}',
      communityId: community.id,
      communityTitle: community.title,
      name: roomName,
      memberCount: '1 member',
      isJoined: true,
    );

    ref.read(communityViewModelProvider.notifier).addRoom(room);

    ref
        .read(activityViewModelProvider.notifier)
        .addActivity(
          type: ActivityType.roomCreated,
          title: 'You created a room',
          subtitle: '$roomName · ${community.title}',
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Room created successfully!'),
        backgroundColor: Color(0xFF7C3AED),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  Widget _sectionLabel(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 2),
      child: Row(
        children: [
          Icon(icon, size: 17, color: _accent),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: child,
    );
  }

  Widget _buildRoomNameField() {
    return _inputCard(
      child: TextField(
        controller: _roomNameController,
        onChanged: (_) => setState(() {}),
        maxLength: 40,
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          hintText: 'e.g. General Discussion',
          hintStyle: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
          ),
          prefixIcon: const Icon(
            Icons.forum_outlined,
            color: _accent,
            size: 21,
          ),
          counterStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCommunitySelector(List<MyCommunityItem> communities) {
    return _inputCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: communities.isEmpty
            ? _buildNoCommunities()
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: communities.map((community) {
                  final isSelected = community.id == _selectedCommunityId;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCommunityId = community.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _accent.withValues(alpha: 0.08)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? _accent : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.4 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: community.gradientColors.isEmpty
                                    ? const [_accent, _accentLight]
                                    : community.gradientColors,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              community.logoIcon,
                              size: 11,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            community.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? _accent
                                  : const Color(0xFF64748B),
                            ),
                          ),
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: _accent,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }

  Widget _buildNoCommunities() {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _accent.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.people_outline_rounded,
            color: _accent,
            size: 26,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'No communities yet',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Create a community first — rooms live inside communities',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateCommunityScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_accent, _accentLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _accent.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              'Create Community',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final communities = ref.watch(communityViewModelProvider).myCommunities;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Color(0xFF1E293B)),
          onPressed: _closeScreen,
        ),
        title: const Text(
          'Create Room',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Room name', Icons.edit_note_rounded),
            _buildRoomNameField(),
            const SizedBox(height: 26),
            _sectionLabel('Community', Icons.groups_outlined),
            _buildCommunitySelector(communities),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFA78BFA).withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: Color(0xFF7C3AED),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Rooms live inside a community you belong to. Members can join and chat in real time.',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: Color(0xFF6D28D9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: 12 + MediaQuery.viewInsetsOf(context).bottom.clamp(0.0, 24.0),
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: GestureDetector(
          onTap: _submitRoom,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_accent, _accentLight]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _accent.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.forum_outlined, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Create Room',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
