import 'package:barberpos_mobile/core/database/entities/user_entity.dart';
import 'package:barberpos_mobile/core/repositories/user_repository.dart';
import 'package:barberpos_mobile/core/services/auth_service.dart';
import 'package:isar_community/isar.dart';

class FakeUserRepository implements UserRepository {
  final Map<int, UserEntity> _store = {};
  int _id = 1;

  @override
  Future<void> deleteByEmail(String email) async {
    _store.removeWhere((_, v) => v.email.toLowerCase() == email.toLowerCase());
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
    final u = UserEntity()
      ..name = name
      ..email = email
      ..password = password
      ..role = role
      ..isGoogle = false;
    await upsert(u);
  }

  @override
  Future<UserEntity?> findByEmail(String email) async {
    for (final e in _store.values) {
      if (e.email.toLowerCase() == email.toLowerCase()) return e;
    }
    return null;
  }

  @override
  Future<UserEntity?> findById(Id id) async => _store[id];

  @override
  Future<List<UserEntity>> getAll() async => _store.values.toList();

  @override
  Future<Id> upsert(UserEntity user) async {
    if (user.id == Isar.autoIncrement) {
      user.id = _id++;
    }
    _store[user.id] = user;
    return user.id;
  }
}
