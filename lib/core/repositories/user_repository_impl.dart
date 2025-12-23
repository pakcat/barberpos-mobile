import 'package:isar_community/isar.dart';

import '../database/entities/user_entity.dart';
import '../services/auth_service.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Future<UserEntity?> findByEmail(String email) {
    return _isar.userEntitys.filter().emailEqualTo(email, caseSensitive: false).findFirst();
  }

  @override
  Future<UserEntity?> findById(Id id) => _isar.userEntitys.get(id);

  @override
  Future<List<UserEntity>> getAll() => _isar.userEntitys.where().findAll();

  @override
  Future<Id> upsert(UserEntity user) async {
    return _isar.writeTxn(() => _isar.userEntitys.put(user));
  }

  @override
  Future<void> deleteByEmail(String email) async {
    await _isar.writeTxn(() async {
      final toDelete = await _isar.userEntitys.filter().emailEqualTo(email, caseSensitive: false).findAll();
      await _isar.userEntitys.deleteAll(toDelete.map((e) => e.id).toList());
    });
  }

  @override
  Future<void> ensureSeedUser({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.manager,
  }) async {
    final exists = await findByEmail(email);
    if (exists != null) return;
    final user = UserEntity()
      ..name = name
      ..email = email
      ..password = password
      ..role = role
      ..isGoogle = false;
    await upsert(user);
  }
}

