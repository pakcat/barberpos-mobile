import 'package:isar_community/isar.dart';

import '../datasources/transaction_firestore_data_source.dart';
import '../datasources/transaction_remote_data_source.dart';
import '../entities/transaction_entity.dart';

class TransactionRepository {
  TransactionRepository(this._isar, {this.remote, this.restRemote});

  final Isar _isar;
  final TransactionFirestoreDataSource? remote;
  final TransactionRemoteDataSource? restRemote;

  Future<List<TransactionEntity>> getAll() async {
    if (restRemote != null) {
      try {
        final items = await restRemote!.fetchAll();
        await replaceAll(items);
        return items;
      } catch (_) {}
    }
    if (remote != null) {
      try {
        final items = await remote!.fetchAll();
        await replaceAll(items);
        return items;
      } catch (_) {
        // Fallback to local
      }
    }
    return _isar.transactionEntitys.where().findAll();
  }

  Future<Id> upsert(TransactionEntity tx) async {
    final id = await _isar.writeTxn(() => _isar.transactionEntitys.put(tx));
    if (restRemote != null) {
      // creation/update via API handled elsewhere (cashier/order flow)
    } else if (remote != null) {
      try {
        await remote!.upsert(tx);
      } catch (_) {
        // Queue for sync? For now just ignore.
      }
    }
    return id;
  }

  Future<void> replaceAll(Iterable<TransactionEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.transactionEntitys.clear();
      await _isar.transactionEntitys.putAll(items.toList());
    });
  }

  Future<void> delete(Id id) async {
    final item = await _isar.transactionEntitys.get(id);
    await _isar.writeTxn(() => _isar.transactionEntitys.delete(id));
    if (remote != null && item != null) {
      try {
        await remote!.delete(item);
      } catch (_) {
        // failed to delete remote
      }
    }
  }
}
