import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/services/activity_log_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/network/network_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../product/data/datasources/product_firestore_data_source.dart';
import '../../../product/data/entities/product_entity.dart';
import '../../../product/data/repositories/product_repository.dart';
import '../../../product/presentation/controllers/product_controller.dart';
import '../../../membership/data/datasources/membership_firestore_data_source.dart';
import '../../../membership/data/repositories/membership_repository.dart';
import '../../../membership/presentation/controllers/membership_controller.dart';
import '../../../reports/data/datasources/reports_firestore_data_source.dart';
import '../../../reports/data/entities/finance_entry_entity.dart';
import '../../../reports/data/repositories/reports_repository.dart';
import '../../../reports/presentation/controllers/reports_controller.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../management/data/datasources/customer_firestore_data_source.dart';
import '../../../management/data/repositories/management_repository.dart';
import '../../../staff/data/datasources/staff_firestore_data_source.dart';
import '../../../staff/data/entities/employee_entity.dart';
import '../../../staff/data/repositories/staff_repository.dart';
import '../../../transactions/data/entities/transaction_entity.dart';
import '../../../transactions/data/repositories/transaction_repository.dart';
import '../../../transactions/presentation/controllers/transaction_controller.dart';
import '../../data/datasources/cashier_firestore_data_source.dart';
import '../../data/datasources/cashier_remote_data_source.dart';
import '../../data/entities/cart_item_entity.dart';
import '../../data/models/order_dtos.dart';
import '../../data/repositories/cashier_repository.dart';
import '../../../staff/data/repositories/attendance_repository.dart';
import '../../../staff/data/entities/attendance_entity.dart';
import '../../data/datasources/payment_remote_data_source.dart';
import '../../data/models/payment_intent_dtos.dart';
import '../models/cashier_item.dart';
import '../models/checkout_models.dart';
import '../../../stock/presentation/controllers/stock_controller.dart';

class CashierController extends GetxController {
  CashierController({
    CashierRepository? repo,
    TransactionRepository? transactionRepository,
    ActivityLogService? logs,
    AuthService? auth,
    NetworkService? network,
    CashierRemoteDataSource? remote,
    CashierFirestoreDataSource? firebase,
    AttendanceRepository? attendanceRepository,
    PaymentRemoteDataSource? paymentRemoteDataSource,
    ProductRepository? productRepository,
    ProductFirestoreDataSource? productFirebase,
    MembershipRepository? membershipRepository,
    MembershipFirestoreDataSource? membershipFirebase,
    ReportsRepository? reportsRepository,
    ReportsFirestoreDataSource? reportsFirebase,
    StaffRepository? staffRepository,
    StaffFirestoreDataSource? staffFirebase,
    ManagementRepository? customerRepository,
    CustomerFirestoreDataSource? customerFirebase,
    AppConfig? config,
    FirebaseFirestore? firestore,
  }) : repo = repo ?? Get.find<CashierRepository>(),
       _transactionRepo = transactionRepository ?? Get.find<TransactionRepository>(),
       _logs = logs ?? Get.find<ActivityLogService>(),
       _auth = auth ?? Get.find<AuthService>(),
       _remote = remote ?? CashierRemoteDataSource((network ?? Get.find<NetworkService>()).dio),
       _attendanceRepo = attendanceRepository ?? Get.find<AttendanceRepository>(),
       _paymentRemote =
           paymentRemoteDataSource ??
           PaymentRemoteDataSource(network ?? Get.find<NetworkService>()),
       _config = config ?? Get.find<AppConfig>(),
       _firebase =
           firebase ??
           ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
               ? CashierFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
               : null),
       _productRepo = productRepository ?? Get.find<ProductRepository>(),
       _productFirebase =
           productFirebase ??
           ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
               ? ProductFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
               : null),
       _membershipRepo = membershipRepository ?? Get.find<MembershipRepository>(),
       _membershipFirebase =
           membershipFirebase ??
           ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
               ? MembershipFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
               : null),
       _reportsRepo = reportsRepository ?? Get.find<ReportsRepository>(),
       _reportsFirebase =
           reportsFirebase ??
           ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
               ? ReportsFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
               : null),
       _staffRepo = staffRepository ?? Get.find<StaffRepository>(),
       _staffFirebase =
           staffFirebase ??
           ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
               ? StaffFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
               : null),
       _customerRepo = customerRepository ?? Get.find<ManagementRepository>(),
       _customerFirebase =
           customerFirebase ??
           ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
               ? CustomerFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
               : null),
       _firestore = (config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
           ? (firestore ?? FirebaseFirestore.instance)
           : null;

  final CashierRepository repo;
  final TransactionRepository _transactionRepo;
  final ActivityLogService _logs;
  final AuthService _auth;
  final CashierRemoteDataSource _remote;
  final CashierFirestoreDataSource? _firebase;
  final AttendanceRepository _attendanceRepo;
  final PaymentRemoteDataSource _paymentRemote;
  final AppConfig _config;
  final ProductRepository _productRepo;
  final ProductFirestoreDataSource? _productFirebase;
  final MembershipRepository _membershipRepo;
  final MembershipFirestoreDataSource? _membershipFirebase;
  final ReportsRepository _reportsRepo;
  final ReportsFirestoreDataSource? _reportsFirebase;
  final StaffRepository _staffRepo;
  final StaffFirestoreDataSource? _staffFirebase;
  final ManagementRepository _customerRepo;
  final CustomerFirestoreDataSource? _customerFirebase;
  final FirebaseFirestore? _firestore;
  final RxString selectedCategory = 'Semua'.obs;
  final Rx<CashierViewMode> viewMode = CashierViewMode.grid.obs;
  final Rx<PaymentMethod> paymentMethod = PaymentMethod.cash.obs;
  final RxString receivedAmount = '0'.obs;
  final RxString selectedStylist = ''.obs;
  final RxString searchQuery = ''.obs;

  final RxList<ServiceItem> services = <ServiceItem>[].obs;

  final RxList<CartItem> cart = <CartItem>[].obs;
  final RxBool processingPayment = false.obs;
  final Rx<DateTime?> lastCheckIn = Rx<DateTime?>(null);

  final RxList<Stylist> stylists = <Stylist>[].obs;

  final RxString selectedCustomer = 'Guest'.obs;
  final List<String> customers = ['Guest'];

  final RxString filterQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshAll();

    // Debounce search input to avoid lagging on every keystroke
    debounce(searchQuery, (query) {
      filterQuery.value = query;
    }, time: const Duration(milliseconds: 500));
  }

  Future<void> refreshAll() async {
    await Future.wait([_loadServices(), _loadStylists(), _loadCustomers(), _loadCart()]);
  }

  bool get _useFirebase => _config.backend == BackendMode.firebase && _firebase != null;

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
    final existingIndex = cart.indexWhere((cartItem) => cartItem.name == item.name);
    if (existingIndex != -1) {
      final existing = cart[existingIndex];
      existing.qty += 1;
      cart[existingIndex] = existing;
    } else {
      cart.add(CartItem(name: item.name, category: item.category, price: _parsePrice(item.price)));
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
    try {
      // Fire and forget to remote
      await Get.find<NetworkService>().dio.post(
        '/attendance/checkin',
        data: {'employeeName': name, 'checkIn': now.toIso8601String(), 'source': 'cashier'},
      );
    } catch (_) {
      // ignore network error; local stored
    }
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

  int get paid => int.tryParse(receivedAmount.value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

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
      _showSnack('Keranjang kosong', 'Tambahkan layanan/produk sebelum membayar.');
      return;
    }
    if (selectedStylist.value.isEmpty) {
      _showSnack('Stylist', 'Pilih stylist untuk transaksi ini.');
      return;
    }
    if (paid < total) {
      _showSnack('Nominal kurang', 'Nominal diterima belum cukup untuk membayar.');
      return;
    }

    processingPayment.value = true;
    try {
      PaymentIntentDto? intent;
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

      final payload = _buildPayload();
      final response = await _remote.submitOrder(payload);
      await _persistTransaction(response, payload, intent: intent);
      if (_useFirebase) {
        final totalItems = payload.items.fold<int>(0, (acc, item) => acc + item.qty);
        await _firebase!.submitOrder(payload, response: response, totalItems: totalItems);
      }
      await _consumeMembershipQuota(payload);
      await _deductStockFromCart();
      await _recordFinanceEntries(payload);
      await _updateDashboard(payload);
      _logs.add(
        title: 'Checkout',
        message:
            'Order ${response.code.isNotEmpty ? response.code : response.id} dibayar '
            '${_labelPayment(paymentMethod.value)}',
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
      final products = await _productRepo.getAll();
      for (final item in cart) {
        final product = products.firstWhereOrNull(
          (p) => p.name.toLowerCase() == item.name.toLowerCase(),
        );
        if (product == null || !product.trackStock) continue;
        final newStock = (product.stock - item.qty).clamp(0, 1 << 31);
        product.stock = newStock;
        await _productRepo.upsert(product);
      }
      // refresh dependent modules
      if (Get.isRegistered<ProductController>()) {
        await Get.find<ProductController>().refreshRemote();
      }
      if (Get.isRegistered<StockController>()) {
        await Get.find<StockController>().refreshRemote();
      }
    } catch (_) {
      // ignore stock sync errors so checkout still succeeds
    }
  }

  Future<void> _recordFinanceEntries(OrderPayloadDto payload) async {
    try {
      final now = DateTime.now();
      for (final line in payload.items) {
        final entry = FinanceEntryEntity()
          ..title = line.name
          ..amount = line.price * line.qty
          ..category = line.category
          ..date = now
          ..type = EntryTypeEntity.revenue
          ..note = 'Penjualan via kasir'
          ..staff = selectedStylist.value.isNotEmpty ? selectedStylist.value : null
          ..service = line.name;
        await _reportsRepo.upsert(entry);
        if (_config.backend == BackendMode.firebase && _reportsFirebase != null) {
          await _reportsFirebase.upsert(entry);
        }
      }
      if (Get.isRegistered<ReportsController>()) {
        await Get.find<ReportsController>().refresh();
      }
      if (Get.isRegistered<DashboardController>()) {
        await Get.find<DashboardController>().load();
      }
    } catch (_) {
      // ignore reporting failure to not block checkout
    }
  }

  Future<void> _updateDashboard(OrderPayloadDto payload) async {
    final fs = _firestore;
    if (fs == null) return;
    try {
      final itemsSold = payload.items.fold<int>(0, (acc, item) => acc + item.qty);
      final customerCount = payload.customer != null ? 1 : 0;
      await fs.collection('dashboard').doc('summary').set({
        'transaksiHariIni': FieldValue.increment(1),
        'omzetHariIni': FieldValue.increment(payload.total),
        'customerHariIni': FieldValue.increment(customerCount),
        'layananTerjual': FieldValue.increment(itemsSold),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final topServices = fs.collection('dashboard_topServices');
      for (final line in payload.items) {
        final docId = _normalizeId(line.name);
        await topServices.doc(docId).set({
          'name': line.name,
          'qty': FieldValue.increment(line.qty),
          'amount': FieldValue.increment(line.price * line.qty),
        }, SetOptions(merge: true));
      }

      if (payload.stylist != null && payload.stylist!.isNotEmpty) {
        final docId = _normalizeId(payload.stylist!);
        await fs.collection('dashboard_topStaff').doc(docId).set({
          'name': payload.stylist,
          'role': 'stylist',
          'qty': FieldValue.increment(1),
          'amount': FieldValue.increment(payload.total),
        }, SetOptions(merge: true));
      }

      await _appendSalesPoint(payload.total);
    } catch (_) {
      // ignore dashboard sync failure
    }
  }

  String _normalizeId(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'-+'), '-');

  Future<void> _consumeMembershipQuota(OrderPayloadDto payload) async {
    try {
      final used = await _membershipRepo.getUsedQuota();
      final consumed = payload.items.fold<int>(0, (acc, item) => acc + item.qty);
      final next = used + (consumed == 0 ? 1 : consumed);
      await _membershipRepo.setUsedQuota(next);
      if (_config.backend == BackendMode.firebase && _membershipFirebase != null) {
        await _membershipFirebase.setUsedQuota(next);
      }
      if (Get.isRegistered<MembershipController>()) {
        Get.find<MembershipController>().usedQuota.value = next;
      }
    } catch (_) {
      // ignore membership sync failure
    }
  }

  Future<void> _appendSalesPoint(int amount) async {
    final fs = _firestore;
    if (fs == null) return;
    try {
      final label = _todayLabel();
      // Dokumen mengikuti naming di fetchSalesSeries (range.toLowerCase()) -> "minggu ini"
      final doc = fs.collection('dashboard_sales').doc('minggu ini');
      await fs.runTransaction((txn) async {
        final snap = await txn.get(doc);
        final data = snap.data() ?? {};
        final points = (data['points'] as List<dynamic>? ?? []).map<Map<String, dynamic>>((e) {
          return Map<String, dynamic>.from(e as Map);
        }).toList();
        final idx = points.indexWhere((p) => p['label'] == label);
        if (idx >= 0) {
          final current = int.tryParse(points[idx]['value']?.toString() ?? '') ?? 0;
          points[idx]['value'] = current + amount;
        } else {
          points.add({'label': label, 'value': amount});
        }
        txn.set(doc, {'points': points}, SetOptions(merge: true));
      });
    } catch (_) {
      // ignore chart aggregation failure
    }
  }

  String _todayLabel() {
    const weekday = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    final now = DateTime.now();
    return weekday[now.weekday % 7];
  }

  OrderPayloadDto _buildPayload() {
    final lines = cart
        .map((c) => OrderLineDto(name: c.name, category: c.category, price: c.price, qty: c.qty))
        .toList();
    final method = _mapPaymentMethod(paymentMethod.value);
    return OrderPayloadDto(
      items: lines,
      total: total,
      paid: paid,
      change: change,
      paymentMethod: method,
      stylist: selectedStylist.value.isNotEmpty ? selectedStylist.value : null,
      customer: selectedCustomer.value == 'Guest' ? null : selectedCustomer.value,
      shiftId: _currentShiftId(),
    );
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
    return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Pembayaran QRIS'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tunjukkan QR ini ke customer.'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(intent.qrString ?? 'QR siap', style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kadaluarsa: ${(intent.expiresAt ?? DateTime.now().add(const Duration(minutes: 10)))}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Get.back(result: false), child: const Text('Batal')),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Tandai Lunas'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _confirmCard(PaymentIntentDto intent) async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Pembayaran Kartu/EDC'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Proses di mesin EDC. Ref: ${intent.reference ?? intent.id}'),
                const SizedBox(height: 8),
                const Text('Tekan "Pembayaran diterima" jika transaksi sukses.'),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Get.back(result: false), child: const Text('Batal')),
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
  }) async {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final usedLines = response.items.isNotEmpty ? response.items : payload.items;
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
      ..status = TransactionStatusEntity.paid
      ..items = items
      ..customer = (selectedCustomer.value.isNotEmpty && selectedCustomer.value != 'Guest')
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

  Future<void> _loadServices() async {
    if (_useFirebase) {
      final allServices = <ServiceItem>[];
      try {
        final remote = await _firebase!.fetchCatalog();
        if (remote.isNotEmpty) {
          allServices.addAll(remote);
        }
      } catch (_) {
        // ignore
      }
      try {
        final products = await _productFirebase?.fetchAll();
        if (products != null && products.isNotEmpty) {
          allServices.addAll(products.map(_mapProduct));
        }
      } catch (_) {
        // ignore
      }

      if (allServices.isNotEmpty) {
        // Dedup by name, preferring the last added (or just unique names)
        final seen = <String>{};
        final unique = <ServiceItem>[];
        for (var item in allServices) {
          if (!seen.contains(item.name)) {
            seen.add(item.name);
            unique.add(item);
          }
        }
        services.assignAll(unique);
        return;
      }
    }
    try {
      final api = await _remote.fetchServices();
      services.assignAll(api);
      return;
    } catch (_) {
      // ignore and fall through to local
    }
    try {
      final localProducts = await _productRepo.getAll();
      services.assignAll(localProducts.map(_mapProduct));
    } catch (_) {
      services.clear();
    }
  }

  Future<void> _loadStylists() async {
    // Prefer staff list from Firestore, then local staff repo, then attendance names.
    final staffFirebase = _staffFirebase;
    if (_useFirebase && staffFirebase != null) {
      try {
        final remote = await staffFirebase.fetchAll();
        if (remote.isNotEmpty) {
          stylists
            ..clear()
            ..addAll(remote.map(_mapStaff));
          selectedStylist.value = stylists.first.name;
          return;
        }
      } catch (_) {}
    }
    try {
      final local = await _staffRepo.getAll();
      if (local.isNotEmpty) {
        stylists
          ..clear()
          ..addAll(local.map(_mapStaff));
        selectedStylist.value = stylists.first.name;
        return;
      }
    } catch (_) {}
    try {
      final names = await _attendanceRepo.getStaffNames();
      if (names.isNotEmpty) {
        stylists
          ..clear()
          ..addAll(names.map((e) => Stylist(name: e, avatar: '')));
        selectedStylist.value = stylists.first.name;
        return;
      }
    } catch (_) {}
    stylists.clear();
    selectedStylist.value = '';
  }

  Future<void> _loadCustomers() async {
    final names = <String>{'Guest'};
    final customerFirebase = _customerFirebase;
    if (_useFirebase && customerFirebase != null) {
      try {
        final remote = await customerFirebase.fetchAll();
        if (remote.isNotEmpty) {
          for (final c in remote) {
            if (c.name.isNotEmpty) names.add(c.name);
          }
        }
      } catch (_) {}
    }
    if (names.length == 1) {
      try {
        final customers = await _customerRepo.getCustomers();
        for (final c in customers) {
          if (c.name.isNotEmpty) names.add(c.name);
        }
      } catch (_) {}
    }
    try {
      final txs = await _transactionRepo.getAll();
      for (final tx in txs) {
        final name = tx.customer?.name.trim();
        if (name != null && name.isNotEmpty) {
          names.add(name);
        }
      }
    } catch (_) {
      // ignore
    }
    customers
      ..clear()
      ..addAll(names);
    selectedCustomer.value = 'Guest';
  }

  ServiceItem _mapProduct(ProductEntity p) {
    return ServiceItem(name: p.name, category: p.category, price: 'Rp${p.price}', image: p.image);
  }

  Stylist _mapStaff(EmployeeEntity e) {
    return Stylist(name: e.name, avatar: '');
  }

  String _currentShiftId() {
    final now = DateTime.now();
    final stylist = selectedStylist.value.isNotEmpty ? selectedStylist.value : 'unknown';
    return 'SHIFT-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-'
        '${stylist.replaceAll(' ', '').toLowerCase()}';
  }

  Future<void> _loadCart() async {
    List<CartItemEntity> stored;
    if (_useFirebase && _auth.currentUser != null) {
      try {
        stored = await _firebase!.fetchCart(_auth.currentUser!.id);
        if (stored.isEmpty) {
          // Keep cart clean if remote is empty (avoid leftover dummy/local data)
          await repo.saveCart([]);
          cart.clear();
          return;
        }
      } catch (_) {
        stored = await repo.getCart();
      }
    } else {
      stored = await repo.getCart();
    }
    cart.assignAll(
      stored.map((e) => CartItem(name: e.name, category: e.category, price: e.price, qty: e.qty)),
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
    if (_useFirebase && _auth.currentUser != null) {
      await _firebase!.saveCart(_auth.currentUser!.id, entities);
    }
  }
}
