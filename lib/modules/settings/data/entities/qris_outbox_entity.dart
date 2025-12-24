import 'package:isar_community/isar.dart';

part 'qris_outbox_entity.g.dart';

@collection
class QrisOutboxEntity {
  Id id = Isar.autoIncrement;
  @enumerated
  QrisOutboxActionEntity action = QrisOutboxActionEntity.upload;
  String filePath = '';
  String filename = '';
  String mimeType = 'image/jpeg';
  DateTime createdAt = DateTime.now();
  bool synced = false;
  DateTime? syncedAt;
  String? lastError;
  int attempts = 0;
  DateTime? lastAttemptAt;
  DateTime? nextAttemptAt;
}

// Keep new values appended to preserve Isar enum indices for existing data.
enum QrisOutboxActionEntity { upload, delete }
