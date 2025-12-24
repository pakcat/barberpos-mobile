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

class CustomerReport {
  CustomerReport({
    required this.name,
    this.phone,
    required this.totalSpent,
    required this.totalTransactions,
    required this.lastVisit,
  });

  final String name;
  final String? phone;
  final int totalSpent;
  final int totalTransactions;
  final DateTime lastVisit;
}

enum ReportTransactionStatus { paid, refund, pending }

class TransactionReportItem {
  TransactionReportItem({
    required this.code,
    required this.date,
    required this.time,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.itemsCount,
    required this.stylist,
    required this.customerName,
  });

  final String code;
  final DateTime date;
  final String time;
  final int amount;
  final String paymentMethod;
  final ReportTransactionStatus status;
  final int itemsCount;
  final String stylist;
  final String customerName;
}
