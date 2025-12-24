import '../config/app_config.dart';
import 'package:get/get.dart';

String resolveImageUrl(String raw, {String? baseUrl}) {
  final url = raw.trim();
  final normalized = url.toLowerCase();
  if (normalized.isEmpty || normalized == 'null' || normalized == 'undefined') {
    return '';
  }
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  if (!url.startsWith('/')) return url;

  final resolvedBaseUrl = (baseUrl != null && baseUrl.isNotEmpty)
      ? baseUrl
      : (Get.isRegistered<AppConfig>() ? Get.find<AppConfig>().baseUrl : '');
  if (resolvedBaseUrl.isEmpty) return url;
  return '${resolvedBaseUrl.replaceAll(RegExp(r'/$'), '')}$url';
}
