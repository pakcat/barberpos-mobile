import 'package:isar_community/isar.dart';

part 'order_outbox_entity.g.dart';

@collection
class OrderOutboxEntity {
  Id id = Isar.autoIncrement;

  late String clientRef;
  late String pendingCode;
  late String payloadJson;
  late DateTime createdAt;

  bool synced = false;
  String? serverCode;
  DateTime? syncedAt;
  String? lastError;
  int attempts = 0;
  DateTime? lastAttemptAt;
  DateTime? nextAttemptAt;
}
