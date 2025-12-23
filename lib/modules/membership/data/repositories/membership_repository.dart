import 'package:isar_community/isar.dart';

import '../entities/membership_topup_entity.dart';
import '../entities/membership_state_entity.dart';

class MembershipRepository {
  MembershipRepository(this._isar);

  final Isar _isar;

  Future<List<MembershipTopupEntity>> getAll() => _isar.membershipTopupEntitys.where().findAll();

  Future<Id> addTopup(MembershipTopupEntity topup) {
    return _isar.writeTxn(() => _isar.membershipTopupEntitys.put(topup));
  }

  Future<int> getUsedQuota() async {
    final state = await _isar.membershipStateEntitys.get(1);
    return state?.usedQuota ?? 0;
  }

  Future<void> setUsedQuota(int value) async {
    await _isar.writeTxn(() async {
      await _isar.membershipStateEntitys.put(
        MembershipStateEntity()
          ..id = 1
          ..usedQuota = value,
      );
    });
  }
}

