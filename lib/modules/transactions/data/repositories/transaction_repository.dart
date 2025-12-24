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

  Future<void> updateCode({required String oldCode, required String newCode}) async {
    if (oldCode == newCode) return;
    final existing = await _isar.transactionEntitys.filter().codeEqualTo(oldCode).findFirst();
    if (existing == null) return;
    await _isar.writeTxn(() async {
      await _isar.transactionEntitys.delete(existing.id);
      existing.code = newCode;
      await _isar.transactionEntitys.put(existing);
    });
  }

  Future<void> markSyncedPending({
    required String pendingCode,
    required String serverCode,
  }) async {
    if (pendingCode == serverCode) return;
    final existing = await _isar.transactionEntitys.filter().codeEqualTo(pendingCode).findFirst();
    if (existing == null) return;
    await _isar.writeTxn(() async {
      final conflict = await _isar.transactionEntitys.filter().codeEqualTo(serverCode).findFirst();
      if (conflict != null && conflict.id != existing.id) {
        await _isar.transactionEntitys.delete(existing.id);
        return;
      }
      existing
        ..code = serverCode
        ..status = TransactionStatusEntity.paid
        ..refundedAt = null
        ..refundNote = '';
      await _isar.transactionEntitys.put(existing);
    });
  }

  Future<bool> refundByCode({
    required String code,
    String? note,
    bool delete = true,
  }) async {
    final remote = restRemote;
    if (remote != null) {
      try {
        await remote.refund(code: code, note: note, delete: delete);
        if (delete) {
          await deleteByCode(code);
        } else {
          final existing = await _isar.transactionEntitys.filter().codeEqualTo(code).findFirst();
          if (existing != null) {
            existing.status = TransactionStatusEntity.refund;
            existing.refundedAt = DateTime.now();
            existing.refundNote = note?.trim() ?? '';
            await _isar.writeTxn(() => _isar.transactionEntitys.put(existing));
          }
        }
        return true;
      } catch (_) {
        return false;
      }
    }
    if (delete) {
      await deleteByCode(code);
      return true;
    }
    final existing = await _isar.transactionEntitys.filter().codeEqualTo(code).findFirst();
    if (existing == null) return true;
    existing.status = TransactionStatusEntity.refund;
    existing.refundedAt = DateTime.now();
    existing.refundNote = note?.trim() ?? '';
    await _isar.writeTxn(() => _isar.transactionEntitys.put(existing));
    return true;
  }

  Future<bool> markPaidByCode({required String code}) async {
    final remote = restRemote;
    if (remote != null) {
      try {
        await remote.markPaid(code: code);
        final existing = await _isar.transactionEntitys.filter().codeEqualTo(code).findFirst();
        if (existing != null) {
          existing.status = TransactionStatusEntity.paid;
          existing.refundedAt = null;
          existing.refundNote = '';
          await _isar.writeTxn(() => _isar.transactionEntitys.put(existing));
        }
        return true;
      } catch (_) {
        return false;
      }
    }
    final existing = await _isar.transactionEntitys.filter().codeEqualTo(code).findFirst();
    if (existing != null) {
      existing.status = TransactionStatusEntity.paid;
      existing.refundedAt = null;
      existing.refundNote = '';
      await _isar.writeTxn(() => _isar.transactionEntitys.put(existing));
    }
    return true;
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
