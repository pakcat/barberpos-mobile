import 'package:isar_community/isar.dart';

import '../database/entities/user_entity.dart';
import '../services/auth_service.dart';

abstract class UserRepository {
  Future<UserEntity?> findByEmail(String email);
  Future<UserEntity?> findById(Id id);
  Future<List<UserEntity>> getAll();
  Future<Id> upsert(UserEntity user);
  Future<void> deleteByEmail(String email);
  Future<void> ensureSeedUser({
    required String name,
    required String email,
    required String password,
    UserRole role,
  });
}

