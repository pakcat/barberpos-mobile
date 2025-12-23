import 'package:isar_community/isar.dart';

part 'membership_state_entity.g.dart';

@collection
class MembershipStateEntity {
  Id id = 1;
  int usedQuota = 0;
}

