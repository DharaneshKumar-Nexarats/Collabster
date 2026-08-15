import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/providers.dart';
import '../../../event/model/event_model.dart';
import '../../model/activity_model.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _linkController = TextEditingController();
  String _selectedCategory = 'Networking';
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isOnline = false;
  String? _imagePath;
  bool _isSubmitting = false;

  final _categories = [
    'Networking',
    'Workshop',
    'Meetup',
    'Conference',
    'Hackathon',
    'Social',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _closeScreen() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  // ── Image picking ────────────────────────────────────────────────────────
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
                  'Event cover image',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Choose a photo to make your event stand out',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                _ImageOptionTile(
                  icon: Icons.photo_library_outlined,
                  title: 'Choose from gallery',
                  subtitle: 'Pick an existing photo',
                  onTap: () async {
                    Navigator.pop(sheetContext, 'gallery');
                  },
                ),
                _ImageOptionTile(
                  icon: Icons.photo_camera_outlined,
                  title: 'Take a photo',
                  subtitle: 'Capture the moment live',
                  onTap: () async {
                    Navigator.pop(sheetContext, 'camera');
                  },
                ),
                if (_imagePath != null)
                  _ImageOptionTile(
                    icon: Icons.delete_outline_rounded,
                    title: 'Remove image',
                    subtitle: 'Use a plain gradient cover',
                    isDestructive: true,
                    onTap: () async {
                      Navigator.pop(sheetContext, 'remove');
                    },
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

  // ── Date & time helpers ──────────────────────────────────────────────────
  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate == null || _endDate!.isBefore(picked)) {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final current = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  DateTime? _combine(DateTime? date, TimeOfDay? time) {
    if (date == null) return null;
    return DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? 9,
      time?.minute ?? 0,
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  // ── Submit ───────────────────────────────────────────────────────────────
  void _submitEvent() {
    FocusScope.of(context).unfocus();

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final location = _isOnline ? 'Online' : _locationController.text.trim();
    final startDate = _combine(_startDate, _startTime);
    final endDate = _combine(_endDate, _endTime);

    if (title.isEmpty) {
      _showError('Please enter an event title');
      return;
    }
    if (description.isEmpty) {
      _showError('Please write a short description');
      return;
    }
    if (_startDate == null) {
      _showError('Please choose a start date');
      return;
    }
    if (_isOnline) {
      if (_linkController.text.trim().isEmpty) {
        _showError('Add the meeting link for the online event');
        return;
      }
    } else if (location.isEmpty) {
      _showError('Please add the venue location');
      return;
    }

    setState(() => _isSubmitting = true);

    final session = ref.read(authViewModelProvider).session;
    final organizerName = session?.fullName ?? 'You';

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      location: _isOnline ? _linkController.text.trim() : location,
      startDate: startDate ?? DateTime.now(),
      endDate: endDate ?? startDate ?? DateTime.now(),
      organizerName: organizerName,
      category: _selectedCategory,
      isOnline: _isOnline,
      imageUrl: _imagePath,
    );

    ref.read(eventViewModelProvider.notifier).addEvent(event);

    ref
        .read(activityViewModelProvider.notifier)
        .addActivity(
          type: ActivityType.eventCreated,
          title: 'You created an event',
          subtitle: event.title,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event created successfully!'),
        backgroundColor: Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
      ),
    );
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

  // ── UI helpers ───────────────────────────────────────────────────────────
  Widget _sectionLabel(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 2),
      child: Row(
        children: [
          Icon(icon, size: 17, color: const Color(0xFF059669)),
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
        height: 180,
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
          colors: [Color(0xFF0F172A), Color(0xFF334155)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: const Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add cover image',
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

  Widget _buildTitleField() {
    return _inputCard(
      child: TextField(
        controller: _titleController,
        maxLength: 80,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          hintText: 'Give your event a clear title',
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
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
        maxLines: 4,
        maxLength: 300,
        style: const TextStyle(
          fontSize: 14.5,
          height: 1.45,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          hintText: 'What is the event about? Agenda, speakers, takeaways...',
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
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

  Widget _buildEventTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isOnline = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: !_isOnline
                    ? const Color(0xFF059669).withValues(alpha: 0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: !_isOnline
                      ? const Color(0xFF059669)
                      : const Color(0xFFE2E8F0),
                  width: !_isOnline ? 1.5 : 1,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF059669),
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'In person',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isOnline = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: _isOnline
                    ? const Color(0xFF2563EB).withValues(alpha: 0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isOnline
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE2E8F0),
                  width: _isOnline ? 1.5 : 1,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.videocam_rounded,
                    color: Color(0xFF2563EB),
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVenueField() {
    return _inputCard(
      child: TextField(
        controller: _locationController,
        style: const TextStyle(fontSize: 14.5, color: Color(0xFF1E293B)),
        decoration: InputDecoration(
          hintText: 'Venue name or address',
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
          ),
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: Color(0xFF059669),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLinkField() {
    return _inputCard(
      child: TextField(
        controller: _linkController,
        keyboardType: TextInputType.url,
        style: const TextStyle(fontSize: 14.5, color: Color(0xFF1E293B)),
        decoration: InputDecoration(
          hintText: 'Paste meeting link (Zoom, Meet, Teams...)',
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade400,
          ),
          prefixIcon: const Icon(
            Icons.link_rounded,
            color: Color(0xFF2563EB),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _pickerTile(
                icon: Icons.event_outlined,
                label: 'Starts',
                value: _startDate != null ? _formatDate(_startDate!) : null,
                onTap: _pickStartDate,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _pickerTile(
                icon: Icons.event_available_outlined,
                label: 'Ends',
                value: _endDate != null ? _formatDate(_endDate!) : null,
                onTap: _pickEndDate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _pickerTile(
                icon: Icons.access_time_rounded,
                label: 'Start time',
                value: _startTime?.format(context),
                onTap: () => _pickTime(isStart: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _pickerTile(
                icon: Icons.schedule_rounded,
                label: 'End time',
                value: _endTime?.format(context),
                onTap: () => _pickTime(isStart: false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pickerTile({
    required IconData icon,
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF059669), size: 19),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value ?? 'Set',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: value != null
                          ? const Color(0xFF1E293B)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
          ],
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
          children: _categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF059669).withValues(alpha: 0.1)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF059669)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF059669)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            );
          }).toList(),
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
          'Create Event',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submitEvent,
            child: const Text(
              'Create',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF059669),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event cover',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 10),
            _buildCoverSection(),
            const SizedBox(height: 26),

            _sectionLabel('Event details', Icons.edit_note_rounded),
            _buildTitleField(),
            const SizedBox(height: 6),
            _buildDescriptionField(),
            const SizedBox(height: 26),

            _sectionLabel('When', Icons.schedule_rounded),
            _buildDateTimeSection(),
            const SizedBox(height: 26),

            _sectionLabel('Event type & venue', Icons.place_outlined),
            _buildEventTypeSelector(),
            const SizedBox(height: 10),
            if (_isOnline) _buildLinkField() else _buildVenueField(),
            const SizedBox(height: 26),

            _sectionLabel('Category', Icons.category_outlined),
            _buildCategorySelector(),
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
          onTap: _isSubmitting ? null : _submitEvent,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF10B981)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF059669).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Create Event',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
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

class _ImageOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ImageOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFDC2626)
        : const Color(0xFF059669);
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
