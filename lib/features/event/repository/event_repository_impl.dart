import '../model/event_model.dart';
import 'i_event_repository.dart';

/// Frontend-only event store (replaces backend API for now).
/// Seeds a rich catalog across every event category so the Event hub
/// behaves like the Startup / Career / Community hubs.
class EventRepositoryImpl implements IEventRepository {
  final List<Event> _events = _seedEvents();
  final Map<String, List<EventAttendee>> _attendees = {
    for (final e in _seedEvents()) e.id: _seedAttendees(e.id),
  };

  @override
  List<Event> fetchEvents() => List.unmodifiable(_events);

  @override
  List<EventAttendee> fetchAttendees(String eventId) =>
      List.unmodifiable(_attendees[eventId] ?? const []);

  @override
  void saveEvent(Event event) {
    _events.insert(0, event);
    _attendees[event.id] = const [];
  }

  @override
  void saveRsvp(String eventId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index == -1) return;
    final e = _events[index];
    _events[index] = Event(
      id: e.id,
      title: e.title,
      description: e.description,
      location: e.location,
      startDate: e.startDate,
      endDate: e.endDate,
      organizerName: e.organizerName,
      category: e.category,
      attendeeCount: e.attendeeCount + 1,
      isOnline: e.isOnline,
      imageUrl: e.imageUrl,
    );
  }

  static List<Event> _seedEvents() {
    return [
      Event(
        id: 'hack-1',
        title: 'Global Fintech Hackathon 2026',
        description:
            '48-hour build sprint for fintech products. Teams pitch to VCs and win up to \$50K in prizes.',
        location: 'Bangalore Tech Park',
        startDate: DateTime(2026, 10, 12),
        endDate: DateTime(2026, 10, 14),
        organizerName: 'Fintech Labs',
        category: 'Hackathon',
        attendeeCount: 340,
        isOnline: false,
      ),
      Event(
        id: 'hack-2',
        title: 'AI for Good Codefest',
        description:
            'Use AI to solve real-world social problems. Mentors from Google Research will guide you.',
        location: 'Online',
        startDate: DateTime(2026, 11, 2),
        endDate: DateTime(2026, 11, 3),
        organizerName: 'AI Collective',
        category: 'Hackathon',
        attendeeCount: 510,
        isOnline: true,
      ),
      Event(
        id: 'ws-1',
        title: 'Advanced UI/UX Design Workshop',
        description:
            'Hands-on design system workshop: tokens, components and Figma workflows used by top product teams.',
        location: 'Virtual Workspace',
        startDate: DateTime(2026, 8, 15),
        endDate: DateTime(2026, 8, 15),
        organizerName: 'DesignHub',
        category: 'Workshop',
        attendeeCount: 260,
        isOnline: true,
      ),
      Event(
        id: 'ws-2',
        title: 'Flutter Performance Masterclass',
        description:
            'Learn how to profile, optimize and ship fast Flutter apps with the core contributors.',
        location: 'Online',
        startDate: DateTime(2026, 9, 6),
        endDate: DateTime(2026, 9, 6),
        organizerName: 'Flutter Community',
        category: 'Workshop',
        attendeeCount: 820,
        isOnline: true,
      ),
      Event(
        id: 'mt-1',
        title: 'Web3 Builders Mixer',
        description:
            'Casual networking mixer for web3 builders. Free snacks, lightning talks and co-founder matching.',
        location: 'Hacker House • Bangalore',
        startDate: DateTime(2026, 8, 20),
        endDate: DateTime(2026, 8, 20),
        organizerName: 'Web3 Collective',
        category: 'Meetup',
        attendeeCount: 145,
        isOnline: false,
      ),
      Event(
        id: 'mt-2',
        title: 'Coffee & Code Indiranagar',
        description:
            'Weekly open mic + networking for developers. Bring your laptop or your startup idea.',
        location: 'Third Wave Coffee • Indiranagar',
        startDate: DateTime(2026, 8, 22),
        endDate: DateTime(2026, 8, 22),
        organizerName: 'DevSocial',
        category: 'Meetup',
        attendeeCount: 88,
        isOnline: false,
      ),
      Event(
        id: 'cf-1',
        title: 'Future of Generative Intelligence',
        description:
            'A curated 2-day conference with industry leaders on the boundaries of neural networks.',
        location: 'London, UK',
        startDate: DateTime(2026, 10, 24),
        endDate: DateTime(2026, 10, 25),
        organizerName: 'GenAI Summit',
        category: 'Conference',
        attendeeCount: 1200,
        isOnline: false,
      ),
      Event(
        id: 'cf-2',
        title: 'Product Strategy 2026',
        description:
            'The annual gathering for product leaders: roadmaps, pricing and AI-era product craft.',
        location: 'London, UK',
        startDate: DateTime(2026, 11, 14),
        endDate: DateTime(2026, 11, 15),
        organizerName: 'ProductCon',
        category: 'Conference',
        attendeeCount: 640,
        isOnline: false,
      ),
      Event(
        id: 'wb-1',
        title: 'AI Ethics Summit',
        description:
            'Webinar series on responsible AI: bias, regulation and the human side of automation.',
        location: 'Online',
        startDate: DateTime(2026, 8, 18),
        endDate: DateTime(2026, 8, 18),
        organizerName: 'AI Ethics Board',
        category: 'Webinar',
        attendeeCount: 430,
        isOnline: true,
      ),
      Event(
        id: 'wb-2',
        title: 'Raising Your First Round',
        description:
            'Founders share how they raised pre-seed and seed rounds — cap tables, decks and term sheets.',
        location: 'Online',
        startDate: DateTime(2026, 8, 25),
        endDate: DateTime(2026, 8, 25),
        organizerName: 'Startup School',
        category: 'Webinar',
        attendeeCount: 210,
        isOnline: true,
      ),
      Event(
        id: 'nt-1',
        title: 'Tech Startup Meetup',
        description: 'Network with founders, engineers and investors over coffee.',
        location: 'Bangalore',
        startDate: DateTime(2026, 9, 10),
        endDate: DateTime(2026, 9, 10),
        organizerName: 'Tech Community',
        category: 'Networking',
        attendeeCount: 120,
        isOnline: false,
      ),
    ];
  }

  static List<EventAttendee> _seedAttendees(String eventId) {
    return [
      const EventAttendee(
        id: 'a-1',
        name: 'Ananya Rao',
        role: 'Founder',
        initials: 'AR',
      ),
      const EventAttendee(
        id: 'a-2',
        name: 'Dev Patel',
        role: 'Engineer',
        initials: 'DP',
      ),
      const EventAttendee(
        id: 'a-3',
        name: 'Meera Nair',
        role: 'Designer',
        initials: 'MN',
      ),
      const EventAttendee(
        id: 'a-4',
        name: 'Kabir Singh',
        role: 'Investor',
        initials: 'KS',
      ),
      const EventAttendee(
        id: 'a-5',
        name: 'Ishita Verma',
        role: 'PM',
        initials: 'IV',
      ),
    ];
  }
}