enum EntryType { revenue, expense }

class FinanceEntry {
  FinanceEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.note = '',
    this.transactionCode,
    this.staff,
    this.service,
  });

  final String id;
  final String title;
  final int amount;
  final String category;
  final DateTime date;
  final EntryType type;
  final String note;
  final String? transactionCode;
  final String? staff;
  final String? service;
}

class StylistPerformance {
  StylistPerformance({
    required this.name,
    required this.totalSales,
    required this.totalTransactions,
    required this.totalItems,
    this.topService,
  });

  final String name;
  final int totalSales;
  final int totalTransactions;
  final int totalItems;
  final String? topService;
}
