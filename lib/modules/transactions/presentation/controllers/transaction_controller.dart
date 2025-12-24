import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../data/entities/transaction_entity.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../../cashier/data/repositories/order_outbox_repository.dart';
import '../../../reports/data/entities/finance_entry_entity.dart';
import '../../../reports/data/repositories/reports_repository.dart';
import '../models/mappers.dart';
import '../models/transaction_models.dart';

class TransactionController extends GetxController {
  TransactionController({
    TransactionRepository? repository,
    AppConfig? config,
  })  : repo = repository ?? Get.find<TransactionRepository>(),
        _config = config ?? Get.find<AppConfig>();

  final TransactionRepository repo;
  final AppConfig _config;

  final RxList<TransactionItem> transactions = <TransactionItem>[].obs;
  final loading = false.obs;
  final Rxn<DateTimeRange> filterRange = Rxn<DateTimeRange>();

  bool get _isRest => _config.backend == BackendMode.rest;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> add(TransactionItem item) async {
    transactions.insert(0, item);
    final entity = toTransactionEntity(item);
    await repo.upsert(entity);
  }

  Future<void> upsertTransaction(TransactionItem item) async {
    if (_isRest) {
      Get.snackbar('Info', 'Update transaksi belum tersedia untuk mode REST.');
      return;
    }
    final index = transactions.indexWhere((t) => t.id == item.id);
    if (index != -1) {
      transactions[index] = item;
    } else {
      transactions.add(item);
    }
    final entity = toTransactionEntity(item);
    await repo.upsert(entity);
  }

  Future<void> remove(String id) async {
    if (id.startsWith('PENDING-') && Get.isRegistered<OrderOutboxRepository>()) {
      await Get.find<OrderOutboxRepository>().cancelByPendingCode(id);
      transactions.removeWhere((t) => t.id == id);
      await repo.deleteByCode(id);
      return;
    }
    final ok = await repo.refundByCode(code: id, delete: true);
    if (!ok) {
      Get.snackbar('Gagal', 'Refund transaksi gagal.');
      return;
    }
    transactions.removeWhere((t) => t.id == id);
  }

  Future<void> refund({
    required String id,
    String? note,
    bool delete = true,
  }) async {
    if (delete && id.startsWith('PENDING-') && Get.isRegistered<OrderOutboxRepository>()) {
      await Get.find<OrderOutboxRepository>().cancelByPendingCode(id);
      transactions.removeWhere((t) => t.id == id);
      await repo.deleteByCode(id);
      return;
    }
    final localTx = transactions.firstWhereOrNull((t) => t.id == id);
    final ok = await repo.refundByCode(code: id, note: note, delete: delete);
    if (!ok) {
      Get.snackbar('Gagal', 'Refund transaksi gagal.');
      return;
    }
    await _recordRefundFinanceEntry(id: id, tx: localTx, note: note);
    if (delete) {
      transactions.removeWhere((t) => t.id == id);
      return;
    }
    final idx = transactions.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final tx = transactions[idx];
      final now = DateTime.now();
      transactions[idx] = TransactionItem(
        id: tx.id,
        date: tx.date,
        time: tx.time,
        amount: tx.amount,
        paymentMethod: tx.paymentMethod,
        status: TransactionStatus.refund,
        refundedAt: now,
        refundNote: note?.trim().isNotEmpty ?? false ? note!.trim() : null,
        items: tx.items,
        customer: tx.customer,
      );
      transactions.refresh();
    }
  }

  Future<void> _recordRefundFinanceEntry({
    required String id,
    required TransactionItem? tx,
    String? note,
  }) async {
    try {
      final reportsRepo =
          Get.isRegistered<ReportsRepository>() ? Get.find<ReportsRepository>() : null;
      if (reportsRepo == null) return;
      final amount = tx?.amount;
      if (amount == null) return;
      final entry = FinanceEntryEntity()
        ..title = 'Refund $id'
        ..amount = amount
        ..category = 'Refund'
        ..date = DateTime.now()
        ..type = EntryTypeEntity.expense
        ..note = note?.trim() ?? ''
        ..transactionCode = id;
      await reportsRepo.upsert(entry);
    } catch (_) {}
  }

  Future<void> _load({DateTimeRange? range}) async {
    loading.value = true;
    final activeRange = range ?? filterRange.value;
    if (activeRange != null) {
      try {
        final data = await repo.getRange(activeRange.start, activeRange.end);
        transactions.assignAll(data.map(_map));
      } catch (_) {
        transactions.clear();
      }
      loading.value = false;
      return;
    }
    final data = await repo.getAll();
    transactions.assignAll(data.map(_map));
    loading.value = false;
  }

  TransactionItem? getById(String id) => transactions.firstWhereOrNull((t) => t.id == id);

  TransactionItem _map(TransactionEntity e) => TransactionItem(
    id: e.code.isNotEmpty ? e.code : e.id.toString(),
    date: e.date,
    time: e.time,
    amount: e.amount,
    paymentMethod: e.paymentMethod,
    status: switch (e.status) {
      TransactionStatusEntity.refund => TransactionStatus.refund,
      TransactionStatusEntity.pending => TransactionStatus.pending,
      TransactionStatusEntity.paid => TransactionStatus.paid,
    },
    refundedAt: e.refundedAt,
    refundNote: e.refundNote.isEmpty ? null : e.refundNote,
    items: e.items
        .map((i) => TransactionLine(name: i.name, category: i.category, price: i.price, qty: i.qty))
        .toList(),
    customer: e.customer == null
        ? TransactionCustomer(name: '', phone: '', email: '', address: '')
        : TransactionCustomer(
            name: e.customer!.name,
            phone: e.customer!.phone,
            email: e.customer!.email,
            address: e.customer!.address,
            visits: e.customer!.visits,
            lastVisit: e.customer!.lastVisit,
          ),
  );

  Future<void> save(TransactionItem item) async {
    if (_isRest) {
      Get.snackbar('Info', 'Edit transaksi belum tersedia untuk mode REST.');
      return;
    }
    final entity = toTransactionEntity(item);
    await repo.upsert(entity);
  }

  Future<void> markPaid(String id) async {
    if (id.startsWith('PENDING-')) {
      Get.snackbar('Info', 'Transaksi masih pending sync.');
      return;
    }
    final ok = await repo.markPaidByCode(code: id);
    if (!ok) {
      Get.snackbar('Gagal', 'Gagal menandai lunas.');
      return;
    }
    await _removeRefundFinanceEntries(id);
    final idx = transactions.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final tx = transactions[idx];
      transactions[idx] = TransactionItem(
        id: tx.id,
        date: tx.date,
        time: tx.time,
        amount: tx.amount,
        paymentMethod: tx.paymentMethod,
        status: TransactionStatus.paid,
        items: tx.items,
        customer: tx.customer,
      );
      transactions.refresh();
    }
  }

  Future<void> _removeRefundFinanceEntries(String transactionCode) async {
    try {
      final reportsRepo =
          Get.isRegistered<ReportsRepository>() ? Get.find<ReportsRepository>() : null;
      if (reportsRepo == null) return;
      final entries = await reportsRepo.getAll();
      final idsToDelete = entries
          .where(
            (e) =>
                e.transactionCode == transactionCode &&
                e.category.trim().toLowerCase() == 'refund' &&
                e.type == EntryTypeEntity.expense,
          )
          .map((e) => e.id)
          .toList();
      for (final id in idsToDelete) {
        await reportsRepo.delete(id);
      }
    } catch (_) {}
  }

  Future<void> refreshRemote() async => _load(range: filterRange.value);

  Future<void> applyRange(DateTimeRange? range) async {
    if (range == null) {
      filterRange.value = null;
      await _load();
      return;
    }
    final normalized = DateTimeRange(
      start: DateTime(range.start.year, range.start.month, range.start.day),
      end: DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59, 999),
    );
    filterRange.value = normalized;
    await _load(range: normalized);
  }

  Future<void> clearRange() async {
    filterRange.value = null;
    await _load();
  }
}
