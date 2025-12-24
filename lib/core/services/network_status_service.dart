import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkStatusService extends GetxService {
  NetworkStatusService({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _sub;

  final RxBool online = true.obs;
  final RxString connectionLabel = 'unknown'.obs;

  @override
  void onInit() {
    super.onInit();
    _sub = _connectivity.onConnectivityChanged.listen((results) => _apply(results));
    unawaited(refresh());
  }

  Future<void> refresh() async {
    final results = await _connectivity.checkConnectivity();
    _apply(results);
  }

  void _apply(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      online.value = false;
      connectionLabel.value = 'offline';
      return;
    }

    final hasNetwork = results.any((r) => r != ConnectivityResult.none);
    online.value = hasNetwork;

    final label = results.contains(ConnectivityResult.wifi)
        ? 'wifi'
        : (results.contains(ConnectivityResult.mobile) ? 'mobile' : results.first.name);
    connectionLabel.value = hasNetwork ? label : 'offline';
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}

