import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/cashier_controller.dart';
import '../models/cashier_item.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/values/app_strings.dart';

class CashierView extends GetView<CashierController> {
  const CashierView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppDimens.tabletBreakpoint;

        return AppScaffold(
          title: AppStrings.cashierTitle,
          backgroundColor: AppColors.grey900,
          appBarBackgroundColor: Colors.transparent,
          appBarForegroundColor: Colors.white,
          drawer: const AppSideDrawer(),
          leading: isTablet
              ? null
              : Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
          actions: [
            IconButton(
              icon: const Icon(Icons.task_alt_rounded),
              tooltip: 'Check-in Stylist',
              onPressed: controller.checkInSelectedStylist,
            ),
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => Get.snackbar(AppStrings.searchService, AppStrings.searchHint),
            ),
          ],
          body: isTablet
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Side: Service Grid
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: controller.refreshAll,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SearchFilterBar(controller: controller),
                              const SizedBox(height: AppDimens.spacingXl),
                              _buildServiceGrid(context, isTablet),
                              const SizedBox(height: AppDimens.spacingXl),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.spacingLg),
                    // Right Side: Cart Panel
                    Container(
                      width: 320,
                      decoration: BoxDecoration(
                        color: AppColors.grey800,
                        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: _TabletCartPanel(
                        controller: controller,
                        onCheckout: () => _onCheckout(context),
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: controller.refreshAll,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SearchFilterBar(controller: controller),
                            const SizedBox(height: AppDimens.spacingXl),
                            _buildServiceGrid(context, isTablet),
                            const SizedBox(height: 100), // Space for cart bar
                          ],
                        ),
                      ),
                    ),
                    // Mobile Cart Bar
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Obx(() {
                        if (controller.cart.isEmpty) return const SizedBox.shrink();
                        return _CartBar(
                          itemCount: controller.cart.fold(0, (sum, item) => sum + item.qty),
                          totalFormatted: controller.formatCurrency(controller.total),
                          onCheckout: () => _onCheckout(context),
                        );
                      }),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _onCheckout(BuildContext context) {
    Get.toNamed(Routes.orderDetail);
  }

  Widget _buildServiceGrid(BuildContext context, bool isTablet) {
    return Obx(() {
      final selected = controller.selectedCategory.value;
      final query = controller.filterQuery.value.toLowerCase();
      final items = controller.services.where((item) {
        final inCategory = selected == AppStrings.allCategories || item.category == selected;
        final matchesQuery = query.isEmpty || item.name.toLowerCase().contains(query);
        return inCategory && matchesQuery;
      }).toList();
      final viewMode = controller.viewMode.value;

      if (items.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingLg),
          child: Center(
            child: Text(
              AppStrings.noServicesFound,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
          ),
        );
      }

      SliverGridDelegate delegate;
      if (viewMode == CashierViewMode.grid) {
        delegate = const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: AppDimens.spacingLg,
          mainAxisSpacing: AppDimens.spacingLg,
          childAspectRatio: 0.65,
        );
      } else {
        delegate = SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 2 : 1,
          crossAxisSpacing: AppDimens.spacingLg,
          mainAxisSpacing: AppDimens.spacingLg,
          childAspectRatio: isTablet ? 2.8 : 1.9,
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: delegate,
        itemBuilder: (context, index) {
          return _ServiceCard(
            item: items[index],
            viewMode: viewMode,
            onAdd: () => controller.addToCart(items[index]),
          );
        },
      );
    });
  }
}

class _SearchFilterBar extends StatelessWidget {
  const _SearchFilterBar({required this.controller});

  final CashierController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spacingMd,
            vertical: AppDimens.spacingSm,
          ),
          decoration: BoxDecoration(
            color: AppColors.grey800,
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
            border: Border.all(color: AppColors.grey700),
          ),
          child: Row(
            children: [
              const Icon(Icons.content_cut_rounded, color: AppColors.orange500, size: 18),
              const SizedBox(width: AppDimens.spacingSm),
              Expanded(
                child: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedCategory.value,
                      dropdownColor: AppColors.grey800,
                      iconEnabledColor: Colors.white70,
                      items: controller.categories
                          .map(
                            (category) => DropdownMenuItem(value: category, child: Text(category)),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) controller.selectCategory(value);
                      },
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.grey700,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune_rounded, color: Colors.white70, size: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spacingMd),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: controller.setSearchQuery,
                controller: TextEditingController(text: controller.searchQuery.value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.searchQuery.value.length),
                  ),
                decoration: InputDecoration(
                  hintText: AppStrings.searchService,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => controller.setSearchQuery(''),
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.grey800,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spacingMd,
                    vertical: AppDimens.spacingSm,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                    borderSide: const BorderSide(color: AppColors.grey700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                    borderSide: const BorderSide(color: AppColors.orange500),
                  ),
                ),
                style: const TextStyle(color: Color(0xFFF8F8F8)),
              ),
            ),
            const SizedBox(width: AppDimens.spacingMd),
            Obx(
              () =>
                  _ViewToggle(mode: controller.viewMode.value, onChange: controller.toggleViewMode),
            ),
          ],
        ),
      ],
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.mode, required this.onChange});

  final CashierViewMode mode;
  final ValueChanged<CashierViewMode> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Row(
        children: [
          _ToggleButton(
            icon: Icons.view_list_rounded,
            active: mode == CashierViewMode.list,
            onTap: () => onChange(CashierViewMode.list),
          ),
          _ToggleButton(
            icon: Icons.grid_view_rounded,
            active: mode == CashierViewMode.grid,
            onTap: () => onChange(CashierViewMode.grid),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.icon, required this.active, required this.onTap});

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spacingSm),
        decoration: BoxDecoration(
          color: active ? AppColors.orange500 : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        ),
        child: Icon(icon, color: active ? Colors.black : Colors.white70, size: 18),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item, required this.viewMode, required this.onAdd});

  final ServiceItem item;
  final CashierViewMode viewMode;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final isList = viewMode == CashierViewMode.list;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: isList ? _listLayout(context) : _gridLayout(context),
    );
  }

  Widget _gridLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimens.cornerRadius)),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: AppImage(imageUrl: item.image, borderRadius: 0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDimens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: AppDimens.spacingXs),
              Text(item.category, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: AppDimens.spacingSm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.price,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: AppColors.orange500),
                  ),
                  _AddButton(onTap: onAdd),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listLayout(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 160,
          child: ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(AppDimens.cornerRadius),
            ),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: AppImage(imageUrl: item.image, borderRadius: 0),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppDimens.spacingXs),
                Text(item.category, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.price,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: AppColors.orange500),
                    ),
                    _AddButton(onTap: onAdd),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TabletCartPanel extends StatelessWidget {
  const _TabletCartPanel({required this.controller, required this.onCheckout});

  final CashierController controller;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Order',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppDimens.spacingMd),
              // Quick Selectors
              Row(
                children: [
                  Expanded(
                    child: _buildSelector(
                      context,
                      label: 'Customer',
                      icon: Icons.person_outline_rounded,
                      value: controller.selectedCustomer,
                      items: controller.customers,
                      onChanged: controller.setCustomer,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spacingSm),
                  Expanded(
                    child: _buildSelector(
                      context,
                      label: 'Stylist',
                      icon: Icons.content_cut_rounded,
                      value: controller.selectedStylist,
                      items: controller.stylists.map((e) => e.name).toList(),
                      onChanged: controller.setStylist,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white10),
        // Cart Items
        Expanded(
          child: Obx(() {
            if (controller.cart.isEmpty) {
              return const Center(
                child: Text('Cart is empty', style: TextStyle(color: Colors.white38)),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              itemCount: controller.cart.length,
              separatorBuilder: (_, index) => const SizedBox(height: AppDimens.spacingMd),
              itemBuilder: (context, index) {
                final item = controller.cart[index];
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            controller.formatCurrency(item.price),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _QtyBtn(
                          icon: Icons.remove_rounded,
                          onTap: () => controller.decrementCartItem(item),
                        ),
                        SizedBox(
                          width: 32,
                          child: Text(
                            '${item.qty}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        _QtyBtn(
                          icon: Icons.add_rounded,
                          onTap: () => controller.incrementCartItem(item),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }),
        ),
        const Divider(color: Colors.white10),
        // Footer
        Padding(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(color: Colors.white70)),
                  Obx(
                    () => Text(
                      controller.formatCurrency(controller.total),
                      style: const TextStyle(
                        color: AppColors.orange500,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spacingLg),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange500,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelector(
    BuildContext context, {
    required String label,
    required IconData icon,
    required RxString value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: items.contains(value.value) ? value.value : null,
            isExpanded: true,
            dropdownColor: AppColors.grey800,
            icon: Icon(icon, size: 16, color: Colors.white54),
            style: const TextStyle(color: Colors.white, fontSize: 12),
            hint: Text(label, style: const TextStyle(color: Colors.white38)),
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: AppColors.orange500,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.black, size: 20),
      ),
    );
  }
}

class _CartBar extends StatelessWidget {
  const _CartBar({required this.itemCount, required this.totalFormatted, required this.onCheckout});

  final int itemCount;
  final String totalFormatted;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLg,
        vertical: AppDimens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.orange500,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius * 2),
        boxShadow: const [
          BoxShadow(color: Color(0x44000000), blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$itemCount ${AppStrings.item}',
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppDimens.spacingXs),
                Text(
                  '${AppStrings.pay} $totalFormatted',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spacingLg,
                vertical: AppDimens.spacingSm,
              ),
            ),
            icon: const Icon(Icons.shopping_cart_checkout_rounded),
            label: const Text(AppStrings.checkout),
          ),
        ],
      ),
    );
  }
}
