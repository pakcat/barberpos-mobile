import 'package:flutter/material.dart';

import '../values/app_dimens.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimens.spacingMd),
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: borderColor ?? Colors.transparent),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          onTap: onTap,
          child: card,
        ),
      );
    }
    return card;
  }
}
