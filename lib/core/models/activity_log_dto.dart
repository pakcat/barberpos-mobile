import 'activity_log.dart';

class ActivityLogDto {
  ActivityLogDto({
    required this.title,
    required this.message,
    required this.actor,
    required this.type,
    required this.timestamp,
  });

  final String title;
  final String message;
  final String actor;
  final String type;
  final DateTime timestamp;

  factory ActivityLogDto.fromModel(ActivityLog log) {
    return ActivityLogDto(
      title: log.title,
      message: log.message,
      actor: log.actor,
      type: log.type.name,
      timestamp: log.timestamp,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
        'actor': actor,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
      };
}
