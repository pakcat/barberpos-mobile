enum NotificationType { info, warning, error }

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.message,
    required this.actor,
    required this.timestamp,
    this.type = NotificationType.info,
  });

  final String title;
  final String message;
  final String actor;
  final NotificationType type;
  final DateTime timestamp;
}
