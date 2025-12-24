enum TransactionStatus { paid, refund, pending }

class TransactionItem {
  const TransactionItem({
    required this.id,
    required this.date,
    required this.time,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.items,
    required this.customer,
    this.refundedAt,
    this.refundNote,
  });

  final String id;
  final DateTime date;
  final String time;
  final int amount;
  final String paymentMethod;
  final TransactionStatus status;
  final List<TransactionLine> items;
  final TransactionCustomer customer;
  final DateTime? refundedAt;
  final String? refundNote;
}

class TransactionLine {
  const TransactionLine({
    required this.name,
    required this.category,
    required this.price,
    required this.qty,
  });

  final String name;
  final String category;
  final int price;
  final int qty;
}

class TransactionCustomer {
  const TransactionCustomer({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    this.visits = 0,
    this.lastVisit,
  });

  final String name;
  final String phone;
  final String email;
  final String address;
  final int visits;
  final String? lastVisit;
}
