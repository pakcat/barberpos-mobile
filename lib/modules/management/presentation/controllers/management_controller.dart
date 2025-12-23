import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../models/management_models.dart';
import '../../data/repositories/management_repository.dart';
import '../../data/entities/category_entity.dart';
import '../../data/entities/customer_entity.dart';
import '../../data/datasources/customer_firestore_data_source.dart';
import '../../data/datasources/category_firestore_data_source.dart';
import '../../data/datasources/management_remote_data_source.dart';

class ManagementController extends GetxController {
  ManagementController({
    ManagementRepository? repository,
    CustomerFirestoreDataSource? firebase,
    CategoryFirestoreDataSource? categoryRemote,
    ManagementRemoteDataSource? restRemote,
    AppConfig? config,
    NetworkService? network,
    FirebaseFirestore? firestore,
  })  : repo = repository ?? Get.find<ManagementRepository>(),
        _config = config ?? Get.find<AppConfig>(),
        _customerRemote = firebase ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? CustomerFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null),
        _categoryRemote = categoryRemote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? CategoryFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null),
        _rest = restRemote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.rest
                ? ManagementRemoteDataSource((network ?? Get.find<NetworkService>()).dio)
                : null);

  final ManagementRepository repo;
  final AppConfig _config;
  final CustomerFirestoreDataSource? _customerRemote;
  final CategoryFirestoreDataSource? _categoryRemote;
  final ManagementRemoteDataSource? _rest;

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
    final rest = _rest;
    if (_config.backend == BackendMode.rest && rest != null) {
      try {
        final remoteCats = await rest.fetchCategories();
        await repo.replaceCategories(remoteCats);
        categories.assignAll(remoteCats.map(_mapCategory));
      } catch (_) {
        final cats = await repo.getCategories();
        categories.assignAll(cats.map(_mapCategory));
      }
      try {
        final remoteCust = await rest.fetchCustomers();
        await repo.replaceCustomers(remoteCust);
        customers.assignAll(remoteCust.map(_mapCustomer));
      } catch (_) {
        final cust = await repo.getCustomers();
        customers.assignAll(cust.map(_mapCustomer));
      }
      loading.value = false;
      return;
    }
    final customerRemote = _customerRemote;
    if (_config.backend == BackendMode.firebase && customerRemote != null) {
      try {
        final remoteCust = await customerRemote.fetchAll();
        await repo.replaceCustomers(remoteCust);
        customers.assignAll(remoteCust.map(_mapCustomer));
      } catch (_) {
        final cust = await repo.getCustomers();
        customers.assignAll(cust.map(_mapCustomer));
      }
      try {
        final categoryRemote = _categoryRemote;
        if (categoryRemote != null) {
          final remoteCats = await categoryRemote.fetchAll();
          await repo.replaceCategories(remoteCats);
          categories.assignAll(remoteCats.map(_mapCategory));
        }
      } catch (_) {
        final cats = await repo.getCategories();
        categories.assignAll(cats.map(_mapCategory));
      }
    } else {
      final cats = await repo.getCategories();
      categories.assignAll(cats.map(_mapCategory));
      final cust = await repo.getCustomers();
      customers.assignAll(cust.map(_mapCustomer));
    }
    loading.value = false;
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
    final categoryRemote = _categoryRemote;
    final rest = _rest;
    if (_config.backend == BackendMode.rest && rest != null) {
      rest.upsertCategory(entity);
    }
    if (_config.backend == BackendMode.firebase && categoryRemote != null) {
      categoryRemote.upsert(entity);
    }
    repo.upsertCategory(entity);
  }

  void deleteCategory(String id) {
    final existing = categories.firstWhereOrNull((c) => c.id == id);
    categories.removeWhere((c) => c.id == id);
    if (existing != null) {
      final parsedId = int.tryParse(id) ?? existing.id.hashCode;
      repo.deleteCategory(parsedId);
      final categoryRemote = _categoryRemote;
      final rest = _rest;
      if (_config.backend == BackendMode.rest && rest != null) {
        rest.deleteCategory(parsedId);
      }
      if (_config.backend == BackendMode.firebase && categoryRemote != null) {
        categoryRemote.delete(_toCategoryEntity(existing));
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
    final customerRemote = _customerRemote;
    final rest = _rest;
    if (_config.backend == BackendMode.rest && rest != null) {
      rest.upsertCustomer(entity);
    }
    if (_config.backend == BackendMode.firebase && customerRemote != null) {
      customerRemote.upsert(entity);
    }
    repo.upsertCustomer(entity);
  }

  void deleteCustomer(String id) {
    final existing = customers.firstWhereOrNull((c) => c.id == id);
    customers.removeWhere((c) => c.id == id);
    customers.refresh();
    if (existing != null) {
      repo.deleteCustomer(int.tryParse(id) ?? existing.id.hashCode);
      final customerRemote = _customerRemote;
      final rest = _rest;
      if (_config.backend == BackendMode.rest && rest != null) {
        rest.deleteCustomer(int.tryParse(id) ?? existing.id.hashCode);
      }
      if (_config.backend == BackendMode.firebase && customerRemote != null) {
        customerRemote.delete(_toCustomerEntity(existing));
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

