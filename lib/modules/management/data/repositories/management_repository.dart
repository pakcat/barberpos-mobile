import 'package:isar_community/isar.dart';

import '../entities/category_entity.dart';
import '../entities/customer_entity.dart';

class ManagementRepository {
  ManagementRepository(this._isar);

  final Isar _isar;

  Future<List<CategoryEntity>> getCategories() => _isar.categoryEntitys.where().findAll();
  Future<List<CustomerEntity>> getCustomers() => _isar.customerEntitys.where().findAll();

  Future<Id> upsertCategory(CategoryEntity category) async {
    return _isar.writeTxn(() => _isar.categoryEntitys.put(category));
  }

  Future<void> deleteCategory(Id id) async {
    await _isar.writeTxn(() => _isar.categoryEntitys.delete(id));
  }

  Future<Id> upsertCustomer(CustomerEntity customer) async {
    return _isar.writeTxn(() => _isar.customerEntitys.put(customer));
  }

  Future<void> deleteCustomer(Id id) async {
    await _isar.writeTxn(() => _isar.customerEntitys.delete(id));
  }

  Future<void> replaceCustomers(Iterable<CustomerEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.customerEntitys.clear();
      await _isar.customerEntitys.putAll(items.toList());
    });
  }

  Future<void> replaceCategories(Iterable<CategoryEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.categoryEntitys.clear();
      await _isar.categoryEntitys.putAll(items.toList());
    });
  }
}

