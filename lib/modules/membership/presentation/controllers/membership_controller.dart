import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/values/app_colors.dart';
import '../../data/datasources/membership_firestore_data_source.dart';
import '../../data/datasources/membership_remote_data_source.dart';
import '../../data/entities/membership_topup_entity.dart';
import '../../data/repositories/membership_repository.dart';
import '../models/membership_models.dart';

class MembershipController extends GetxController {
  MembershipController({
    AuthService? authService,
    MembershipRepository? repository,
    MembershipFirestoreDataSource? firebase,
    MembershipRemoteDataSource? restRemote,
    AppConfig? config,
    NetworkService? network,
    FirebaseFirestore? firestore,
  })  : _auth = authService ?? Get.find<AuthService>(),
        repo = repository ?? Get.find<MembershipRepository>(),
        _config = config ?? Get.find<AppConfig>(),
        _remote = firebase ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? MembershipFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null),
        _rest = restRemote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.rest
                ? MembershipRemoteDataSource((network ?? Get.find<NetworkService>()).dio)
                : null);

  final AuthService _auth;
  final MembershipRepository repo;
  final AppConfig _config;
  final MembershipFirestoreDataSource? _remote;
  final MembershipRemoteDataSource? _rest;

  final int freeQuotaMonthly = 1000;
  final RxInt usedQuota = 0.obs;
  final RxList<QuotaTopup> topups = <QuotaTopup>[].obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool get isManager => _auth.isManager;
  bool get isStaff => _auth.isStaffOnly;
  bool get _useFirebase => _config.backend == BackendMode.firebase && _remote != null;
  bool get _useRest => _config.backend == BackendMode.rest && _rest != null;

  int get topupQuota => topups.fold(0, (acc, item) => acc + item.amount);
  int get totalQuota => freeQuotaMonthly + topupQuota;
  int get remainingQuota => max(totalQuota - usedQuota.value, 0);
  double get usageProgress => totalQuota == 0 ? 0 : usedQuota.value / totalQuota;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    if (_useRest) {
      try {
        usedQuota.value = await _rest!.fetchUsedQuota();
        final data = await _rest!.fetchTopups();
        topups.assignAll(data.map(_map));
        for (final t in data) {
          await repo.addTopup(t);
        }
        await repo.setUsedQuota(usedQuota.value);
        return;
      } catch (_) {}
    }

    final remote = _remote;
    if (_useFirebase && remote != null) {
      try {
        usedQuota.value = await remote.fetchUsedQuota();
        final data = await remote.fetchTopups();
        topups.assignAll(data.map(_map));
        // persist to local
        for (final t in data) {
          await repo.addTopup(t);
        }
        await repo.setUsedQuota(usedQuota.value);
      } catch (_) {
        usedQuota.value = await repo.getUsedQuota();
        final data = await repo.getAll();
        topups.assignAll(data.map(_map));
      }
    } else {
      usedQuota.value = await repo.getUsedQuota();
      final data = await repo.getAll();
      topups.assignAll(data.map(_map));
    }
  }

  void addTopup() {
    final amount = int.tryParse(amountController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (amount <= 0) {
      Get.snackbar('Nominal tidak valid', 'Masukkan angka lebih dari 0');
      return;
    }
    topups.insert(
      0,
      QuotaTopup(
        amount: amount,
        manager: _auth.currentUser?.name ?? 'Manager',
        note: noteController.text.trim().isEmpty ? 'Top up tanpa catatan' : noteController.text,
        date: DateTime.now(),
      ),
    );
    final entity = _toEntity(topups.first);
    repo.addTopup(entity);
    if (_useRest && _rest != null) {
      _rest!.addTopup(entity);
    } else {
      final remote = _remote;
      if (_useFirebase && remote != null) {
        remote.addTopup(entity);
      }
    }
    amountController.clear();
    noteController.clear();
  }

  Future<void> updateUsage(int value) async {
    usedQuota.value = value;
    await repo.setUsedQuota(value);
    if (_useRest && _rest != null) {
      _rest!.setUsedQuota(value);
    } else {
      final remote = _remote;
      if (_useFirebase && remote != null) {
        await remote.setUsedQuota(value);
      }
    }
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

  QuotaTopup _map(MembershipTopupEntity e) =>
      QuotaTopup(amount: e.amount, manager: e.manager, note: e.note, date: e.date);

  MembershipTopupEntity _toEntity(QuotaTopup t) {
    final entity = MembershipTopupEntity()
      ..amount = t.amount
      ..manager = t.manager
      ..note = t.note
      ..date = t.date;
    return entity;
  }
}
