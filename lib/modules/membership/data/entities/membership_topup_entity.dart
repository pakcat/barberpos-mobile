import 'package:isar_community/isar.dart';

part 'membership_topup_entity.g.dart';

@collection
class MembershipTopupEntity {
  Id id = Isar.autoIncrement;
  late int amount;
  late String manager;
  late String note;
  late DateTime date;
}

