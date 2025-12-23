import 'package:isar_community/isar.dart';

import '../entities/closing_history_entity.dart';

class ClosingRepository {
  ClosingRepository(this._isar);

  final Isar _isar;

  Future<List<ClosingHistoryEntity>> getAll() =>
      _isar.closingHistoryEntitys.where().sortByTanggalDesc().findAll();

  Future<Id> add(ClosingHistoryEntity history) {
    return _isar.writeTxn(() => _isar.closingHistoryEntitys.put(history));
  }

  Future<void> replaceAll(List<ClosingHistoryEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.closingHistoryEntitys.clear();
      await _isar.closingHistoryEntitys.putAll(items);
    });
  }
}

