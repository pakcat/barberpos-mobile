enum PaymentMethod { cash, nonCash, qris, card }

class CartItem {
  CartItem({
    required this.name,
    required this.category,
    required this.price,
    this.qty = 1,
  });

  final String name;
  final String category;
  final int price;
  int qty;

  int get subtotal => price * qty;
}

class Stylist {
  const Stylist({
    required this.name,
    required this.avatar,
  });

  final String name;
  final String avatar;
}
