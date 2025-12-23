import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/cart_item_entity.dart';
import '../models/order_dtos.dart';
import '../../presentation/models/cashier_item.dart';

class CashierFirestoreDataSource {
  CashierFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> submitOrder(
    OrderPayloadDto payload, {
    OrderResponseDto? response,
    int? totalItems,
  }) async {
    final itemQty = totalItems ?? payload.items.fold<int>(0, (acc, item) => acc + item.qty);
    final data = {
      'items': payload.items
          .map((i) => {
                'name': i.name,
                'category': i.category,
                'price': i.price,
                'qty': i.qty,
              })
          .toList(),
      'total': payload.total,
      'paid': payload.paid,
      'change': payload.change,
      'paymentMethod': payload.paymentMethod,
      'stylist': payload.stylist,
      'customer': payload.customer,
      'shiftId': payload.shiftId,
      'itemCount': payload.items.length,
      'totalItems': itemQty,
      'createdAt': FieldValue.serverTimestamp(),
      if (response != null && response.code.isNotEmpty) 'code': response.code,
      if (response != null && response.id.isNotEmpty) 'orderId': response.id,
    };
    await _firestore.collection('orders').add(data);
  }

  Future<List<CartItemEntity>> fetchCart(String userId) async {
    final doc = await _firestore.collection('carts').doc(userId).get();
    final data = doc.data();
    if (data == null) return [];
    final items = data['items'] as List<dynamic>? ?? [];
    return items
        .map((raw) => CartItemEntity()
          ..name = raw['name']?.toString() ?? ''
          ..category = raw['category']?.toString() ?? ''
          ..price = _toInt(raw['price'])
          ..qty = _toInt(raw['qty']))
        .toList();
  }

  Future<void> saveCart(String userId, List<CartItemEntity> items) async {
    await _firestore.collection('carts').doc(userId).set({
      'items': items
          .map((c) => {
                'name': c.name,
                'category': c.category,
                'price': c.price,
                'qty': c.qty,
              })
          .toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  int _toInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

  Future<List<ServiceItem>> fetchCatalog() async {
    final snap = await _firestore.collection('services').orderBy('name').get();
    return snap.docs
        .map(
          (doc) => ServiceItem(
            name: doc.data()['name']?.toString() ?? '',
            category: doc.data()['category']?.toString() ?? 'Lainnya',
            price: doc.data()['price']?.toString() ?? '0',
            image: doc.data()['image']?.toString() ?? '',
          ),
        )
        .toList();
  }
}
