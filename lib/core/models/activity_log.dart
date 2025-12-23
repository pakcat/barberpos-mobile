class ActivityLog {
  ActivityLog({
    this.id,
    required this.title,
    required this.message,
    required this.actor,
    this.type = ActivityLogType.info,
    DateTime? timestamp,
    this.synced = false,
  }) : timestamp = timestamp ?? DateTime.now();

  final int? id;
  final String title;
  final String message;
  final String actor;
  final ActivityLogType type;
  final DateTime timestamp;
  final bool synced;

  ActivityLog copyWith({
    int? id,
    String? title,
    String? message,
    String? actor,
    ActivityLogType? type,
    DateTime? timestamp,
    bool? synced,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      actor: actor ?? this.actor,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      synced: synced ?? this.synced,
    );
  }
}

enum ActivityLogType { info, warning, error }
