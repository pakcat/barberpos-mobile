import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/region_service.dart';
import '../../../../routes/app_routes.dart';

class CompleteProfileController extends GetxController {
  CompleteProfileController()
      : auth = Get.find<AuthService>(),
        regionService = Get.find<RegionService>();

  final AuthService auth;
  final RegionService regionService;

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final RxString selectedRegion = ''.obs;
  final loading = false.obs;

  List<String> get regionOptions => List<String>.from(regionService.regions);

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    final user = auth.currentUser;
    if (regionService.regions.isEmpty) {
      await regionService.load();
    }
    phoneController.text = user?.phone ?? '';
    addressController.text = user?.address ?? '';
    selectedRegion.value = (user?.region.isNotEmpty ?? false)
        ? user!.region
        : (regionOptions.isNotEmpty ? regionOptions.first : '');
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    loading.value = true;
    await auth.updateProfile(
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      region: selectedRegion.value,
    );
    loading.value = false;
    Get.offAllNamed(Routes.home);
  }
}
