import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../values/app_dimens.dart';
import '../values/app_colors.dart';
import '../../routes/app_routes.dart';
import 'network_status_banner.dart';
import 'sync_status_banner.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.onNavigateBack,
    this.leading,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.centerTitle = true,
    this.showUserMenu = true,
    this.showStatusBanners = true,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Future<bool> Function()? onNavigateBack;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final Color? appBarForegroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool centerTitle;
  final bool showUserMenu;
  final bool showStatusBanners;

  @override
  Widget build(BuildContext context) {
    final auth = Get.isRegistered<AuthService>() ? Get.find<AuthService>() : null;
    final mergedActions = <Widget>[
      if (actions != null) ...actions!,
      if (showUserMenu && auth != null) _UserMenu(auth: auth),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppDimens.tabletBreakpoint;

        if (isTablet && drawer != null) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Row(
              children: [
                // Permanent Drawer
                SizedBox(width: 240, child: drawer),
                const VerticalDivider(width: 1, color: Colors.white10),
                // Main Content
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      title: Text(title),
                      automaticallyImplyLeading: false, // Hide hamburger
                      actions: mergedActions,
                      backgroundColor: appBarBackgroundColor ?? Colors.transparent,
                      foregroundColor: appBarForegroundColor,
                      surfaceTintColor: Colors.transparent,
                      centerTitle: centerTitle,
                      elevation: 0,
                    ),
                    body: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const _BackgroundAccent(),
                        Padding(
                          padding: const EdgeInsets.all(AppDimens.padding),
                          child: Column(
                            children: [
                              if (showStatusBanners) ...[
                                const NetworkStatusBanner(),
                                const SyncStatusBanner(),
                              ],
                              Expanded(child: body),
                            ],
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: bottomNavigationBar,
                    floatingActionButton: floatingActionButton,
                    floatingActionButtonLocation: floatingActionButtonLocation,
                  ),
                ),
              ],
            ),
          );
        }

        // Mobile Layout
        return Scaffold(
          drawer: drawer,
          drawerEnableOpenDragGesture: drawer != null,
          endDrawer: endDrawer,
          endDrawerEnableOpenDragGesture: endDrawer != null,
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(title),
            leading:
                leading ??
                (onNavigateBack != null
                    ? BackButton(
                        onPressed: () async {
                          final allow = await onNavigateBack!();
                          if (allow) Get.back();
                        },
                      )
                    : null),
            actions: mergedActions,
            backgroundColor: appBarBackgroundColor ?? Colors.transparent,
            foregroundColor: appBarForegroundColor,
            surfaceTintColor: Colors.transparent,
            centerTitle: centerTitle,
            elevation: 0,
          ),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              const _BackgroundAccent(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.padding),
                  child: Column(
                    children: [
                      if (showStatusBanners) ...[
                        const NetworkStatusBanner(),
                        const SyncStatusBanner(),
                      ],
                      Expanded(child: body),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );
      },
    );
  }
}

class _UserMenu extends StatelessWidget {
  const _UserMenu({required this.auth});

  final AuthService auth;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.account_circle_rounded),
      color: AppColors.grey800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
      onSelected: (value) {
        if (value == 'logout') _confirmLogout();
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'profile',
          child: Text(
            auth.currentUser?.name ?? 'Pengguna',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.grey800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
        title: const Text('Konfirmasi', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Logout sekarang? Pastikan perubahan sudah disimpan.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              await auth.logout();
              Get.offAllNamed(Routes.login);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _BackgroundAccent extends StatelessWidget {
  const _BackgroundAccent();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -120,
      left: -50,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(
          width: 116,
          height: 116,
          decoration: const BoxDecoration(color: Color(0x66D4A152), shape: BoxShape.circle),
        ),
      ),
    );
  }
}
