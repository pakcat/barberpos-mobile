import 'package:isar_community/isar.dart';

import '../entities/finance_entry_entity.dart';
import '../datasources/reports_firestore_data_source.dart';

class ReportsRepository {
  ReportsRepository(this._isar, {this.remote});

  final Isar _isar;
  final ReportsFirestoreDataSource? remote;

  Future<List<FinanceEntryEntity>> getAll() async {
    if (remote != null) {
      try {
        final items = await remote!.fetchAll();
        await replaceAll(items);
        return items;
      } catch (_) {
        // Fallback to local
      }
    }
    return _isar.financeEntryEntitys.where().findAll();
  }

  Future<Id> upsert(FinanceEntryEntity entry) {
    return _isar.writeTxn(() async {
      final id = await _isar.financeEntryEntitys.put(entry);
      if (remote != null) {
        try {
          await remote!.upsert(entry);
        } catch (_) {}
      }
      return id;
    });
  }

  Future<void> replaceAll(Iterable<FinanceEntryEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.financeEntryEntitys.clear();
      await _isar.financeEntryEntitys.putAll(items.toList());
    });
  }

  Future<void> delete(Id id) async {
    final item = await _isar.financeEntryEntitys.get(id);
    await _isar.writeTxn(() => _isar.financeEntryEntitys.delete(id));
    if (remote != null && item != null) {
      try {
        await remote!.delete(item);
      } catch (_) {}
    }
  }
}

