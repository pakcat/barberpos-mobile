import 'package:barberpos_mobile/modules/reports/data/entities/finance_entry_entity.dart';
import 'package:barberpos_mobile/modules/reports/data/repositories/reports_repository.dart';
import 'package:isar/isar.dart';

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
  Future<Id> upsert(FinanceEntryEntity entry) async {
    _entries.add(entry);
    return entry.id;
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
}
