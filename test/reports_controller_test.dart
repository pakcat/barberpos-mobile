import 'package:barberpos_mobile/modules/reports/presentation/controllers/reports_controller.dart';
import 'package:barberpos_mobile/modules/reports/presentation/models/report_models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'stubs/stub_reports_repo.dart';
import 'stubs/stub_transaction_repo.dart';

void main() {
  late ReportsController controller;

  setUp(() {
    controller = ReportsController(
      repo: StubReportsRepository(),
      txRepo: StubTransactionRepository(),
    );
    controller.entries.addAll([
      FinanceEntry(
        id: '1',
        title: 'Haircut',
        amount: 100000,
        category: 'Service',
        date: DateTime(2024, 1, 1),
        type: EntryType.revenue,
        staff: 'Awan',
        service: 'Haircut',
      ),
      FinanceEntry(
        id: '2',
        title: 'Supplies',
        amount: 20000,
        category: 'Expense',
        date: DateTime(2024, 1, 2),
        type: EntryType.expense,
      ),
    ]);
    controller.stylistReports.addAll([
      StylistPerformance(name: 'Awan', totalSales: 100000, totalTransactions: 1, totalItems: 2, topService: 'Haircut')
    ]);
  });

  test('net calculation', () {
    expect(controller.totalRevenue, greaterThan(0));
    expect(controller.net, equals(controller.totalRevenue - controller.totalExpense));
  });

  test('stylist performance generated', () async {
    expect(controller.stylistReports.isNotEmpty, isTrue);
    expect(controller.stylistReports.first.totalSales, greaterThan(0));
  });
}
