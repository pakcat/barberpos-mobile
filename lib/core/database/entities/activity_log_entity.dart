import 'package:isar_community/isar.dart';

import '../../models/activity_log.dart';

part 'activity_log_entity.g.dart';

@collection
class ActivityLogEntity {
  Id id = Isar.autoIncrement;
  late String title;
  late String message;
  late String actor;
  @enumerated
  late ActivityLogType type;
  late DateTime timestamp;
  bool synced = false;
}

extension ActivityLogEntityMapper on ActivityLogEntity {
  ActivityLog toModel() {
    return ActivityLog(
      id: id,
      title: title,
      message: message,
      actor: actor,
      type: type,
      timestamp: timestamp,
      synced: synced,
    );
  }
}

extension ActivityLogMapper on ActivityLog {
  ActivityLogEntity toEntity() {
    return ActivityLogEntity()
      ..id = id ?? Isar.autoIncrement
      ..title = title
      ..message = message
      ..actor = actor
      ..type = type
      ..timestamp = timestamp
      ..synced = synced;
  }
}

