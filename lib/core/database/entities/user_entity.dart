import 'package:isar_community/isar.dart';

import '../../services/auth_service.dart';

part 'user_entity.g.dart';

@collection
class UserEntity {
  Id id = Isar.autoIncrement;
  late String name;
  late String email;
  String phone = '';
  String address = '';
  String region = '';
  @enumerated
  UserRole role = UserRole.manager;
  bool isGoogle = false;
  String? password;
}

