import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/local_time.dart';
import '../../../../core/values/app_colors.dart';
import '../../data/datasources/membership_remote_data_source.dart';
import '../../data/entities/membership_state_entity.dart';
import '../../data/entities/membership_topup_entity.dart';
import '../../data/repositories/membership_repository.dart';
import '../models/membership_models.dart';

class MembershipController extends GetxController {
  MembershipController({
    AuthService? authService,
    MembershipRepository? repository,
    MembershipRemoteDataSource? restRemote,
    AppConfig? config,
    NetworkService? network,
  }) : _auth = authService ?? Get.find<AuthService>(),
       repo = repository ?? Get.find<MembershipRepository>(),
       _config = config ?? Get.find<AppConfig>(),
       _rest =
           restRemote ??
           MembershipRemoteDataSource(
             (network ?? Get.find<NetworkService>()).dio,
           );

  final AuthService _auth;
  final MembershipRepository repo;
  final AppConfig _config;
  final MembershipRemoteDataSource _rest;

  final RxInt usedQuota = 0.obs;
  final RxInt freeQuota = 1000.obs;
  final RxInt freeUsed = 0.obs;
  final RxInt topupBalance = 0.obs;
  final RxList<QuotaTopup> topups = <QuotaTopup>[].obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool get isManager => _auth.isManager;
  bool get isStaff => _auth.isStaffOnly;
  bool get _useRest => _config.backend == BackendMode.rest;

  int get topupQuota => topupBalance.value > 0
      ? topupBalance.value
      : topups.fold(0, (acc, item) => acc + item.amount);
  int get totalQuota => freeQuota.value + topupQuota;
  int get remainingQuota => max(totalQuota - usedQuota.value, 0);
  double get usageProgress =>
      totalQuota == 0 ? 0 : usedQuota.value / totalQuota;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    if (_useRest) {
      try {
        final state = await _rest.fetchState();
        _applyState(
          used: state.usedQuota,
          free: state.freeQuota,
          freeUsedValue: state.freeUsed,
          topupBal: state.topupBalance,
        );
        await repo.setState(
          MembershipStateEntity()
            ..id = 1
            ..usedQuota = state.usedQuota,
        );
        final data = await _rest.fetchTopups();
        topups.assignAll(data.map(_map));
        await repo.replaceTopups(data);
        return;
      } catch (_) {}
    }

    usedQuota.value = await repo.getUsedQuota();
    final data = await repo.getAll();
    topups.assignAll(data.map(_map));
  }

  void addTopup() {
    final amount =
        int.tryParse(amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    if (amount <= 0) {
      Get.snackbar('Nominal tidak valid', 'Masukkan angka lebih dari 0');
      return;
    }
    topups.insert(
      0,
      QuotaTopup(
        amount: amount,
        manager: _auth.currentUser?.name ?? 'Manager',
        note: noteController.text.trim().isEmpty
            ? 'Top up tanpa catatan'
            : noteController.text,
        date: DateTime.now(),
      ),
    );
    final entity = _toEntity(topups.first);
    repo.addTopup(entity);
    amountController.clear();
    noteController.clear();
  }

  Future<void> updateUsage(int value) async {
    usedQuota.value = value;
    await repo.setUsedQuota(value);
  }

  void _applyState({
    required int used,
    required int free,
    required int freeUsedValue,
    required int topupBal,
  }) {
    usedQuota.value = used;
    freeQuota.value = free;
    freeUsed.value = freeUsedValue;
    topupBalance.value = topupBal;
  }

  String formatNumber(int value) {
    final digits = value.abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }
    final formatted = buffer.toString();
    return value < 0 ? '-$formatted' : formatted;
  }

  String formatDate(DateTime date) {
    date = asLocalTime(date);
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    return '$day $month ${date.year}';
  }

  Color get usageColor {
    if (usageProgress < 0.5) return AppColors.green500;
    if (usageProgress < 0.8) return AppColors.orange500;
    return AppColors.red500;
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }

  QuotaTopup _map(MembershipTopupEntity e) => QuotaTopup(
    amount: e.amount,
    manager: e.manager,
    note: e.note,
    date: e.date,
  );

  MembershipTopupEntity _toEntity(QuotaTopup item) {
    final entity = MembershipTopupEntity()
      ..amount = item.amount
      ..manager = item.manager
      ..note = item.note
      ..date = item.date;
    return entity;
  }
}
