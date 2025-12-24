import 'package:barberpos_mobile/modules/reports/data/datasources/finance_remote_data_source.dart';
import 'package:barberpos_mobile/modules/reports/data/entities/finance_entry_entity.dart';
import 'package:barberpos_mobile/modules/reports/data/repositories/reports_repository.dart';
import 'package:isar_community/isar.dart';

class StubReportsRepository implements ReportsRepository {
  final List<FinanceEntryEntity> _entries = [
    FinanceEntryEntity()
      ..id = 1
      ..title = 'Haircut'
      ..amount = 100000
      ..category = 'Service'
      ..date = DateTime(2024, 1, 1)
      ..type = EntryTypeEntity.revenue
      ..staff = 'Awan'
      ..service = 'Haircut',
    FinanceEntryEntity()
      ..id = 2
      ..title = 'Supplies'
      ..amount = 20000
      ..category = 'Expense'
      ..date = DateTime(2024, 1, 2)
      ..type = EntryTypeEntity.expense,
  ];

  @override
  Future<List<FinanceEntryEntity>> getAll() async => _entries;

  @override
  Future<List<FinanceEntryEntity>> getRange(DateTime start, DateTime end) async {
    return _entries
        .where((e) => !e.date.isBefore(start) && !e.date.isAfter(end))
        .toList();
  }

  @override
  Future<Id> upsert(FinanceEntryEntity entry) async {
    _entries.removeWhere((e) => e.id == entry.id);
    _entries.add(entry);
    return entry.id;
  }

  @override
  Future<void> upsertAll(Iterable<FinanceEntryEntity> items) async {
    for (final entry in items) {
      _entries.removeWhere((e) => e.id == entry.id);
      _entries.add(entry);
    }
  }

  @override
  Future<void> delete(Id id) async {
    _entries.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> replaceAll(Iterable<FinanceEntryEntity> items) async {
    _entries
      ..clear()
      ..addAll(items);
  }

  @override
  FinanceRemoteDataSource? get restRemote => null;
}
