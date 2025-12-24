import 'package:get/get.dart';

import '../../data/entities/category_entity.dart';
import '../../data/entities/customer_entity.dart';
import '../../data/repositories/management_repository.dart';
import '../models/management_models.dart';

class ManagementController extends GetxController {
  ManagementController({
    ManagementRepository? repository,
  })  : repo = repository ?? Get.find<ManagementRepository>(),
        super();

  final ManagementRepository repo;

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
      final cats = await repo.getCategories();
      categories.assignAll(cats.map(_mapCategory));
      final cust = await repo.getCustomers();
      customers.assignAll(cust.map(_mapCustomer));
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

  Future<void> upsertCategory(CategoryItem item) async {
    final existingIndex = categories.indexWhere((c) => c.id == item.id);
    if (existingIndex >= 0) {
      categories[existingIndex] = item;
    } else {
      categories.add(item);
    }
    final entity = _toCategoryEntity(item);
    final savedId = await repo.upsertCategory(entity);
    _updateCategoryId(tempId: item.id, savedId: savedId);
  }

  Future<void> deleteCategory(String id) async {
    final existing = categories.firstWhereOrNull((c) => c.id == id);
    categories.removeWhere((c) => c.id == id);
    if (existing != null) {
      final parsedId = int.tryParse(id);
      if (parsedId != null) {
        await repo.deleteCategory(parsedId);
      } else {
        // If the item never got a numeric ID, it's only local UI state.
      }
    }
  }

  Future<void> upsertCustomer(CustomerItem item) async {
    final existingIndex = customers.indexWhere((c) => c.id == item.id);
    if (existingIndex >= 0) {
      customers[existingIndex] = item;
    } else {
      customers.add(item);
    }
    final entity = _toCustomerEntity(item);
    final savedId = await repo.upsertCustomer(entity);
    _updateCustomerId(tempId: item.id, savedId: savedId);
  }

  Future<void> deleteCustomer(String id) async {
    final existing = customers.firstWhereOrNull((c) => c.id == id);
    customers.removeWhere((c) => c.id == id);
    if (existing != null) {
      final parsedId = int.tryParse(id);
      if (parsedId != null) {
        await repo.deleteCustomer(parsedId);
      } else {
        // If the item never got a numeric ID, it's only local UI state.
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
    entity.id = int.tryParse(item.id) ?? 0;
    return entity;
  }

  CustomerEntity _toCustomerEntity(CustomerItem item) {
    final entity = CustomerEntity()
      ..name = item.name
      ..phone = item.phone
      ..email = item.email
      ..address = item.address;
    entity.id = int.tryParse(item.id) ?? 0;
    return entity;
  }

  void _updateCategoryId({required String tempId, required int savedId}) {
    if (savedId <= 0) return;
    final newId = savedId.toString();
    if (tempId == newId) return;
    final idx = categories.indexWhere((c) => c.id == tempId);
    if (idx == -1) return;
    final current = categories[idx];
    categories[idx] = CategoryItem(id: newId, name: current.name);
  }

  void _updateCustomerId({required String tempId, required int savedId}) {
    if (savedId <= 0) return;
    final newId = savedId.toString();
    if (tempId == newId) return;
    final idx = customers.indexWhere((c) => c.id == tempId);
    if (idx == -1) return;
    final current = customers[idx];
    customers[idx] = CustomerItem(
      id: newId,
      name: current.name,
      phone: current.phone,
      email: current.email,
      address: current.address,
    );
  }
}
