class OrderLineDto {
  OrderLineDto({
    required this.name,
    required this.category,
    required this.price,
    required this.qty,
  });

  final String name;
  final String category;
  final int price;
  final int qty;

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'price': price,
        'qty': qty,
      };

  factory OrderLineDto.fromJson(Map<String, dynamic> json) {
    return OrderLineDto(
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: int.tryParse(json['price']?.toString() ?? '') ?? 0,
      qty: int.tryParse(json['qty']?.toString() ?? '') ?? 0,
    );
  }
}

class OrderPayloadDto {
  OrderPayloadDto({
    required this.items,
    required this.total,
    required this.paid,
    required this.change,
    required this.paymentMethod,
    this.stylist,
    this.customer,
    this.shiftId,
  });

  final List<OrderLineDto> items;
  final int total;
  final int paid;
  final int change;
  final String paymentMethod;
  final String? stylist;
  final String? customer;
  final String? shiftId;

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'paid': paid,
        'change': change,
        'paymentMethod': paymentMethod,
        if (stylist != null) 'stylist': stylist,
        if (customer != null) 'customer': customer,
        if (shiftId != null) 'shiftId': shiftId,
      };
}

class OrderResponseDto {
  OrderResponseDto({
    required this.id,
    required this.code,
    required this.total,
    required this.paid,
    required this.change,
    required this.paymentMethod,
    this.items = const [],
  });

  final String id;
  final String code;
  final int total;
  final int paid;
  final int change;
  final String paymentMethod;
  final List<OrderLineDto> items;

  factory OrderResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? <dynamic>[];
    return OrderResponseDto(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      total: int.tryParse(json['total']?.toString() ?? '') ?? 0,
      paid: int.tryParse(json['paid']?.toString() ?? '') ?? 0,
      change: int.tryParse(json['change']?.toString() ?? '') ?? 0,
      paymentMethod: json['paymentMethod']?.toString() ?? 'cash',
      items: rawItems
          .whereType<Map>()
          .map((e) => OrderLineDto.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  factory OrderResponseDto.fallback({
    required OrderPayloadDto payload,
    required String generatedId,
  }) {
    return OrderResponseDto(
      id: generatedId,
      code: generatedId,
      total: payload.total,
      paid: payload.paid,
      change: payload.change,
      paymentMethod: payload.paymentMethod,
      items: payload.items,
    );
  }
}
