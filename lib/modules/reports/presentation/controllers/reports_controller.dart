import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../transactions/data/entities/transaction_entity.dart';
import '../../../transactions/data/repositories/transaction_repository.dart';
import '../../data/datasources/reports_firestore_data_source.dart';
import '../../data/entities/finance_entry_entity.dart';
import '../../data/repositories/reports_repository.dart';
import '../models/report_models.dart';

class ReportsController extends GetxController {
  ReportsController({
    ReportsRepository? repo,
    TransactionRepository? txRepo,
    ReportsFirestoreDataSource? firebase,
    AppConfig? config,
    FirebaseFirestore? firestore,
  })  : repo = repo ?? Get.find<ReportsRepository>(),
        _txRepo = txRepo ?? Get.find<TransactionRepository>(),
        _config = config ?? Get.find<AppConfig>(),
        _firebase = firebase ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? ReportsFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null);

  final ReportsRepository repo;
  final TransactionRepository _txRepo;
  final AppConfig _config;
  final ReportsFirestoreDataSource? _firebase;
  final RxList<FinanceEntry> entries = <FinanceEntry>[].obs;
  final RxList<StylistPerformance> stylistReports = <StylistPerformance>[].obs;

  bool get _useFirebase => _config.backend == BackendMode.firebase && _firebase != null;

  int get totalRevenue => entries
      .where((e) => e.type == EntryType.revenue)
      .fold(0, (acc, e) => acc + e.amount);

  int get totalExpense => entries
      .where((e) => e.type == EntryType.expense)
      .fold(0, (acc, e) => acc + e.amount);

  int get net => totalRevenue - totalExpense;

  final loading = false.obs;
  final filterRange = 'Bulan ini'.obs;
  final filterStaff = ''.obs;
  final filterCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  @override
  @override
  Future<void> refresh() => _load();

  Future<void> _load() async {
    loading.value = true;
    if (_useFirebase) {
      try {
        final remote = await _firebase!.fetchAll();
        await repo.replaceAll(remote);
        entries.assignAll(remote.map(_map));
      } catch (_) {
        final data = await repo.getAll();
        entries.assignAll(data.map(_map));
      }
    } else {
      final data = await repo.getAll();
      entries.assignAll(data.map(_map));
    }
    await _loadStylistReport();
    loading.value = false;
  }

  Future<void> _loadStylistReport() async {
    final txs = await _txRepo.getAll();
    stylistReports.assignAll(_buildStylistPerf(txs));
  }

  List<StylistPerformance> _buildStylistPerf(List<TransactionEntity> txs) {
    final Map<String, _StylistAgg> agg = {};
    for (final tx in txs) {
      final name = (tx.stylist.isNotEmpty ? tx.stylist : 'Unknown').trim();
      final a = agg.putIfAbsent(name, () => _StylistAgg());
      a.totalSales += tx.amount;
      a.totalTransactions += 1;
      for (final item in tx.items) {
        a.totalItems += item.qty;
        a.serviceCount.update(item.name, (v) => v + item.qty, ifAbsent: () => item.qty);
      }
    }
    return agg.entries.map((e) {
      final topService = e.value.serviceCount.entries.isEmpty
          ? null
          : e.value.serviceCount.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      return StylistPerformance(
        name: e.key,
        totalSales: e.value.totalSales,
        totalTransactions: e.value.totalTransactions,
        totalItems: e.value.totalItems,
        topService: topService,
      );
    }).toList()
      ..sort((a, b) => b.totalSales.compareTo(a.totalSales));
  }

  List<FinanceEntry> get filteredEntries {
    return entries.where((e) {
      final staffMatch = filterStaff.value.isEmpty || e.staff == filterStaff.value;
      final serviceMatch = filterCategory.value.isEmpty ||
          e.service == filterCategory.value ||
          e.category == filterCategory.value;
      return staffMatch && serviceMatch;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  String get summaryText {
    final highest = filteredEntries.isEmpty
        ? null
        : filteredEntries.reduce((a, b) => a.amount > b.amount ? a : b);
    if (highest == null) return 'Belum ada data laporan untuk filter ini.';
    return 'Transaksi tertinggi: ${highest.title} sebesar Rp${highest.amount}.';
  }

  void addEntry(FinanceEntry entry) {
    entries.add(entry);
    final entity = _toEntity(entry);
    if (_useFirebase) {
      _firebase!.upsert(entity);
    }
    repo.upsert(entity);
  }

  Future<String> exportCsv() async {
    final buffer = StringBuffer();
    buffer.writeln('id,title,amount,category,date,type,staff,service');
    for (final e in filteredEntries) {
      buffer.writeln(
          '${e.id},${e.title},${e.amount},${e.category},${e.date.toIso8601String()},${e.type.name},${e.staff ?? ''},${e.service ?? ''}');
    }
    return buffer.toString();
  }

  FinanceEntry _map(FinanceEntryEntity e) => FinanceEntry(
        id: e.id.toString(),
        title: e.title,
        amount: e.amount,
        category: e.category,
        date: e.date,
        type: e.type == EntryTypeEntity.expense ? EntryType.expense : EntryType.revenue,
        note: e.note,
        staff: e.staff,
        service: e.service,
      );

  FinanceEntryEntity _toEntity(FinanceEntry e) {
    final entity = FinanceEntryEntity()
      ..title = e.title
      ..amount = e.amount
      ..category = e.category
      ..date = e.date
      ..type = e.type == EntryType.expense ? EntryTypeEntity.expense : EntryTypeEntity.revenue
      ..note = e.note
      ..staff = e.staff
      ..service = e.service;
    entity.id = int.tryParse(e.id) ?? e.id.hashCode;
    return entity;
  }
}

class _StylistAgg {
  int totalSales = 0;
  int totalTransactions = 0;
  int totalItems = 0;
  final Map<String, int> serviceCount = {};
}
