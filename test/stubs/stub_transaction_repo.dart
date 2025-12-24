import 'package:barberpos_mobile/modules/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:barberpos_mobile/modules/transactions/data/entities/transaction_entity.dart';
import 'package:barberpos_mobile/modules/transactions/data/repositories/transaction_repository.dart';
import 'package:isar_community/isar.dart';

class StubTransactionRepository implements TransactionRepository {
  final List<TransactionEntity> _txs = [
    TransactionEntity()
      ..id = 1
      ..code = 'TX1'
      ..date = DateTime(2024, 1, 1)
      ..time = '10:00'
      ..amount = 100000
      ..paymentMethod = 'cash'
      ..status = TransactionStatusEntity.paid
      ..items = [
        TransactionLineEntity()
          ..name = 'Potong'
          ..category = 'Haircut'
          ..price = 50000
          ..qty = 2
      ]
      ..stylist = 'Awan',
  ];

  @override
  Future<void> delete(Id id) async {
    _txs.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> deleteByCode(String code) async {
    _txs.removeWhere((e) => e.code == code);
  }

  @override
  Future<void> updateCode({required String oldCode, required String newCode}) async {
    final existing = _txs.where((e) => e.code == oldCode).toList();
    if (existing.isEmpty) return;
    existing.first.code = newCode;
  }

  @override
  Future<void> markSyncedPending({
    required String pendingCode,
    required String serverCode,
  }) async {
    final existing = _txs.where((e) => e.code == pendingCode).toList();
    if (existing.isEmpty) return;
    existing.first
      ..code = serverCode
      ..status = TransactionStatusEntity.paid
      ..refundedAt = null
      ..refundNote = '';
  }

  @override
  Future<bool> refundByCode({
    required String code,
    String? note,
    bool delete = true,
  }) async {
    _txs.removeWhere((e) => e.code == code);
    return true;
  }

  @override
  Future<bool> markPaidByCode({required String code}) async {
    final existing = _txs.where((e) => e.code == code).toList();
    if (existing.isEmpty) return true;
    existing.first.status = TransactionStatusEntity.paid;
    return true;
  }

  @override
  Future<List<TransactionEntity>> getAll() async => _txs;

  @override
  Future<List<TransactionEntity>> getRange(DateTime start, DateTime end) async {
    return _txs
        .where((t) => !t.date.isBefore(start) && !t.date.isAfter(end))
        .toList();
  }

  @override
  Future<Id> upsert(TransactionEntity tx) async {
    _txs.removeWhere((t) => t.id == tx.id);
    _txs.add(tx);
    return tx.id;
  }

  @override
  Future<void> upsertAll(Iterable<TransactionEntity> items) async {
    for (final tx in items) {
      _txs.removeWhere((t) => t.id == tx.id);
      _txs.add(tx);
    }
  }

  @override
  Future<void> replaceAll(Iterable<TransactionEntity> items) async {
    _txs
      ..clear()
      ..addAll(items);
  }

  @override
  TransactionRemoteDataSource? get restRemote => null;
}
