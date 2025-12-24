import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/network_status_service.dart';
import '../values/app_colors.dart';
import '../values/app_dimens.dart';

class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<NetworkStatusService>()) return const SizedBox.shrink();
    final service = Get.find<NetworkStatusService>();

    return Obx(() {
      if (service.online.value) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.spacingLg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.grey800,
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
            border: Border.all(color: AppColors.grey700),
          ),
          child: const Row(
            children: [
              Icon(Icons.wifi_off_rounded, color: AppColors.orange500),
              SizedBox(width: AppDimens.spacingSm),
              Expanded(
                child: Text(
                  'Offline mode: beberapa aksi akan masuk queue sinkronisasi.',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

