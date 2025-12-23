import 'package:isar_community/isar.dart';

part 'session_entity.g.dart';

@collection
class SessionEntity {
  Id id = 1;
  int? userId;
  String? token;
  String? refreshToken;
  DateTime? expiresAt;
}

