import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/providers.dart';
import '../../model/activity_model.dart';
import '../../model/community_model.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roomNameController = TextEditingController();
  bool _createRoom = false;
  String _selectedCategory = 'Tech';
  String _selectedVisibility = 'Public';
  String? _imagePath;

  static const _accent = Color(0xFF2563EB);

  final _categories = [
    ('Tech', Icons.code_rounded),
    ('Design', Icons.palette_outlined),
    ('Startup', Icons.rocket_launch_outlined),
    ('AI / ML', Icons.psychology_outlined),
    ('Marketing', Icons.campaign_outlined),
    ('Finance', Icons.account_balance_outlined),
    ('Health', Icons.favorite_outline_rounded),
    ('Education', Icons.school_outlined),
  ];

  final _visibilityOptions = [
    ('Public', 'Anyone can find and join', Icons.public_rounded),
    ('Private', 'Only invited members can join', Icons.lock_outline_rounded),
    ('Invite Only', 'Join by invite link only', Icons.mail_outline_rounded),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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

  Future<void> _showImageOptions() async {
    final picker = ImagePicker();

    final option = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Community cover image',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Show what your community is about',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                _CoverOptionTile(
                  icon: Icons.photo_library_outlined,
                  title: 'Choose from gallery',
                  subtitle: 'Pick an existing photo',
                  color: _accent,
                  onTap: () => Navigator.pop(sheetContext, 'gallery'),
                ),
                _CoverOptionTile(
                  icon: Icons.photo_camera_outlined,
                  title: 'Take a photo',
                  subtitle: 'Capture the moment live',
                  color: _accent,
                  onTap: () => Navigator.pop(sheetContext, 'camera'),
                ),
                if (_imagePath != null)
                  _CoverOptionTile(
                    icon: Icons.delete_outline_rounded,
                    title: 'Remove image',
                    subtitle: 'Use the default vibrant cover',
                    color: const Color(0xFFDC2626),
                    isDestructive: true,
                    onTap: () => Navigator.pop(sheetContext, 'remove'),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (option == null) return;

    if (option == 'remove') {
      setState(() => _imagePath = null);
      return;
    }

    try {
      final picked = await picker.pickImage(
        source: option == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        setState(() => _imagePath = picked.path);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not access the photo library'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _submitCommunity() {
    FocusScope.of(context).unfocus();

    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter a community name');
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showError('Please write a short description');
      return;
    }

    final now = DateTime.now();
    final title = _nameController.text.trim();
    final community = MyCommunityItem(
      id: now.millisecondsSinceEpoch.toString(),
      title: title,
      memberCount: '1 Member',
      activeTodayCount: '1 active today',
      avatarUrls: const [],
      overflowCount: 0,
      gradientColors: const [Color(0xFF2563EB), Color(0xFF3B82F6)],
      logoIcon: Icons.people_rounded,
      categoryId: _selectedCategory.toLowerCase(),
      imageUrl: _imagePath,
    );

    ref.read(communityViewModelProvider.notifier).addCommunity(community);

    ref
        .read(activityViewModelProvider.notifier)
        .addActivity(
          type: ActivityType.communityCreated,
          title: 'You created a community',
          subtitle: title,
        );

    if (_createRoom) {
      final roomName = _roomNameController.text.trim().isEmpty
          ? 'General'
          : _roomNameController.text.trim();
      final room = CommunityRoom(
        id: 'room_${now.millisecondsSinceEpoch + 1}',
        communityId: community.id,
        communityTitle: title,
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
            subtitle: '$roomName · $title',
          );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Community created successfully!'),
        backgroundColor: Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  // ── UI helpers ───────────────────────────────────────────────────────────
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

  Widget _buildCoverSection() {
    final hasImage = _imagePath != null;
    return GestureDetector(
      onTap: _showImageOptions,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage)
                Image.file(
                  File(_imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _coverPlaceholder(),
                )
              else
                _coverPlaceholder(),
              Positioned(
                top: 12,
                right: 12,
                child: hasImage
                    ? Row(
                        children: [
                          _CoverChip(
                            icon: Icons.edit_rounded,
                            label: 'Change',
                            onTap: _showImageOptions,
                          ),
                          const SizedBox(width: 8),
                          _CoverChip(
                            icon: Icons.close_rounded,
                            label: '',
                            onTap: () => setState(() => _imagePath = null),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              if (hasImage)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 30, 16, 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.55),
                        ],
                      ),
                    ),
                    child: Text(
                      _nameController.text.trim().isEmpty
                          ? 'Your community'
                          : _nameController.text.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
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

  Widget _coverPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add community cover',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Recommended 1200 × 600 · JPG or PNG',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return _inputCard(
      child: TextField(
        controller: _nameController,
        onChanged: (_) => setState(() {}),
        maxLength: 40,
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          hintText: 'e.g. Flutter Developers',
          hintStyle: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
          ),
          prefixIcon: const Icon(
            Icons.groups_outlined,
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

  Widget _buildDescriptionField() {
    return _inputCard(
      child: TextField(
        controller: _descriptionController,
        onChanged: (_) => setState(() {}),
        maxLines: 4,
        maxLength: 200,
        style: const TextStyle(
          fontSize: 14.5,
          height: 1.45,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          hintText: "What's this community about? Who is it for?",
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Icon(Icons.description_outlined, color: _accent, size: 21),
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

  Widget _buildCategorySelector() {
    return _inputCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((entry) {
            final cat = entry.$1;
            final icon = entry.$2;
            final isSelected = _selectedCategory == cat;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
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
                    Icon(
                      icon,
                      size: 14,
                      color: isSelected ? _accent : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? _accent : const Color(0xFF64748B),
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

  Widget _buildVisibilitySelector() {
    return _inputCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: _visibilityOptions.map((option) {
            final label = option.$1;
            final desc = option.$2;
            final icon = option.$3;
            final isSelected = _selectedVisibility == label;
            return GestureDetector(
              onTap: () => setState(() => _selectedVisibility = label),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _accent.withValues(alpha: 0.05)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? _accent : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.4 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? _accent : const Color(0xFF94A3B8),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? _accent
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            desc,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: isSelected ? _accent : const Color(0xFF94A3B8),
                      size: 20,
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

  Widget _buildRoomSection() {
    return _inputCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.forum_outlined,
                  size: 20,
                  color: Color(0xFF7C3AED),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create with a starter room',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Rooms are created together with your community',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _createRoom = !_createRoom),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _createRoom
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _createRoom ? Icons.check_rounded : Icons.add_rounded,
                          size: 14,
                          color: _createRoom
                              ? Colors.white
                              : const Color(0xFF7C3AED),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _createRoom ? 'Added' : 'Add room',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _createRoom
                                ? Colors.white
                                : const Color(0xFF7C3AED),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_createRoom) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF5FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.25),
                  ),
                ),
                child: TextField(
                  controller: _roomNameController,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Room name e.g. General Discussion',
                    hintStyle: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey.shade400,
                    ),
                    prefixIcon: const Icon(
                      Icons.forum_outlined,
                      color: Color(0xFF7C3AED),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Create Community',
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
            Text(
              'Community cover',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 10),
            _buildCoverSection(),
            const SizedBox(height: 26),

            _sectionLabel('Community details', Icons.edit_note_rounded),
            _buildNameField(),
            const SizedBox(height: 6),
            _buildDescriptionField(),
            const SizedBox(height: 26),

            _sectionLabel('Category', Icons.category_outlined),
            _buildCategorySelector(),
            const SizedBox(height: 26),

            _sectionLabel('Visibility', Icons.visibility_outlined),
            _buildVisibilitySelector(),
            const SizedBox(height: 26),

            _sectionLabel('Starter room', Icons.forum_outlined),
            _buildRoomSection(),
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
          onTap: _submitCommunity,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.groups_outlined, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Create Community',
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

class _CoverChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CoverChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: label.isEmpty ? 0 : 10,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CoverOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;
  final bool isDestructive;

  const _CoverOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.color,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
