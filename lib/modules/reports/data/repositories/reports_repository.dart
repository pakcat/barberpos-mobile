import 'package:isar_community/isar.dart';
import 'package:flutter/foundation.dart';

import '../datasources/finance_remote_data_source.dart';
import '../entities/finance_entry_entity.dart';

class ReportsRepository {
  ReportsRepository(this._isar, {this.restRemote});

  final Isar _isar;
  final FinanceRemoteDataSource? restRemote;

  Future<List<FinanceEntryEntity>> getAll() async {
    if (restRemote != null) {
      try {
        final items = await restRemote!.fetchAll();
        await replaceAll(items);
        return items;
      } catch (_) {}
    }
    return _isar.financeEntryEntitys.where().findAll();
  }

  Future<List<FinanceEntryEntity>> getRange(DateTime start, DateTime end) async {
    if (restRemote != null) {
      try {
        final items = await restRemote!.fetchAll(startDate: start, endDate: end);
        await upsertAll(items);
        return items;
      } catch (_) {}
    }
    return _isar.financeEntryEntitys
        .filter()
        .dateBetween(start, end, includeLower: true, includeUpper: true)
        .findAll();
  }

  Future<FinanceUpsertResult> upsert(FinanceEntryEntity entry) async {
    final localId = entry.id;
    final id = await _isar.writeTxn(() => _isar.financeEntryEntitys.put(entry));

    final remote = restRemote;
    if (remote == null) {
      return FinanceUpsertResult(localId: id, synced: false);
    }

    try {
      final saved = await remote.add(entry);
      if (saved.id != 0 && saved.id != localId) {
        await _isar.writeTxn(() async {
          await _isar.financeEntryEntitys.delete(localId);
          await _isar.financeEntryEntitys.put(saved);
        });
      }
      return FinanceUpsertResult(localId: id, synced: true);
    } catch (_) {}

    return FinanceUpsertResult(localId: id, synced: false);
  }

  Future<Uint8List?> downloadExport({
    required String format,
    required DateTime start,
    required DateTime end,
  }) async {
    final remote = restRemote;
    if (remote == null) return null;
    try {
      return await remote.downloadExport(format: format, startDate: start, endDate: end);
    } catch (_) {
      return null;
    }
  }

  Future<void> replaceAll(Iterable<FinanceEntryEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.financeEntryEntitys.clear();
      await _isar.financeEntryEntitys.putAll(items.toList());
    });
  }

  Future<void> upsertAll(Iterable<FinanceEntryEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.financeEntryEntitys.putAll(items.toList());
    });
  }

  Future<void> updateTransactionCode({required String oldCode, required String newCode}) async {
    if (oldCode == newCode) return;
    await _isar.writeTxn(() async {
      final rows = await _isar.financeEntryEntitys.filter().transactionCodeEqualTo(oldCode).findAll();
      if (rows.isEmpty) return;
      for (final e in rows) {
        e.transactionCode = newCode;
      }
      await _isar.financeEntryEntitys.putAll(rows);
    });
  }

  Future<void> delete(Id id) async => _isar.writeTxn(() => _isar.financeEntryEntitys.delete(id));
}

class FinanceUpsertResult {
  FinanceUpsertResult({required this.localId, required this.synced});

  final Id localId;
  final bool synced;
}
