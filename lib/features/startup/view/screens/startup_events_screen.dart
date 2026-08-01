import 'package:flutter/material.dart';

class StartupEventsScreen extends StatefulWidget {
  const StartupEventsScreen({super.key, required this.startupName});

  final String startupName;

  @override
  State<StartupEventsScreen> createState() => _StartupEventsScreenState();
}

class _StartupEventsScreenState extends State<StartupEventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'All';
  final List<_StartupEvent> _events = [
    _StartupEvent(
      title: 'MedTech Startup Summit 2026',
      category: 'Pitch Events',
      date: 'AUG\n18',
      dateLabel: 'Tuesday - Thursday',
      time: '9:00 AM - 6:00 PM GMT-7',
      location: 'Moscone Center, San Francisco',
      attendees: 120,
      description:
          'The premier gathering for healthcare innovators, founders building the future of autonomous medicine, and investors.',
      color: const Color(0xFF6D28D9),
    ),
    _StartupEvent(
      title: 'Founder\'s Last Mile',
      category: 'Networking',
      date: 'AUG\n21',
      dateLabel: 'Thursday',
      time: '5:30 PM - 8:00 PM',
      location: 'SOMA District, San Francisco',
      attendees: 84,
      description:
          'An intimate operator meetup for founders preparing their next growth milestone.',
      color: const Color(0xFF2563EB),
    ),
    _StartupEvent(
      title: 'Future of AI Healthcare',
      category: 'Conferences',
      date: 'AUG\n24',
      dateLabel: 'Sunday',
      time: '10:00 AM - 4:00 PM',
      location: 'Palo Alto Tech Hub',
      attendees: 210,
      description:
          'Product leaders, clinicians, and AI researchers discuss responsible healthcare innovation.',
      color: const Color(0xFF0F766E),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_StartupEvent> get _visibleEvents {
    final query = _searchController.text.trim().toLowerCase();
    return _events.where((event) {
      final matchesFilter = _filter == 'All' || event.category == _filter;
      final matchesQuery =
          query.isEmpty ||
          event.title.toLowerCase().contains(query) ||
          event.location.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  Future<void> _openEvent(_StartupEvent event) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => _StartupEventDetailsScreen(event: event),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _createEvent() async {
    final created = await showModalBottomSheet<_StartupEvent>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _CreateEventBottomSheet(startupName: widget.startupName),
    );

    if (created != null) {
      setState(() {
        _events.insert(0, created);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _visibleEvents;
    final myEvents = _events.where((event) => event.registered).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Events',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: _createEvent,
            icon: const Icon(Icons.add_circle_outline),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You are all caught up.')),
            ),
            icon: const Badge(
              smallSize: 7,
              child: Icon(Icons.notifications_none),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E1EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E1EB)),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Networking', 'Pitch Events', 'Conferences']
                  .map(
                    (filter) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: _filter == filter,
                        onSelected: (_) => setState(() => _filter = filter),
                        selectedColor: const Color(0xFF6D28D9),
                        labelStyle: TextStyle(
                          color: _filter == filter
                              ? Colors.white
                              : const Color(0xFF4B5563),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 22),
          if (events.isNotEmpty)
            _FeaturedEventCard(
              event: events.first,
              onTap: () => _openEvent(events.first),
            ),
          const SizedBox(height: 24),
          _SectionTitle(
            title: 'Recommended for you',
            action: '${events.length} events',
          ),
          const SizedBox(height: 10),
          if (events.isEmpty)
            const _EmptyEvents()
          else
            ...events
                .skip(1)
                .map(
                  (event) => _EventListCard(
                    event: event,
                    onTap: () => _openEvent(event),
                    onSave: () => setState(() => event.saved = !event.saved),
                  ),
                ),
          const SizedBox(height: 20),
          _SectionTitle(title: 'My events', action: 'View all'),
          const SizedBox(height: 10),
          if (myEvents.isEmpty)
            const _EmptyEvents(message: 'Register for an event to see it here.')
          else
            ...myEvents.map(
              (event) => _EventListCard(
                event: event,
                onTap: () => _openEvent(event),
                onSave: () => setState(() => event.saved = !event.saved),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createEvent,
        backgroundColor: const Color(0xFF6D28D9),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create event'),
      ),
    );
  }
}

class _StartupEventDetailsScreen extends StatefulWidget {
  const _StartupEventDetailsScreen({required this.event});
  final _StartupEvent event;

  @override
  State<_StartupEventDetailsScreen> createState() =>
      _StartupEventDetailsScreenState();
}

class _StartupEventDetailsScreenState
    extends State<_StartupEventDetailsScreen> {
  void _register() {
    setState(() => widget.event.registered = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You are registered. We will send event updates here.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Event details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => event.saved = !event.saved),
            icon: Icon(event.saved ? Icons.bookmark : Icons.bookmark_border),
          ),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Event link copied.'))),
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _EventHero(event: event),
          const SizedBox(height: 16),
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 24,
              height: 1.15,
              fontWeight: FontWeight.w900,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            event.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF5D6472),
            ),
          ),
          const SizedBox(height: 18),
          _DetailsCard(event: event),
          const SizedBox(height: 20),
          const Text(
            'About this event',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Meet founders, investors, and product leaders. Build partnerships, join focused sessions, and leave with practical next steps.',
            style: TextStyle(color: Color(0xFF5D6472), height: 1.5),
          ),
          const SizedBox(height: 20),
          const Text(
            'Schedule',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          const _ScheduleItem(time: '09:00 AM', title: 'Registration & Coffee'),
          const _ScheduleItem(time: '10:30 AM', title: 'Founder keynote'),
          const _ScheduleItem(
            time: '12:30 PM',
            title: 'Networking lunch',
            last: true,
          ),
          const SizedBox(height: 18),
          const Text(
            'Location',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            event.location,
            style: const TextStyle(color: Color(0xFF5D6472)),
          ),
          const SizedBox(height: 12),
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFFDCEBFF), Color(0xFFEDE9FE)],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: Color(0xFF6D28D9),
                size: 34,
              ),
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Free',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Registration',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: event.registered ? null : _register,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6D28D9),
                  minimumSize: const Size(154, 48),
                ),
                child: Text(event.registered ? 'Registered' : 'Register now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartupEvent {
  _StartupEvent({
    required this.title,
    required this.category,
    required this.date,
    required this.dateLabel,
    required this.time,
    required this.location,
    required this.attendees,
    required this.description,
    required this.color,
  });
  final String title;
  final String category;
  final String date;
  final String dateLabel;
  final String time;
  final String location;
  final int attendees;
  final String description;
  final Color color;
  bool saved = false;
  bool registered = false;
}

class _FeaturedEventCard extends StatelessWidget {
  const _FeaturedEventCard({required this.event, required this.onTap});
  final _StartupEvent event;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Ink(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [event.color, const Color(0xFF4C1D95)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FEATURED EVENT',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '${event.dateLabel}  |  ${event.location}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          const Chip(
            label: Text('View event'),
            labelStyle: TextStyle(
              color: Color(0xFF5B21B6),
              fontWeight: FontWeight.w800,
            ),
            backgroundColor: Colors.white,
          ),
        ],
      ),
    ),
  );
}

class _EventListCard extends StatelessWidget {
  const _EventListCard({
    required this.event,
    required this.onTap,
    required this.onSave,
  });

  final _StartupEvent event;
  final VoidCallback onTap;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 54,
                decoration: BoxDecoration(
                  color: event.color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    event.date,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: event.color,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
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
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      event.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onSave,
                icon: Icon(
                  event.saved ? Icons.bookmark : Icons.bookmark_border,
                  color: const Color(0xFF6D28D9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventHero extends StatelessWidget {
  const _EventHero({required this.event});
  final _StartupEvent event;
  @override
  Widget build(BuildContext context) => Container(
    height: 180,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [event.color, const Color(0xFF1E1B4B)],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          right: -10,
          top: -20,
          child: Icon(
            Icons.hub_rounded,
            size: 180,
            color: Colors.white.withValues(alpha: .12),
          ),
        ),
        Positioned(
          left: 18,
          bottom: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.category.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${event.attendees} founders attending',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.event});
  final _StartupEvent event;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE6E4ED)),
    ),
    child: Column(
      children: [
        _DetailRow(
          icon: Icons.calendar_month_outlined,
          text: '${event.date.replaceAll('\n', ' ')}  •  ${event.dateLabel}',
        ),
        _DetailRow(icon: Icons.schedule_outlined, text: event.time),
        _DetailRow(
          icon: Icons.location_on_outlined,
          text: event.location,
          last: true,
        ),
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text, this.last = false});
  final IconData icon;
  final String text;
  final bool last;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: last ? 0 : 14),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFFF0EAFE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: const Color(0xFF6D28D9)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    ),
  );
}

class _CreateEventBottomSheet extends StatefulWidget {
  const _CreateEventBottomSheet({required this.startupName});
  final String startupName;

  @override
  State<_CreateEventBottomSheet> createState() => _CreateEventBottomSheetState();
}

class _CreateEventBottomSheetState extends State<_CreateEventBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _descriptionController;
  String _category = 'Networking';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _locationController = TextEditingController();
    _dateController = TextEditingController(text: 'AUG 18');
    _timeController = TextEditingController(text: '9:00 AM - 6:00 PM');
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.event_available_rounded,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Create event',
                            style: TextStyle(
                              color: Color(0xFF172033),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add a new event for ${widget.startupName} and keep it visible in the startup dashboard.',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              height: 1.35,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F4F6),
                      ),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF6B7280),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _ComposerField(
                  controller: _titleController,
                  label: 'Event name',
                  hintText: 'Founder Meetup Night',
                  icon: Icons.title_outlined,
                  autofocus: true,
                ),
                const SizedBox(height: 14),
                _ComposerField(
                  controller: _locationController,
                  label: 'Location',
                  hintText: 'San Francisco, CA',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 14),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: InputDecoration(
                        hintText: 'Select category',
                        prefixIcon: const Icon(Icons.category_outlined, color: Color(0xFF6B7280), size: 22),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF6D28D9), width: 1.5),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Networking', child: Text('Networking')),
                        DropdownMenuItem(value: 'Pitch Events', child: Text('Pitch Events')),
                        DropdownMenuItem(value: 'Conferences', child: Text('Conferences')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _category = value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _ComposerField(
                        controller: _dateController,
                        label: 'Date',
                        hintText: 'AUG 18',
                        icon: Icons.calendar_month_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ComposerField(
                        controller: _timeController,
                        label: 'Time',
                        hintText: '9:00 AM - 6:00 PM',
                        icon: Icons.schedule_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _ComposerField(
                  controller: _descriptionController,
                  label: 'Description',
                  hintText: 'Tell founders why they should attend this event.',
                  icon: Icons.notes_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty) return;
                      final rawDate = _dateController.text.trim().toUpperCase();
                      final formattedDate = rawDate.isEmpty
                          ? 'SEP\n12'
                          : rawDate.replaceFirst(RegExp(r'\s+'), '\n');
                      Navigator.pop(
                        context,
                        _StartupEvent(
                          title: _titleController.text.trim(),
                          category: _category,
                          date: formattedDate,
                          dateLabel: rawDate.isEmpty ? 'Friday' : rawDate,
                          time: _timeController.text.trim().isEmpty
                              ? '6:00 PM - 8:00 PM'
                              : _timeController.text.trim(),
                          location: _locationController.text.trim().isEmpty
                              ? 'Location to be announced'
                              : _locationController.text.trim(),
                          attendees: 0,
                          description: _descriptionController.text.trim().isEmpty
                              ? 'An event created by ${widget.startupName}.'
                              : _descriptionController.text.trim(),
                          color: const Color(0xFF7C3AED),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Create event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
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

class _ComposerField extends StatelessWidget {
  const _ComposerField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.autofocus = false,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final bool autofocus;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4B5563),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          autofocus: autofocus,
          maxLines: maxLines,
          textInputAction: maxLines > 1
              ? TextInputAction.newline
              : TextInputAction.next,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 22),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6D28D9), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({
    required this.time,
    required this.title,
    this.last = false,
  });
  final String time;
  final String title;
  final bool last;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Color(0xFF6D28D9),
              shape: BoxShape.circle,
            ),
          ),
          if (!last)
            Container(width: 2, height: 36, color: const Color(0xFFE4D8FA)),
        ],
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6D28D9),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.action});
  final String title;
  final String action;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w900,
          color: Color(0xFF172033),
        ),
      ),
      const Spacer(),
      Text(
        action,
        style: const TextStyle(
          color: Color(0xFF6D28D9),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _EmptyEvents extends StatelessWidget {
  const _EmptyEvents({this.message = 'No events match your search.'});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        const Icon(Icons.event_busy_outlined, color: Color(0xFF9CA3AF)),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF6B7280)),
        ),
      ],
    ),
  );
}
