import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/activity_log_entity.dart';
import '../../modules/settings/data/entities/settings_entity.dart';
import 'entities/user_entity.dart';
import 'entities/region_entity.dart';
import '../../modules/management/data/entities/category_entity.dart';
import '../../modules/management/data/entities/customer_entity.dart';
import '../../modules/product/data/entities/product_entity.dart';
import '../../modules/product/data/entities/product_outbox_entity.dart';
import '../../modules/product/data/entities/product_image_outbox_entity.dart';
import '../../modules/staff/data/entities/employee_entity.dart';
import '../../modules/reports/data/entities/finance_entry_entity.dart';
import '../../modules/membership/data/entities/membership_topup_entity.dart';
import '../../modules/transactions/data/entities/transaction_entity.dart';
import '../../modules/stock/data/entities/stock_entity.dart';
import '../../modules/stock/data/entities/stock_adjustment_outbox_entity.dart';
import 'entities/session_entity.dart';
import '../../modules/closing/data/entities/closing_history_entity.dart';
import '../../modules/membership/data/entities/membership_state_entity.dart';
import '../../modules/cashier/data/entities/cart_item_entity.dart';
import '../../modules/cashier/data/entities/order_outbox_entity.dart';
import '../../modules/staff/data/entities/attendance_entity.dart';
import '../../modules/staff/data/entities/attendance_outbox_entity.dart';
import '../../modules/settings/data/entities/qris_outbox_entity.dart';

class LocalDatabase extends GetxService {
  late final Isar isar;

  Future<LocalDatabase> init() async {
    final dir = await getApplicationSupportDirectory();
    isar = await Isar.open(
      [
        ActivityLogEntitySchema,
        SettingsEntitySchema,
        UserEntitySchema,
        RegionEntitySchema,
        CategoryEntitySchema,
        CustomerEntitySchema,
        ProductEntitySchema,
        ProductOutboxEntitySchema,
        ProductImageOutboxEntitySchema,
        EmployeeEntitySchema,
        FinanceEntryEntitySchema,
        MembershipTopupEntitySchema,
        TransactionEntitySchema,
        StockEntitySchema,
        StockAdjustmentOutboxEntitySchema,
        SessionEntitySchema,
        ClosingHistoryEntitySchema,
        MembershipStateEntitySchema,
        CartItemEntitySchema,
        OrderOutboxEntitySchema,
        AttendanceEntitySchema,
        AttendanceOutboxEntitySchema,
        QrisOutboxEntitySchema,
      ],
      directory: dir.path,
      inspector: kDebugMode,
    );
    return this;
  }
}

