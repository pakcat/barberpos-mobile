import 'package:barberpos_mobile/modules/cashier/presentation/controllers/cashier_controller.dart';
import 'package:barberpos_mobile/modules/cashier/presentation/models/cashier_item.dart';
import 'package:barberpos_mobile/modules/cashier/presentation/models/checkout_models.dart';
import 'package:barberpos_mobile/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'fakes/fake_activity_log_service.dart';
import 'fakes/fake_network_service.dart';
import 'stubs/stub_cashier_remote.dart';
import 'stubs/stub_payment_remote.dart';
import 'stubs/stub_transaction_repo.dart';
import 'stubs/stub_cashier_repo.dart';
import 'stubs/stub_auth_service.dart';
import 'stubs/stub_attendance_repo.dart';

void main() {
  late CashierController controller;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    Get.put(const AppConfig(backend: BackendMode.local, baseUrl: 'http://localhost'));
    controller = CashierController(
      repo: StubCashierRepository(),
      transactionRepository: StubTransactionRepository(),
      logs: FakeActivityLogService(),
      auth: StubAuthService(),
      network: FakeNetworkService(),
      remote: StubCashierRemote(),
      attendanceRepository: StubAttendanceRepository(),
      paymentRemoteDataSource: StubPaymentRemote(),
    );
    controller.services.assignAll(
      const [
        ServiceItem(id: '1', name: 'Haircut', category: 'Service', price: 'Rp10000', image: ''),
      ],
    );
    controller.selectedStylist.value = 'Awan';
  });

  test('total and change calculation', () {
    controller.addToCart(controller.services.first);
    controller.addToCart(controller.services.first);
    expect(controller.total > 0, isTrue);
    controller.setPaymentInput(controller.total.toString());
    expect(controller.change, equals(0));
  });

  test('checkout fails when no stylist selected', () async {
    controller.selectedStylist.value = '';
    await controller.checkout();
    expect(controller.processingPayment.value, isFalse);
  });

  test('checkout with QRIS confirms dialog flow', () async {
    controller.paymentMethod.value = PaymentMethod.qris;
    controller.addToCart(controller.services.first);
    controller.setPaymentInput('999999');
    // Since _confirmQris shows dialog, we only assert no crash and processing resets
    await controller.checkout();
    expect(controller.processingPayment.value, isFalse);
  });
}
