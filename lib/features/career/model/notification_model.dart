enum CareerNotificationType {
  post,
  event,
  community,
  job,
  interview,
  system,
}

class CareerNotification {
  final String id;
  final String title;
  final String description;
  final CareerNotificationType type;
  final String iconName;
  final int iconColor;
  final int iconBg;
  final String time;
  final bool isRead;
  final String actionText;
  final String? deepLink;

  const CareerNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.iconName,
    required this.iconColor,
    required this.iconBg,
    required this.time,
    this.isRead = false,
    this.actionText = 'View',
    this.deepLink,
  });

  CareerNotification copyWith({
    String? id,
    String? title,
    String? description,
    CareerNotificationType? type,
    String? iconName,
    int? iconColor,
    int? iconBg,
    String? time,
    bool? isRead,
    String? actionText,
    String? deepLink,
  }) {
    return CareerNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      iconName: iconName ?? this.iconName,
      iconColor: iconColor ?? this.iconColor,
      iconBg: iconBg ?? this.iconBg,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      actionText: actionText ?? this.actionText,
      deepLink: deepLink ?? this.deepLink,
    );
  }
}