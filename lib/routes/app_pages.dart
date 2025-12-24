import 'package:get/get.dart';

import '../modules/home/presentation/bindings/home_binding.dart';
import '../modules/home/presentation/controllers/home_controller.dart';
import '../modules/home/presentation/views/home_view.dart';
import '../modules/auth/presentation/bindings/auth_binding.dart';
import '../modules/auth/presentation/controllers/auth_controller.dart';
import '../modules/auth/presentation/views/login_view.dart';
import '../modules/auth/presentation/controllers/register_controller.dart';
import '../modules/auth/presentation/views/register_view.dart';
import '../modules/auth/presentation/controllers/forgot_password_controller.dart';
import '../modules/auth/presentation/views/forgot_password_view.dart';
import '../modules/auth/presentation/views/complete_profile_view.dart';
import '../modules/cashier/presentation/bindings/cashier_binding.dart';
import '../modules/cashier/presentation/controllers/cashier_controller.dart';
import '../modules/cashier/presentation/views/cashier_view.dart';
import '../modules/cashier/presentation/views/order_detail_view.dart';
import '../modules/cashier/presentation/views/payment_success_view.dart';
import '../modules/cashier/presentation/views/payment_view.dart';
import '../modules/cashier/presentation/views/stylist_view.dart';
import '../modules/stock/presentation/bindings/stock_binding.dart';
import '../modules/stock/presentation/controllers/stock_controller.dart';
import '../modules/stock/presentation/views/stock_adjust_view.dart';
import '../modules/stock/presentation/views/stock_detail_view.dart';
import '../modules/stock/presentation/views/stock_list_view.dart';
import '../modules/management/presentation/bindings/management_binding.dart';
import '../modules/management/presentation/controllers/management_controller.dart';
import '../modules/management/presentation/views/category_form_view.dart';
import '../modules/management/presentation/views/category_list_view.dart';
import '../modules/management/presentation/views/customer_form_view.dart';
import '../modules/management/presentation/views/customer_list_view.dart';
import '../modules/product/presentation/bindings/product_binding.dart';
import '../modules/product/presentation/controllers/product_controller.dart';
import '../modules/product/presentation/views/product_form_view.dart';
import '../modules/product/presentation/views/product_list_view.dart';
import '../modules/transactions/presentation/bindings/transaction_binding.dart';
import '../modules/transactions/presentation/controllers/transaction_controller.dart';
import '../modules/transactions/presentation/views/transaction_detail_view.dart';
import '../modules/transactions/presentation/views/transaction_list_view.dart';
import '../modules/reports/presentation/bindings/reports_binding.dart';
import '../modules/reports/presentation/controllers/reports_controller.dart';
import '../modules/reports/presentation/views/finance_form_view.dart';
import '../modules/reports/presentation/views/reports_view.dart';
import '../modules/settings/presentation/bindings/settings_binding.dart';
import '../modules/settings/presentation/bindings/bluetooth_printer_binding.dart';
import '../modules/settings/presentation/controllers/settings_controller.dart';
import '../modules/settings/presentation/views/settings_view.dart';
import '../modules/settings/presentation/views/bluetooth_printer_view.dart';
import '../modules/closing/presentation/bindings/closing_binding.dart';
import '../modules/closing/presentation/controllers/closing_controller.dart';
import '../modules/closing/presentation/views/closing_view.dart';
import '../modules/staff/presentation/bindings/staff_binding.dart';
import '../modules/staff/presentation/controllers/staff_controller.dart';
import '../modules/staff/presentation/views/employee_detail_view.dart';
import '../modules/staff/presentation/views/employee_form_view.dart';
import '../modules/staff/presentation/views/employee_list_view.dart';
import '../modules/logs/presentation/bindings/logs_binding.dart';
import '../modules/logs/presentation/controllers/logs_controller.dart';
import '../modules/logs/presentation/views/activity_log_view.dart';
import '../modules/membership/presentation/bindings/membership_binding.dart';
import '../modules/membership/presentation/controllers/membership_controller.dart';
import '../modules/membership/presentation/views/membership_view.dart';
import '../modules/notifications/presentation/bindings/notification_binding.dart';
import '../modules/notifications/presentation/controllers/notification_controller.dart';
import '../modules/notifications/presentation/views/notification_view.dart';
import '../modules/sync/presentation/bindings/sync_binding.dart';
import '../modules/sync/presentation/views/sync_view.dart';
import '../modules/splash/presentation/bindings/splash_binding.dart';
import '../modules/splash/presentation/controllers/splash_controller.dart';
import '../modules/splash/presentation/views/splash_view.dart';
import '../core/middlewares/auth_middleware.dart';
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage<SplashController>(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage<AuthController>(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage<RegisterController>(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage<ForgotPasswordController>(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.completeProfile,
      page: () => const CompleteProfileView(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<HomeController>(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage<CashierController>(
      name: Routes.cashier,
      page: () => const CashierView(),
      binding: CashierBinding(),
      middlewares: [AuthMiddleware(allowStaff: true)],
    ),
    GetPage<CashierController>(
      name: Routes.orderDetail,
      page: () => const OrderDetailView(),
      binding: CashierBinding(),
      middlewares: [AuthMiddleware(allowStaff: true)],
    ),
    GetPage<CashierController>(
      name: Routes.stylist,
      page: () => const StylistView(),
      binding: CashierBinding(),
      middlewares: [AuthMiddleware(allowStaff: true)],
    ),
    GetPage<CashierController>(
      name: Routes.payment,
      page: () => const PaymentView(),
      binding: CashierBinding(),
      middlewares: [AuthMiddleware(allowStaff: true)],
    ),
    GetPage<CashierController>(
      name: Routes.paymentSuccess,
      page: () => const PaymentSuccessView(),
      binding: CashierBinding(),
      middlewares: [AuthMiddleware(allowStaff: true)],
    ),
    GetPage<StockController>(
      name: Routes.stock,
      page: () => const StockListView(),
      binding: StockBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<StockController>(
      name: Routes.stockDetail,
      page: () => const StockDetailView(),
      binding: StockBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<StockController>(
      name: Routes.stockAdjust,
      page: () => const StockAdjustView(),
      binding: StockBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<ManagementController>(
      name: Routes.categories,
      page: () => const CategoryListView(),
      binding: ManagementBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<ManagementController>(
      name: Routes.categoryForm,
      page: () => const CategoryFormView(),
      binding: ManagementBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<ManagementController>(
      name: Routes.customers,
      page: () => const CustomerListView(),
      binding: ManagementBinding(),
      middlewares: [AuthMiddleware(allowStaff: true)],
    ),
    GetPage<ManagementController>(
      name: Routes.customerForm,
      page: () => const CustomerFormView(),
      binding: ManagementBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<ProductController>(
      name: Routes.products,
      page: () => const ProductListView(),
      binding: ProductBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<ProductController>(
      name: Routes.productForm,
      page: () => const ProductFormView(),
      binding: ProductBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<TransactionController>(
      name: Routes.transactions,
      page: () => const TransactionListView(),
      binding: TransactionBinding(),
      middlewares: [AuthMiddleware(allowStaff: true)],
    ),
    GetPage<TransactionController>(
      name: Routes.transactionDetail,
      page: () => const TransactionDetailView(),
      binding: TransactionBinding(),
      middlewares: [AuthMiddleware(allowStaff: true)],
    ),
    GetPage<ReportsController>(
      name: Routes.reports,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<ReportsController>(
      name: Routes.financeForm,
      page: () => const FinanceFormView(),
      binding: ReportsBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<SettingsController>(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage(
      name: Routes.bluetoothPrinter,
      page: () => const BluetoothPrinterView(),
      binding: BluetoothPrinterBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<ClosingController>(
      name: Routes.closing,
      page: () => const ClosingView(),
      binding: ClosingBinding(),
      middlewares: [AuthMiddleware(allowStaff: true)],
    ),
    GetPage<MembershipController>(
      name: Routes.membership,
      page: () => const MembershipView(),
      binding: MembershipBinding(),
      middlewares: [AuthMiddleware(allowStaff: true)],
    ),
    GetPage<StaffController>(
      name: Routes.employees,
      page: () => const EmployeeListView(),
      binding: StaffBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<StaffController>(
      name: Routes.employeeForm,
      page: () => const EmployeeFormView(),
      binding: StaffBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<StaffController>(
      name: Routes.employeeDetail,
      page: () => const EmployeeDetailView(),
      binding: StaffBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<LogsController>(
      name: Routes.activityLogs,
      page: () => const ActivityLogView(),
      binding: LogsBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
    GetPage<NotificationController>(
      name: Routes.notifications,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.sync,
      page: () => const SyncView(),
      binding: SyncBinding(),
      middlewares: [AuthMiddleware(requireManager: true)],
    ),
  ];
}
