import 'package:isar_community/isar.dart';

part 'product_outbox_entity.g.dart';

@collection
class ProductOutboxEntity {
  Id id = Isar.autoIncrement;
  int localProductId = 0;
  @enumerated
  ProductOutboxActionEntity action = ProductOutboxActionEntity.upsert;
  String payloadJson = '';
  DateTime createdAt = DateTime.now();
  bool synced = false;
  DateTime? syncedAt;
  String? serverId;
  String? lastError;
  int attempts = 0;
  DateTime? lastAttemptAt;
  DateTime? nextAttemptAt;
}

// Keep new values appended to preserve Isar enum indices for existing data.
enum ProductOutboxActionEntity { upsert, delete }
