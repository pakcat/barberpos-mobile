import '../../../../core/network/network_service.dart';
import '../models/payment_intent_dtos.dart';

class PaymentRemoteDataSource {
  PaymentRemoteDataSource(this._network);

  final NetworkService _network;

  Future<PaymentIntentDto> createQris({required int amount}) async {
    try {
      final res = await _network.dio.post<Map<String, dynamic>>(
        '/payments/qris',
        data: {'amount': amount},
        queryParameters: {'amount': amount},
      );
      return PaymentIntentDto.fromJson(res.data ?? <String, dynamic>{});
    } catch (_) {
      // Dummy QR if backend not ready
      return PaymentIntentDto(
        id: 'qris-${DateTime.now().millisecondsSinceEpoch}',
        method: 'qris',
        qrString: '00020101021226380011ID.CO.QRIS.WWW01189360091100200010000031303UKE51440014ID.CO.QRIS.WWW0215DUMMYQRISEXAMPLE53033605406${amount}5802ID5908BARBER6010JAKARTA6304ABCD',
        status: 'pending',
        expiresAt: DateTime.now().add(const Duration(minutes: 10)),
        intentId: 'qris-intent-${DateTime.now().millisecondsSinceEpoch}',
      );
    }
  }

  Future<PaymentIntentDto> createCard({required int amount}) async {
    try {
      final res = await _network.dio.post<Map<String, dynamic>>(
        '/payments/card',
        data: {'amount': amount},
        queryParameters: {'amount': amount},
      );
      return PaymentIntentDto.fromJson(res.data ?? <String, dynamic>{});
    } catch (_) {
      return PaymentIntentDto(
        id: 'card-${DateTime.now().millisecondsSinceEpoch}',
        method: 'card',
        reference: 'REF${DateTime.now().millisecondsSinceEpoch}',
        status: 'pending',
        intentId: 'card-intent-${DateTime.now().millisecondsSinceEpoch}',
      );
    }
  }
}
