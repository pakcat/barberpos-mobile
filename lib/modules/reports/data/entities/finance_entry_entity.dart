import 'package:isar_community/isar.dart';

part 'finance_entry_entity.g.dart';

@collection
class FinanceEntryEntity {
  Id id = Isar.autoIncrement;
  late String title;
  late int amount;
  late String category;
  late DateTime date;
  @enumerated
  late EntryTypeEntity type;
  String note = '';
  String? staff;
  String? service;
}

enum EntryTypeEntity { revenue, expense }

