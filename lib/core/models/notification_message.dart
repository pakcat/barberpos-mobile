class NotificationMessage {
  NotificationMessage({
    this.id,
    required this.title,
    required this.message,
    this.type = NotificationType.info,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final int? id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
}

enum NotificationType { info, warning, error }
