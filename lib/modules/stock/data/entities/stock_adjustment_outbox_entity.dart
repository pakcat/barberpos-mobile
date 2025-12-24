import 'package:isar_community/isar.dart';

part 'stock_adjustment_outbox_entity.g.dart';

@collection
class StockAdjustmentOutboxEntity {
  Id id = Isar.autoIncrement;

  late int stockId;
  late int change;
  late String type; // add|reduce|recount (match backend)
  String note = '';
  int? productId;

  late DateTime createdAt;
  bool synced = false;
}

