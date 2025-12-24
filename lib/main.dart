import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'core/config/app_binding.dart';
import 'core/config/app_config.dart';
import 'core/database/local_database.dart';
import 'core/values/app_strings.dart';
import 'core/values/app_themes.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _bootstrap();
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

Future<void> _bootstrap() async {
  final backend = _backendFromEnvironment();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Analytics: collect only on release to avoid noisy dev data.
  try {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(kReleaseMode);
  } catch (_) {}

  // Crashlytics: only on release.
  try {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  } catch (_) {}
  if (kReleaseMode) {
    FlutterError.onError = (details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  final mediaQuery = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
  final shortestSide = mediaQuery.shortestSide;
  if (shortestSide >= 1300) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
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
}
