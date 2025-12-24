import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../data/entities/transaction_entity.dart';
import '../../data/repositories/transaction_repository.dart';
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
    if (_isRest) {
      Get.snackbar('Info', 'Refund/hapus transaksi belum tersedia untuk mode REST.');
      return;
    }
    transactions.removeWhere((t) => t.id == id);
    await repo.deleteByCode(id);
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
    status: e.status == TransactionStatusEntity.refund
        ? TransactionStatus.refund
        : TransactionStatus.paid,
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
