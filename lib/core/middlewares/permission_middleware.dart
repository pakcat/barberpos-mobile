import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../../routes/app_routes.dart';

class PermissionMiddleware extends GetMiddleware {
  PermissionMiddleware({required this.permission});

  final String permission;

  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthService>();
    if (!auth.isLoggedIn) return null;
    if (!auth.isStaffOnly) return null;
    if (auth.staffCan(permission)) return null;
    Get.snackbar(
      'Akses dibatasi',
      'Akun ini tidak memiliki akses ke menu tersebut.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return const RouteSettings(name: Routes.attendance);
  }
}

