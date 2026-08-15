enum EventNotificationType {
  reminder,
  registration,
  update,
  cancellation,
  waitlist,
  system,
}

class EventNotification {
  final String id;
  final String title;
  final String subtitle;
  final String body;
  final EventNotificationType type;
  final String iconName;
  final int iconColor;
  final int iconBg;
  final DateTime createdAt;
  final bool isRead;
  final String? deepLink;

  const EventNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    this.body = '',
    required this.type,
    required this.iconName,
    required this.iconColor,
    required this.iconBg,
    required this.createdAt,
    this.isRead = false,
    this.deepLink,
  });

  EventNotification copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? body,
    EventNotificationType? type,
    String? iconName,
    int? iconColor,
    int? iconBg,
    DateTime? createdAt,
    bool? isRead,
    String? deepLink,
  }) {
    return EventNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      body: body ?? this.body,
      type: type ?? this.type,
      iconName: iconName ?? this.iconName,
      iconColor: iconColor ?? this.iconColor,
      iconBg: iconBg ?? this.iconBg,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      deepLink: deepLink ?? this.deepLink,
    );
  }
}