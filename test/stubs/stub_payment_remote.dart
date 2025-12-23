import 'package:barberpos_mobile/modules/cashier/data/datasources/payment_remote_data_source.dart';
import 'package:barberpos_mobile/modules/cashier/data/models/payment_intent_dtos.dart';
import '../fakes/fake_network_service.dart';

class StubPaymentRemote extends PaymentRemoteDataSource {
  StubPaymentRemote() : super(FakeNetworkService());

  @override
  Future<PaymentIntentDto> createCard({required int amount}) async {
    return PaymentIntentDto(
      id: 'card',
      method: 'card',
      status: 'pending',
      reference: 'REF',
      intentId: 'card-intent',
    );
  }

  @override
  Future<PaymentIntentDto> createQris({required int amount}) async {
    return PaymentIntentDto(
      id: 'qris',
      method: 'qris',
      status: 'pending',
      qrString: 'DUMMYQR',
      intentId: 'qris-intent',
    );
  }
}
