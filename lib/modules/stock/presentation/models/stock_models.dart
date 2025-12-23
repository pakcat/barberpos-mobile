class StockItem {
  const StockItem({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.stock,
    required this.transactions,
  });

  final String id;
  final String name;
  final String category;
  final String image;
  final int stock;
  final int transactions;
}

enum StockAdjustmentType { add, reduce, recount }

class StockHistory {
  const StockHistory({
    required this.date,
    required this.status,
    required this.quantity,
    required this.remaining,
    required this.type,
  });

  final String date;
  final String status;
  final int quantity;
  final int remaining;
  final StockAdjustmentType type;
}
