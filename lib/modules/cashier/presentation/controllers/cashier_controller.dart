import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/printing/thermal_printer_service.dart';
import '../../../../core/services/activity_log_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../management/data/repositories/management_repository.dart';
import '../../../membership/data/repositories/membership_repository.dart';
import '../../../membership/presentation/controllers/membership_controller.dart';
import '../../../product/data/entities/product_entity.dart';
import '../../../product/data/repositories/product_repository.dart';
import '../../../product/presentation/controllers/product_controller.dart';
import '../../../reports/data/entities/finance_entry_entity.dart';
import '../../../reports/data/repositories/reports_repository.dart';
import '../../../reports/presentation/controllers/reports_controller.dart';
import '../../../staff/data/entities/attendance_entity.dart';
import '../../../staff/data/entities/employee_entity.dart';
import '../../../staff/data/repositories/attendance_repository.dart';
import '../../../staff/data/repositories/staff_repository.dart';
import '../../../stock/presentation/controllers/stock_controller.dart';
import '../../../transactions/data/entities/transaction_entity.dart';
import '../../../transactions/data/repositories/transaction_repository.dart';
import '../../../transactions/presentation/controllers/transaction_controller.dart';
import '../../../transactions/presentation/models/transaction_models.dart';
import '../../data/datasources/cashier_remote_data_source.dart';
import '../../data/datasources/payment_remote_data_source.dart';
import '../../../membership/data/datasources/membership_remote_data_source.dart';
import '../../data/entities/cart_item_entity.dart';
import '../../data/repositories/order_outbox_repository.dart';
import '../../data/models/order_dtos.dart';
import '../../data/models/payment_intent_dtos.dart';
import '../../data/repositories/cashier_repository.dart';
import '../models/cashier_item.dart';
import '../models/checkout_models.dart';

class CashierController extends GetxController {
  CashierController({
    CashierRepository? repo,
    TransactionRepository? transactionRepository,
    ActivityLogService? logs,
    AuthService? auth,
    NetworkService? network,
    CashierRemoteDataSource? remote,
    AttendanceRepository? attendanceRepository,
    PaymentRemoteDataSource? paymentRemoteDataSource,
    ProductRepository? productRepository,
    MembershipRepository? membershipRepository,
    ReportsRepository? reportsRepository,
    StaffRepository? staffRepository,
    ManagementRepository? customerRepository,
    AppConfig? config,
    OrderOutboxRepository? orderOutbox,
  }) : repo = repo ?? Get.find<CashierRepository>(),
       _transactionRepo =
           transactionRepository ?? Get.find<TransactionRepository>(),
       _logs = logs ?? Get.find<ActivityLogService>(),
       _auth = auth ?? Get.find<AuthService>(),
       _remote =
           remote ??
           CashierRemoteDataSource((network ?? Get.find<NetworkService>()).dio),
       _attendanceRepo =
           attendanceRepository ?? Get.find<AttendanceRepository>(),
       _paymentRemote =
           paymentRemoteDataSource ??
           PaymentRemoteDataSource(network ?? Get.find<NetworkService>()),
       _config = config ?? Get.find<AppConfig>(),
       _orderOutbox =
           orderOutbox ??
           (Get.isRegistered<OrderOutboxRepository>()
               ? Get.find<OrderOutboxRepository>()
               : null),
       _productRepo =
           productRepository ??
           (Get.isRegistered<ProductRepository>()
               ? Get.find<ProductRepository>()
               : null),
       _membershipRepo =
           membershipRepository ??
           (Get.isRegistered<MembershipRepository>()
               ? Get.find<MembershipRepository>()
               : null),
       _reportsRepo =
           reportsRepository ??
           (Get.isRegistered<ReportsRepository>()
               ? Get.find<ReportsRepository>()
               : null),
       _staffRepo =
           staffRepository ??
           (Get.isRegistered<StaffRepository>()
               ? Get.find<StaffRepository>()
               : null),
       _customerRepo =
           customerRepository ??
           (Get.isRegistered<ManagementRepository>()
               ? Get.find<ManagementRepository>()
               : null);

  final CashierRepository repo;
  final TransactionRepository _transactionRepo;
  final ActivityLogService _logs;
  final AuthService _auth;
  final CashierRemoteDataSource _remote;
  final AttendanceRepository _attendanceRepo;
  final PaymentRemoteDataSource _paymentRemote;
  final AppConfig _config;
  final OrderOutboxRepository? _orderOutbox;
  final ProductRepository? _productRepo;
  final MembershipRepository? _membershipRepo;
  final ReportsRepository? _reportsRepo;
  final StaffRepository? _staffRepo;
  final ManagementRepository? _customerRepo;

  final RxString selectedCategory = 'Semua'.obs;
  final Rx<CashierViewMode> viewMode = CashierViewMode.grid.obs;
  final Rx<PaymentMethod> paymentMethod = PaymentMethod.cash.obs;
  final RxString receivedAmount = '0'.obs;
  final RxString selectedStylist = ''.obs;
  final RxnInt selectedStylistId = RxnInt();
  final RxString searchQuery = ''.obs;

  final RxList<ServiceItem> services = <ServiceItem>[].obs;

  final RxList<CartItem> cart = <CartItem>[].obs;
  final RxBool processingPayment = false.obs;
  final Rx<DateTime?> lastCheckIn = Rx<DateTime?>(null);

  final RxList<Stylist> stylists = <Stylist>[].obs;

  final RxString selectedCustomer = 'Guest'.obs;
  final List<String> customers = ['Guest'];

  final RxString filterQuery = ''.obs;

  bool get _useRest => _config.backend == BackendMode.rest;

  @override
  void onInit() {
    super.onInit();
    refreshAll();

    debounce(searchQuery, (query) {
      filterQuery.value = query;
    }, time: const Duration(milliseconds: 500));
  }

  Future<void> refreshAll() async {
    await Future.wait([
      _loadServices(),
      _loadStylists(),
      _loadCustomers(),
      _loadCart(),
    ]);
  }

  List<String> get categories => [
    'Semua',
    ...{for (final service in services) service.category},
  ];

  void toggleViewMode(CashierViewMode mode) {
    viewMode.value = mode;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  int get total => cart.fold(0, (acc, item) => acc + item.subtotal);

  void addToCart(ServiceItem item) {
    final existingIndex = cart.indexWhere(
      (cartItem) => cartItem.name == item.name,
    );
    if (existingIndex != -1) {
      final existing = cart[existingIndex];
      existing.qty += 1;
      cart[existingIndex] = existing;
    } else {
      cart.add(
        CartItem(
          name: item.name,
          category: item.category,
          price: _parsePrice(item.price),
        ),
      );
    }
    _persistCart();
  }

  void removeCartItem(CartItem item) {
    cart.remove(item);
    _persistCart();
  }

  void incrementCartItem(CartItem item) {
    final index = cart.indexOf(item);
    if (index == -1) return;
    cart[index].qty += 1;
    cart[index] = cart[index];
    _persistCart();
  }

  void decrementCartItem(CartItem item) {
    final index = cart.indexOf(item);
    if (index == -1) return;
    final current = cart[index];
    if (current.qty > 1) {
      current.qty -= 1;
      cart[index] = current;
    } else {
      cart.removeAt(index);
    }
    _persistCart();
  }

  void setPaymentMethod(PaymentMethod method) {
    paymentMethod.value = method;
  }

  void setStylist(String name) {
    selectedStylist.value = name;
    int? id;
    for (final s in stylists) {
      if (s.name == name) {
        id = s.id;
        break;
      }
    }
    selectedStylistId.value = id;
  }

  Future<void> checkInSelectedStylist() async {
    final name = selectedStylist.value.isNotEmpty
        ? selectedStylist.value
        : (stylists.isNotEmpty ? stylists.first.name : '');
    if (name.isEmpty) {
      _showSnack('Stylist', 'Pilih stylist terlebih dahulu');
      return;
    }
    final now = DateTime.now();
    final existing = await _attendanceRepo.getTodayFor(name);
    if (existing != null && existing.checkIn != null) {
      _showSnack('Stylist', '$name sudah check-in pada ${existing.checkIn}');
      lastCheckIn.value = existing.checkIn;
      return;
    }
    final entity = AttendanceEntity()
      ..employeeName = name
      ..date = DateTime(now.year, now.month, now.day)
      ..checkIn = now
      ..status = AttendanceStatus.present
      ..source = 'cashier';
    final id = await _attendanceRepo.upsert(entity);
    entity.id = id;
    lastCheckIn.value = now;
    _logs.add(
      title: 'Check-in stylist',
      message: '$name check-in via kasir',
      actor: _auth.currentUser?.name ?? 'Kasir',
    );
    _showSnack('Check-in', '$name berhasil check-in');
  }

  void setCustomer(String name) {
    selectedCustomer.value = name;
  }

  void clearPaymentInput() {
    receivedAmount.value = '0';
  }

  void setPaymentInput(String value) {
    receivedAmount.value = value.isEmpty ? '0' : value;
  }

  void appendPaymentInput(String value) {
    final current = receivedAmount.value == '0' ? '' : receivedAmount.value;
    receivedAmount.value = '$current$value';
  }

  void removeLastPaymentDigit() {
    final current = receivedAmount.value;
    if (current.isEmpty || current == '0') return;
    if (current.length == 1) {
      receivedAmount.value = '0';
      return;
    }
    receivedAmount.value = current.substring(0, current.length - 1);
  }

  int get paid =>
      int.tryParse(receivedAmount.value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  int get change => paid - total;

  String formatCurrency(int value) {
    final digits = value.abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }
    final formatted = buffer.toString();
    return value < 0 ? '-Rp$formatted' : 'Rp$formatted';
  }

  void resetForNewOrder() {
    cart.clear();
    _persistCart();
    receivedAmount.value = '0';
    paymentMethod.value = PaymentMethod.cash;
    selectedCategory.value = 'Semua';
    searchQuery.value = '';
    viewMode.value = CashierViewMode.grid;
    if (stylists.isNotEmpty) {
      selectedStylist.value = stylists.first.name;
    }
    lastCheckIn.value = null;
  }

  int _parsePrice(String value) {
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  Future<void> checkout() async {
    if (processingPayment.value) return;
    if (cart.isEmpty) {
      _showSnack(
        'Keranjang kosong',
        'Tambahkan layanan/produk sebelum membayar.',
      );
      return;
    }
    if (selectedStylist.value.isEmpty) {
      _showSnack('Stylist', 'Pilih stylist untuk transaksi ini.');
      return;
    }
    if (paid < total) {
      _showSnack(
        'Nominal kurang',
        'Nominal diterima belum cukup untuk membayar.',
      );
      return;
    }
    if (!_useRest && paymentMethod.value != PaymentMethod.cash) {
      _showSnack(
        'Mode offline',
        'Metode non-tunai tidak tersedia saat offline.',
      );
      return;
    }

    processingPayment.value = true;
    try {
      PaymentIntentDto? intent;
      if (_useRest) {
        if (paymentMethod.value == PaymentMethod.qris) {
          intent = await _paymentRemote.createQris(amount: total);
          final ok = await _confirmQris(intent);
          if (!ok) {
            processingPayment.value = false;
            return;
          }
        } else if (paymentMethod.value == PaymentMethod.card) {
          intent = await _paymentRemote.createCard(amount: total);
          final ok = await _confirmCard(intent);
          if (!ok) {
            processingPayment.value = false;
            return;
          }
        }
      }

      final payload = _buildPayload();
      OrderResponseDto response;
      var queuedForSync = false;
      if (_useRest) {
        try {
          response = await _remote.submitOrder(payload);
        } on DioException catch (e) {
          // Only queue for later sync when it's a connectivity/timeout problem (no server response).
          if (e.response != null) rethrow;
          final outbox = _orderOutbox;
          if (paymentMethod.value != PaymentMethod.cash || outbox == null) {
            rethrow;
          }
          final pendingCode = 'PENDING-${payload.clientRef}';
          await outbox.enqueue(
            clientRef: payload.clientRef,
            pendingCode: pendingCode,
            payload: payload.toJson(),
          );
          response = OrderResponseDto.fallback(
            payload: payload,
            generatedId: pendingCode,
          );
          queuedForSync = true;
          _showSnack(
            'Offline',
            'Order disimpan dan akan disinkronkan otomatis.',
          );
        }
      } else {
        response = OrderResponseDto.fallback(
          payload: payload,
          generatedId: _localOrderCode(),
        );
      }
      await _persistTransaction(
        response,
        payload,
        intent: intent,
        status: queuedForSync ? TransactionStatusEntity.pending : TransactionStatusEntity.paid,
      );
      // Only apply side effects (stock, membership, finance) when the transaction is confirmed (not queued/pending).
      if (!queuedForSync) {
        await _consumeMembershipQuota(payload);
        await _deductStockFromCart();
        await _recordFinanceEntries(
          payload,
          transactionCode: response.code.isNotEmpty ? response.code : response.id,
        );
        await _autoPrintReceipt(response: response, payload: payload);
      }
      _logs.add(
        title: 'Checkout',
        message:
            'Order ${response.code.isNotEmpty ? response.code : response.id} dibayar ${_labelPayment(paymentMethod.value)}',
        actor: _auth.currentUser?.name ?? 'Kasir',
      );
      if (Get.isRegistered<TransactionController>()) {
        await Get.find<TransactionController>().refreshRemote();
      }
      Get.offNamed(Routes.paymentSuccess);
    } catch (e) {
      _showSnack('Pembayaran gagal', 'Tidak dapat mengirim pesanan: $e');
    } finally {
      processingPayment.value = false;
    }
  }

  Future<void> _deductStockFromCart() async {
    try {
      final productRepo = _productRepo;
      if (productRepo == null) return;
      final products = await productRepo.getAll();
      for (final item in cart) {
        final product = products.firstWhereOrNull(
          (p) => p.name.toLowerCase() == item.name.toLowerCase(),
        );
        if (product == null || !product.trackStock) continue;
        final newStock = (product.stock - item.qty).clamp(0, 1 << 31);
        product.stock = newStock;
        await productRepo.upsert(product);
      }
      if (Get.isRegistered<ProductController>()) {
        await Get.find<ProductController>().refreshRemote();
      }
      if (Get.isRegistered<StockController>()) {
        await Get.find<StockController>().refreshRemote();
      }
    } catch (_) {}
  }

  Future<void> _recordFinanceEntries(
    OrderPayloadDto payload, {
    required String transactionCode,
  }) async {
    try {
      final reportsRepo = _reportsRepo;
      if (reportsRepo == null) return;
      final now = DateTime.now();
      for (final line in payload.items) {
        final entry = FinanceEntryEntity()
          ..title = line.name
          ..amount = line.price * line.qty
          ..category = line.category
          ..date = now
          ..type = EntryTypeEntity.revenue
          ..note = 'Penjualan via kasir'
          ..transactionCode = transactionCode
          ..staff = selectedStylist.value.isNotEmpty
              ? selectedStylist.value
              : null
          ..service = line.name;
        await reportsRepo.upsert(entry);
      }
      if (Get.isRegistered<ReportsController>()) {
        await Get.find<ReportsController>().refresh();
      }
      if (Get.isRegistered<DashboardController>()) {
        await Get.find<DashboardController>().load();
      }
    } catch (_) {}
  }

  Future<void> _autoPrintReceipt({
    required OrderResponseDto response,
    required OrderPayloadDto payload,
  }) async {
    try {
      final service = ThermalPrinterService();
      final profile = await service.loadProfile();
      if (!profile.autoPrint) return;
      if (profile.printerType.trim().toLowerCase() == 'system') return;
      if (profile.paperSize == 'A4') return;

      final code = response.code.isNotEmpty ? response.code : response.id;
      final tx = TransactionItem(
        id: code,
        date: DateTime.now(),
        time: '',
        amount: payload.total,
        paymentMethod: _labelPayment(paymentMethod.value),
        status: TransactionStatus.paid,
        items: payload.items
            .map(
              (e) => TransactionLine(
                name: e.name,
                category: e.category,
                price: e.price,
                qty: e.qty,
              ),
            )
            .toList(),
        customer: TransactionCustomer(
          name: selectedCustomer.value == 'Guest' ? '' : selectedCustomer.value,
          phone: '',
          email: '',
          address: '',
        ),
      );
      await service.printReceipt(tx, profile: profile);
    } catch (_) {}
  }

  Future<void> _consumeMembershipQuota(OrderPayloadDto payload) async {
    try {
      if (_useRest) {
        final remote = MembershipRemoteDataSource(
          Get.find<NetworkService>().dio,
        );
        final state = await remote.fetchState();
        await _membershipRepo?.setUsedQuota(state.usedQuota);
        if (Get.isRegistered<MembershipController>()) {
          final c = Get.find<MembershipController>();
          c.usedQuota.value = state.usedQuota;
          c.freeQuota.value = state.freeQuota;
          c.freeUsed.value = state.freeUsed;
          c.topupBalance.value = state.topupBalance;
        }
        return;
      }

      final membershipRepo = _membershipRepo;
      if (membershipRepo == null) return;
      final used = await membershipRepo.getUsedQuota();
      final consumed = payload.items.fold<int>(
        0,
        (acc, item) => acc + item.qty,
      );
      final next = used + (consumed == 0 ? 1 : consumed);
      await membershipRepo.setUsedQuota(next);
      if (Get.isRegistered<MembershipController>()) {
        Get.find<MembershipController>().usedQuota.value = next;
      }
    } catch (_) {}
  }

  OrderPayloadDto _buildPayload() {
    final lines = cart
        .map(
          (c) => OrderLineDto(
            productId: _findProductIdForCartItem(c),
            name: c.name,
            category: c.category,
            price: c.price,
            qty: c.qty,
          ),
        )
        .toList();
    final method = _mapPaymentMethod(paymentMethod.value);
    return OrderPayloadDto(
      items: lines,
      clientRef: _clientRef(),
      total: total,
      paid: paid,
      change: change,
      paymentMethod: method,
      stylist: selectedStylist.value.isNotEmpty ? selectedStylist.value : null,
      stylistId: selectedStylistId.value,
      customer: selectedCustomer.value == 'Guest'
          ? null
          : selectedCustomer.value,
      shiftId: _currentShiftId(),
    );
  }

  String _clientRef() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return 'CREF-$now-${now % 100000}';
  }

  int? _findProductIdForCartItem(CartItem item) {
    for (final s in services) {
      if (s.name == item.name && s.category == item.category) {
        return int.tryParse(s.id);
      }
    }
    for (final s in services) {
      if (s.name == item.name) {
        return int.tryParse(s.id);
      }
    }
    return null;
  }

  String _mapPaymentMethod(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.nonCash:
        return 'non-cash';
      case PaymentMethod.qris:
        return 'qris';
      case PaymentMethod.card:
        return 'card';
    }
  }

  String _labelPayment(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'tunai';
      case PaymentMethod.nonCash:
        return 'non tunai';
      case PaymentMethod.qris:
        return 'QRIS';
      case PaymentMethod.card:
        return 'kartu';
    }
  }

  void _showSnack(String title, String message) {
    if (Get.testMode) return;
    if (Get.context == null) return;
    Get.snackbar(title, message);
  }

  Future<bool> _confirmQris(PaymentIntentDto intent) async {
    final qrisFuture = _fetchQrisImageBytes();
    return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Pembayaran QRIS'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tunjukkan QR ini ke customer.'),
                const SizedBox(height: 8),
                FutureBuilder<Uint8List?>(
                  future: qrisFuture,
                  builder: (context, snapshot) {
                    final bytes = snapshot.data;
                    if (bytes != null && bytes.isNotEmpty) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.memory(
                            bytes,
                            width: 240,
                            height: 240,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFDDDDDD)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        intent.qrString ?? 'QR siap',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Kadaluarsa: ${(intent.expiresAt ?? DateTime.now().add(const Duration(minutes: 10)))}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Tandai Lunas'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<Uint8List?> _fetchQrisImageBytes() async {
    try {
      final dio = Get.find<NetworkService>().dio;
      final res = await dio.get<List<int>>(
        '/settings/qris',
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = res.data ?? <int>[];
      if (bytes.isEmpty) return null;
      return Uint8List.fromList(bytes);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> _confirmCard(PaymentIntentDto intent) async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Pembayaran Kartu/EDC'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proses di mesin EDC. Ref: ${intent.reference ?? intent.id}',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tekan "Pembayaran diterima" jika transaksi sukses.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Pembayaran diterima'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _persistTransaction(
    OrderResponseDto response,
    OrderPayloadDto payload, {
    PaymentIntentDto? intent,
    required TransactionStatusEntity status,
  }) async {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final usedLines = response.items.isNotEmpty
        ? response.items
        : payload.items;
    final items = usedLines
        .map(
          (item) => TransactionLineEntity()
            ..name = item.name
            ..category = item.category
            ..price = item.price
            ..qty = item.qty,
        )
        .toList();
    final tx = TransactionEntity()
      ..code = response.code.isNotEmpty ? response.code : response.id
      ..date = now
      ..time = timeStr
      ..amount = response.total
      ..paymentMethod = response.paymentMethod
      ..shiftId = _currentShiftId()
      ..operatorName = _auth.currentUser?.name ?? 'Kasir'
      ..paymentIntentId = intent?.intentId ?? intent?.id
      ..paymentReference = intent?.reference
      ..status = status
      ..items = items
      ..customer =
          (selectedCustomer.value.isNotEmpty &&
              selectedCustomer.value != 'Guest')
          ? (TransactionCustomerEntity()
              ..name = selectedCustomer.value
              ..phone = ''
              ..email = ''
              ..address = ''
              ..visits = 0
              ..lastVisit = null)
          : null;
    tx.stylist = selectedStylist.value;
    await _transactionRepo.upsert(tx);
  }

  String _currentShiftId() {
    final now = DateTime.now();
    final stylist = selectedStylist.value.isNotEmpty
        ? selectedStylist.value
        : 'unknown';
    return 'SHIFT-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-'
        '${stylist.replaceAll(' ', '').toLowerCase()}';
  }

  String _localOrderCode() => 'LOCAL-${DateTime.now().millisecondsSinceEpoch}';

  Future<void> _loadServices() async {
    try {
      if (_useRest) {
        final api = await _remote.fetchServices();
        services.assignAll(api);
        return;
      }
    } catch (_) {}
    try {
      final productRepo = _productRepo;
      if (productRepo == null) {
        services.clear();
        return;
      }
      final localProducts = await productRepo.getAll();
      final eligible = _useRest
          ? localProducts.where((p) => p.syncStatus == ProductSyncStatusEntity.synced && !p.deleted)
          : localProducts.where((p) => !p.deleted);
      services.assignAll(eligible.map(_mapProduct));
    } catch (_) {
      services.clear();
    }
  }

  Future<void> _loadStylists() async {
    if (_auth.isStaffOnly) {
      final name = _auth.currentUser?.name.trim() ?? '';
      if (name.isNotEmpty) {
        stylists
          ..clear()
          ..add(Stylist(id: null, name: name, avatar: ''));
        selectedStylist
          ..value = name
          ..refresh();
        selectedStylistId.value = null;
        return;
      }
    }
    try {
      final staffRepo = _staffRepo;
      if (staffRepo != null) {
        final local = await staffRepo.getAll();
        if (local.isNotEmpty) {
          stylists
            ..clear()
            ..addAll(local.map(_mapStaff));
          selectedStylist
            ..value = stylists.first.name
            ..refresh();
          selectedStylistId.value = stylists.first.id;
          return;
        }
      }
    } catch (_) {}
    try {
      final names = await _attendanceRepo.getStaffNames();
      if (names.isNotEmpty) {
        stylists
          ..clear()
          ..addAll(names.map((e) => Stylist(id: null, name: e, avatar: '')));
        selectedStylist
          ..value = stylists.first.name
          ..refresh();
        selectedStylistId.value = stylists.first.id;
        return;
      }
    } catch (_) {}
    stylists.clear();
    selectedStylist.value = '';
    selectedStylistId.value = null;
  }

  Future<void> _loadCustomers() async {
    final names = <String>{'Guest'};
    try {
      final customerRepo = _customerRepo;
      if (customerRepo != null) {
        final customers = await customerRepo.getCustomers();
        for (final c in customers) {
          if (c.name.isNotEmpty) names.add(c.name);
        }
      }
    } catch (_) {}
    try {
      final txs = await _transactionRepo.getAll();
      for (final tx in txs) {
        final name = tx.customer?.name.trim();
        if (name != null && name.isNotEmpty) {
          names.add(name);
        }
      }
    } catch (_) {}
    customers
      ..clear()
      ..addAll(names);
    selectedCustomer.value = 'Guest';
  }

  ServiceItem _mapProduct(ProductEntity p) {
    return ServiceItem(
      id: p.id.toString(),
      name: p.name,
      category: p.category,
      price: 'Rp${p.price}',
      image: p.image,
    );
  }

  Stylist _mapStaff(EmployeeEntity e) {
    return Stylist(id: e.id, name: e.name, avatar: '');
  }

  Future<void> _loadCart() async {
    final stored = await repo.getCart();
    cart.assignAll(
      stored.map(
        (e) => CartItem(
          name: e.name,
          category: e.category,
          price: e.price,
          qty: e.qty,
        ),
      ),
    );
  }

  Future<void> _persistCart() async {
    final entities = cart
        .map(
          (c) => CartItemEntity()
            ..name = c.name
            ..category = c.category
            ..price = c.price
            ..qty = c.qty
            ..id = Isar.autoIncrement,
        )
        .toList();
    await repo.saveCart(entities);
  }
}
