import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../values/app_colors.dart';
import '../values/app_dimens.dart';

class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppDimens.cornerRadius,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey800,
      highlightColor: AppColors.grey700,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.grey800,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(borderRadius) : null,
        ),
      ),
    );
  }
}
