import 'package:isar_community/isar.dart';

import '../../data/entities/finance_entry_entity.dart';
import '../models/report_models.dart';

FinanceEntryEntity toEntity(FinanceEntry e) {
  final entity = FinanceEntryEntity()
    ..title = e.title
    ..amount = e.amount
    ..category = e.category
    ..date = e.date
    ..type = e.type == EntryType.expense ? EntryTypeEntity.expense : EntryTypeEntity.revenue
    ..note = e.note
    ..transactionCode = e.transactionCode
    ..staff = e.staff
    ..service = e.service;
  entity.id = int.tryParse(e.id) ?? Isar.autoIncrement;
  return entity;
}

