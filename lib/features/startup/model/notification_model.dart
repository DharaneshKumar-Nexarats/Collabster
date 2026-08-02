enum NotificationType {
  connection,
  message,
  milestone,
  funding,
  team,
  document,
  system,
}

class AppNotification {
  final String id;
  final String title;
  final String subtitle;
  final String? body;
  final NotificationType type;
  final String iconKey;
  final String colorKey;
  final DateTime createdAt;
  final bool isRead;
  final String? deepLink;
  final Map<String, dynamic>? metadata;

  const AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    this.body,
    required this.type,
    required this.iconKey,
    required this.colorKey,
    required this.createdAt,
    this.isRead = false,
    this.deepLink,
    this.metadata,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? body,
    NotificationType? type,
    String? iconKey,
    String? colorKey,
    DateTime? createdAt,
    bool? isRead,
    String? deepLink,
    Map<String, dynamic>? metadata,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      body: body ?? this.body,
      type: type ?? this.type,
      iconKey: iconKey ?? this.iconKey,
      colorKey: colorKey ?? this.colorKey,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      deepLink: deepLink ?? this.deepLink,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'body': body,
        'type': type.name,
        'iconKey': iconKey,
        'colorKey': colorKey,
        'createdAt': createdAt.toIso8601String(),
        'isRead': isRead,
        'deepLink': deepLink,
        'metadata': metadata,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      body: json['body'] as String?,
      type: NotificationType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      iconKey: json['iconKey'] as String,
      colorKey: json['colorKey'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      deepLink: json['deepLink'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
