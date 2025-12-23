enum BackendMode { firebase, rest, local }

class AppConfig {
  final BackendMode backend;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  /// Firebase options are provided externally (dart-define/env) to avoid
  /// committing secrets. Keep Isar enabled regardless of backend for offline.
  final Map<String, dynamic>? firebaseOptions;

  const AppConfig({
    required this.backend,
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 20),
    this.sendTimeout = const Duration(seconds: 15),
    this.firebaseOptions,
  });

  static const AppConfig dev = AppConfig(
    backend: BackendMode.rest,
    // Default to deployed API; override via dart-define API_BASE_URL for local dev.
    baseUrl: 'https://api.barberpos.cloud',
  );
}
