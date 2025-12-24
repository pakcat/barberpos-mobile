import 'package:barberpos_mobile/modules/cashier/presentation/controllers/cashier_controller.dart';
import 'package:barberpos_mobile/modules/cashier/data/datasources/cashier_remote_data_source.dart';
import 'package:barberpos_mobile/modules/cashier/data/models/order_dtos.dart';
import 'package:barberpos_mobile/modules/cashier/presentation/models/cashier_item.dart';
import 'package:barberpos_mobile/modules/cashier/presentation/models/checkout_models.dart';
import 'package:barberpos_mobile/core/config/app_config.dart';
import 'package:barberpos_mobile/core/database/local_database.dart';
import 'package:barberpos_mobile/modules/cashier/data/repositories/order_outbox_repository.dart';
import 'package:barberpos_mobile/modules/membership/data/entities/membership_state_entity.dart';
import 'package:barberpos_mobile/modules/membership/data/entities/membership_topup_entity.dart';
import 'package:barberpos_mobile/modules/membership/data/datasources/membership_remote_data_source.dart';
import 'package:barberpos_mobile/modules/membership/data/repositories/membership_repository.dart';
import 'package:barberpos_mobile/modules/product/data/entities/product_entity.dart';
import 'package:barberpos_mobile/modules/product/data/datasources/product_remote_data_source.dart';
import 'package:barberpos_mobile/modules/product/data/repositories/product_repository.dart';
import 'package:barberpos_mobile/modules/transactions/data/entities/transaction_entity.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import 'fakes/fake_activity_log_service.dart';
import 'fakes/fake_network_service.dart';
import 'stubs/stub_cashier_remote.dart';
import 'stubs/stub_payment_remote.dart';
import 'stubs/stub_transaction_repo.dart';
import 'stubs/stub_cashier_repo.dart';
import 'stubs/stub_auth_service.dart';
import 'stubs/stub_attendance_repo.dart';

class _OfflineCashierRemote extends CashierRemoteDataSource {
  _OfflineCashierRemote() : super(dio.Dio());

  @override
  Future<OrderResponseDto> submitOrder(OrderPayloadDto payload) async {
    throw dio.DioException(
      requestOptions: dio.RequestOptions(path: '/orders'),
      type: dio.DioExceptionType.connectionTimeout,
    );
  }
}

class _ServerErrorCashierRemote extends CashierRemoteDataSource {
  _ServerErrorCashierRemote() : super(dio.Dio());

  @override
  Future<OrderResponseDto> submitOrder(OrderPayloadDto payload) async {
    final req = dio.RequestOptions(path: '/orders');
    throw dio.DioException(
      requestOptions: req,
      type: dio.DioExceptionType.badResponse,
      response: dio.Response<dynamic>(
        requestOptions: req,
        statusCode: 500,
        data: {'status': 'error', 'message': 'internal error'},
      ),
    );
  }
}

class _CountingMembershipRepository implements MembershipRepository {
  int setUsedQuotaCalls = 0;

  @override
  MembershipRemoteDataSource? get remote => null;

  @override
  Future<void> setUsedQuota(int value) async {
    setUsedQuotaCalls += 1;
  }

  @override
  Future<int> getUsedQuota() async => 0;

  @override
  Future<List<MembershipTopupEntity>> getAll() async => <MembershipTopupEntity>[];

  @override
  Future<Id> addTopup(MembershipTopupEntity topup) async => 0;

  @override
  Future<MembershipStateEntity?> fetchState() async => null;

  @override
  Future<void> setState(MembershipStateEntity state) async {}

  @override
  Future<void> replaceTopups(Iterable<MembershipTopupEntity> items) async {}
}

class _CountingProductRepository implements ProductRepository {
  int getAllCalls = 0;
  int upsertCalls = 0;

  @override
  ProductRemoteDataSource? get restRemote => null;

  @override
  Future<List<ProductEntity>> getAll() async {
    getAllCalls += 1;
    return [
      ProductEntity()
        ..id = 1
        ..name = 'Haircut'
        ..category = 'Service'
        ..price = 10000
        ..image = ''
        ..trackStock = true
        ..stock = 10
        ..minStock = 0,
    ];
  }

  @override
  Future<ProductEntity?> getById(Id id) async => null;

  @override
  Future<Id> upsertLocal(ProductEntity product) async {
    upsertCalls += 1;
    return product.id;
  }

  @override
  Future<Id> upsert(ProductEntity product) async {
    upsertCalls += 1;
    return product.id;
  }

  @override
  Future<void> replaceAllFromRemote(Iterable<ProductEntity> remoteItems) async {}

  @override
  Future<void> replaceAll(Iterable<ProductEntity> items) async {}

  @override
  Future<void> delete(Id id) async {}

  @override
  Future<void> markSyncedFromServer({required int localId, required ProductEntity server}) async {}

  @override
  Future<void> markPending(int id) async {}

  @override
  Future<void> markFailed(int id, String message) async {}

  @override
  Future<void> markDeletedPending(int id) async {}
}

class _FakeOrderOutboxRepository extends OrderOutboxRepository {
  _FakeOrderOutboxRepository() : super(Future<LocalDatabase>.value(LocalDatabase()));

  final List<Map<String, dynamic>> enqueued = <Map<String, dynamic>>[];
  int _id = 0;

  @override
  Future<int> enqueue({
    required String clientRef,
    required String pendingCode,
    required Map<String, dynamic> payload,
  }) async {
    enqueued.add({
      'clientRef': clientRef,
      'pendingCode': pendingCode,
      'payload': payload,
    });
    _id += 1;
    return _id;
  }
}

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

  test('offline cash checkout queues without local stock/quota decrement', () async {
    final txRepo = StubTransactionRepository();
    final outbox = _FakeOrderOutboxRepository();
    final membershipRepo = _CountingMembershipRepository();
    final productRepo = _CountingProductRepository();

    final c = CashierController(
      repo: StubCashierRepository(),
      transactionRepository: txRepo,
      logs: FakeActivityLogService(),
      auth: StubAuthService(),
      network: FakeNetworkService(),
      remote: _OfflineCashierRemote(),
      attendanceRepository: StubAttendanceRepository(),
      paymentRemoteDataSource: StubPaymentRemote(),
      config: const AppConfig(backend: BackendMode.rest, baseUrl: 'http://localhost'),
      orderOutbox: outbox,
      membershipRepository: membershipRepo,
      productRepository: productRepo,
    );

    c.services.assignAll(
      const [
        ServiceItem(id: '1', name: 'Haircut', category: 'Service', price: 'Rp10000', image: ''),
      ],
    );
    c.selectedStylist.value = 'Awan';
    c.addToCart(c.services.first);
    c.setPaymentInput('999999');

    await c.checkout();

    expect(outbox.enqueued.length, 1);
    expect(membershipRepo.setUsedQuotaCalls, 0);
    expect(productRepo.getAllCalls, 0);
    expect(productRepo.upsertCalls, 0);

    final txs = await txRepo.getAll();
    expect(
      txs.any((t) => t.code.startsWith('PENDING-') && t.status == TransactionStatusEntity.pending),
      isTrue,
    );
  });

  test('server error checkout does not queue or decrement', () async {
    final txRepo = StubTransactionRepository();
    final outbox = _FakeOrderOutboxRepository();
    final membershipRepo = _CountingMembershipRepository();
    final productRepo = _CountingProductRepository();

    final c = CashierController(
      repo: StubCashierRepository(),
      transactionRepository: txRepo,
      logs: FakeActivityLogService(),
      auth: StubAuthService(),
      network: FakeNetworkService(),
      remote: _ServerErrorCashierRemote(),
      attendanceRepository: StubAttendanceRepository(),
      paymentRemoteDataSource: StubPaymentRemote(),
      config: const AppConfig(backend: BackendMode.rest, baseUrl: 'http://localhost'),
      orderOutbox: outbox,
      membershipRepository: membershipRepo,
      productRepository: productRepo,
    );

    c.services.assignAll(
      const [
        ServiceItem(id: '1', name: 'Haircut', category: 'Service', price: 'Rp10000', image: ''),
      ],
    );
    c.selectedStylist.value = 'Awan';
    c.addToCart(c.services.first);
    c.setPaymentInput('999999');

    await c.checkout();

    expect(outbox.enqueued.length, 0);
    expect(membershipRepo.setUsedQuotaCalls, 0);
    expect(productRepo.getAllCalls, 0);
    expect(productRepo.upsertCalls, 0);

    final txs = await txRepo.getAll();
    expect(txs.any((t) => t.code.startsWith('PENDING-')), isFalse);
  });
}
