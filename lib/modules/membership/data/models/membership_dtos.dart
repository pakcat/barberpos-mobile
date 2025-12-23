import 'package:isar_community/isar.dart';

import '../entities/membership_state_entity.dart';
import '../entities/membership_topup_entity.dart';

class MembershipTopupDto {
  MembershipTopupDto({
    required this.id,
    required this.amount,
    required this.manager,
    required this.note,
    required this.date,
  });

  final String id;
  final int amount;
  final String manager;
  final String note;
  final DateTime date;

  factory MembershipTopupDto.fromJson(Map<String, dynamic> json) {
    return MembershipTopupDto(
      id: json['id']?.toString() ?? '',
      amount: int.tryParse(json['amount']?.toString() ?? '') ?? 0,
      manager: json['manager']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  MembershipTopupEntity toEntity() {
    final entity = MembershipTopupEntity()
      ..amount = amount
      ..manager = manager
      ..note = note
      ..date = date;
    entity.id = int.tryParse(id) ?? Isar.autoIncrement;
    return entity;
  }
}

class MembershipStateDto {
  MembershipStateDto({required this.usedQuota});

  final int usedQuota;

  factory MembershipStateDto.fromJson(Map<String, dynamic> json) {
    return MembershipStateDto(usedQuota: int.tryParse(json['usedQuota']?.toString() ?? '') ?? 0);
  }

  MembershipStateEntity toEntity() {
    return MembershipStateEntity()..usedQuota = usedQuota;
  }
}

