import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();
  String _selectedCommunity = 'Flutter Developers';

  final List<String> _communities = const [
    'Flutter Developers',
    'Startup Founders',
    'UI/UX Designers',
    'AI Engineers',
    'Product Managers',
  ];

  final List<_PostTypeOption> _postTypes = const [
    _PostTypeOption(icon: Icons.forum_rounded, label: 'Discussion', color: Color(0xFFEA580C)),
    _PostTypeOption(icon: Icons.help_outline_rounded, label: 'Question', color: Color(0xFF2563EB)),
    _PostTypeOption(icon: Icons.article_outlined, label: 'Article', color: Color(0xFF059669)),
    _PostTypeOption(icon: Icons.poll_rounded, label: 'Poll', color: Color(0xFF7C3AED)),
  ];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      ref.read(postViewModelProvider.notifier).updateTitle(_titleController.text.trim());
    });
    _contentController.addListener(() {
      ref.read(postViewModelProvider.notifier).updateContent(_contentController.text.trim());
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void _closeScreen() {
    FocusScope.of(context).unfocus();
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _submitPost() {
    final postState = ref.read(postViewModelProvider);
    if (!postState.hasTitle || !postState.hasContent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Please fill in title and content'),
            ],
          ),
          backgroundColor: const Color(0xFF1E293B),
        ),
      );
      return;
    }

    ref.read(postViewModelProvider.notifier).submitPost(
          _titleController.text.trim(),
          _contentController.text.trim(),
          _selectedCommunity,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Post published successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
      ),
    );
    _closeScreen();
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postViewModelProvider);
    final selectedPostType = postState.selectedPostType;
    final canPost = postState.hasTitle && postState.hasContent;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _closeScreen,
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Icon(Icons.close_rounded, color: Color(0xFF1E293B), size: 26),
          ),
        ),
        title: const Text(
          'New Post',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: canPost ? _submitPost : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                decoration: BoxDecoration(
                  gradient: canPost
                      ? const LinearGradient(
                          colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: canPost ? null : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: canPost
                      ? [BoxShadow(color: const Color(0xFFEA580C).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]
                      : null,
                ),
                child: Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: canPost ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCommunitySelector(),
                  const SizedBox(height: 16),
                  _buildPostTypeSelector(selectedPostType),
                  const SizedBox(height: 20),
                  _buildTitleField(),
                  Divider(color: const Color(0xFFE2E8F0), height: 1, indent: 4, endIndent: 4, thickness: 1),
                  const SizedBox(height: 16),
                  _buildContentField(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildCommunitySelector() {
    return GestureDetector(
      onTap: _showCommunityPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFF97316)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.widgets_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedCommunity,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Posting to this community',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }

  void _showCommunityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _CommunityPickerSheet(
        communities: _communities,
        selected: _selectedCommunity,
        onSelected: (c) {
          setState(() => _selectedCommunity = c);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  Widget _buildPostTypeSelector(String selectedPostType) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _postTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = _postTypes[index];
          final isSelected = selectedPostType == type.label;
          return GestureDetector(
            onTap: () => ref.read(postViewModelProvider.notifier).setPostType(type.label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? type.color.withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? type.color.withValues(alpha: 0.3) : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(type.icon, size: 17, color: isSelected ? type.color : Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(
                    type.label,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? type.color : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      focusNode: _titleFocus,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => _contentFocus.requestFocus(),
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E293B), height: 1.3),
      decoration: InputDecoration(
        hintText: 'Give your post a title',
        hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey.shade400),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
      ),
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: _contentController,
      focusNode: _contentFocus,
      maxLines: null,
      minLines: 8,
      textInputAction: TextInputAction.newline,
      style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF334155)),
      decoration: InputDecoration(
        hintText: 'Share your thoughts, ideas, or questions with the community...',
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400, height: 1.6),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE2E8F0), width: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, -3))],
      ),
      child: Row(
        children: [
          _buildAttachmentButton(Icons.image_outlined, 'Image', const Color(0xFF059669)),
          const SizedBox(width: 16),
          _buildAttachmentButton(Icons.link_rounded, 'Link', const Color(0xFF2563EB)),
          const SizedBox(width: 16),
          _buildAttachmentButton(Icons.tag_rounded, 'Tag', const Color(0xFF7C3AED)),
          const SizedBox(width: 16),
          _buildAttachmentButton(Icons.location_on_outlined, 'Location', const Color(0xFFEA580C)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _contentController.text.length > 500
                  ? const Color(0xFFFEF2F2)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_contentController.text.length}/2000',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _contentController.text.length > 500
                    ? const Color(0xFFEF4444)
                    : Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}

class _PostTypeOption {
  final IconData icon;
  final String label;
  final Color color;
  const _PostTypeOption({required this.icon, required this.label, required this.color});
}

class _CommunityPickerSheet extends StatelessWidget {
  final List<String> communities;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CommunityPickerSheet({
    required this.communities,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Community',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose where to share your post',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...communities.map((c) {
            final isSelected = c == selected;
            return GestureDetector(
              onTap: () => onSelected(c),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEA580C).withValues(alpha: 0.06) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFEA580C).withValues(alpha: 0.2) : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.lerp(const Color(0xFFEA580C), const Color(0xFF7C3AED), communities.indexOf(c) / communities.length)!,
                            Color.lerp(const Color(0xFFF97316), const Color(0xFFA78BFA), communities.indexOf(c) / communities.length)!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          c[0],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        c,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded, color: Color(0xFFEA580C), size: 22)
                    else
                      Icon(Icons.radio_button_unchecked_rounded, color: Colors.grey.shade300, size: 22),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }
}
