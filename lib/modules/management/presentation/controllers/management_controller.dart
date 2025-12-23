import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../data/datasources/management_remote_data_source.dart';
import '../../data/entities/category_entity.dart';
import '../../data/entities/customer_entity.dart';
import '../../data/repositories/management_repository.dart';
import '../models/management_models.dart';

class ManagementController extends GetxController {
  ManagementController({
    ManagementRepository? repository,
    ManagementRemoteDataSource? restRemote,
    AppConfig? config,
    NetworkService? network,
  })  : repo = repository ?? Get.find<ManagementRepository>(),
        _config = config ?? Get.find<AppConfig>(),
        _rest = restRemote ??
            ManagementRemoteDataSource((network ?? Get.find<NetworkService>()).dio);

  final ManagementRepository repo;
  final AppConfig _config;
  final ManagementRemoteDataSource _rest;

  final RxList<CategoryItem> categories = <CategoryItem>[].obs;
  final RxList<CustomerItem> customers = <CustomerItem>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    loading.value = true;
    try {
      if (_config.backend == BackendMode.rest) {
        final remoteCats = await _rest.fetchCategories();
        await repo.replaceCategories(remoteCats);
        categories.assignAll(remoteCats.map(_mapCategory));

        final remoteCust = await _rest.fetchCustomers();
        await repo.replaceCustomers(remoteCust);
        customers.assignAll(remoteCust.map(_mapCustomer));
      } else {
        final cats = await repo.getCategories();
        categories.assignAll(cats.map(_mapCategory));
        final cust = await repo.getCustomers();
        customers.assignAll(cust.map(_mapCustomer));
      }
    } catch (_) {
      final cats = await repo.getCategories();
      categories.assignAll(cats.map(_mapCategory));
      final cust = await repo.getCustomers();
      customers.assignAll(cust.map(_mapCustomer));
    } finally {
      loading.value = false;
    }
  }

  CategoryItem? getCategoryById(String id) =>
      categories.firstWhereOrNull((c) => c.id == id);

  CustomerItem? getCustomerById(String id) =>
      customers.firstWhereOrNull((c) => c.id == id);

  void upsertCategory(CategoryItem item) {
    final index = categories.indexWhere((c) => c.id == item.id);
    if (index >= 0) {
      categories[index] = item;
    } else {
      categories.add(item);
    }
    final entity = _toCategoryEntity(item);
    if (_config.backend == BackendMode.rest) {
      _rest.upsertCategory(entity);
    }
    repo.upsertCategory(entity);
  }

  void deleteCategory(String id) {
    final existing = categories.firstWhereOrNull((c) => c.id == id);
    categories.removeWhere((c) => c.id == id);
    if (existing != null) {
      final parsedId = int.tryParse(id) ?? existing.id.hashCode;
      repo.deleteCategory(parsedId);
      if (_config.backend == BackendMode.rest) {
        _rest.deleteCategory(parsedId);
      }
    }
  }

  void upsertCustomer(CustomerItem item) {
    final index = customers.indexWhere((c) => c.id == item.id);
    if (index >= 0) {
      customers[index] = item;
    } else {
      customers.add(item);
    }
    customers.refresh();
    final entity = _toCustomerEntity(item);
    if (_config.backend == BackendMode.rest) {
      _rest.upsertCustomer(entity);
    }
    repo.upsertCustomer(entity);
  }

  void deleteCustomer(String id) {
    final existing = customers.firstWhereOrNull((c) => c.id == id);
    customers.removeWhere((c) => c.id == id);
    customers.refresh();
    if (existing != null) {
      final parsedId = int.tryParse(id) ?? existing.id.hashCode;
      repo.deleteCustomer(parsedId);
      if (_config.backend == BackendMode.rest) {
        _rest.deleteCustomer(parsedId);
      }
    }
  }

  CategoryItem _mapCategory(CategoryEntity e) => CategoryItem(id: e.id.toString(), name: e.name);
  CustomerItem _mapCustomer(CustomerEntity e) => CustomerItem(
        id: e.id.toString(),
        name: e.name,
        phone: e.phone,
        email: e.email,
        address: e.address,
      );

  CategoryEntity _toCategoryEntity(CategoryItem item) {
    final entity = CategoryEntity()..name = item.name;
    entity.id = int.tryParse(item.id) ?? Isar.autoIncrement;
    return entity;
  }

  CustomerEntity _toCustomerEntity(CustomerItem item) {
    final entity = CustomerEntity()
      ..name = item.name
      ..phone = item.phone
      ..email = item.email
      ..address = item.address;
    entity.id = int.tryParse(item.id) ?? Isar.autoIncrement;
    return entity;
  }
}
