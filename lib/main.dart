import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'core/config/app_binding.dart';
import 'core/config/app_config.dart';
import 'core/database/local_database.dart';
import 'core/values/app_strings.dart';
import 'core/values/app_themes.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final backend = _backendFromEnvironment();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final mediaQuery = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
  final shortestSide = mediaQuery.shortestSide;
  if (shortestSide >= 1300) {
    // Tablet: force landscape
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    // Mobile: force portrait
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  final db = await LocalDatabase().init();
  final apiBase = const String.fromEnvironment('API_BASE_URL').isNotEmpty
      ? const String.fromEnvironment('API_BASE_URL')
      : AppConfig.dev.baseUrl;
  final config = AppConfig(
    backend: backend,
    baseUrl: apiBase,
    connectTimeout: AppConfig.dev.connectTimeout,
    receiveTimeout: AppConfig.dev.receiveTimeout,
    sendTimeout: AppConfig.dev.sendTimeout,
  );
  Get.put<AppConfig>(config, permanent: true);
  Get.put<LocalDatabase>(db, permanent: true);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      initialBinding: GlobalBindings(),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
    );
  }
}

BackendMode _backendFromEnvironment() {
  const raw = String.fromEnvironment('BACKEND_MODE', defaultValue: 'rest');
  return raw.toLowerCase() == 'local' ? BackendMode.local : BackendMode.rest;
}
