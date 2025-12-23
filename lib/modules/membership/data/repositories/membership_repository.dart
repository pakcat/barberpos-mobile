import 'package:isar_community/isar.dart';

import '../datasources/membership_remote_data_source.dart';
import '../entities/membership_topup_entity.dart';
import '../entities/membership_state_entity.dart';

class MembershipRepository {
  MembershipRepository(this._isar, {this.remote});

  final Isar _isar;
  final MembershipRemoteDataSource? remote;

  Future<List<MembershipTopupEntity>> getAll() async {
    if (remote != null) {
      try {
        final items = await remote!.fetchTopups();
        await _replaceTopups(items);
        return items;
      } catch (_) {}
    }
    return _isar.membershipTopupEntitys.where().findAll();
  }

  Future<Id> addTopup(MembershipTopupEntity topup) async {
    if (remote != null) {
      try {
        final saved = await remote!.addTopup(topup);
        topup.id = saved.id;
      } catch (_) {}
    }
    return _isar.writeTxn(() => _isar.membershipTopupEntitys.put(topup));
  }

  Future<int> getUsedQuota() async {
    if (remote != null) {
      try {
        final state = await remote!.fetchState();
        await setState(
          MembershipStateEntity()
            ..id = 1
            ..usedQuota = state.usedQuota,
        );
        return state.usedQuota;
      } catch (_) {}
    }
    final state = await _isar.membershipStateEntitys.get(1);
    return state?.usedQuota ?? 0;
  }

  Future<MembershipStateEntity?> fetchState() async {
    if (remote != null) {
      try {
        final state = await remote!.fetchState();
        final entity = MembershipStateEntity()
          ..id = 1
          ..usedQuota = state.usedQuota;
        await setState(entity);
        return entity;
      } catch (_) {}
    }
    return _isar.membershipStateEntitys.get(1);
  }

  Future<void> setUsedQuota(int value) async {
    await setState(
      MembershipStateEntity()
        ..id = 1
        ..usedQuota = value,
    );
    if (remote != null) {
      try {
        await remote!.setUsedQuota(value);
      } catch (_) {}
    }
  }

  Future<void> setState(MembershipStateEntity state) async {
    await _isar.writeTxn(() async {
      await _isar.membershipStateEntitys.put(state);
    });
  }

  Future<void> _replaceTopups(Iterable<MembershipTopupEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.membershipTopupEntitys.clear();
      await _isar.membershipTopupEntitys.putAll(items.toList());
    });
  }
}
