class QuotaTopup {
  QuotaTopup({
    required this.amount,
    required this.manager,
    required this.note,
    required this.date,
  });

  final int amount;
  final String manager;
  final String note;
  final DateTime date;
}
