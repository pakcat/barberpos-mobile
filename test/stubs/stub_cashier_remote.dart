import 'package:barberpos_mobile/modules/cashier/data/datasources/cashier_remote_data_source.dart';
import 'package:barberpos_mobile/modules/cashier/data/models/order_dtos.dart';
import 'package:dio/dio.dart';

class StubCashierRemote extends CashierRemoteDataSource {
  StubCashierRemote() : super(Dio());

  @override
  Future<OrderResponseDto> submitOrder(OrderPayloadDto payload) async {
    return OrderResponseDto.fallback(
      payload: payload,
      generatedId: 'ORD-TEST',
    );
  }
}
