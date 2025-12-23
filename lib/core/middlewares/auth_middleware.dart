import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({this.requireManager = false, this.allowStaff = false});

  final bool requireManager;
  final bool allowStaff;

  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthService>();
    final isStaff = auth.isStaffOnly;
    if (!auth.isLoggedIn) {
      return const RouteSettings(name: Routes.login);
    }
    if (requireManager && !auth.isManager) {
      Get.snackbar('Akses dibatasi', 'Halaman ini hanya untuk Admin/Manager');
      return RouteSettings(name: isStaff ? Routes.closing : Routes.home);
    }
    if (!allowStaff && isStaff) {
      Get.snackbar('Akses dibatasi', 'Peran Anda tidak diizinkan');
      return const RouteSettings(name: Routes.closing);
    }
    return null;
  }
}
