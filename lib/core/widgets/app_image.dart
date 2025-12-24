import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../values/app_colors.dart';
import '../values/app_dimens.dart';
import '../utils/resolve_image_url.dart';
import 'app_shimmer.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppDimens.cornerRadius,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = resolveImageUrl(imageUrl);
    if (resolvedUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.grey700,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const Icon(
          Icons.image_not_supported_rounded,
          color: Colors.white54,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: resolvedUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => AppShimmer(
          width: width,
          height: height,
          borderRadius: 0, // Handled by ClipRRect
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: AppColors.grey700,
          child: const Icon(
            Icons.image_not_supported_rounded,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
