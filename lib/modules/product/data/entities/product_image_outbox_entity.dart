import 'package:isar_community/isar.dart';

part 'product_image_outbox_entity.g.dart';

@collection
class ProductImageOutboxEntity {
  Id id = Isar.autoIncrement;
  int localProductId = 0;
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
