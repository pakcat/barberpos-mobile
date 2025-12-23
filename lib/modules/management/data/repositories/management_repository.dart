import 'package:isar_community/isar.dart';

import '../datasources/management_remote_data_source.dart';
import '../entities/category_entity.dart';
import '../entities/customer_entity.dart';

class ManagementRepository {
  ManagementRepository(this._isar, {this.remote});

  final Isar _isar;
  final ManagementRemoteDataSource? remote;

  Future<List<CategoryEntity>> getCategories() async {
    if (remote != null) {
      try {
        final items = await remote!.fetchCategories();
        await replaceCategories(items);
        return items;
      } catch (_) {}
    }
    return _isar.categoryEntitys.where().findAll();
  }

  Future<List<CustomerEntity>> getCustomers() async {
    if (remote != null) {
      try {
        final items = await remote!.fetchCustomers();
        await replaceCustomers(items);
        return items;
      } catch (_) {}
    }
    return _isar.customerEntitys.where().findAll();
  }

  Future<Id> upsertCategory(CategoryEntity category) async {
    if (remote != null) {
      try {
        final saved = await remote!.upsertCategory(category);
        category.id = saved.id;
      } catch (_) {}
    }
    return _isar.writeTxn(() => _isar.categoryEntitys.put(category));
  }

  Future<void> deleteCategory(Id id) async {
    await _isar.writeTxn(() => _isar.categoryEntitys.delete(id));
    if (remote != null) {
      try {
        await remote!.deleteCategory(id);
      } catch (_) {}
    }
  }

  Future<Id> upsertCustomer(CustomerEntity customer) async {
    if (remote != null) {
      try {
        final saved = await remote!.upsertCustomer(customer);
        customer.id = saved.id;
      } catch (_) {}
    }
    return _isar.writeTxn(() => _isar.customerEntitys.put(customer));
  }

  Future<void> deleteCustomer(Id id) async {
    await _isar.writeTxn(() => _isar.customerEntitys.delete(id));
    if (remote != null) {
      try {
        await remote!.deleteCustomer(id);
      } catch (_) {}
    }
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
