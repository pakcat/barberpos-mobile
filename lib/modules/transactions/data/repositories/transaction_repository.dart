import 'package:isar_community/isar.dart';

import '../datasources/transaction_remote_data_source.dart';
import '../entities/transaction_entity.dart';

class TransactionRepository {
  TransactionRepository(this._isar, {this.restRemote});

  final Isar _isar;
  final TransactionRemoteDataSource? restRemote;

  Future<List<TransactionEntity>> getAll() async {
    if (restRemote != null) {
      try {
        final items = await restRemote!.fetchAll();
        await replaceAll(items);
        return items;
      } catch (_) {}
    }
    return _isar.transactionEntitys.where().findAll();
  }

  Future<List<TransactionEntity>> getRange(DateTime start, DateTime end) async {
    if (restRemote != null) {
      try {
        final items = await restRemote!.fetchAll(startDate: start, endDate: end);
        await upsertAll(items);
        return items;
      } catch (_) {}
    }
    return _isar.transactionEntitys
        .filter()
        .dateBetween(start, end, includeLower: true, includeUpper: true)
        .findAll();
  }

  Future<Id> upsert(TransactionEntity tx) async {
    // Transaction creation through REST API is handled in the cashier flow.
    final existing = await _isar.transactionEntitys.filter().codeEqualTo(tx.code).findFirst();
    if (existing != null) {
      tx.id = existing.id;
    }
    return _isar.writeTxn(() => _isar.transactionEntitys.put(tx));
  }

  Future<void> deleteByCode(String code) async {
    final existing = await _isar.transactionEntitys.filter().codeEqualTo(code).findFirst();
    if (existing == null) return;
    await _isar.writeTxn(() => _isar.transactionEntitys.delete(existing.id));
  }

  Future<void> replaceAll(Iterable<TransactionEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.transactionEntitys.clear();
      await _isar.transactionEntitys.putAll(items.toList());
    });
  }

  Future<void> upsertAll(Iterable<TransactionEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.transactionEntitys.putAll(items.toList());
    });
  }

  Future<void> delete(Id id) async => _isar.writeTxn(() => _isar.transactionEntitys.delete(id));
}
