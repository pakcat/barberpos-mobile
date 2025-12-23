import 'package:barberpos_mobile/modules/transactions/data/datasources/transaction_firestore_data_source.dart';
import 'package:barberpos_mobile/modules/transactions/data/entities/transaction_entity.dart';
import 'package:barberpos_mobile/modules/transactions/data/repositories/transaction_repository.dart';
import 'package:isar/isar.dart';

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
  Future<List<TransactionEntity>> getAll() async => _txs;

  @override
  Future<Id> upsert(TransactionEntity tx) async {
    _txs.add(tx);
    return tx.id;
  }

  @override
  Future<void> replaceAll(Iterable<TransactionEntity> items) async {
    _txs
      ..clear()
      ..addAll(items);
  }

  @override
  TransactionFirestoreDataSource? get remote => null;
}
