import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../transactions/data/entities/transaction_entity.dart';
import '../../../transactions/data/repositories/transaction_repository.dart';
import '../../data/entities/finance_entry_entity.dart';
import '../../data/repositories/reports_repository.dart';
import '../models/report_models.dart';

class ReportsController extends GetxController {
  ReportsController({ReportsRepository? repo, TransactionRepository? txRepo})
    : repo = repo ?? Get.find<ReportsRepository>(),
      _txRepo = txRepo ?? Get.find<TransactionRepository>();

  final ReportsRepository repo;
  final TransactionRepository _txRepo;
  final RxList<FinanceEntry> entries = <FinanceEntry>[].obs;
  final RxList<StylistPerformance> stylistReports = <StylistPerformance>[].obs;
  final RxList<CustomerReport> customerReports = <CustomerReport>[].obs;
  final RxList<TransactionReportItem> transactionReports = <TransactionReportItem>[].obs;

  int get transactionCount => transactionReports.length;
  int get paidCount => transactionReports.where((e) => e.status == ReportTransactionStatus.paid).length;
  int get refundCount => transactionReports.where((e) => e.status == ReportTransactionStatus.refund).length;
  int get pendingCount => transactionReports.where((e) => e.status == ReportTransactionStatus.pending).length;

  int get totalRevenue => filteredEntries
      .where((e) => e.type == EntryType.revenue)
      .fold(0, (acc, e) => acc + e.amount);

  int get totalExpense => filteredEntries
      .where((e) => e.type == EntryType.expense)
      .fold(0, (acc, e) => acc + e.amount);

  int get net => totalRevenue - totalExpense;

  final loading = false.obs;
  final exporting = false.obs;
  final filterRange = 'Bulan ini'.obs;
  final filterStaff = ''.obs;
  final filterCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
    ever(filterRange, (_) => _load());
  }

  @override
  Future<void> refresh() => _load();

  Future<void> _load() async {
    loading.value = true;
    final range = _resolveRange();
    try {
      final data = await repo.getRange(range.start, range.end);
      entries.assignAll(data.map(_map));
    } catch (_) {
      entries.clear();
    }

    try {
      final txs = await _txRepo.getRange(range.start, range.end);
      _applyTransactionReports(txs);
    } catch (_) {
      stylistReports.clear();
      customerReports.clear();
      transactionReports.clear();
    }
    loading.value = false;
  }

  void _applyTransactionReports(List<TransactionEntity> txs) {
    stylistReports.assignAll(_buildStylistPerf(txs));
    customerReports.assignAll(_buildCustomerReport(txs));
    transactionReports.assignAll(_buildTransactionReport(txs));
  }

  List<TransactionReportItem> _buildTransactionReport(List<TransactionEntity> txs) {
    final sorted = [...txs]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.map((tx) {
      final status = switch (tx.status) {
        TransactionStatusEntity.paid => ReportTransactionStatus.paid,
        TransactionStatusEntity.refund => ReportTransactionStatus.refund,
        TransactionStatusEntity.pending => ReportTransactionStatus.pending,
      };
      final customerName = tx.customer?.name.trim().isNotEmpty == true ? tx.customer!.name.trim() : '-';
      final stylist = tx.stylist.trim().isNotEmpty ? tx.stylist.trim() : '-';
      final itemsCount = tx.items.fold<int>(0, (sum, e) => sum + e.qty);
      return TransactionReportItem(
        code: tx.code,
        date: tx.date,
        time: tx.time,
        amount: tx.amount,
        paymentMethod: tx.paymentMethod,
        status: status,
        itemsCount: itemsCount,
        stylist: stylist,
        customerName: customerName,
      );
    }).toList();
  }

  List<CustomerReport> _buildCustomerReport(List<TransactionEntity> txs) {
    final Map<String, _CustomerAgg> agg = {};
    for (final tx in txs) {
      final customer = tx.customer;
      final rawName = (customer?.name ?? '').trim();
      if (rawName.isEmpty) continue;
      final key = rawName.toLowerCase();
      final a = agg.putIfAbsent(key, () => _CustomerAgg(name: rawName, phone: (customer?.phone ?? '').trim()));
      a.totalSpent += tx.amount;
      a.totalTransactions += 1;
      if (tx.date.isAfter(a.lastVisit)) a.lastVisit = tx.date;
    }
    final list = agg.values
        .map(
          (c) => CustomerReport(
            name: c.name,
            phone: c.phone.isEmpty ? null : c.phone,
            totalSpent: c.totalSpent,
            totalTransactions: c.totalTransactions,
            lastVisit: c.lastVisit,
          ),
        )
        .toList();
    list.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
    return list;
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
        a.serviceCount.update(
          item.name,
          (v) => v + item.qty,
          ifAbsent: () => item.qty,
        );
      }
    }
    return agg.entries.map((e) {
      final topService = e.value.serviceCount.entries.isEmpty
          ? null
          : e.value.serviceCount.entries
                .reduce((a, b) => a.value >= b.value ? a : b)
                .key;
      return StylistPerformance(
        name: e.key,
        totalSales: e.value.totalSales,
        totalTransactions: e.value.totalTransactions,
        totalItems: e.value.totalItems,
        topService: topService,
      );
    }).toList()..sort((a, b) => b.totalSales.compareTo(a.totalSales));
  }

  List<FinanceEntry> get filteredEntries {
    return entries.where((e) {
      final rangeMatch = _matchesRange(e.date);
      final staffMatch =
          filterStaff.value.isEmpty || e.staff == filterStaff.value;
      final serviceMatch =
          filterCategory.value.isEmpty ||
          e.service == filterCategory.value ||
          e.category == filterCategory.value;
      return rangeMatch && staffMatch && serviceMatch;
    }).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  String get summaryText {
    final highest = filteredEntries.isEmpty
        ? null
        : filteredEntries.reduce((a, b) => a.amount > b.amount ? a : b);
    if (highest == null) return 'Belum ada data laporan untuk filter ini.';
    return 'Transaksi tertinggi: ${highest.title} sebesar Rp${highest.amount}.';
  }

  Future<bool> addEntry(FinanceEntry entry) async {
    entries.add(entry);
    final res = await repo.upsert(_toEntity(entry));
    // If remote save failed, keep local row, user can refresh/retry later.
    return res.synced;
  }

  Future<String> exportCsv() async {
    final buffer = StringBuffer();
    buffer.writeln('id,title,amount,category,date,type,transaction_code,staff,service');
    for (final e in filteredEntries) {
      buffer.writeln(
        '${e.id},${e.title},${e.amount},${e.category},${e.date.toIso8601String()},${e.type.name},${e.transactionCode ?? ''},${e.staff ?? ''},${e.service ?? ''}',
      );
    }
    return buffer.toString();
  }

  Future<void> downloadExport({required String format}) async {
    final range = _resolveRange();
    exporting.value = true;
    try {
      final remoteBytes = await repo.downloadExport(
        format: format,
        start: range.start,
        end: range.end,
      );

      final useXlsx = format.toLowerCase() == 'xlsx' || format.toLowerCase() == 'excel';
      final bytes = remoteBytes ?? Uint8List.fromList(utf8.encode(await exportCsv()));

      final ext = remoteBytes != null && useXlsx ? 'xlsx' : 'csv';
      final filename =
          'finance_${range.start.year}${range.start.month.toString().padLeft(2, '0')}${range.start.day.toString().padLeft(2, '0')}_'
          '${range.end.year}${range.end.month.toString().padLeft(2, '0')}${range.end.day.toString().padLeft(2, '0')}.$ext';

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}${Platform.pathSeparator}$filename');
      await file.writeAsBytes(bytes, flush: true);

      if (useXlsx && remoteBytes == null) {
        Get.snackbar('Info', 'Export Excel butuh backend REST, dikirim sebagai CSV.');
      }
      await Share.shareXFiles([XFile(file.path)], text: 'Export laporan keuangan');
    } catch (e) {
      Get.snackbar('Gagal export', e.toString());
    } finally {
      exporting.value = false;
    }
  }

  FinanceEntry _map(FinanceEntryEntity e) => FinanceEntry(
    id: e.id.toString(),
    title: e.title,
    amount: e.amount,
    category: e.category,
    date: e.date,
    type: e.type == EntryTypeEntity.expense
        ? EntryType.expense
        : EntryType.revenue,
    note: e.note,
    transactionCode: e.transactionCode,
    staff: e.staff,
    service: e.service,
  );

  FinanceEntryEntity _toEntity(FinanceEntry e) {
    final entity = FinanceEntryEntity()
      ..title = e.title
      ..amount = e.amount
      ..category = e.category
      ..date = e.date
      ..type = e.type == EntryType.expense
          ? EntryTypeEntity.expense
          : EntryTypeEntity.revenue
      ..note = e.note
      ..transactionCode = e.transactionCode
      ..staff = e.staff
      ..service = e.service;
    entity.id = int.tryParse(e.id) ?? e.id.hashCode;
    return entity;
  }

  bool _matchesRange(DateTime date) {
    final now = DateTime.now();
    switch (filterRange.value) {
      case 'Hari ini':
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      case 'Minggu ini':
        final start = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 6));
        return !date.isBefore(start);
      case 'Bulan ini':
        return date.year == now.year && date.month == now.month;
      default:
        return true;
    }
  }

  DateTimeRange _resolveRange() {
    final now = DateTime.now();
    switch (filterRange.value) {
      case 'Hari ini':
        final start = DateTime(now.year, now.month, now.day);
        return DateTimeRange(start: start, end: _endOfDay(start));
      case 'Minggu ini':
        final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
        return DateTimeRange(start: start, end: _endOfDay(now));
      case 'Bulan ini':
      default:
        final start = DateTime(now.year, now.month, 1);
        final lastDay = DateTime(now.year, now.month + 1, 0);
        return DateTimeRange(start: start, end: _endOfDay(lastDay));
    }
  }

  DateTime _endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}

class _StylistAgg {
  int totalSales = 0;
  int totalTransactions = 0;
  int totalItems = 0;
  final Map<String, int> serviceCount = {};
}

class _CustomerAgg {
  _CustomerAgg({required this.name, required this.phone});

  final String name;
  final String phone;
  int totalSpent = 0;
  int totalTransactions = 0;
  DateTime lastVisit = DateTime.fromMillisecondsSinceEpoch(0);
}
