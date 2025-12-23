import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../data/datasources/transaction_remote_data_source.dart';
import '../../data/entities/transaction_entity.dart';
import '../../data/repositories/transaction_repository.dart';
import '../models/mappers.dart';
import '../models/transaction_models.dart';

class TransactionController extends GetxController {
  TransactionController({
    TransactionRepository? repository,
    TransactionRemoteDataSource? remote,
    AppConfig? config,
    NetworkService? network,
  })  : repo = repository ?? Get.find<TransactionRepository>(),
        _config = config ?? Get.find<AppConfig>(),
        _remote = remote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.rest
                ? TransactionRemoteDataSource((network ?? Get.find<NetworkService>()).dio)
                : null);

  final TransactionRepository repo;
  final AppConfig _config;
  final TransactionRemoteDataSource? _remote;

  final RxList<TransactionItem> transactions = <TransactionItem>[].obs;
  final loading = false.obs;

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
    final tx = transactions.firstWhereOrNull((t) => t.id == id);
    transactions.removeWhere((t) => t.id == id);
    if (tx != null) {
      await repo.delete(int.tryParse(tx.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? tx.hashCode);
    }
  }

  Future<void> _load() async {
    loading.value = true;
    final remote = _remote;
    if (_config.backend == BackendMode.rest && remote != null) {
      try {
        final data = await remote.fetchAll();
        await repo.replaceAll(data);
        transactions.assignAll(data.map(_map));
        loading.value = false;
        return;
      } catch (_) {
        // fallback to local
      }
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
    final entity = toTransactionEntity(item);
    await repo.upsert(entity);
  }

  Future<void> refreshRemote() async => _load();
}
